# Prompt user for input
$startDate = Read-Host "Enter the start date (YYYY-MM-DD)"
$endDate = Read-Host "Enter the end date (YYYY-MM-DD)"
$baseDownloadFolder = Read-Host "Enter the base download folder path"
$basePath = Read-Host "Enter the base path for GCP storage"
$uploadBucket = Read-Host "Enter the upload bucket path"

# Convert dates to DateTime objects
$startDate = Get-Date $startDate
$endDate = Get-Date $endDate

$logFile = Join-Path $baseDownloadFolder "downloaded_tfplans.txt"

# Ensure base folder and log file exist
if (-Not (Test-Path $baseDownloadFolder)) {
    New-Item -Path $baseDownloadFolder -ItemType Directory | Out-Null
}
if (-Not (Test-Path $logFile)) {
    New-Item -Path $logFile -ItemType File | Out-Null
}

# Loop through each date
for ($date = $startDate; $date -le $endDate; $date = $date.AddDays(1)) {
    $prefix = $date.ToString("yyyyMMdd")
    $searchPath = "$basePath/$prefix*"
    $dateFolder = Join-Path $baseDownloadFolder $prefix
    $jsonFolder = Join-Path $dateFolder "json"
    $dateLogFile = Join-Path $dateFolder "downloaded_files.txt"

    Write-Host "Searching in: $searchPath"

    # Create folders
    if (-Not (Test-Path $dateFolder)) {
        New-Item -Path $dateFolder -ItemType Directory | Out-Null
    }
    if (-Not (Test-Path $jsonFolder)) {
        New-Item -Path $jsonFolder -ItemType Directory | Out-Null
    }

    # Initialize or clear the date-specific log file
    Set-Content -Path $dateLogFile -Value ""

    # Find .tfplan files
    $tfplanFiles = gsutil ls -r "$searchPath/**" 2>$null | Where-Object { $_ -like "*.tfplan" }

    foreach ($file in $tfplanFiles) {
        Write-Host "Downloading: $file"
        $fileName = Split-Path $file -Leaf
        $localPath = Join-Path $dateFolder $fileName

        # Download file
        gsutil cp $file $localPath 2>$null

        # Log to global and date-specific logs
        Add-Content -Path $logFile -Value $file
        Add-Content -Path $dateLogFile -Value $file

        # Copy to json folder with .json extension
        $jsonFileName = [System.IO.Path]::ChangeExtension($fileName, ".json")
        Copy-Item -Path $localPath -Destination (Join-Path $jsonFolder $jsonFileName)
    }

    Start-Sleep -Seconds 60

    # Upload the entire date folder to GCP
    Write-Host "Uploading $dateFolder to $uploadBucket/$prefix"
    gsutil -m cp -r "$dateFolder" "$uploadBucket/"

    # Clear the local date folder
    Remove-Item -Path $dateFolder -Recurse -Force

    # Add a blank line to separate logs by date
    Add-Content -Path $logFile -Value ""
}

Write-Host "All operations completed. Logs saved to $logFile"

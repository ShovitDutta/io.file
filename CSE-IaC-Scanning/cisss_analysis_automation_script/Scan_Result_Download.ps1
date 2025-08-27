# Define the base GCS path
$gcsBasePath = "gs://csetest/review_plan_files"

# Define the local download path
$localDownloadPath = "C:\Users\C842034\Saurabh\CVS_Work\CVS_IAC\ContainerAutomation\scan_result"
if (-not (Test-Path $localDownloadPath)) {
    New-Item -ItemType Directory -Force -Path $localDownloadPath | Out-Null
}

# Define start and end dates (inclusive)
$startDate = [datetime]::ParseExact("20250405", "yyyyMMdd", $null)
$endDate = [datetime]::ParseExact("20250406", "yyyyMMdd", $null)

# List all folders in the base path
$folders = & gsutil ls $gcsBasePath

foreach ($folder in $folders) {
    # Extract the folder name (e.g., 20250405)
    $folderName = ($folder.TrimEnd('/') -split '/')[-1]

    # Try to parse the folder name as a date
    try {
        $folderDate = [datetime]::ParseExact($folderName, "yyyyMMdd", $null)
    } catch {
        continue  # Skip folders that don't match the date format
    }

    # Check if the folder date is within the specified range
    if ($folderDate -ge $startDate -and $folderDate -le $endDate) {        

        $jsonFolderPath = "${folder}result_json/*.json"

        # Create a local subfolder for this date
        $localSubfolder = Join-Path $localDownloadPath $folderName
        if (-not (Test-Path $localSubfolder)) {
            New-Item -ItemType Directory -Force -Path $localSubfolder | Out-Null
        }

        # Download JSON files
        Write-Host "Downloading JSON files from $jsonFolderPath to $localSubfolder"
        & gsutil -m cp $jsonFolderPath $localSubfolder
    }
}

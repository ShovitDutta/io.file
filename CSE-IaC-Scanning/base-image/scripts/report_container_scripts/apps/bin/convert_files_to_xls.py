import openpyxl
from csv import reader
import sys

# Define variable to load the dataframe
wb = openpyxl.Workbook()
sheet_array=[ "sheet0", "sheet1","sheet2","sheet3" ]
sheet_array_nm=[ "sheet0", "Coverage_Report","Scan_metrics","Rules_Info_weekly" ]

n = len(sys.argv)
# open demo.csv file in read mode
for i in range(1, n-1):
      with open(sys.argv[i], 'r') as readObj:

    # pass the file object to reader() to get the reader object
           csvReader = reader(readObj)

           my_sheet=sheet_array[i]
           my_sheet_nm=sheet_array_nm[i]
           my_sheet=wb.create_sheet(my_sheet_nm)
    # Iterate over each row in the csv using reader object
           for row in csvReader:
        # row variable is a list that represents a row in csv
              my_sheet.append(row)
wb.remove(wb['Sheet'])
wb.save(sys.argv[4])

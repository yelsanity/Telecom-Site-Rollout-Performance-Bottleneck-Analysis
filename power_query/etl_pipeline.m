// ETL - Auto-detect and load the latest tracker file
// Reads the most recent .xlsx file based on yyyy-MM-dd date in filename
let
    Source = Folder.Files("C:\Your\Tracker\Folder\Path"),
    ExcelFiles = Table.SelectRows(Source, each Text.EndsWith([Name], ".xlsx")),
    AddFileDate = Table.AddColumn(ExcelFiles, "File Date", each
        Date.FromText(
            Text.BeforeDelimiter(
                Text.AfterDelimiter([Name], "_", {0, RelativePosition.FromEnd}),
                ".xlsx"
            ),
            [Format="yyyy-MM-dd"]
        )
    ),
    SortNewest = Table.Sort(AddFileDate, {{"File Date", Order.Descending}}),
    LatestFile = SortNewest{0}[Content],
    ReadExcel = Excel.Workbook(LatestFile, null, true)
in
    ReadExcel

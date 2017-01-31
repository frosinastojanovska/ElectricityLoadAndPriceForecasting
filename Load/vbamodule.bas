Attribute VB_Name = "Module2"
Sub computeForecast()
'This routine is called when the Compute Forecast button is pushed

Dim NNForecast As Variant
Dim TBForecast As Variant
Dim model As String
Dim foreDate As Variant
Dim foreTemp As Variant
Dim isHoliday As String

'Get inputs
foreDate = Sheets("Forecast").Range("inDate").Value
foreTemp = Sheets("Forecast").Range("inTemperature").Value
isHoliday = Sheets("Forecast").Range("inHoliday").Value

'Call MATLAB-generated function
Forecast = loadForecast(foreDate, foreTemp, isHoliday)
                            
'Write outputs
Sheets("Forecast").Range("outForecast").Value = Forecast
                            
'Insert figure
InsertFigure

End Sub

Sub launchReport()
'This routine is called when the Launch Calibration Report button is pressed.
'It simply launches the Neural Network calibration report
reportPath = Application.Workbooks(1).Path & "\html\CalibrationReport.html"
ActiveWorkbook.FollowHyperlink Address:=reportPath, NewWindow:=True

End Sub

Sub ClearCells()
'This routine is called when the Clear button is pressed.
'It clears the figure and forecast information from the sheet
Dim mainSheet As Worksheet
Dim idx
Set mainSheet = ThisWorkbook.Sheets(1)
    Range("outForecast").Value = ""
    If mainSheet.Shapes.Count > 3 Then
        mainSheet.Shapes(1).Delete
    End If
    
End Sub

Sub InsertFigure()
'This routine inserts the figure from the clipboard into the spreadsheet
Dim idx As Integer
Dim mainSheet As Worksheet
Set mainSheet = ThisWorkbook.Sheets(1)

'Clean out existing figures
If mainSheet.Shapes.Count > 3 Then
    mainSheet.Shapes(1).Delete
End If

'Paste new figure
Range("g8").Select
mainSheet.Paste

'Resize figure to fill its allotted space, regardless of the screen resolution
For idx = 1 To mainSheet.Shapes.Count
    If Left(mainSheet.Shapes(idx).OLEFormat.Object.Name, 6) = "Pictur" Then
            mainSheet.Shapes(idx).Height = mainSheet.Range("G8:G28").Height
            'mainSheet.Shapes(idx).Width = mainSheet.Range("G8:N8").Width
        Exit For
    End If
Next idx

End Sub

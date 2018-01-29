Type=StaticCode
Version=4.7
ModulesStructureVersion=1
B4J=true
@EndOfDesignText@
'Static code module
Sub Process_Globals
	Private fx As JFX
	Private listStrategiesAndMethodsFrom As Form
	Public categoryname, subcategory As String
	Private ListView1 As ListView

End Sub

Public Sub Show
	listStrategiesAndMethodsFrom.Initialize("列表",380,330)
	listStrategiesAndMethodsFrom.SetFormStyle("UNIFIED")
	listStrategiesAndMethodsFrom.RootPane.LoadLayout("listContentInCategory") 'Load the layout file.
	listStrategiesAndMethodsFrom.Title="翻译策略与方法"
	listStrategiesAndMethodsFrom.Show
	loadList
End Sub

Sub loadList
	Dim path As String
	path=File.Combine(File.DirApp,"StrategiesAndMethods/ByCategory/"&categoryname&"/"&subcategory)
	Log(path)
	Dim filelist As List
	filelist.Initialize
	filelist=File.ListFiles(path)
	ListView1.Items.AddAll(filelist)
End Sub

Sub ListView1_SelectedIndexChanged(Index As Int)
	
End Sub

Sub ListView1_MouseClicked (EventData As MouseEvent)
    If ListView1.SelectedItem<>Null Then
		Dim path As String
		path=File.Combine(File.DirApp,"StrategiesAndMethods/ByCategory/"&categoryname&"/"&subcategory&"/"&ListView1.SelectedItem)
		Log(path)	
		viewStrategy.path=path
		viewStrategy.Show		
    End If
End Sub


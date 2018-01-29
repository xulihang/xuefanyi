Type=StaticCode
Version=4.7
ModulesStructureVersion=1
B4J=true
@EndOfDesignText@
'Static code module
Sub Process_Globals
	Private fx As JFX
    Private listContentInCategoryForm As Form		
	Private ListView1 As ListView
	Public categoryname As String
	Public subcategory As String
End Sub

Public Sub Show
	listContentInCategoryForm.Initialize("列表",380,330)
	listContentInCategoryForm.SetFormStyle("UNIFIED")
	listContentInCategoryForm.RootPane.LoadLayout("listContentInCategory") 'Load the layout file.
	listContentInCategoryForm.Show
	loadList
End Sub

Sub loadList
	Dim path As String
	path=File.Combine(File.DirApp,"Corpus/ByCategory/"&categoryname&"/"&subcategory)
	Log(path)
	Dim filelist As List
	filelist.Initialize
	filelist=File.ListFiles(path)
	Dim ItemToRemove As List
	ItemToRemove.Initialize
	For i=0 To filelist.Size-1
        Dim item As String
		item=filelist.Get(i)
		Log(item)
		If item.Contains("-term") Then '排除术语文件
			ItemToRemove.Add(filelist.Get(i))
		End If
		If item.Contains("[parallel]") And Main.result=-2 Then '处理查看平行文本还是可比文本
			ItemToRemove.Add(filelist.Get(i))
		Else if Main.result=-1 And item.Contains("-term")=False And item.Contains("[parallel]")=False Then
			ItemToRemove.Add(filelist.Get(i))
		End If		
	Next
	ListView1.Items.AddAll(filelist)
	For Each item As String In ItemToRemove
		Log(item)
		ListView1.Items.RemoveAt(ListView1.Items.IndexOf(item))
	Next
	
End Sub

Sub ListView1_SelectedIndexChanged(Index As Int)
	
End Sub

Sub ListView1_MouseClicked (EventData As MouseEvent)
    If ListView1.SelectedItem<>Null Then
		Dim path As String
		path=File.Combine(File.DirApp,"Corpus/ByCategory/"&categoryname&"/"&subcategory&"/"&ListView1.SelectedItem)
		Log(path)	
		viewContent.path=path
		viewContent.Show		
    End If
End Sub

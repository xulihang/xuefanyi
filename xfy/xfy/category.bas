Type=StaticCode
Version=4.7
ModulesStructureVersion=1
B4J=true
@EndOfDesignText@
'Static code module
Sub Process_Globals
	Private fx As JFX
	Private categoryForm As Form
	Private TreeView1 As TreeView
	Private Button1 As Button
	Private Label1 As Label
	Private Label2 As Label
End Sub

Public Sub Show
	categoryForm.Initialize("登录",380,330)
	categoryForm.SetFormStyle("UNIFIED")
	categoryForm.RootPane.LoadLayout("category") 'Load the layout file.
	categoryForm.Show
	addTreeViewItem
	Button1.Enabled=False
End Sub

Sub TreeView1_SelectedItemChanged(SelectedItem As TreeItem)
    Log(SelectedItem.Parent.Root)
	Button1.Tag=SelectedItem.Text
	TreeView1.Tag=SelectedItem.Parent.Root
	Log(Button1.tag)
	If SelectedItem.Parent.Root=True Then
		Button1.Enabled=False
	Else
		listContentInCategory.subcategory=SelectedItem.Text
		listContentInCategory.categoryname=SelectedItem.Parent.Text
		Button1.Enabled=True
	End If
End Sub

Sub TreeView1_MouseClicked (EventData As MouseEvent)
	
End Sub

Sub addTreeViewItem
	Dim categoryList As List
	categoryList=File.ListFiles("./Corpus/ByCategory")
	For Each item As String In categoryList
		Dim treeItem As TreeItem
		treeItem.Initialize("treeItem",item)
		Dim subCategory As List
		subCategory=File.ListFiles("./Corpus/ByCategory/"&item)
		For Each subitem As String In subCategory
			Dim ctreeItem As TreeItem
            ctreeItem.Initialize("ctreeItem", subitem)
            treeItem.Children.Add(ctreeItem) 'add the child
		Next
		TreeView1.Root.Children.Add(treeItem)
	Next
End Sub

Sub treeItem_ExpandedChanged(Expanded As Boolean)
   Dim ti As TreeItem = Sender
   Log(ti.Text & ": " & Expanded)
End Sub

Sub Button1_MouseClicked (EventData As MouseEvent)
	listContentInCategory.Show
	categoryForm.Close
End Sub
Sub Label2_MouseClicked (EventData As MouseEvent)
    addCorpusByCategoryStep1.Show
End Sub

Sub Label1_MouseClicked (EventData As MouseEvent)
	Dim msgbox As Msgboxes
	msgbox.Show("此分类里为各类可比文本收集，主要供阅读以获取广泛的知识。"&CRLF&"Know something about everything.","说明")
End Sub
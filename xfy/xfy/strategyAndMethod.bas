Type=StaticCode
Version=4.7
ModulesStructureVersion=1
B4J=true
@EndOfDesignText@
'Static code module
Sub Process_Globals
	Private fx As JFX
	Private strategyAndMethodForm As Form
	Private Button1 As Button
	Private Label1 As Label
	Private Label2 As Label
	Private TreeView1 As TreeView

End Sub

Public Sub Show
	strategyAndMethodForm.Initialize("查看",380,330)
	strategyAndMethodForm.SetFormStyle("UNIFIED")
	strategyAndMethodForm.RootPane.LoadLayout("strategyAndMethod") 'Load the layout file.
	strategyAndMethodForm.Show
    addTreeViewItem
End Sub

Sub Button1_MouseClicked (EventData As MouseEvent)
	listStrategiesAndMethods.Show
	strategyAndMethodForm.Close
End Sub

Sub TreeView1_SelectedItemChanged(SelectedItem As TreeItem)
    Log(SelectedItem.Parent.Root)
	Button1.Tag=SelectedItem.Text
	TreeView1.Tag=SelectedItem.Parent.Root
	Log(Button1.tag)
	If SelectedItem.Parent.Root=True Then
		Button1.Enabled=False
	Else
		listStrategiesAndMethods.subcategory=SelectedItem.Text
		listStrategiesAndMethods.categoryname=SelectedItem.Parent.Text
		Button1.Enabled=True
	End If	
End Sub

Sub addTreeViewItem
	Dim categoryList As List
	categoryList=File.ListFiles("./StrategiesAndMethods/ByCategory")
	For Each item As String In categoryList
		Dim treeItem As TreeItem
		treeItem.Initialize("treeItem",item)
		Dim subCategory As List
		subCategory=File.ListFiles("./StrategiesAndMethods/ByCategory/"&item)
		For Each subitem As String In subCategory
			Dim ctreeItem As TreeItem
            ctreeItem.Initialize("ctreeItem", subitem)
            treeItem.Children.Add(ctreeItem) 'add the child
		Next
		TreeView1.Root.Children.Add(treeItem)
	Next
End Sub

Sub Label2_MouseClicked (EventData As MouseEvent)
    addStrategyStep1.Show
End Sub

Sub Label1_MouseClicked (EventData As MouseEvent)
	Dim msgbox As Msgboxes
	msgbox.Show("此分类里为各类翻译技巧和例文收集。","说明")
End Sub


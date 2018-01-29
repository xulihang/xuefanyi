Type=StaticCode
Version=4.7
ModulesStructureVersion=1
B4J=true
@EndOfDesignText@
'Static code module
Sub Process_Globals
	Private fx As JFX
	Private exerciseForm As Form
	Private Button1 As Button
	Private ListView1 As ListView
	Private Button2 As Button
End Sub

Public Sub Show
	exerciseForm.Initialize("查看",600,400)
	exerciseForm.SetFormStyle("UNIFIED")
	exerciseForm.RootPane.LoadLayout("exercise") 'Load the layout file.
	exerciseForm.Show
    loadList
End Sub

Sub Button1_MouseClicked (EventData As MouseEvent)
	loadText.Show
End Sub

Sub Button2_MouseClicked (EventData As MouseEvent)
	exerciseForm.Close
	loadExerciseDone.Show
End Sub

Sub loadList
	Dim list1,toDeleteList As List
	toDeleteList.Initialize
	list1=File.ListFiles(File.Combine(File.DirApp,"/Exercise/Done/"))
	ListView1.Items.AddAll(list1)
	For Each item As String In list1
		If item.Contains("-bitext") Or item.Contains("-annotation") Then
			toDeleteList.Add(item)
		End If
	Next
	For Each item As String In toDeleteList
        ListView1.items.RemoveAt(ListView1.items.IndexOf(item))
	Next
	
End Sub

Sub ListView1_MouseClicked (EventData As MouseEvent)
	If ListView1.SelectedItem<>Null Then
		Log(ListView1.SelectedItem)
		viewExercise.Show(File.Combine(File.DirApp,"/Exercise/Done/"&ListView1.SelectedItem))
	End If
End Sub
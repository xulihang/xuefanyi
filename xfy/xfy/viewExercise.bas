Type=StaticCode
Version=4.7
ModulesStructureVersion=1
B4J=true
@EndOfDesignText@
'Static code module
Sub Process_Globals
	Private fx As JFX
	Private viewExerciseForm As Form
	Private TextArea1 As TextArea
	Private Button1 As Button
End Sub

Public Sub Show(path As String)
	viewExerciseForm.Initialize("查看",600,400)
	viewExerciseForm.SetFormStyle("UNIFIED")
	viewExerciseForm.RootPane.LoadLayout("viewExercise") 'Load the layout file.
	viewExerciseForm.Show
	modifyText.path=path
	TextArea1.Text=File.ReadString(path,"")
End Sub

Sub TextArea1_TextChanged (Old As String, New As String)
	
End Sub

Sub Button1_MouseClicked (EventData As MouseEvent)
	viewExerciseForm.Close
	modifyText.Show
End Sub
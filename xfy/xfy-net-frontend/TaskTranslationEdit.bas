Type=StaticCode
Version=5.9
ModulesStructureVersion=1
B4J=true
@EndOfDesignText@
'Static code module
Sub Process_Globals
	Private fx As JFX
	Private TaskTranslationEditForm As Form
End Sub

Public Sub Show
	TaskTranslationEditForm.Initialize("查看",600,450)
	TaskTranslationEditForm.SetFormStyle("UNIFIED")
	TaskTranslationEditForm.RootPane.LoadLayout("TaskTranslationEdit") 'Load the layout file.
	TaskTranslationEditForm.Show
End Sub
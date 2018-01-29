Type=StaticCode
Version=4.7
ModulesStructureVersion=1
B4J=true
@EndOfDesignText@
'Static code module
Sub Process_Globals
	Private fx As JFX
	Private addCorpusByCategoryForm As Form
	Private Button1 As Button
	Private CheckBox1 As CheckBox
	Private ComboBox1 As ComboBox
	Private ComboBox2 As ComboBox
	Private Label1 As Label
	Private Label2 As Label
	Private TextField1 As TextField
End Sub


Public Sub Show
	addCorpusByCategoryForm.Initialize("添加语料",380,330)
	addCorpusByCategoryForm.SetFormStyle("UNIFIED")
	addCorpusByCategoryForm.RootPane.LoadLayout("addCorpusByCategory") 'Load the layout file.
	addCorpusByCategoryForm.Show
End Sub

Sub CheckBox1_CheckedChange(Checked As Boolean)
	
End Sub

Sub Button1_MouseClicked (EventData As MouseEvent)
	
End Sub
Type=StaticCode
Version=4.7
ModulesStructureVersion=1
B4J=true
@EndOfDesignText@
'Static code module
Sub Process_Globals
	Private fx As JFX
	Private LoginForm As Form
	Private Button1 As Button
    Private Button2 As Button
	Private Label1 As Label
	Private RadioButton1 As RadioButton
	Private RadioButton2 As RadioButton
	Private TextField1 As TextField
	Private TextField2 As TextField
	
End Sub

Public Sub Show
	LoginForm.Initialize("登录",380,330)
	LoginForm.SetFormStyle("UNIFIED")
	LoginForm.RootPane.LoadLayout("login") 'Load the layout file.
	LoginForm.Show
End Sub


Sub Button1_MouseClicked (EventData As MouseEvent)
	If RadioButton1.Selected=True Then '老师
		File.WriteString(File.DirApp,"user","teacher")
	Else '学生
		File.WriteString(File.DirApp,"user","student")
	End If
	LoginForm.Close
	Main.Show
End Sub

Sub RadioButton2_SelectedChange(Selected As Boolean)
	
End Sub

Sub RadioButton1_SelectedChange(Selected As Boolean)
	
End Sub

Sub Button2_MouseClicked (EventData As MouseEvent)
	File.WriteString(File.DirApp,"user","Guest")
	LoginForm.Close
	Main.Show	
End Sub


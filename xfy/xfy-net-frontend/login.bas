Type=StaticCode
Version=5.9
ModulesStructureVersion=1
B4J=true
@EndOfDesignText@
'Static code module
Sub Process_Globals
	Private fx As JFX
	Private LoginForm As Form
	Private Button1 As Button
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
	load
End Sub

Sub load
	If File.Exists(File.DirApp,"user") Then
		Dim list1 As List
		list1=File.ReadList(File.DirApp,"user")
		TextField1.Text=list1.Get(0)
		TextField2.Text=list1.Get(1)
		Select list1.Get(2)
			Case "teacher"
				RadioButton1.Selected=True
			Case "student"
				RadioButton2.Selected=True
		End Select
	End If
End Sub


Sub Button1_MouseClicked (EventData As MouseEvent)
	Dim userType As String
	If RadioButton1.Selected=True Then
		userType="teacher"
	Else
		userType="student"
	End If
	Dim job1 As HttpJob
	job1.Initialize("job1",Me)
	job1.PostString("http://127.0.0.1:8888/userlogin","username="&TextField1.Text&"&password="&TextField2.Text&"&userType="&userType)
	

End Sub

Sub JobDone (job As HttpJob)
	Log("JobName = " & job.JobName & ", Success = " & job.Success)
	If job.Success = True Then
		Select job.JobName
			Case "job1"
				If job.GetString="Login successfully." Then
					Dim list1 As List
					list1.Initialize
					list1.Add(TextField1.Text)
					list1.Add(TextField2.Text)
					If RadioButton1.Selected=True Then '老师
						list1.Add("teacher")
						File.WriteList(File.DirApp,"user",list1)
					Else '学生
						list1.Add("student")
						File.WriteList(File.DirApp,"user",list1)
					End If
					LoginForm.Close
					Main.Show
				Else
                    fx.Msgbox(LoginForm,job.GetString,"")
				End If
		End Select
	Else
		Log("Error: " & job.ErrorMessage)
	End If
	job.Release
End Sub

Sub RadioButton2_SelectedChange(Selected As Boolean)
	
End Sub

Sub RadioButton1_SelectedChange(Selected As Boolean)
	
End Sub
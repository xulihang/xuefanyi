Type=StaticCode
Version=5.9
ModulesStructureVersion=1
B4J=true
@EndOfDesignText@
'Static code module
Sub Process_Globals
	Private fx As JFX
	Private viewHomeworkDoneListForm As Form
	Private ListView1 As ListView
	Private Button1 As Button
	Private hwkname As String
End Sub

Public Sub Show(homeworkname As String)
	viewHomeworkDoneListForm.Initialize("查看",600,450)
	viewHomeworkDoneListForm.SetFormStyle("UNIFIED")
	viewHomeworkDoneListForm.RootPane.LoadLayout("viewHomeworkDoneList") 'Load the layout file.
	viewHomeworkDoneListForm.Show
	hwkname=homeworkname
	loadList(homeworkname)
End Sub

Sub ListView1_MouseClicked (EventData As MouseEvent)
	
End Sub

Sub loadList(homeworkname As String)
	Dim job1 As HttpJob
	Dim teachername As String
	teachername=File.ReadList(File.DirApp,"user").Get(0)
	job1.Initialize("job1",Me)
	job1.Download("http://127.0.0.1:8888/homeworkDoneList?"&"teacher="&teachername&"&homeworkname="&homeworkname)
End Sub

Sub JobDone (job As HttpJob)
	Log("JobName = " & job.JobName & ", Success = " & job.Success)
	If job.Success = True Then
		Select job.JobName
			Case "job1"
				Dim json As JSONParser
				json.Initialize(job.GetString)
				ListView1.Items.AddAll(json.NextArray)
		End Select
	Else
		Log("Error: " & job.ErrorMessage)
	End If
	job.Release
End Sub

Sub Button1_MouseClicked (EventData As MouseEvent)
	If ListView1.SelectedItem<>Null Then
	    viewHomework.Show(hwkname,ListView1.SelectedItem)
	End If
End Sub
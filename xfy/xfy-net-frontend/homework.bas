Type=StaticCode
Version=4.7
ModulesStructureVersion=1
B4J=true
@EndOfDesignText@
'Static code module
Sub Process_Globals
	Private fx As JFX
	Private homeworkForm As Form
End Sub

Public Sub Show
	homeworkForm.Initialize("查看",600,400)
	homeworkForm.SetFormStyle("UNIFIED")
	homeworkForm.RootPane.LoadLayout("viewContent") 'Load the layout file.
	homeworkForm.Show
	uploadHomework
End Sub

Sub uploadHomework
	Dim job1 As HttpJob
	job1.Initialize("job1",Me)
	Dim fd As MultipartFileData
	fd.Initialize
	fd.KeyName = "file"
    fd.Dir = File.DirApp
    fd.FileName = "1.zip"
    fd.ContentType = "application/zip"
    Dim files As List
    files.Initialize
    files.Add(fd)	
	Dim map1 As Map
	map1.Initialize
	map1.Put("title","hello")
	map1.Put("username","1120113325")
	job1.PostMultipart("http://192.168.1.107:8888/homework",map1,files)
End Sub

Sub JobDone (job As HttpJob)
	Log("JobName = " & job.JobName & ", Success = " & job.Success)
	If job.Success = True Then
		Select job.JobName
			Case "job1"
                fx.Msgbox(homeworkForm,job.GetString,"")
		End Select
	Else
		Log("Error: " & job.ErrorMessage)
	End If
	job.Release
End Sub
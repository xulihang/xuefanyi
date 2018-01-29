Type=StaticCode
Version=5.9
ModulesStructureVersion=1
B4J=true
@EndOfDesignText@
'Static code module
Sub Process_Globals
	Private fx As JFX
	Private homeworkTeacherForm As Form
	Private Button1 As Button
	Private Label1 As Label
	Private ListView1 As ListView
	Private Button2 As Button
End Sub

Public Sub Show
	homeworkTeacherForm.Initialize("查看",600,400)
	homeworkTeacherForm.SetFormStyle("UNIFIED")
	homeworkTeacherForm.RootPane.LoadLayout("homeworkTeacher") 'Load the layout file.
	homeworkTeacherForm.Show
	loadHomeworkList
End Sub

Sub uploadHomework(path As String)
	Dim job1 As HttpJob
	job1.Initialize("job1",Me)
	Dim dir,name As String
	If path.Contains("\") Then
		dir=path.SubString2(0,path.LastIndexOf("\"))
		name=path.SubString(path.LastIndexOf("\")+1)
		Log(dir&CRLF&name)
	Else
		dir=path.SubString2(0,path.LastIndexOf("/"))
		name=path.SubString(path.LastIndexOf("/")+1)
		Log(dir&CRLF&name)
	End If
	Dim fd As MultipartFileData
	fd.Initialize
	fd.KeyName = "file"
    fd.Dir = dir
    fd.FileName = name
    fd.ContentType = "application/zip"
    Dim files As List
    files.Initialize
    files.Add(fd)	
	Dim map1 As Map
	map1.Initialize
	map1.Put("username",File.ReadList(File.DirApp,"user").Get(0))
	job1.PostMultipart("http://127.0.0.1:8888/uploadhomework",map1,files)
End Sub

Sub JobDone (job As HttpJob)
	Log("JobName = " & job.JobName & ", Success = " & job.Success)
	If job.Success = True Then
		Select job.JobName
			Case "job1"
                fx.Msgbox(homeworkTeacherForm,job.GetString,"")
			Case "job2"
				Dim json As JSONParser
				json.Initialize(job.GetString)
				ListView1.Items.AddAll(json.NextArray)
		End Select
	Else
		Log("Error: " & job.ErrorMessage)
	End If
	job.Release
End Sub

Sub ListView1_MouseClicked (EventData As MouseEvent)
	
End Sub

Sub Button1_MouseClicked (EventData As MouseEvent)
	Dim fc As FileChooser
	Dim path As String
	fc.Initialize
	fc.SetExtensionFilter("zip",Array As String("*.zip"))
	path=fc.ShowOpen(homeworkTeacherForm)
	Log(path)
	If path<>"" Then
		uploadHomework(path)
	End If
End Sub

Sub loadHomeworkList
	Dim job2 As HttpJob
	Dim teachername As String
	teachername=File.ReadList(File.DirApp,"user").Get(0)
	job2.Initialize("job2",Me)
	job2.Download("http://127.0.0.1:8888/homeworkList?"&"teacher="&teachername)
End Sub

Sub Button2_MouseClicked (EventData As MouseEvent)
	If ListView1.SelectedItem<>Null Then
	    viewHomeworkDoneList.Show(ListView1.SelectedItem)
	End If
End Sub
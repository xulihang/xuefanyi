Type=StaticCode
Version=5.9
ModulesStructureVersion=1
B4J=true
@EndOfDesignText@
'Static code module
Sub Process_Globals
	Private fx As JFX
	Private homeworkStudentForm As Form
	Private Button1 As Button
	Private ListView1 As ListView
	Private ListView2 As ListView
	Private Button2 As Button
	Private ListView3 As ListView
	Private Button3 As Button
End Sub

Public Sub Show
	homeworkStudentForm.Initialize("查看",600,450)
	homeworkStudentForm.SetFormStyle("UNIFIED")
	homeworkStudentForm.RootPane.LoadLayout("homeworkStudent") 'Load the layout file.
	homeworkStudentForm.Show
	loadTeachers
	loadLocalExercise
End Sub


Sub loadTeachers
	ListView1.Items.Add("张三老师")
End Sub

Sub loadLocalExercise
	Dim list1,toDeleteList As List
	toDeleteList.Initialize
	list1=File.ListFiles(File.Combine(File.DirApp,"/Exercise/Done/"))
	ListView3.Items.AddAll(list1)
	For Each item As String In list1
		If item.Contains("-bitext") Or item.Contains("-annotation") Then
			toDeleteList.Add(item)
		End If
	Next
	For Each item As String In toDeleteList
        ListView3.items.RemoveAt(ListView3.items.IndexOf(item))
	Next
End Sub

Sub ListView1_MouseClicked (EventData As MouseEvent)
	If ListView1.SelectedItem=Null Then
		Return
	End If
	ListView2.Items.Clear
	Dim job1 As HttpJob
	job1.Initialize("job1",Me)
	job1.Download("http://127.0.0.1:8888/homeworkList?"&"teacher="&ListView1.SelectedItem)
End Sub

Sub Button1_MouseClicked (EventData As MouseEvent)
	If ListView2.SelectedItem=Null Then
		fx.Msgbox(homeworkStudentForm,"请先选择作业","")
		Return
	End If
	Dim job2 As HttpJob
	job2.Initialize("job2",Me)
	job2.Download("http://127.0.0.1:8888/"&ListView1.SelectedItem&"/"&ListView2.SelectedItem)
End Sub

Sub JobDone (job As HttpJob)
	Log("JobName = " & job.JobName & ", Success = " & job.Success)
	If job.Success = True Then
		Select job.JobName
			Case "job1"
                Dim json As JSONParser
				json.Initialize(job.GetString)
				ListView2.Items.AddAll(json.NextArray)
			Case "job2"
				Dim out As OutputStream
				out=File.OpenOutput(File.DirApp,"1.zip",False)				
				File.Copy2(job.GetInputStream,out)
				out.Close
				fx.Msgbox(homeworkStudentForm,"已保存到根目录","")
			Case "job3"
				fx.Msgbox(homeworkStudentForm,job.GetString,"")
			Case "job4"
				viewReview.Show(job.GetString)
		End Select
	Else
		fx.Msgbox(homeworkStudentForm,job.ErrorMessage,"")
		Log("Error: " & job.ErrorMessage)
	End If
	job.Release
End Sub

Sub Button2_MouseClicked (EventData As MouseEvent)
	If ListView1.SelectedItem=Null Or ListView2.SelectedItem=Null Then
		fx.Msgbox(homeworkStudentForm,"请同时选中完成的作业和布置的作业以提交","")
	Else
		Dim username As String
		username=File.ReadList(File.DirApp,"user").Get(0)
		Dim filename As String
		filename=ListView3.SelectedItem
		filename=filename.Replace(".txt","-annotation.json")
		Dim archiver As Archiver
		Dim filenames() As String
		filenames=Array As String(ListView3.SelectedItem,ListView3.SelectedItem&"-bitext.csv",filename)
		archiver.AsyncZipFiles(File.Combine(File.DirApp,"/Exercise/Done/"),filenames,File.DirApp,username&".zip","zip")
	End If
End Sub

Sub zip_zipDone(CompletedWithoutError As Boolean, NbOfFiles As Int)
	Log(CompletedWithoutError)
	Log(NbOfFiles)
	submitHomework
End Sub

Sub submitHomework
	Dim map1 As Map
	map1.Initialize
	map1.Put("username",File.ReadList(File.DirApp,"user").Get(0))
	map1.Put("homeworkname",ListView2.SelectedItem)
	map1.Put("teacher",ListView1.SelectedItem)
	Dim fd As MultipartFileData
	fd.Initialize
	fd.KeyName = "file"
    fd.Dir = File.DirApp
    fd.FileName = File.ReadList(File.DirApp,"user").Get(0)&".zip"
    fd.ContentType = "application/zip"
	Dim filelist As List
	filelist.Initialize
	filelist.Add(fd)
	Dim job3 As HttpJob
	job3.Initialize("job3",Me)
	job3.PostMultipart("http://127.0.0.1:8888/submithomework",map1,filelist)
End Sub

Sub Button3_MouseClicked (EventData As MouseEvent)
	Dim job4 As HttpJob
	job4.Initialize("job4",Me)
	job4.PostString("http://127.0.0.1:8888/getReview","teachername="&ListView1.SelectedItem&"&studentname="&File.ReadList(File.DirApp,"user").Get(0)&"&homeworkname="&ListView2.SelectedItem)
End Sub
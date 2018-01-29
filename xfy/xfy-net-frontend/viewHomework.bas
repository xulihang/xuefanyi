Type=StaticCode
Version=5.9
ModulesStructureVersion=1
B4J=true
@EndOfDesignText@
'Static code module
Sub Process_Globals
	Private fx As JFX
	Private viewHomeworkForm As Form
	Private annotationForm As Form
	Private annotationList As List
	Private ListButton As Button
	Private SplitPane1 As SplitPane
	Private WebView1 As WebView
	Private TextArea1 As TextArea
	Private annotationListView As ListView
	Private ReviewButton As Button

End Sub

Public Sub Show(homeworkname As String,studentname As String)
	viewHomeworkForm.Initialize("查看",600,450)
	viewHomeworkForm.SetFormStyle("UNIFIED")
	viewHomeworkForm.RootPane.LoadLayout("viewHomework") 'Load the layout file.
	viewHomeworkForm.Show
	annotationList.Initialize
	SplitPane1.LoadLayout("TextArea")
	SplitPane1.LoadLayout("WebView")	
    downloadHomework(homeworkname,studentname)

End Sub

Sub downloadHomework(homeworkname As String,studentname As String)
	Dim teachername As String
	teachername=File.ReadList(File.DirApp,"user").Get(0)
	Dim list1 As List
	list1.Initialize
	list1.AddAll(Array As String(teachername,homeworkname,studentname))
	File.WriteList(File.DirApp,"homework.tmp",list1)'记录以供批改使用	
	Dim job1 As HttpJob
	job1.Initialize("job1",Me)
	job1.Download("http://127.0.0.1:8888/"&teachername&"/"&homeworkname&"-student"&"/"&studentname&"/"&studentname&".zip")	
End Sub

Sub JobDone (job As HttpJob)
	Log("JobName = " & job.JobName & ", Success = " & job.Success)
	If job.Success = True Then
		Select job.JobName
			Case "job1"
				Dim out As OutputStream
				out=File.OpenOutput(File.DirApp,"homework.zip",False)				
				File.Copy2(job.GetInputStream,out)
				out.Close
				loadContent
		End Select
	Else
		Log("Error: " & job.ErrorMessage)
	End If
	job.Release
End Sub

Sub zip_UnZipDone(CompletedWithoutError As Boolean, NbOfFiles As Int)
	If CompletedWithoutError=False Then
		Log("unzip failed")
	Else
		Dim filelist As List
		filelist=File.ListFiles(File.Combine(File.DirApp,"studentHomework"))
		For Each item As String In filelist
			If item.Contains(".txt") And item.Contains("csv")=False Then
				TextArea1.Text=File.ReadString(File.Combine(File.DirApp,"studentHomework"),item)
				WebView1.LoadHtml(buildHtmlString(TextArea1.Text))
			End If
			If item.Contains("annotation") Then
				Dim json As JSONParser
			    json.Initialize(File.ReadString(File.Combine(File.DirApp,"studentHomework"),item))
			    annotationList.AddAll(json.NextArray)
			End If
		Next		
	End If
End Sub

Sub ListButton_MouseClicked (EventData As MouseEvent)
	If annotationForm.IsInitialized=False Then
		initAnnotationForm
	End If
	If annotationForm.Showing=False Then
		annotationForm.Show
		annotationListView.Items.Clear
		If annotationList.Size=0 Then
			fx.Msgbox(viewHomeworkForm,"译注为空","")
		Else
			Dim i=0 As Int
			For Each map1 As Map In annotationList
				i=i+1
				Dim textlabel As Label
				textlabel.Initialize("textlabel")
				If map1.ContainsKey("批注类型") Then
					'错误及技巧的批注
					textlabel.Text="["&i&"]"&map1.Get("批注类型")&":"&map1.Get("selectedText")
				Else
					'译注（感想）
					textlabel.Text="["&i&"]"&"译注（感想）"&":"&map1.Get("译注（感想）")
				End If
				Dim list1 As List '用于储存信息
				list1.Initialize
				list1.Add(i)
				list1.Add(map1.Get("selectedText"))
				Log(list1)
				textlabel.Tag=list1
				annotationListView.Items.Add(textlabel)	
			Next
		End If
	End If	
End Sub

Sub initAnnotationForm
	annotationForm.Initialize("",280,150)
	annotationForm.SetFormStyle("UNIFIED")
	annotationForm.RootPane.LoadLayout("annotationList") 'Load the layout file.
End Sub

Sub textlabel_MouseClicked (EventData As MouseEvent)
	Dim modifiedstring As String
	Dim lbl As Label
	Dim list1 As List 
	lbl=Sender
	list1=lbl.Tag
	Log(lbl.Tag)
	Dim  selectedText As String
	selectedText=list1.Get(1)&"["&list1.get(0)&"]"
	modifiedstring=TextArea1.Text.Replace(selectedText,"<font color="&Chr(34)&"red"&Chr(34)&">"&selectedText&"</font>")
	WebView1.LoadHtml(buildHtmlString(modifiedstring))
	TextArea1.SetSelection(TextArea1.Text.IndexOf(list1.Get(1)&"["&list1.get(0)&"]"),TextArea1.Text.IndexOf(list1.Get(1)&"["&list1.get(0)&"]")+selectedText.Length)
End Sub

Sub loadContent
	If File.Exists(File.DirApp,"studentHomework")=False Then
		File.MakeDir(File.DirApp,"studentHomework")
	End If
	Dim archiver As Archiver
    archiver.AsyncUnZip(File.DirApp,"homework.zip",File.Combine(File.DirApp,"studentHomework"),"zip")
End Sub

Sub buildHtmlString(raw As String) As String
	Dim result As String
	Dim htmlhead As String
	Dim cssPath As String
	cssPath="file:///"&File.Combine(File.DirApp,"style.css")
	cssPath=cssPath.Replace("\","/")
	htmlhead="<!DOCTYPE HTML><html><head><meta charset="&Chr(34)&"utf-8"&Chr(34)&" /><link href="&Chr(34)&cssPath&Chr(34)&" rel="&Chr(34)&"stylesheet"&Chr(34)&" /><style type="&Chr(34)&"text/css"&Chr(34)&">p {font-size: 18px}</style></head><body>"
	Dim htmlend As String
	htmlend="</body></html>"
	For Each para In Regex.Split(CRLF,raw)
		result=result&"<p>"&para&"</p>"
	Next
	result=htmlhead&result&htmlend
	Return result
End Sub

Sub ReviewButton_MouseClicked (EventData As MouseEvent)
	viewHomeworkForm.Close	
	HomeworkReview.Show
End Sub
Type=StaticCode
Version=5.9
ModulesStructureVersion=1
B4J=true
@EndOfDesignText@
'Static code module
Sub Process_Globals
	Private fx As JFX
	Private ListView1 As ListView
	Private ListView2 As ListView
	Private ListView3 As ListView
	Private textListForm As Form
	Public textType As String
	Private Button1 As Button
	Private Button2 As Button
End Sub

Public Sub Show
	textListForm.Initialize("",600,300)
	textListForm.SetFormStyle("UNIFIED")
	textListForm.RootPane.LoadLayout("textList") 'Load the layout file.
	textListForm.Show
	init
End Sub

Sub init
	ListView1.Items.AddAll(File.ListFiles(File.Combine(File.DirApp,"/"&textType&"/ByCategory")))
End Sub

Sub ListView3_MouseClicked (EventData As MouseEvent)
	If ListView3.SelectedItem=Null Then
		Return
	End If	
End Sub
Sub ListView2_MouseClicked (EventData As MouseEvent)
	If ListView2.SelectedItem=Null Then
		Return
	End If
	ListView3.Items.Clear
	Dim path As String
	path=File.Combine(File.DirApp,"/"&textType&"/ByCategory/"&ListView1.Items.Get(ListView1.SelectedIndex)&"/"&ListView2.Items.Get(ListView2.SelectedIndex))
	Dim fileList As List
    fileList.Initialize
	For Each item As String In File.ListFiles(path)
		If item.Contains("terms")=False Then
			fileList.Add(item)
		End If
	Next
	Log(path)
	ListView3.Items.AddAll(fileList)
End Sub
Sub ListView1_MouseClicked (EventData As MouseEvent)
	If ListView1.SelectedItem=Null Then
		Return
	End If
	ListView3.Items.Clear
	ListView2.Items.Clear
	Dim path As String
	path=File.Combine(File.DirApp,"/"&textType&"/ByCategory/"&ListView1.Items.Get(ListView1.selectedIndex))	
	Log(path)
	ListView2.Items.AddAll(File.ListFiles(path))
End Sub

Sub Button2_MouseClicked (EventData As MouseEvent)
	If ListView3.SelectedItem=Null Then
		fx.Msgbox(textListForm,"请先选择具体的文本","")
		Return
	End If
	Dim categoryname As String
	categoryname=ListView1.Items.Get(ListView1.selectedIndex)
	Dim subcategory As String
	subcategory=ListView2.Items.Get(ListView2.SelectedIndex)
	Dim filename As String
	filename=ListView3.Items.Get(ListView3.SelectedIndex)
	Dim path As String
	path=File.Combine(File.DirApp,textType&"/ByCategory/"&categoryname&"/"&subcategory&"/"&filename)
	Log(path)	
	If textType="Corpus" Then
	    viewContent.path=path	
	    viewContent.Show
	Else
		viewStrategy.path=path	
	    viewStrategy.Show
	End If
End Sub

Sub Button1_MouseClicked (EventData As MouseEvent)
	If ListView3.SelectedItem=Null Then
		fx.Msgbox(textListForm,"请先选择具体的文本","")
		Return
	End If
	Dim categoryname As String
	categoryname=ListView1.Items.Get(ListView1.selectedIndex)
	Dim subcategory As String
	subcategory=ListView2.Items.Get(ListView2.SelectedIndex)
	Dim filename As String
	filename=ListView3.Items.Get(ListView3.SelectedIndex)	
	Dim username As String
	username=File.ReadList(File.DirApp,"user").Get(0)
	Dim textstring As String
	textstring=File.ReadString(File.Combine(File.DirApp,textType&"/ByCategory/"&categoryname&"/"&subcategory&"/"&filename),"")
	Dim job1 As HttpJob
	job1.Initialize("job1",Me)
	job1.PostString("http://127.0.0.1:8888/uploadText","username="&username&"&category="&categoryname&"&subcategory="&subcategory&"&filename="&filename&"&textType="&textType&"&textstring="&textstring)
End Sub

Sub JobDone (job As HttpJob)
	Log("JobName = " & job.JobName & ", Success = " & job.Success)
	If job.Success = True Then
		Select job.JobName
			Case "job1"
                fx.Msgbox(textListForm,job.GetString,"")
		End Select
	Else
		Log("Error: " & job.ErrorMessage)
	End If
	job.Release
End Sub
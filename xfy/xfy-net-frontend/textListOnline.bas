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
	Button1.Visible=False
	init
End Sub

Sub init
	Dim job1 As HttpJob
	job1.Initialize("job1",Me)
	job1.Download("http://127.0.0.1:8888/viewTextList?"&"&textType="&textType)
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
    Dim lbl As Label
	lbl=ListView1.SelectedItem
	Dim category As String
	category=lbl.Text
	Dim subcategory As String
	subcategory=ListView2.SelectedItem
	Dim job2 As HttpJob
	job2.Initialize("job2",Me)
	job2.Download("http://127.0.0.1:8888/viewTextFileList?"&"&textType="&textType&"&category="&category&"&subcategory="&subcategory)
End Sub
Sub ListView1_MouseClicked (EventData As MouseEvent)
	If ListView1.SelectedItem=Null Then
		Return
	End If
	ListView3.Items.Clear
	ListView2.Items.Clear
    Dim lbl As Label
	lbl=ListView1.SelectedItem
	ListView2.Items.AddAll(lbl.Tag)
End Sub

Sub Button2_MouseClicked (EventData As MouseEvent)
	If ListView3.SelectedItem=Null Then
		fx.Msgbox(textListForm,"请先选择具体的文本","")
		Return
	End If	
    Dim lbl As Label
	lbl=ListView1.SelectedItem
	Dim category As String
	category=lbl.Text
	Dim subcategory As String
	subcategory=ListView2.SelectedItem
	Dim filename As String
	filename=ListView3.SelectedItem	
	viewContentOnline.filename=filename
	viewContentOnline.Show(category,subcategory)
End Sub

Sub Button1_MouseClicked (EventData As MouseEvent)
	
End Sub

Sub JobDone (job As HttpJob)
	Log("JobName = " & job.JobName & ", Success = " & job.Success)
	If job.Success = True Then
		Select job.JobName
			Case "job1"
                loadList(job.GetString)
			Case "job2"
                loadFileList(job.GetString)
		End Select
	Else
		Log("Error: " & job.ErrorMessage)
	End If
	job.Release
End Sub

Sub loadList(jsonstring As String)
    Dim json As JSONParser
	json.Initialize(jsonstring)
	Dim map1 As Map
	map1=json.NextObject
	For Each key In map1.Keys
		Dim lbl As Label
		lbl.Initialize("lbl")
		lbl.Text=key
		lbl.Tag=map1.Get(key)
		ListView1.Items.Add(lbl)
	Next
End Sub

Sub loadFileList(jsonstring As String)
	Dim json As JSONParser
	json.Initialize(jsonstring)
	Dim list1 As List
	list1=json.NextArray
	For Each item In list1
		ListView3.Items.Add(item)
	Next
End Sub

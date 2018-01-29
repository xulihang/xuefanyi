Type=StaticCode
Version=5.9
ModulesStructureVersion=1
B4J=true
@EndOfDesignText@
'Static code module
Sub Process_Globals
	Private fx As JFX
	Private viewTaskForm As Form
	Private ListView1 As ListView
	Private inputTextForm As Form
	Private TextArea1 As TextArea	
End Sub

Public Sub Show(code As String)
	viewTaskForm.Initialize("查看",600,450)
	viewTaskForm.SetFormStyle("UNIFIED")
	viewTaskForm.RootPane.LoadLayout("viewTask") 'Load the layout file.
	viewTaskForm.Show
	loadMenu
	getTaskDetail(code)
End Sub

Sub ListView1_MouseClicked (EventData As MouseEvent)
	
End Sub

Sub getTaskDetail(code As String)
	Dim job1 As HttpJob
	job1.Initialize("job1",Me)
	job1.Download("http://127.0.0.1:8888/getTaskDetail?code="&code)
End Sub

Sub JobDone (job As HttpJob)
	Log("JobName = " & job.JobName & ", Success = " & job.Success)
	If job.Success = True Then
		Select job.JobName
			Case "job1"
                loadJson(job.GetString)
		End Select
	Else
		fx.Msgbox(viewTaskForm,job.ErrorMessage,"")
		Log("Error: " & job.ErrorMessage)
	End If
	job.Release
End Sub

Sub loadJson(jsonstring As String)
	Dim json As JSONParser
    json.Initialize(jsonstring)
	For Each map As Map In json.NextArray
		Dim pane1 As Pane
	    pane1.Initialize("pane1")
	    pane1.LoadLayout("panel")
	    pane1.PrefHeight=34dip
	    Dim name,assignment As TextField
		Dim text As Label
		Dim choicebox As ChoiceBox
		name=pane1.GetNode(0)
		assignment=pane1.GetNode(1)
		text=pane1.GetNode(2)
		choicebox=pane1.GetNode(3)
		name.Text=map.Get("组员姓名")
		assignment.Text=map.Get("任务分配")
		text.Text=map.Get("文本")
		choicebox.Items.Add(map.Get("分工"))
		choicebox.SelectedIndex=0
		ListView1.Items.Add(pane1)
	Next
End Sub

Sub loadMenu
	Dim mi As MenuItem
	mi.Initialize("提交翻译","")
	ListView1.ContextMenu.MenuItems.Clear
	ListView1.ContextMenu.MenuItems.Add(mi)
End Sub

Sub Listview1_Action
	TaskTranslationEdit.Show
End Sub

Sub Label1_MouseClicked (EventData As MouseEvent)
	Dim lbl As Label
	lbl=Sender
	inputText(lbl.Text)
	lbl.Text=TextArea1.Text
End Sub

Sub inputText(text As String)
	If inputTextForm.IsInitialized=False Then
		inputTextForm.Initialize("查看",600,450)
		inputTextForm.SetFormStyle("UNIFIED")
		inputTextForm.RootPane.LoadLayout("TextArea") 'Load the layout file.
		TextArea1.Text=text
		inputTextForm.ShowAndWait
	Else
		TextArea1.Text=text
		inputTextForm.ShowAndWait
	End If
End Sub
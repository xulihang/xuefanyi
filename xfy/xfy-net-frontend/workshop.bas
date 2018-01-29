Type=StaticCode
Version=5.9
ModulesStructureVersion=1
B4J=true
@EndOfDesignText@
'Static code module
Sub Process_Globals
	Private fx As JFX
	Private workshopForm As Form
	Private inputTextForm As Form
	Private ListView1 As ListView
	Private TextField1 As TextField
	Private TextArea1 As TextArea
	Private Button2 As Button
	Private Button1 As Button
End Sub

Public Sub Show
	workshopForm.Initialize("查看",600,450)
	workshopForm.SetFormStyle("UNIFIED")
	workshopForm.RootPane.LoadLayout("workshop") 'Load the layout file.
	workshopForm.Show
    addPane

End Sub

Sub addPane
	Dim pane1 As Pane
	pane1.Initialize("pane1")
	pane1.LoadLayout("panel")
	pane1.PrefHeight=34dip
	Dim choicebox As ChoiceBox
	choicebox=pane1.GetNode(3)
	choicebox.Items.AddAll(Array As String("组长","翻译","审校"))
	choicebox.SelectedIndex=1
	ListView1.Items.Add(pane1)
End Sub

Sub ListView1_MouseClicked (EventData As MouseEvent)
	If ListView1.SelectedItem<>Null Then

	End If
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

Sub Button2_MouseClicked (EventData As MouseEvent)
	If File.Exists(File.DirApp,"workshop")=False Then
		File.MakeDir(File.DirApp,"workshop")
	End If
	Dim json As JSONGenerator
	Dim list1 As List
	list1.Initialize
	For Each item As Pane In ListView1.Items
		Dim name,assignment As TextField
		Dim text As Label
		Dim choicebox As ChoiceBox
		name=item.GetNode(0)
		assignment=item.GetNode(1)
		text=item.GetNode(2)
		choicebox=item.GetNode(3)
		Dim map1 As Map
		map1.Initialize
		map1.Put("组员姓名",name.Text)
		map1.Put("任务分配",assignment.Text)
		map1.Put("文本",text.Text)
		map1.Put("分工",choicebox.items.Get(choicebox.SelectedIndex))
		list1.Add(map1)
	Next
	json.Initialize2(list1)
	File.WriteString(File.DirApp,"workshop/out.json",json.ToPrettyString(4))
	Dim job1 As HttpJob
	job1.Initialize("job1",Me)
	job1.PostString("http://127.0.0.1:8888/workshopAdd","name="&TextField1.Text&"&content="&json.ToString)
End Sub

Sub Button1_MouseClicked (EventData As MouseEvent)
	addPane
End Sub

Sub Listview1_Action
   Dim mi As MenuItem = Sender
   Log(mi.Text)
   ListView1.Items.RemoveAt(ListView1.SelectedIndex)	
End Sub

Sub JobDone (job As HttpJob)
	Log("JobName = " & job.JobName & ", Success = " & job.Success)
	If job.Success = True Then
		Select job.JobName
			Case "job1"
                fx.Msgbox(workshopForm,job.GetString,"")
		End Select
	Else
		fx.Msgbox(workshopForm,job.ErrorMessage,"")
		Log("Error: " & job.ErrorMessage)
	End If
	job.Release
End Sub

Sub TextField1_TextChanged (Old As String, New As String)
	If New.Contains("<") Or New.Contains(">") Or New.Contains("/") Or New.Contains("\") Or New.Contains("|") Or New.Contains(":") Or New.Contains(Chr(34)) Or New.Contains("?") Or New.Contains("*") Then
	    TextField1.Text=Old
		fx.msgbox(workshopForm,"不能包含< > / \ | : " & Chr(34)  & " * ?等字符","")
	End If
End Sub
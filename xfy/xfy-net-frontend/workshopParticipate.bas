Type=StaticCode
Version=5.9
ModulesStructureVersion=1
B4J=true
@EndOfDesignText@
'Static code module
Sub Process_Globals
	Private fx As JFX
	Private workshopParticipateForm As Form
	Private Button1 As Button
	Private ListView1 As ListView
	Private TextField1 As TextField

End Sub

Public Sub Show
	workshopParticipateForm.Initialize("查看",600,450)
	workshopParticipateForm.SetFormStyle("UNIFIED")
	workshopParticipateForm.RootPane.LoadLayout("workshopParticipate") 'Load the layout file.
	workshopParticipateForm.Show
	loadList
	TextField1.Text="1487818005172"
End Sub

Sub Button1_MouseClicked (EventData As MouseEvent)
	viewTask.Show(TextField1.Text)
End Sub

Sub loadList
	Dim job1 As HttpJob
	job1.Initialize("job1",Me)
	job1.Download("http://127.0.0.1:8888/workshopList")
End Sub

Sub JobDone (job As HttpJob)
	Log("JobName = " & job.JobName & ", Success = " & job.Success)
	If job.Success = True Then
		Select job.JobName
			Case "job1"
                loadJson(job.GetString)
		End Select
	Else
		fx.Msgbox(workshopParticipateForm,job.ErrorMessage,"")
		Log("Error: " & job.ErrorMessage)
	End If
	job.Release
End Sub


Sub loadJson(jsonstring As String)
	Dim json As JSONParser
	json.Initialize(jsonstring)
	Dim list1 As List
	list1=json.NextArray
	For Each item As String In list1
		Dim lbl As Label
		lbl.Initialize("lbl")
		lbl.Text=DateTime.Date(Regex.Split("-",item)(0))&"-"&Regex.Split("-",item)(1)
		lbl.Tag=item
		ListView1.Items.Add(lbl)
	Next
End Sub



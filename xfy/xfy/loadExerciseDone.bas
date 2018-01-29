Type=StaticCode
Version=4.7
ModulesStructureVersion=1
B4J=true
@EndOfDesignText@
'Static code module
Sub Process_Globals
	Private fx As JFX
	Private loadExerciseDoneForm As Form
	Private Button1 As Button
	Private ListView1 As ListView
	Private ListView2 As ListView
	Private Button2 As Button
	Private InputTextField1 As TextField
	Private OKButton1 As Button
	Private inputTitleForm As Form
	Private title As String
End Sub

Public Sub Show
	loadExerciseDoneForm.Initialize("查看",600,400)
	loadExerciseDoneForm.SetFormStyle("UNIFIED")
	loadExerciseDoneForm.RootPane.LoadLayout("loadExerciseDone") 'Load the layout file.
	loadExerciseDoneForm.Show
End Sub

Sub Button1_MouseClicked (EventData As MouseEvent)
	Dim shell As Shell
	shell.Initialize("","./AU3/获取双语文本无界面版.exe",Null)
	shell.WorkingDirectory=File.DirApp
	shell.RunSynchronous(-1)
	loadTMX
	Button2.Visible=True
End Sub

Sub loadTMX
	Dim su As ApacheSU
	Dim textReader As TextReader
	textReader.Initialize(File.OpenInput(File.DirApp,"out.csv"))
	Dim line As String
	line=textReader.ReadLine
	Do While line<>Null
		ListView1.Items.Add(su.SplitWithSeparator(line,"	")(0))
		ListView2.Items.Add(su.SplitWithSeparator(line,"	")(1))
		line=textReader.ReadLine
	Loop
	textReader.Close
End Sub

Sub Button2_MouseClicked (EventData As MouseEvent)
	inputTitleForm.Initialize("",300,125)
	inputTitleForm.SetFormStyle("UNIFIED")
	inputTitleForm.RootPane.LoadLayout("inputTitle") 'Load the layout file.
	inputTitleForm.ShowAndWait
		
	Dim sourceText,translation As String
	For Each item As String In ListView1.Items
		sourceText=sourceText&item
	Next
	For Each item As String In ListView2.Items
		translation=translation&item
	Next
	sourceText=sourceText.Replace("\n",CRLF)
	translation=translation.Replace("\n",CRLF)
	Dim filename As String
	filename=DateTime.GetYear(DateTime.Now)&"-"&DateTime.GetMonth(DateTime.Now)&"-"&DateTime.GetDayOfMonth(DateTime.Now)&"-"&title&".txt"
	File.WriteString(File.DirApp,"/Exercise/Done/"&filename,"译文："&CRLF&translation&CRLF&"原文："&CRLF&sourceText)	
	File.Copy(File.DirApp,"out.csv",File.DirApp,"/Exercise/Done/"&filename&"-bitext.csv")
End Sub

Sub OKButton1_MouseClicked (EventData As MouseEvent)
    If InputTextField1.Text="" Then
		fx.Msgbox(inputTitleForm,"请输入标题","")
	Else
		title=InputTextField1.Text
	    inputTitleForm.Close	
    End If
End Sub
Type=StaticCode
Version=4.7
ModulesStructureVersion=1
B4J=true
@EndOfDesignText@
'Static code module
Sub Process_Globals
	Private fx As JFX
	Private viewTermsForm As Form
	Private ListView1 As ListView
	Private Button1 As Button
	Private TextField1 As TextField
	Private TextField2 As TextField
	Private addTermsForm As Form
	Private addTermsListForm As Form
	Private termListView As ListView
	Private upLoadButton As Button
	Private addTermButton As Button
	Private termFilePath As String
End Sub

Public Sub Show
	viewTermsForm.Initialize("查看",380,330)
	viewTermsForm.SetFormStyle("UNIFIED")
	viewTermsForm.RootPane.LoadLayout("viewTerms") 'Load the layout file.
	viewTermsForm.Show
    loadTerms
End Sub

Sub loadTerms	
	termFilePath=viewContent.path&"-terms"
	If File.Exists(termFilePath,"")=False Then
		Dim msgbox As Msgboxes
		msgbox.Show("无术语","")
	Else
		ListView1.Items.AddAll(File.ReadList(termFilePath,""))
	End If
End Sub

Sub ListView1_SelectedIndexChanged(Index As Int)
	
End Sub

Sub ListView1_MouseClicked (EventData As MouseEvent)
	If ListView1.SelectedItem<>Null Then
		Dim term As String
		term=ListView1.SelectedItem
		Dim su As ApacheSU
		Dim source As String
		source=su.SplitWithSeparator(term,"	")(0)
		Dim target As String
		target=su.SplitWithSeparator(term,"	")(1)	
		Dim html As String
		Dim htmlEN As String
		Dim htmlCN As String
		If Main.result=-2 Then
			html=viewContent.htmlstring.Replace(source,"<font color="&Chr(34)&"#FF0000"&Chr(34)&"><strong>"&source&"</strong></font>")
		    html=html.Replace("font-size: 18px","font-size: "&viewContent.textSize&"px")
		    viewContent.WebView1.LoadHtml(html)
		Else
			htmlEN=viewContent.htmlstringEN.Replace(source,"<font color="&Chr(34)&"#FF0000"&Chr(34)&"><strong>"&source&"</strong></font>")
		    htmlEN=htmlEN.Replace("font-size: 18px","font-size: "&viewContent.textSize&"px")
			htmlCN=viewContent.htmlstringCN.Replace(target,"<font color="&Chr(34)&"#FF0000"&Chr(34)&"><strong>"&target&"</strong></font>")
		    htmlCN=htmlCN.Replace("font-size: 18px","font-size: "&viewContent.textSize&"px")		
		    viewContent.WebView1.LoadHtml(htmlEN)
			viewContent.WebView2.LoadHtml(htmlCN)
			File.WriteString(File.DirApp,"out.html",htmlCN)		
		End If
    End If
End Sub

Sub Button1_MouseClicked (EventData As MouseEvent)
	If addTermsForm.IsInitialized=False Then
		addTermsListForm.Initialize("查看",400,350)
		addTermsListForm.SetFormStyle("UNIFIED")
		addTermsListForm.RootPane.LoadLayout("addTermsList") 'Load the layout file.
		addTermsListForm.Show
		addTermsForm.Initialize("查看",280,150)
		addTermsForm.SetFormStyle("UNIFIED")
		addTermsForm.RootPane.LoadLayout("addTerms") 'Load the layout file.
		addTermsForm.Show		
	Else
		termListView.Items.Clear		
		addTermsListForm.Show	
		addTermsForm.Show	
	End If
	setAlwaysOnTop(addTermsForm, True)	
End Sub

Sub upLoadButton_MouseClicked (EventData As MouseEvent)
	Dim TotalList As List
	TotalList.Initialize
	TotalList.AddAll(ListView1.Items)
	TotalList.AddAll(termListView.Items)
	File.WriteList(termFilePath,"",TotalList)
	ListView1.Items.AddAll(termListView.Items)
	addTermsForm.Close
	addTermsListForm.Close	
End Sub

Sub termListView_MouseClicked (EventData As MouseEvent)
	
End Sub

Sub addTermButton_MouseClicked (EventData As MouseEvent)
	setAlwaysOnTop(addTermsForm, False)
	Dim msgbox As Msgboxes	
	If TextField1.Text="" Or TextField2.Text="" Then		
		msgbox.Show("请填写完整","")
	Else
		termListView.Items.Add(TextField1.Text.Trim&"	"&TextField2.Text.Trim)
	    TextField1.Text=""
	    TextField2.Text=""
		msgbox.Show("已添加","")
	End If
	setAlwaysOnTop(addTermsForm, True)
End Sub

Sub setAlwaysOnTop(frm As Object, Value As Boolean)
    Dim frmJO As JavaObject = frm
    Dim stage As JavaObject = frmJO.GetField("stage")
    stage.RunMethod("setAlwaysOnTop", Array(Value))
End Sub

Sub ListView1_Action
   Dim mi As MenuItem = Sender
   Log(mi.Text)
   ListView1.Items.RemoveAt(ListView1.SelectedIndex)
End Sub
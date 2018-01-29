Type=StaticCode
Version=5.9
ModulesStructureVersion=1
B4J=true
@EndOfDesignText@
'Static code module
Sub Process_Globals
	Private fx As JFX
	Private viewReviewForm As Form
	Private annotationForm As Form
	Private SplitPane1 As SplitPane
	Private TextArea1 As TextArea
	Private WebView1 As WebView
	Private annotationList As List
	Private ListButton As Button
	Private annotationListView As ListView
End Sub

Public Sub Show(jsonstring As String)
	viewReviewForm.Initialize("查看",600,450)
	viewReviewForm.SetFormStyle("UNIFIED")
	viewReviewForm.RootPane.LoadLayout("viewReview") 'Load the layout file.
	viewReviewForm.Show
	annotationList.Initialize
	SplitPane1.LoadLayout("TextArea")
	SplitPane1.LoadLayout("WebView")
	Log(jsonstring)
	loadJson(jsonstring)
End Sub

Sub loadJson(jsonstring As String)
	Dim json As JSONParser
	json.Initialize(jsonstring)
	Dim list1 As List
	list1=json.NextArray
	Dim json2 As JSONParser
	json2.Initialize(list1.Get(1))
	TextArea1.Text=list1.Get(0)
	annotationList=json2.NextArray
End Sub

Sub ListButton_MouseClicked (EventData As MouseEvent)
	If annotationForm.IsInitialized=False Then
		initAnnotationForm
	End If
	If annotationForm.Showing=False Then
		annotationForm.Show
		annotationListView.Items.Clear
		If annotationList.Size=0 Then
			fx.Msgbox(viewReviewForm,"译注为空","")
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

Sub TextArea1_TextChanged (Old As String, New As String)
	WebView1.LoadHtml(buildHtmlString(New))
End Sub


Type=StaticCode
Version=4.7
ModulesStructureVersion=1
B4J=true
@EndOfDesignText@
'Static code module
Sub Process_Globals
	Private fx As JFX
	Private modifyTextForm As Form
	Private inputBoxForm As Form
	Private annotationForm As Form
	Private SplitPane1 As SplitPane
	Private TextArea1 As TextArea
	Private WebView1 As WebView
	Public path As String
	Private ToggleButton1 As ToggleButton
	Private inputTextArea As TextArea
	Private okButton1 As Button
	Private annotationList As List
	Private ListButton As Button
	Private annotationListView As ListView
	Private SaveButton As Button
End Sub

Public Sub Show
	modifyTextForm.Initialize("查看",600,400)
	modifyTextForm.SetFormStyle("UNIFIED")
	modifyTextForm.RootPane.LoadLayout("modifyText") 'Load the layout file.
	modifyTextForm.Show
	SplitPane1.LoadLayout("TextArea")
	SplitPane1.LoadLayout("WebView")
	Log(path)
	TextArea1.Text=File.ReadString(path,"")
	WebView1.LoadHtml("预览窗口")
	annotationList.Initialize
	If File.Exists(path.Replace(".txt","-annotation.json"),"") Then
        Dim json As JSONParser
		json.Initialize(File.ReadString(path.Replace(".txt","-annotation.json"),""))
		annotationList.AddAll(json.NextArray)
	End If
End Sub

Sub Button1_MouseClicked (EventData As MouseEvent)
	
End Sub

Sub TextArea1_TextChanged (Old As String, New As String)
	If ToggleButton1.Selected Then
	    WebView1.LoadHtml(buildHtmlString(New))
		File.WriteString(File.DirApp,"out.html",buildHtmlString(New))
	End If
End Sub

Sub buildHtmlString(raw As String) As String
	Dim su As ApacheSU
	Dim result As String
	Dim htmlhead As String
	Dim cssPath As String
	cssPath="file:///"&File.Combine(File.DirApp,"style.css")
	cssPath=cssPath.Replace("\","/")
	htmlhead="<!DOCTYPE HTML><html><head><meta charset="&Chr(34)&"utf-8"&Chr(34)&" /><link href="&Chr(34)&cssPath&Chr(34)&" rel="&Chr(34)&"stylesheet"&Chr(34)&" /><style type="&Chr(34)&"text/css"&Chr(34)&">p {font-size: 18px}</style></head><body>"
	Dim htmlend As String
	htmlend="</body></html>"
	For Each para In su.SplitWithSeparator(raw,CRLF)
		result=result&"<p>"&para&"</p>"
	Next
	result=htmlhead&result&htmlend
	Return result
End Sub

Sub ToggleButton1_SelectedChange(Selected As Boolean)
	If Selected Then
		WebView1.LoadHtml(buildHtmlString(TextArea1.Text))
	End If
	Log(TextArea1.SelectionEnd&" "&TextArea1.selectionStart)
End Sub

Sub TextArea1_Action
	Dim mi As MenuItem = Sender
	Log(mi.Text)
    Dim selectedText As String
	selectedText=TextArea1.Text.SubString2(TextArea1.SelectionStart,TextArea1.SelectionEnd)
	Dim textBeforeSelectedText, textAfterSelectedText As String
	textAfterSelectedText=TextArea1.Text.SubString(TextArea1.SelectionEnd)
	textBeforeSelectedText=TextArea1.Text.SubString2(0,TextArea1.Selectionstart)
	Select mi.Text
		Case "删除"
			selectedText="<del>"&selectedText&"</del>"
			TextArea1.Text=textBeforeSelectedText&selectedText&textAfterSelectedText			
		Case "替换"
			If inputBoxForm.IsInitialized=False Then
				initInputBox
			Else
				inputTextArea.Text=""
			End If
		    inputBoxForm.ShowAndWait
			selectedText="<del>"&selectedText&"</del>"
			TextArea1.Text=textBeforeSelectedText&selectedText&"<ins>"&inputTextArea.Text&"</ins>"&textAfterSelectedText
	    Case "译得好"
			selectedText="<span class="&Chr(34)&"good"&Chr(34)&">"&selectedText&"</span>"
			TextArea1.Text=textBeforeSelectedText&selectedText&textAfterSelectedText
		Case "添加译注（感想）"
			If inputBoxForm.IsInitialized=False Then
				initInputBox
			Else
				inputTextArea.Text=""
			End If
		    inputBoxForm.ShowAndWait
			Dim map1 As Map
			map1.Initialize
			map1.Put("译注（感想）",inputTextArea.Text)
			map1.Put("selectedText",selectedText)
			annotationList.Add(map1)
			selectedText=selectedText&"["&annotationList.Size&"]"
			TextArea1.Text=textBeforeSelectedText&selectedText&textAfterSelectedText
			Log(annotationList)
		Case Else
			Dim map1 As Map
			map1.Initialize
			map1.Put("批注类型",mi.Text)
			map1.Put("selectedText",selectedText)
			annotationList.Add(map1)
			selectedText=selectedText&"["&annotationList.Size&"]"
			TextArea1.Text=textBeforeSelectedText&selectedText&textAfterSelectedText			
	End Select
End Sub

Sub initInputBox
	inputBoxForm.Initialize("",280,150)
	inputBoxForm.SetFormStyle("UNIFIED")
	inputBoxForm.RootPane.LoadLayout("inputReplace") 'Load the layout file.
End Sub

Sub okButton1_MouseClicked (EventData As MouseEvent)
	If inputTextArea.Text="" Then
		fx.Msgbox(modifyTextForm,"请输入文本","错误")
	Else
		inputBoxForm.Close
	End If
End Sub

Sub cancelButton_MouseClicked (EventData As MouseEvent)
	inputBoxForm.Close
End Sub

Sub ListButton_MouseClicked (EventData As MouseEvent)
	If annotationForm.IsInitialized=False Then
		initAnnotationForm
	End If
	If annotationForm.Showing=False Then
		annotationForm.Show
		annotationListView.Items.Clear
		If annotationList.Size=0 Then
			fx.Msgbox(modifyTextForm,"译注为空","")
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

Sub SaveButton_MouseClicked (EventData As MouseEvent)
	File.WriteString(path,"",TextArea1.Text)	
	Dim json As JSONGenerator
	json.Initialize2(annotationList)
	File.WriteString(path.Replace(".txt","-annotation.json"),"",json.ToPrettyString(4))
	fx.Msgbox(modifyTextForm,"已保存","")
End Sub
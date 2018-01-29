Type=StaticCode
Version=5.9
ModulesStructureVersion=1
B4J=true
@EndOfDesignText@
'Static code module
Sub Process_Globals
	Private fx As JFX
	Private viewContentForm As Form
	Private setStyleForm As Form
	Private TextField1 As TextField
	Private TextField2 As TextField
	Public path As String
	Private Button1 As Button
	Private Button2 As Button
	Public WebView1 As WebView
	Private Spinner1 As Spinner
	Public htmlstring As String
	Public htmlstringEN As String
	Public htmlstringCN As String
	Public textSize=18 As Int
	Public WebView2 As WebView
End Sub

Public Sub Show
	viewContentForm.Initialize("查看",600,400)
	viewContentForm.SetFormStyle("UNIFIED")
	If path.Contains("[parallel]")=False Then
		viewContentForm.RootPane.LoadLayout("viewContent") 'Load the layout file.
	Else
		viewContentForm.RootPane.LoadLayout("viewContentP") 'Load the layout file.
	End If
	viewContentForm.Show
    loadContent
End Sub

Sub loadContent
	Dim json As JSONParser
	json.Initialize(File.ReadString(path,""))
	Dim map1 As Map
	map1=json.NextObject
	TextField1.Text=map1.Get("title")
	TextField2.Text=map1.Get("source")
    If path.Contains("[parallel]")=False Then
		htmlstring=buildHtmlString(map1.Get("content"))
	    WebView1.LoadHtml(htmlstring)
	Else
		htmlstringEN=buildHtmlString(map1.Get("content_en"))
		htmlstringCN=buildHtmlString(map1.Get("content_cn"))
		WebView1.LoadHtml(htmlstringEN)
		WebView2.LoadHtml(htmlstringCN)
	End If
End Sub

Sub Button2_MouseClicked (EventData As MouseEvent)
	viewTerms.Show
End Sub

Sub Button1_MouseClicked (EventData As MouseEvent)
	setStyleForm.Initialize("设置字体",250,150)
	setStyleForm.SetFormStyle("UNIFIED")
	setStyleForm.RootPane.LoadLayout("setStyle") 'Load the layout file.
	setStyleForm.Show
End Sub

Sub buildHtmlString(raw As String) As String
	Dim su As ApacheSU
	Dim result As String
	Dim htmlhead As String
	htmlhead="<!DOCTYPE HTML><html><head><meta charset="&Chr(34)&"utf-8"&Chr(34)&" /><style type="&Chr(34)&"text/css"&Chr(34)&">p {font-size: 18px}</style></head><body>"
	Dim htmlend As String
	htmlend="</body></html>"
	For Each para In su.SplitWithSeparator(raw,CRLF)
		result=result&"<p>"&para&"</p>"
	Next
	result=htmlhead&result&htmlend
	Return result
End Sub

Sub Spinner1_ValueChanged (Value As Object)	
	textSize=Value
	If path.Contains("[parallel]")=False Then
		WebView1.LoadHtml(htmlstring.Replace("font-size: 18px","font-size: "&Value&"px"))
	Else
		WebView1.LoadHtml(htmlstringEN.Replace("font-size: 18px","font-size: "&Value&"px"))
		WebView2.LoadHtml(htmlstringCN.Replace("font-size: 18px","font-size: "&Value&"px"))
	End If
	
End Sub
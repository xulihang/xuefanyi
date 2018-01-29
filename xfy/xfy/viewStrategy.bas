Type=StaticCode
Version=4.7
ModulesStructureVersion=1
B4J=true
@EndOfDesignText@
'Static code module
Sub Process_Globals
	Private fx As JFX
	Private viewStrategyForm As Form
	Private Spinner1 As Spinner
	Private WebView1 As WebView
	Private textsize=18 As Int
	Private htmlstring As String
	Public path As String
End Sub

Public Sub Show
	viewStrategyForm.Initialize("查看",600,400)
	viewStrategyForm.SetFormStyle("UNIFIED")
	viewStrategyForm.RootPane.LoadLayout("viewStrategy") 'Load the layout file.
	viewStrategyForm.Show
    loadContent
End Sub

Sub loadContent
	htmlstring=buildHtmlString(File.ReadString(path,""))
	WebView1.LoadHtml(htmlstring)
End Sub

Sub Spinner1_ValueChanged (Value As Object)
	textsize=Value
	WebView1.LoadHtml(htmlstring.Replace("font-size: 18px","font-size: "&Value&"px"))
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


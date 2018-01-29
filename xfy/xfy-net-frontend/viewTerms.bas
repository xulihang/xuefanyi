Type=StaticCode
Version=5.9
ModulesStructureVersion=1
B4J=true
@EndOfDesignText@
'Static code module
Sub Process_Globals
	Private fx As JFX
	Private viewTermsForm As Form
	Private ListView1 As ListView
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
		fx.msgbox(viewTermsForm,"无术语","")
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
		If viewContent.path.Contains("[parallel]")=False Then
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


Sub ListView1_Action
   Dim mi As MenuItem = Sender
   Log(mi.Text)
   ListView1.Items.RemoveAt(ListView1.SelectedIndex)
End Sub
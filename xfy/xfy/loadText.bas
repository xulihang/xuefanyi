Type=StaticCode
Version=4.7
ModulesStructureVersion=1
B4J=true
@EndOfDesignText@
'Static code module
Sub Process_Globals
	Private fx As JFX
	Private loadTextForm As Form
	
	Private Button1 As Button
	Private Button2 As Button
	Private TextArea1 As TextArea
	Private Button3 As Button
End Sub

Public Sub Show
	loadTextForm.Initialize("查看",600,400)
	loadTextForm.SetFormStyle("UNIFIED")
	loadTextForm.RootPane.LoadLayout("loadText") 'Load the layout file.
	loadTextForm.Show
End Sub


Sub Button2_MouseClicked (EventData As MouseEvent)
	If TextArea1.Text.Contains(CRLF) Then
		fx.Msgbox(loadTextForm,"未替换段落信息","")
	Else
		Dim fileChooser As FileChooser
		fileChooser.Initialize
		fileChooser.SetExtensionFilter("TXT纯文本文件",Array As String("*.txt"))
		Dim path As String
		path=fileChooser.ShowSave(loadTextForm)
		Dim writer As TextWriter	
		If path<>"" Then
			writer.Initialize2(File.OpenOutput(path,"",False),"UTF8")
			writer.Write(TextArea1.Text)
			writer.Flush
			writer.Close
			fx.Msgbox(loadTextForm,"已保存文件，将启动雪人CAT。请手动创立项目并翻译。","")
			Dim shell As Shell
			shell.Initialize("","./SnowmanCAT/translation.exe",Null)
			shell.WorkingDirectory=File.DirApp
			shell.Run(-1)
		Else
			fx.Msgbox(loadTextForm,"未选择文件","")
		End If
	End If

End Sub

Sub Button1_MouseClicked (EventData As MouseEvent)
	TextRelace
End Sub

Sub TextRelace
	TextArea1.Text=TextArea1.Text.Replace(CRLF," \n ")
End Sub

Sub Button3_MouseClicked (EventData As MouseEvent)
	TextArea1.Text=TextArea1.Text.Replace("‘","'")
	TextArea1.Text=TextArea1.Text.Replace("’","'")
	TextArea1.Text=TextArea1.Text.Replace("“",Chr(34))
	TextArea1.Text=TextArea1.Text.Replace("”",Chr(34))
End Sub
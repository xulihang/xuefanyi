Type=StaticCode
Version=4.7
ModulesStructureVersion=1
B4J=true
@EndOfDesignText@
'Static code module
Sub Process_Globals
	Private fx As JFX
	Private addStrategy2Form As Form
	Private Button1 As Button
	Private Button2 As Button
	Private TextArea1 As TextArea
	Private TextField1 As TextField
	Public categoryname As String
	Public subcategory As String	
End Sub

Public Sub Show
	addStrategy2Form.Initialize("添加语料",380,330)
	addStrategy2Form.SetFormStyle("UNIFIED")
	addStrategy2Form.RootPane.LoadLayout("addStrategy") 'Load the layout file.
	addStrategy2Form.Show
End Sub

Sub Button1_MouseClicked (EventData As MouseEvent)
    If File.Exists(File.DirApp,"StrategiesAndMethods/ByCategory/"&categoryname&"/"&subcategory)=False Then
		File.MakeDir(File.DirApp,"StrategiesAndMethods/ByCategory/"&categoryname&"/"&subcategory)
	End If
	File.WriteString(File.DirApp,"StrategiesAndMethods/ByCategory/"&categoryname&"/"&subcategory&"/"&TextField1.Text,TextArea1.Text)
	Dim msgbox As Msgboxes
	msgbox.Show("提交成功","")
	addStrategy2Form.Close
End Sub

Sub TextArea1_TextChanged (Old As String, New As String)
	
End Sub

Sub Button2_MouseClicked (EventData As MouseEvent)
	Dim selectedText As String
	selectedText=TextArea1.Text.SubString2(TextArea1.SelectionStart,TextArea1.SelectionEnd)
	Dim textBeforeSelectedText, textAfterSelectedText As String
	textAfterSelectedText=TextArea1.Text.SubString(TextArea1.SelectionEnd)
	textBeforeSelectedText=TextArea1.Text.SubString2(0,TextArea1.Selectionstart)
	TextArea1.Text=textBeforeSelectedText&"<font color="&Chr(34)&"red"&Chr(34)&">"&selectedText&"</font>"&textAfterSelectedText
	'TextArea1.Text=TextArea1.Text.Replace(selectedText,"<font color="&Chr(34)&"red"&Chr(34)&">"&selectedText&"</font>")
End Sub
Sub TextField1_TextChanged (Old As String, New As String)
    Dim msgbox As Msgboxes
	If New.Contains("-term") Or New.Contains("<") Or New.Contains(">") Or New.Contains("/") Or New.Contains("\") Or New.Contains("|") Or New.Contains(":") Or New.Contains(Chr(34)) Or New.Contains("?") Or New.Contains("*") Then
	    TextField1.Text=Old
		msgbox.Show("不能包含< > / \ | : " & Chr(34)  & " * ?等字符","")
	End If
End Sub
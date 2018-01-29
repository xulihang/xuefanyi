Type=StaticCode
Version=4.7
ModulesStructureVersion=1
B4J=true
@EndOfDesignText@
'Static code module
Sub Process_Globals
	Private fx As JFX
    Private addCorpusByCategory2Form As Form	
	Private TextArea1 As TextArea
	Private TextField1 As TextField
	Private TextField2 As TextField
	Private Button1 As Button
	Public categoryname As String
	Public subcategory As String
	Private ComboBox1 As ComboBox
	Private ComboBox2 As ComboBox
	Private TextArea2 As TextArea
End Sub

Public Sub Show
	addCorpusByCategory2Form.Initialize("添加语料",380,330)
	addCorpusByCategory2Form.SetFormStyle("UNIFIED")
	If Main.result=-2 Then
		addCorpusByCategory2Form.RootPane.LoadLayout("addCorpusByCategory2") 'Load the layout file.
	Else
		addCorpusByCategory2Form.RootPane.LoadLayout("addCorpusByCategory2P") 'Load the layout file.
	End If	
	addCorpusByCategory2Form.Show
	ComboBox1.Items.Add("中文原文")
	ComboBox1.Items.Add("英语原文")
	ComboBox1.SelectedIndex="1"
	ComboBox2.Items.Add("网络")
	ComboBox2.Items.Add("书本")
	ComboBox2.Items.Add("其它")
	ComboBox2.SelectedIndex="0"
End Sub

Sub Button1_MouseClicked (EventData As MouseEvent)
	If TextArea1.Text<>"" And TextField1.Text<>"" And TextField2.Text<>"" Then
		If File.Exists(File.DirApp,"Corpus/ByCategory/"&categoryname&"/"&subcategory)=False Then
			File.MakeDir(File.DirApp,"Corpus/ByCategory/"&categoryname&"/"&subcategory)
		End If
		Dim map1 As Map
		map1.Initialize
		map1.Put("title",TextField1.Text)
		map1.Put("source",TextField2.text)
		map1.Put("language",ComboBox1.Value)
		map1.Put("source_type",ComboBox2.Value)
		Dim json As JSONGenerator		
		Log(subcategory)
		If Main.result=-2 Then
			map1.Put("content",TextArea1.Text)
			json.Initialize(map1)
		    File.WriteString(File.DirApp,"Corpus/ByCategory/"&categoryname&"/"&subcategory&"/"&TextField1.Text,json.ToPrettyString(4))
		Else
			map1.Put("content_en",TextArea1.Text)
			map1.Put("content_cn",TextArea2.Text)
			json.Initialize(map1)
			File.WriteString(File.DirApp,"Corpus/ByCategory/"&categoryname&"/"&subcategory&"/"&"[parallel]"&TextField1.Text,json.ToPrettyString(4))
		End If
		
		Dim msgbox As Msgboxes
		msgbox.Show("提交成功","")
		addCorpusByCategory2Form.Close
	Else
		Dim msgbox As Msgboxes
		msgbox.Show("请填写完整","")
	End If
End Sub

Sub TextField1_TextChanged (Old As String, New As String)
	isChinese(New)
    Dim msgbox As Msgboxes
	If New.Contains("-term") Or New.Contains("<") Or New.Contains(">") Or New.Contains("/") Or New.Contains("\") Or New.Contains("|") Or New.Contains(":") Or New.Contains(Chr(34)) Or New.Contains("?") Or New.Contains("*") Then
	    TextField1.Text=Old
		
		msgbox.Show("不能包含< > / \ | : " & Chr(34)  & " * ?等字符","")
	End If
End Sub

Sub ComboBox1_SelectedIndexChanged(Index As Int, Value As Object)
	If TextField1.Text<>"" Then
		isChinese(TextField1.Text)
	End If
End Sub

Sub ComboBox2_SelectedIndexChanged(Index As Int, Value As Object)
	
End Sub

Sub TextArea2_TextChanged (Old As String, New As String)
	Dim msgbox As Msgboxes
	Dim s As Boolean = Main.NativeMe.RunMethod("isChinese",Array(TextArea2.Text))
    If s=False Then
		msgbox.Show("没有中文，你确定你输入的是中文吗？","")
        TextArea2.Text=Old
    End If	
End Sub

Sub TextArea1_TextChanged (Old As String, New As String)
	Dim msgbox As Msgboxes
	Dim s As Boolean = Main.NativeMe.RunMethod("isChinese",Array(TextArea2.Text))
    If s=True Then
		msgbox.Show("有中文，你确定你输入的是英文吗？","")
        TextArea1.Text=Old
    End If	
End Sub

Sub isChinese(Text As String)
	Dim msgbox As Msgboxes
	Dim result As Int
	Dim s As Boolean = Main.NativeMe.RunMethod("isChinese",Array(Text))
    If s=True And ComboBox1.SelectedIndex=1 Then
		result=msgbox.Show2("标题含有中文，你确定原文是英文吗？","","是英文","","弄错了，是中文")
		If result=-2 Then
			ComboBox1.SelectedIndex=0
		End If
	Else If s=False And ComboBox1.SelectedIndex=0 Then
		result=msgbox.Show2("标题不含中文，你确定原文是中文吗？","","是中文","","弄错了，是英文")
		If result=-2 Then
			ComboBox1.SelectedIndex=1
		End If
    End If
End Sub
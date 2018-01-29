Type=StaticCode
Version=4.7
ModulesStructureVersion=1
B4J=true
@EndOfDesignText@
'Static code module
Sub Process_Globals
	Private fx As JFX
	Private addStrategy1Form As Form
	Private Button1 As Button
	Private CheckBox1 As CheckBox
	Private ComboBox1 As ComboBox
	Private ComboBox2 As ComboBox
	Private Label1 As Label
	Private Label2 As Label
	Private TextField1 As TextField
End Sub


Public Sub Show
	addStrategy1Form.Initialize("添加语料",380,330)
	addStrategy1Form.SetFormStyle("UNIFIED")
	addStrategy1Form.RootPane.LoadLayout("addCorpusByCategory") 'Load the layout file.
	addStrategy1Form.Show
	ComboBox2.Enabled=True
	TextField1.Enabled=False
	loadComboBoxValue		
End Sub

Sub loadComboBoxValue
	Dim categoryList As List
	categoryList=File.ListFiles("./StrategiesAndMethods/ByCategory")
	ComboBox1.Items.AddAll(categoryList)
End Sub


Sub CheckBox1_CheckedChange(Checked As Boolean)
	If Checked Then
		ComboBox2.Enabled=False
		TextField1.Enabled=True
	Else
		ComboBox2.Enabled=True
		TextField1.Enabled=False		
	End If
End Sub

Sub Button1_MouseClicked (EventData As MouseEvent)
	Dim combox1Value As String
	Dim combox2Value As String
	combox1Value=ComboBox1.Value
	combox2Value=ComboBox2.Value
	If CheckBox1.Checked Then
		If combox1Value<>"null" And TextField1.Text<>"" Then
		    addStrategyStep2.subcategory=TextField1.Text
			addStrategyStep2.categoryname=ComboBox1.Value	
			addStrategy1Form.Close
			addStrategyStep2.Show
		Else
			Dim msgbox As Msgboxes
			msgbox.Show("请填写完整","")			
		End If
	Else
		If combox1Value<>"null" And combox2Value<>"null" Then
			Log("ddd"&ComboBox2.Value)
			addStrategyStep2.subcategory=ComboBox2.Value
			addStrategyStep2.categoryname=ComboBox1.Value	
			addStrategy1Form.Close
			addStrategyStep2.Show
		Else
			Dim msgbox As Msgboxes
			msgbox.Show("请填写完整","")				
		End If		
	End If
End Sub

Sub ComboBox1_ValueChanged (Value As Object)
	
End Sub

Sub ComboBox1_SelectedIndexChanged(Index As Int, Value As Object)
	Log(Value)
	ComboBox2.Items.Clear
	Dim subCategoryList As List
	subCategoryList=File.ListFiles("./StrategiesAndMethods/ByCategory"&"/"&Value)
	ComboBox2.Items.Addall(subCategoryList)
End Sub
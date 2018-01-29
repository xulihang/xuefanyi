Type=Class
Version=5.9
ModulesStructureVersion=1
B4J=true
@EndOfDesignText@
'Handler class
Sub Class_Globals
	
End Sub

Public Sub Initialize
	
End Sub

Sub Handle(req As ServletRequest, resp As ServletResponse)
	Dim textType,category,subcategory As String
	textType=req.GetParameter("textType")
	category=req.GetParameter("category")
	subcategory=req.GetParameter("subcategory")
	resp.ContentType="text/html"
	resp.Write(buildJson(textType,category,subcategory))
End Sub

Sub buildJson(textType As String,category As String,subcategory As String) As String
	Dim fileList As List
    fileList=File.ListFiles(File.DirApp&"/"&textType&"/ByCategory/"&category&"/"&subcategory)
	Dim termsExcludedList As List
	termsExcludedList.Initialize
	For Each item As String In fileList
		If item.Contains("terms")=False Then
			termsExcludedList.Add(item)
		End If
	Next
	Dim json As JSONGenerator
	json.Initialize2(termsExcludedList)
	Return json.ToString
End Sub
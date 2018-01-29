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
	Dim textType As String
	textType=req.GetParameter("textType")
	resp.ContentType="text/html"
	resp.Write(buildJson(textType))
End Sub

Sub buildJson(textType As String) As String
	Dim categoryList,subcategoryList As List
	Dim map1 As Map
	map1.Initialize
	categoryList=File.ListFiles(File.DirApp&"/"&textType&"/ByCategory/")
	For Each category As String In categoryList
		subcategoryList=File.ListFiles(File.DirApp&"/"&textType&"/ByCategory/"&category)
		map1.Put(category,subcategoryList)
	Next
	Dim json As JSONGenerator
	json.Initialize(map1)
	Return json.ToString
End Sub
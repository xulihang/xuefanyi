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
	Dim username,textType As String
	username=req.GetParameter("username")
	textType=req.GetParameter("textType")
	resp.ContentType="text/html"
	If File.Exists(File.DirApp,"/users/"&username) Then
		resp.Write(buildJson(username,textType))
	Else
		resp.Write("user has not uploaded texts.")
	End If
End Sub

Sub buildJson(username As String,textType As String) As String
	Dim categoryList,subcategoryList As List
	Dim map1 As Map
	map1.Initialize
	categoryList=File.ListFiles(File.DirApp&"/users/"&username&"/"&textType&"/ByCategory/")
	For Each category As String In categoryList
		subcategoryList=File.ListFiles(File.DirApp&"/users/"&username&"/"&textType&"/ByCategory/"&category)
		map1.Put(category,subcategoryList)
	Next
	Dim json As JSONGenerator
	json.Initialize(map1)
	Return json.ToString
End Sub
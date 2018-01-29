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
	Dim textType,category,subcategory,filename As String
	textType=req.GetParameter("textType")
	category=req.GetParameter("category")
	subcategory=req.GetParameter("subcategory")
	filename=req.GetParameter("filename")
	resp.ContentType="text/html"
	resp.Write(File.readstring(File.DirApp,textType&"/ByCategory/"&category&"/"&subcategory&"/"&filename))
End Sub


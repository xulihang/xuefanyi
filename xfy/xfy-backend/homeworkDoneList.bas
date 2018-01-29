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
	Dim teachername,homeworkname As String
	teachername=req.GetParameter("teacher")
	homeworkname=req.GetParameter("homeworkname")
	resp.ContentType="text/html"
	Dim json As JSONGenerator
	json.Initialize2(File.ListFiles(File.Combine(File.DirApp,"homework/"&teachername&"/"&homeworkname&"-student")))
	resp.Write(json.ToString)
End Sub
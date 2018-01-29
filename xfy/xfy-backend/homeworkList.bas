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
	Dim teachername As String
	teachername=req.GetParameter("teacher")
	resp.ContentType="text/html"
	Dim json As JSONGenerator
	Dim filelist As List
    filelist.Initialize
	For Each item As String In File.ListFiles(File.Combine(File.DirApp,"homework/"&teachername))
		If item.Contains("-student")=False Then
			filelist.Add(item)
		End If
	Next
	If File.Exists(File.DirApp,"homework/"&teachername) Then
	    json.Initialize2(filelist)
	    resp.Write(json.ToString)
	Else
		resp.SendError(500,"no homework")
	End If
End Sub
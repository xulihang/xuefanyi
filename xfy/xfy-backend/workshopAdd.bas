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
	Try
        Dim name,content As String
	    name=req.GetParameter("name")
        content=req.GetParameter("content")
        If File.Exists(File.DirApp,"workshop")=False Then
		    File.MakeDir(File.DirApp,"workshop")	
        End If
		'DateTime.DateFormat="yyyy-MM-dd"
		Dim time As String
		time=DateTime.Now
		File.MakeDir(File.DirApp,"workshop/"&time&"-"&name)
		File.WriteString(File.DirApp,"workshop/"&time&"-"&name&"/task.json",content)
	    resp.ContentType="text/html"
		resp.Write("提交成功！")
	Catch
		resp.SendError(500, LastException)
	End Try
End Sub
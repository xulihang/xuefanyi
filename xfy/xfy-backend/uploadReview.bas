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
        Dim teachername,homeworkname,studentname,text,note As String
		teachername=req.GetParameter("teachername")
	    homeworkname=req.GetParameter("homeworkname")
		studentname=req.GetParameter("studentname")
		note=req.GetParameter("note")
		text=req.GetParameter("text")
		resp.ContentType="text/html"
		Dim path As String
		path="/homework/"&teachername&"/"&homeworkname&"-student/"&studentname&"/review"
		Log(path)
		If File.Exists(File.DirApp,path)=False Then
			File.MakeDir(File.DirApp,path)
		End If
		File.WriteString(File.DirApp,path&"/text",text)
		File.WriteString(File.DirApp,path&"/note",note)
		resp.Write("上传成功!")
	Catch
		resp.SendError(500, LastException)
		resp.Write("上传失败!")
	End Try
End Sub
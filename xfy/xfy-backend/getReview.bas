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
        Dim teachername,homeworkname,studentname As String
		teachername=req.GetParameter("teachername")
	    homeworkname=req.GetParameter("homeworkname")
		studentname=req.GetParameter("studentname")
		resp.ContentType="text/html"
		Dim path As String
		path="/homework/"&teachername&"/"&homeworkname&"-student/"&studentname&"/review"
		Log(path)

		Dim list1 As List
		list1.Initialize
		list1.Add(File.ReadString(File.DirApp,path&"/text"))
		list1.Add(File.ReadString(File.DirApp,path&"/note"))
		Dim json As JSONGenerator
		json.Initialize2(list1)
		resp.Write(json.ToString)
	Catch
		resp.SendError(500, LastException)
		resp.Write("上传失败!")
	End Try
End Sub
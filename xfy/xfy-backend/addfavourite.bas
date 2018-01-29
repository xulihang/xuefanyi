Type=Class
Version=5.9
ModulesStructureVersion=1
B4J=true
@EndOfDesignText@
'Handler class
Sub Class_Globals
	Private sql1 As SQL
End Sub

Public Sub Initialize
	
End Sub

Sub Handle(req As ServletRequest, resp As ServletResponse)
	Dim username,link As String
    username=req.GetParameter("username")
	link=req.GetParameter("link")
	resp.ContentType="text/html"
	If File.Exists(File.DirApp,"/users/"&username&"-favourite.db")=False Then
		sql1.InitializeSQLite(File.DirApp, "/users/"&username&"-favourite.db", True)
	    sql1.ExecNonQuery("CREATE TABLE favourite (link,time)")
	    sql1.ExecNonQuery2("INSERT INTO favourite VALUES(?,?)",Array As Object(link,DateTime.Now))
	Else
		sql1.InitializeSQLite(File.DirApp, "/users/"&username&"-favourite.db", True)
		sql1.ExecNonQuery2("INSERT INTO favourite VALUES(?,?)",Array As Object(link,DateTime.Now))
	End If
	sql1.Close
	resp.Write("收藏成功！")	
End Sub
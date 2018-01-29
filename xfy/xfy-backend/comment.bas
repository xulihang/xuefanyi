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
	Dim commentContent,username,category,subcategory,filename As String
    username=req.GetParameter("username")
	category=req.GetParameter("category")
    subcategory=req.GetParameter("subcategory")
	filename=req.GetParameter("filename")
	commentContent=req.GetParameter("comment")
	resp.ContentType="text/html"
	If File.Exists(File.DirApp,"comment/"&category&"-"&subcategory&"-"&filename&".db")=False Then
		sql1.InitializeSQLite(File.DirApp, "comment/"&category&"-"&subcategory&"-"&filename&".db", True)
	    sql1.ExecNonQuery("CREATE TABLE comment (username,comment,time)")
	    sql1.ExecNonQuery2("INSERT INTO comment VALUES(?,?,?)",Array As Object(username,commentContent,DateTime.Now))
	Else
		sql1.InitializeSQLite(File.DirApp, "comment/"&category&"-"&subcategory&"-"&filename&".db", True)
		sql1.ExecNonQuery2("INSERT INTO comment VALUES(?,?,?)",Array As Object(username,commentContent,DateTime.Now))
	End If
	sql1.Close
	resp.Write("评论成功！")
End Sub
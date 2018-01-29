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
	Dim username As String
	username=req.GetParameter("username")
	resp.ContentType="text/html"
	Dim list1 As List
	list1.Initialize
	If File.Exists(File.DirApp,"/users/"&username&"-favourite.db")=True Then
		sql1.InitializeSQLite(File.DirApp, "/users/"&username&"-favourite.db",False)
		Dim cursor As ResultSet
		cursor=sql1.ExecQuery("SELECT * FROM favourite")
		Do While cursor.NextRow
            list1.Add(cursor.GetString("link"))
		Loop
	End If
	sql1.Close
	Dim json As JSONGenerator
	json.Initialize2(list1)
	resp.Write(json.ToString)
End Sub
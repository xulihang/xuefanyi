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
	Dim category,subcategory,filename As String
	category=req.GetParameter("category")
    subcategory=req.GetParameter("subcategory")
	filename=req.GetParameter("filename")
	resp.ContentType="text/html"
	Dim list1 As List
	list1.Initialize
	If File.Exists(File.DirApp,"comment/"&category&"-"&subcategory&"-"&filename&".db")=True Then
		sql1.InitializeSQLite(File.DirApp, "comment/"&category&"-"&subcategory&"-"&filename&".db",False)
		Dim cursor As ResultSet
		cursor=sql1.ExecQuery("SELECT * FROM comment")
		Do While cursor.NextRow
			Dim map1 As Map
	        map1.Initialize
			map1.Put("username",cursor.GetString("username"))
			map1.Put("comment",cursor.GetString("comment"))
			map1.Put("time",cursor.GetLong("time"))
			list1.Add(map1)
		Loop
	End If
	sql1.Close
	Dim json As JSONGenerator
	json.Initialize2(list1)
	resp.Write(json.ToString)	
End Sub
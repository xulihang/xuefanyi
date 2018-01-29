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
        Dim json As JSONGenerator
		json.Initialize2(File.ListFiles(File.Combine(File.DirApp,"workshop")))
	    resp.ContentType="text/html"
		resp.Write(json.ToString)
	Catch
		resp.SendError(500, LastException)
	End Try	
End Sub
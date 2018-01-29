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
		resp.ContentType="text/html"
        Dim code As String
	    code=req.GetParameter("code")
		Log(code)
		For Each item As String In File.ListFiles(File.Combine(File.DirApp,"workshop"))
			If item.contains(code) Then
				Log(item)
				resp.Write(File.ReadString(File.DirApp,"workshop/"&item&"/task.json"))
			End If
		Next
	Catch
		resp.SendError(500, LastException)
	End Try		
End Sub
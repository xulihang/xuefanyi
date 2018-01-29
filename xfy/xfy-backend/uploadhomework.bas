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
		If req.ContentType.StartsWith("multipart/form-data") Then
			Dim parts As Map = req.GetMultipartData(File.DirApp & "/www", 10000000)
		    Dim filepart As Part = parts.Get("file")

			Dim usernamepart As Part = parts.Get("username")
			Dim username As String
			username=usernamepart.GetValue(req.CharacterEncoding)
			Log(filepart.IsFile)
			If File.Exists(File.DirApp,"homework/"&username)=False Then
				File.MakeDir(File.DirApp,"homework/"&username)
			End If
			File.Copy(filepart.TempFile,"",File.DirApp,"homework/"&username&"/"&filepart.SubmittedFilename)
			File.Delete(filepart.TempFile,"")			
			Log(filepart.SubmittedFilename)
            Log(username)
		End If
		resp.Write("Form data was printed in the logs.")
	Catch
		resp.SendError(500, LastException)
	End Try
	
End Sub
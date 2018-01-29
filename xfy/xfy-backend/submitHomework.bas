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
			Dim teacherpart As Part = parts.Get("teacher")
			Dim homeworkpart As Part = parts.Get("homeworkname")
			Dim username,teachername,homeworkname As String
			username=usernamepart.GetValue(req.CharacterEncoding)
			teachername=teacherpart.GetValue(req.CharacterEncoding)
			homeworkname=homeworkpart.GetValue(req.CharacterEncoding)
			Log(filepart.IsFile)
			'Dim zippath As String 
			'zippath=File.Combine(File.DirApp,"homework/"&teachername&"/"&homeworkname&"-student/"&username&"/"&filepart.SubmittedFilename)
			If File.Exists(File.DirApp,"homework/"&teachername&"/"&homeworkname&"-student/"&username)=False Then
				File.MakeDir(File.DirApp,"homework/"&teachername&"/"&homeworkname&"-student/"&username)
			End If
			File.Copy(filepart.TempFile,"",File.DirApp,"homework/"&teachername&"/"&homeworkname&"-student/"&username&"/"&filepart.SubmittedFilename)
			File.Delete(filepart.TempFile,"")			
			Log(filepart.SubmittedFilename)
            Log(username)
			Dim archiver As Archiver
			archiver.AsyncUnZip(File.Combine(File.DirApp,"homework/"&teachername&"/"&homeworkname&"-student/"&username),filepart.SubmittedFilename,File.Combine(File.DirApp,"homework/"&teachername&"/"&homeworkname&"-student/"&username),"zip")
		End If
		resp.Write("Form data was printed in the logs.")
	Catch
		resp.SendError(500, LastException)
	End Try
End Sub

Sub zip_UnZipDone(CompletedWithoutError As Boolean, NbOfFiles As Int)
	If CompletedWithoutError=False Then
		Log("unzip failed")
	End If
End Sub
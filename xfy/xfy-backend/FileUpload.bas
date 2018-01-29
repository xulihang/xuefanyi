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
	If File.Exists(File.DirApp,"uploaded")=False Then
		File.MakeDir(File.DirApp,"uploaded")
	End If
    If req.Method <> "POST" Then
		resp.SendError(500, "method not supported.")
		Return
	End If
	'we need to call req.InputStream before calling GetParameter.
	'Otherwise the stream will be read internally (as the parameter might be in the post body).
	Dim In As InputStream = req.InputStream
	'Dim reqType As String = req.GetParameter("type")
	Dim name As String = req.GetParameter("name")
	Dim out As OutputStream = File.OpenOutput(File.DirApp,"/uploaded/"&name, False)
	File.Copy2(In, out)
	out.Close
	'Log("Received file: " & name & ", size=" & File.Size(Main.filesFolder, name))
	resp.Write("File received successfully.")
End Sub
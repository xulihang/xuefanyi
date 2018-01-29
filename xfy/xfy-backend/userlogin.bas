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
	If req.Method <> "POST" Then
		resp.SendError(500, "method not supported.")
		Return
	End If
	Dim username,password,userType As String
	username=req.GetParameter("username")
	password=req.GetParameter("password")	
	userType=req.GetParameter("userType")
	Dim userslist As List
	userslist=File.ReadList(File.DirApp,userType&"s.txt")
	Dim userindex As Int
	userindex=userslist.IndexOf(username)
	Log(usertype)
	If userindex<>-1 Then
		If userslist.Get(userindex+1)=password Then
			resp.Write("Login successfully.")
		Else
			resp.Write("Wrong password")
		End If
	Else
		resp.Write("username not exist")
	End If
End Sub
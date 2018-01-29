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
	resp.ContentType = "text/html"
	Dim username,category,subcategory,filename,textType,textstring As String
	username=req.GetParameter("username")
    category=req.GetParameter("category")
    subcategory=req.GetParameter("subcategory")
	filename=req.GetParameter("filename")
	textType=req.GetParameter("textType")
	textstring=req.GetParameter("textstring")
	Log(textType&"/ByCategory/"&category&"/"&subcategory&"/"&filename)
	If File.Exists(File.DirApp,textType&"/ByCategory/"&category&"/"&subcategory&"/"&filename) Then
		resp.Write("已经上传过了")
		Return 
	End If
	If textType="Corpus" Then
		If File.Exists(File.DirApp,"Corpus/ByCategory/"&category&"/"&subcategory)=False Then
			File.MakeDir(File.DirApp,"Corpus/ByCategory/"&category&"/"&subcategory)
		End If		
		File.WriteString(File.DirApp,"Corpus/ByCategory/"&category&"/"&subcategory&"/"&filename,textstring)
	Else
		If File.Exists(File.DirApp,"StrategiesAndMethods/ByCategory/"&category&"/"&subcategory)=False Then
			File.MakeDir(File.DirApp,"StrategiesAndMethods/ByCategory/"&category&"/"&subcategory)
		End If		
		File.WriteString(File.DirApp,"StrategiesAndMethods/ByCategory/"&category&"/"&subcategory&"/"&filename,textstring)
	End If
	resp.Write("success!")
End Sub
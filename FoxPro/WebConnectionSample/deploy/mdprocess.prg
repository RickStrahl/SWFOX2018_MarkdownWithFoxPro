************************************************************************
*PROCEDURE mdprocess
****************************
***  Function: Processes incoming Web Requests for mdprocess
***            requests. This function is called from the wwServer 
***            process.
***      Pass: loServer -   wwServer object reference
*************************************************************************
LPARAMETER loServer
LOCAL loProcess
PRIVATE Request, Response, Server, Session, Process
STORE NULL TO Request, Response, Server, Session, Process

#INCLUDE WCONNECT.H

loProcess = CREATEOBJECT("mdprocess", loServer)
loProcess.lShowRequestData = loServer.lShowRequestData

IF VARTYPE(loProcess)#"O"
   *** All we can do is return...
   RETURN .F.
ENDIF

*** Call the Process Method that handles the request
loProcess.Process()

*** Explicitly force process class to release
loProcess.Dispose()

RETURN

*************************************************************
DEFINE CLASS mdprocess AS WWC_PROCESS
*************************************************************

*** Response class used - override as needed
cResponseClass = [WWC_PAGERESPONSE]

*** Default for page script processing if no method exists
*** 1 - MVC Template (ExpandTemplate()) 
*** 2 - Web Control Framework Pages
*** 3 - MVC Script (ExpandScript())
nPageScriptMode = 3

*!* cAuthenticationMode = "UserSecurity"  && `Basic` is default


#IF .F.
* Intellisense for THIS
LOCAL THIS as mdprocess OF mdprocess.prg
#ENDIF
 
*********************************************************************
* Function mdprocess :: OnProcessInit
************************************
*** If you need to hook up generic functionality that occurs on
*** every hit against this process class , implement this method.
*********************************************************************
FUNCTION OnProcessInit

*!* LOCAL lcScriptName, llForceLogin
*!*	THIS.InitSession("MyApp")
*!*
*!*	lcScriptName = LOWER(JUSTFNAME(Request.GetPhysicalPath()))
*!*	llIgnoreLoginRequest = INLIST(lcScriptName,"default","login","logout")
*!*
*!*	IF !THIS.Authenticate("any","",llIgnoreLoginRequest) 
*!*	   IF !llIgnoreLoginRequest
*!*		  RETURN .F.
*!*	   ENDIF
*!*	ENDIF

*** Explicitly specify that pages should encode to UTF-8 
*** Assume all form and query request data is UTF-8
Response.Encoding = "UTF8"
Request.lUtf8Encoding = .T.


*** Add CORS header to allow cross-site access from other domains/mobile devices on Ajax calls
*!* Response.AppendHeader("Access-Control-Allow-Origin","*")
*!* Response.AppendHeader("Access-Control-Allow-Origin",Request.ServerVariables("HTTP_ORIGIN"))
*!* Response.AppendHeader("Access-Control-Allow-Methods","POST, GET, DELETE, PUT, OPTIONS")
*!* Response.AppendHeader("Access-Control-Allow-Headers","Content-Type, *")
*!* *** Allow cookies and auth headers
*!* Response.AppendHeader("Access-Control-Allow-Credentials","true")
*!* 
*!* *** CORS headers are requested with OPTION by XHR clients. OPTIONS returns no content
*!*	lcVerb = Request.GetHttpVerb()
*!*	IF (lcVerb == "OPTIONS")
*!*	   *** Just exit with CORS headers set
*!*	   *** Required to make CORS work from Mobile devices
*!*	   RETURN .F.
*!*	ENDIF   


RETURN .T.
ENDFUNC




*********************************************************************
FUNCTION TestPage()
************************

#IF .F. 
* Intellisense for intrinsic objects
LOCAL Request as wwRequest, Response as wwPageResponse, Server as wwServer, ;
      Process as wwProcess, Session as wwSession
#ENDIF

THIS.StandardPage("Hello World from the mdprocess process",;
                  "If you got here, everything is working fine.<p>" + ;
                  "Server Time: <b>" + TIME()+ "</b>")
                  
ENDFUNC
* EOF TestPage


*************************************************************
*** PUT YOUR OWN CUSTOM METHODS HERE                      
*** 
*** Any method added to this class becomes accessible
*** as an HTTP endpoint with MethodName.Extension where
*** .Extension is your scriptmap. If your scriptmap is .rs
*** and you have a function called Helloworld your
*** endpoint handler becomes HelloWorld.rs
*************************************************************


ENDDEFINE
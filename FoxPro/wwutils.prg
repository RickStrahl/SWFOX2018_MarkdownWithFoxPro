************************************************************************
* FUNCTION Utils
******************
***    Author: Rick Strahl
***            (c) West Wind Technologies, 1995-2011
***   Contact: rstrahl@west-wind.com
***  Modified: 07/10/2011
***  Function: A set of utility classes and functions used by 
***            the various classes and processing code.
*************************************************************************


****************************************************
FUNCTION GoUrl
******************
***    Author: Rick Strahl
***            (c) West Wind Technologies, 1996
***   Contact: rstrahl@west-wind.com
***  Modified: 03/14/96
***  Function: Starts associated Web Browser
***            and goes to the specified URL.
***            If Browser is already open it
***            reloads the page.
***    Assume: Works only on Win95 and NT 4.0
***      Pass: tcUrl  - The URL of the site or
***                     HTML page to bring up
***                     in the Browser
***    Return: 2  - Bad Association (invalid URL)
***            31 - No application association
***            29 - Failure to load application
***            30 - Application is busy 
***
***            Values over 32 indicate success
***            and return an instance handle for
***            the application started (the browser) 
****************************************************
LPARAMETERS tcUrl, tcAction, tcDirectory, tcParms

IF EMPTY(tcUrl)
   RETURN -1
ENDIF
IF EMPTY(tcAction)
   tcAction = "OPEN"
ENDIF
IF EMPTY(tcDirectory)
   tcDirectory = SYS(2023) 
ENDIF

DECLARE INTEGER ShellExecute ;
    IN SHELL32.dll ;
    INTEGER nWinHandle,;
    STRING cOperation,;
    STRING cFileName,;
    STRING cParameters,;
    STRING cDirectory,;
    INTEGER nShowWindow
    
IF EMPTY(tcParms)
   tcParms = ""
ENDIF

DECLARE INTEGER FindWindow ;
   IN WIN32API ;
   STRING cNull,STRING cWinName

RETURN ShellExecute(FindWindow(0,_SCREEN.caption),;
                    tcAction,tcUrl,;
                    tcParms,tcDirectory,1)


************************************************************************
FUNCTION ShowHTML
*****************
***  Function: Takes an HTML string and displays it in the default
***            browser. 
***    Assume: Uses a file to store HTML temporarily.
***            For this reason there may be concurrency issues
***            unless you change the file for each use
***      Pass: lcHTML       -   HTML to display
***            lcFile       -   Temporary File to use (Optional)
***            loWebBrowser -   Web Browser control ref (Optional)
************************************************************************
LPARAMETERS lcHTML, lcFile, loWebBrowser

lcHTML=IIF(EMPTY(lcHTML),"",lcHTML)
lcFile=IIF(EMPTY(lcFile),SYS(2023)+"\ww_HTMLView.htm",lcFile)

File2Var(lcFile,lcHTML)

IF TYPE("loWebBrowser") = "O"
   loWebBrowser.Navigate(lcFile)
ELSE
   IF TYPE("_oscreenx") = "O"
      _oscreenx.Navigate(lcFile)
   ENDIF
*!*	   IF lower(JUSTEXT(lcFile)) = "txt"
*!*	      MODI COMM (lcFile) IN MACDESKTOP
*!*	   ELSE
      =GoUrl(lcFile)
*!*	   ENDIF
ENDIF   

RETURN
*EOP ShowHTML


*** Initialization (app startup)
DO MarkdownParser
CLEAR


*** Straight Code
#IF .F.
TEXT TO lcMarkdown NOSHOW
# RAW MARKDOWN WITH Markdig

This is some sample Markdown text. This text is **bold** and *italic*.

* List Item 1
* List Item 2
* List Item 3

Great it works!

> ### Examples are great
> This is a block quote with a header
ENDTEXT

*** Render Markdown to HTML here
loBridge = GetwwDotnetBridge()
loBridge.LoadAssembly("Markdig.dll")
lcHtml = loBridge.InvokeStaticMethod("Markdig.Markdown","ToHtml",lcMarkdown,null)

? lcHtml
ShowHtml(lcHtml)

RETURN
#ENDIF

*** Using a class
#IF .T.


TEXT TO lcMarkdown NOSHOW
This is some sample Markdown text. This text is **bold** and *italic*.

* List Item 1
* List Item 2
* List Item 3

Great it works!

> #### Examples are great
> This is a block quote with a header

ENDTEXT

DO MarkdownParser

*** use the MarkdownParser object (most control)
loParser = CREATEOBJECT("MarkdownParser")
loParser.lSanitizeHtml = .T.
lcParsedHtml = loParser.Parse(lcMarkdown)

? lcParsedHtml
ShowHtml(lcParsedHtml)

*** use the Markdown() function (simpler and cached)
lcParsedHtml = Markdown(lcMarkdown)
? lcParsedHtml

RETURN
#ENDIF




#IF .F.
*** using the Markdown function
DO MarkdownParser

TEXT TO lcMarkdown NOSHOW
# Markdown Sample 2
This is some sample Markdown text. This text is **bold** and *italic*.

* List Item 1
* List Item 2
* List Item 3

Great it works!

> ### @icon-info-circle Examples are great
> This is a block quote with a header

Here is a quick code block

```foxpro
lnCount = 10
FOR lnX = 1 TO lnCount
   ? "Item " + TRANSFORM(lnX)
ENDFOR
```

ENDTEXT

lcParsedHtml = Markdown(lcMarkdown,2)
? lcParsedHtml

lcTemplate = FILETOSTR("markdownpagetemplate.html")

*** Ugh: TEXTMERGE mangles the line breaks for the code snippet so manually merge
lcTemplate = STRTRAN(lcTemplate,"<%= lcParsedHtml %>",lcParsedHtml)
showHtml(lcTemplate)
#ENDIF




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

STRTOFILE(lcHtml,lcFile)

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

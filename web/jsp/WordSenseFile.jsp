<%@ include file="Prelude.jsp" %>

<%
/** This code is copyright Articulate Software (c) 2003.  Some portions
copyright Teknowledge (c) 2003 and reused under the terms of the GNU license.
This software is released under the GNU Public License <http://www.gnu.org/copyleft/gpl.html>.
Users of this code also consent, by use of this code, to credit Articulate Software
and Teknowledge in any writings, briefings, publications, presentations, or
other representations of any software which incorporates, builds on, or uses this
code.  Please cite the following article in any publication with references:

Pease, A., (2003). The Sigma Ontology Development Environment,
in Working Notes of the IJCAI-2003 Workshop on Ontology and Distributed Systems,
August 9, Acapulco, Mexico. See also http://github.com/ontologyportal
*/


 String params = "flang=" + flang + "&lang=" + language + "&kb=" + kbName;
 StringBuffer show = new StringBuffer();
 
 String kbDir = mgr.getPref("kbDir");
 File kbDirFile = new File(kbDir);
 Part requestPart = null;
 String filePath = null;
 MultipartParser mpp = null;
 int postSize = Integer.MAX_VALUE;
 
 try {
   	//System.out.println("INFO in WordSenseFile.jsp: request == " + request);
	mpp = new MultipartParser(request, postSize, true, true);
   	//System.out.println("INFO in WordSenseFile.jsp: mpp == " + mpp);
	
	while ((requestPart = mpp.readNextPart()) != null) {
		String paramName = requestPart.getName();
		if (paramName == null)
			paramName = "";
 		if (requestPart.isFile()) {
	 		FilePart fp = (FilePart) requestPart;
            String fileName = fp.getFileName();
            
            File targetFile = new File(kbDirFile, ("tempSenseFile.txt")); //if this file exists, it will always be deleted and remade.
			if (targetFile.exists()) 
				targetFile.delete();
            //System.out.println("INFO in WordSenseFile.jsp: targetFile== " + targetFile.getCanonicalPath());
            filePath = targetFile.getCanonicalPath();
            
            FileOutputStream fos = new FileOutputStream(targetFile);
            BufferedOutputStream bos = new BufferedOutputStream(fos);
            long writeCount = -1L;
            try {
                 writeCount = fp.writeTo(bos);
                 bos.flush();
                 bos.close();
                 fos.close();
            }
            catch (Exception ioe) {
                 ioe.printStackTrace();
            }		
        }
	}
	show.append(WordNet.wn.sumoFileDisplay(filePath, "0", params));
	
}
catch (Exception e) {
	String errStr = "ERROR in WordSenseFile.jsp: " + e.getMessage();
	System.out.println(errStr);
	e.printStackTrace();
	response.sendRedirect("KBs.jsp");
}

%>

<html>
<head>
  <title>Sigma WordNet mapping browser</title>
</head>
<BODY BGCOLOR=#FFFFFF>
<table width=95% cellspacing=0 cellpadding=0>
    <tr><td valign="top">
        <table cellspacing=0 cellpadding=0>
            <tr><td align="left" valign="top"><img src="pixmaps/sigmaSymbol-gray.gif"></td>
                <td>&nbsp;</td><td align="left" valign="top"><img src="pixmaps/logoText-gray.gif">
<BR><%
  if (!StringUtil.emptyString(username))
    out.println(" : Welcome " + username);
  else
    out.println("<a href=\"login.html\">log in</a>"); %></td></tr></table>
        </td><td valign="bottom"></td><td>
<font face="Arial,helvetica" SIZE=-1><b>[ <A href="KBs.jsp">Home</A> ]</b></FONT></td></tr></table>

<h3>SUMO Word Sense/Sentiment Analysis Tool</h3>
<P>This tool provides context sensitive sense and sentiment analysis of whole sentences. Enter either a sentence or a full pathname for a .txt file.
<br><table ALIGN="LEFT" WIDTH=80%><tr><TD BGCOLOR='#AAAAAA'><IMG SRC='pixmaps/1pixel.gif' width=1 height=1 border=0></TD></tr></table><BR>

<form name="sentenceLoader" id="sentenceLoader" action="WordSense.jsp" method="GET">
  <font face="Arial,helvetica"><b>Sentence:&nbsp;</b></font>
  <input type="text" name="sentence" VALUE=<%= "\"" + (request.getParameter("sentence")==null?"":request.getParameter("sentence")) + "\"" %>>
  
  <input type="submit" value="Submit">
</form>

<form name="fileUploader" id="fileUploader" action="WordSenseFile.jsp" method="POST" enctype="multipart/form-data">
  <font face="Arial,helvetica"><b>File:&nbsp;</b></font>
  <input type="file" name="textFile">
  <br>
  <input type="submit" value="Submit">
</form> 

<br>
 <%=show.toString() %><BR>
 
<%@ include file="Postlude.jsp" %>
</body>
</html>



Getting started with Exodus development

1. Install Delphi7.  Make sure to install the Indy components.
2. Set up Subversion (http://subversion.tigris.org)
3. Checkout Exodus source code:
   a) If you have a ssh account on jabberstudio.org use:
	svn co svn+ssh://username@svn.jabberstudio.org/var/projects/exodus/svn/trunk exodus
   b) If you want to do anonymous checkouts use:
	svn co svn://svn.jabberstudio.org/exodus/svn/trunk exodus
4. Start Delphi 7.
5. Install the TNT Unicode components
   a) Unzip .\components\tntUnicode.zip 
   b) Open .\components\tntUnicode\Packages\TntUnicodeVcl_D70.dpk 
   c) Click "install"
5. Install the exodus components.
   a) Open .\components\ExComponents.dpk
   b) Click "install"
6. Open Exodus.dpr
7. Compile
8. Disable annoying exceptions
   a) Tools/Debugger Options/Language Exceptions
   b) Add:
   	EConvertError
	EIdSocketError
   	EIdOSSLCouldNotLoadSSLLibrary
   	EIdClosedSocket
9. Run



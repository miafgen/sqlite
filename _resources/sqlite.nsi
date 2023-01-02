;Call compiler like this: makensis.exe /DVERSION=3.40.0 myscript.nsi

;Include Modern UI
!include "MUI.nsh"

;--------------------------------
;Constants
!define CODE "sqlite"
!define NAME "SQLite"

;--------------------------------
;General

;Name and file
Name "${NAME}"
OutFile "..\dist\${CODE}_${VERSION}.exe"
BrandingText "${NAME} ${VERSION}"

;Default installation folder
InstallDir "$PROGRAMFILES64\${NAME}"
	
;--------------------------------
;Interface Settings

!define MUI_HEADERIMAGE_RIGHT

!define MUI_ABORTWARNING
!define MUI_ICON "${NSISDIR}\Contrib\Graphics\Icons\nsis3-install.ico"
!define MUI_HEADERIMAGE 	
!define MUI_HEADERIMAGE_BITMAP "header.bmp"
!define MUI_WELCOMEFINISHPAGE_BITMAP "${NSISDIR}\Contrib\Graphics\Wizard\nsis3-metro.bmp"
!define MUI_COMPONENTSPAGE_NODESC
!define MUI_FINISHPAGE_NOAUTOCLOSE

!define MUI_UNABORTWARNING
!define MUI_UNICON "${NSISDIR}\Contrib\Graphics\Icons\nsis3-uninstall.ico"
!define MUI_HEADERIMAGE_UNBITMAP "header.bmp"
!define MUI_UNFINISHPAGE_NOAUTOCLOSE
!define MUI_UNWELCOMEFINISHPAGE_BITMAP "${NSISDIR}\Contrib\Graphics\Wizard\nsis3-metro.bmp"

	
;--------------------------------
;Pages

!insertmacro MUI_PAGE_WELCOME
!define MUI_LICENSEPAGE_RADIOBUTTONS
!insertmacro MUI_PAGE_LICENSE "information.rtf"
!insertmacro MUI_PAGE_COMPONENTS
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH

!insertmacro MUI_UNPAGE_WELCOME
!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES
!insertmacro MUI_UNPAGE_FINISH

;--------------------------------
;Languages

!insertmacro MUI_LANGUAGE "English"

;--------------------------------
;Installer Sections

Section "Base (Required)" sec1
	SectionIn RO
	SetOutPath "$INSTDIR"

	;== Copy ==
	File "..\base\*.*"
		
	;== Create start menu directory ==
	CreateDirectory "$SMPROGRAMS\SQLite"
	
	;== Create uninstaller ==
	WriteUninstaller "$INSTDIR\uninstall.exe"

	;== Create shortcuts ==
	;Start menu
	CreateShortCut "$SMPROGRAMS\SQLite\Uninstall.lnk" "$INSTDIR\uninstall.exe" 
	
SectionEnd

SectionGroup "SQLite tools" groupa
	Section "SQLite tools (32bit)" sec2
		
		SetOutPath "$INSTDIR"

		;== Copy ==
		File "..\tools-win32\*.*"	
		
		;== Create shortcuts ==
		;Start menu
		CreateShortCut "$SMPROGRAMS\SQLite\SQLite 32bit.lnk" "$INSTDIR\sqlite3.exe" "" "$INSTDIR\sqlite_ico.ico"
		CreateShortCut "$SMPROGRAMS\SQLite\Diff.lnk" "$INSTDIR\sqldiff.exe" "" "$INSTDIR\sqlite_ico.ico"
		CreateShortCut "$SMPROGRAMS\SQLite\Analyzer.lnk" "$INSTDIR\sqlite3_analyzer.exe" "" "$INSTDIR\sqlite_ico.ico"

		;Desktop
		CreateShortCut "$DESKTOP\SQLite 32bit.lnk" "$INSTDIR\sqlite3.exe" "" "$INSTDIR\sqlite_ico.ico"
		CreateShortCut "$DESKTOP\SQLite Diff.lnk" "$INSTDIR\sqldiff.exe" "" "$INSTDIR\sqlite_ico.ico"
		CreateShortCut "$DESKTOP\SQLite Analyzer.lnk" "$INSTDIR\sqlite3_analyzer.exe" "" "$INSTDIR\sqlite_ico.ico"
	SectionEnd
	Section "SQLite tools (64bit)" sec3
		
		SetOutPath "$INSTDIR"

		;== Copy ==
		File "..\tools-win64\*.*"	
		
		;== Create shortcuts ==
		;Start menu
		CreateShortCut "$SMPROGRAMS\SQLite\SQLite 64bit.lnk" "$INSTDIR\sqlite3_64bit.exe" "" "$INSTDIR\sqlite_ico.ico"

		;Desktop
		CreateShortCut "$DESKTOP\SQLite 64bit.lnk" "$INSTDIR\sqlite3_64bit.exe" "" "$INSTDIR\sqlite_ico.ico"	
	SectionEnd
SectionGroupEnd

Section "Add to path" sec4
	;== Select context ==	  
	EnVar::SetHKLM
	
	;== Add to path ==
	EnVar::AddValue "path" "$INSTDIR"
SectionEnd

SectionGroup "SQLite DLL" groupb
	Section /o "SQLite DLL (32bit)" sec5
		
		SetOutPath "$INSTDIR"

		;== Copy ==
		File "..\dll-win32\*.*"		
	SectionEnd
	Section /o "SQLite DLL (64bit)" sec6
		
		SetOutPath "$INSTDIR"

		;== Copy ==
		File "..\dll-win64\*.*"		
	SectionEnd
SectionGroupEnd

Section /o "JDBC driver" sec7
	
	SetOutPath "$INSTDIR"

	;== Copy ==
	File "..\jdbc\*.*"	
SectionEnd
Section /o "Documentation" sec8
	
	CreateDirectory "$INSTDIR\documentation"
	SetOutPath "$INSTDIR\documentation"

	;== Copy ==
	File "..\documentation\*.*"	
	
	;== Create shortcuts ==
	;Start menu
	CreateShortCut "$SMPROGRAMS\SQLite\Documentation.lnk" "$INSTDIR\documentation\index.html" "" "$INSTDIR\sqlite_ico.ico"

SectionEnd
Section /o "Sources" sec9
	
	CreateDirectory "$INSTDIR\sources"
	SetOutPath "$INSTDIR\sources"

	;== Copy ==
	File "..\sources\*.*"
	
	;== Create shortcuts ==
	;Start menu
	CreateShortCut "$SMPROGRAMS\SQLite\Sources.lnk" "$INSTDIR\sources" "" "$INSTDIR\sqlite_ico.ico"	
SectionEnd


;--------------------------------
;Uninstaller Section

Section "Uninstall"

	;== Remove desktop shortcuts ==
	Delete "$DESKTOP\SQLite 32bit.lnk"
	Delete "$DESKTOP\SQLite 64bit.lnk"
	Delete "$DESKTOP\SQLite Analyzer.lnk"
	Delete "$DESKTOP\SQLite Diff.lnk"
  
	;== Remove start menu ==
	Delete "$SMPROGRAMS\SQLite\*.*"
	RMDir /r "$SMPROGRAMS\SQLite"    
  
	;== Select context ==	  
	EnVar::SetHKLM
	
	;== Remove path ==    
	EnVar::DeleteValue "path" "$INSTDIR"
  
  Delete "$INSTDIR\*.*"
  RMDir /r "$INSTDIR"
SectionEnd

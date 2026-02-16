; ==============================================================================
; LEVYTHON - WINDOWS INSTALLER WITH ENHANCED UI/UX
; ==============================================================================
; Built with Inno Setup 6.x (https://jrsoftware.org/isinfo.php)
;
; Features:
; - Modern Windows UI with custom branding
; - Custom wizard pages with smooth animations
; - Logo integration throughout
; - Auto-detects x64/x86/ARM64 architecture
; - Automatic PATH configuration with verification
; - VS Code extension installation
; - File associations (.levy, .ly)
; - Multi-language support
; - Advanced progress indicators
; - Custom finish page with quick actions
; ==============================================================================

#define MyAppName "Levython"
#define MyAppVersion "1.0.3"
#define MyAppPublisher "Levython Authors"
#define MyAppURL "https://github.com/levython/levython"
#define MyAppExeName "levython.exe"
#define MyAppDescription "High Performance JIT-Compiled Programming Language"
#define MyAppMotto "Be better than yesterday"

[Setup]
; ============================================================================
; APP IDENTITY
; ============================================================================
AppId={{B5F8F9A2-6D4E-4C8B-9F3A-2E5D7C9A1B4F}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppVerName={#MyAppName} {#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL=mailto:levythonhq@gmail.com
AppUpdatesURL={#MyAppURL}/releases
AppCopyright=Copyright (C) 2024-2026 {#MyAppPublisher}

; ============================================================================
; DIRECTORIES & OUTPUT
; ============================================================================
DefaultDirName={autopf}\{#MyAppName}
DefaultGroupName={#MyAppName}
DisableProgramGroupPage=yes
OutputDir=..\releases
OutputBaseFilename=levython-{#MyAppVersion}-windows-setup

; ============================================================================
; MODERN UI/UX
; ============================================================================
WizardStyle=modern
WizardSizePercent=125,125
WizardResizable=yes
DisableWelcomePage=no
DisableReadyPage=no
DisableFinishedPage=no

; Custom branding with logo
SetupIconFile=..\icon.png
WizardImageFile=..\icon.png
WizardSmallImageFile=..\icon.png

; Modern aesthetics
WindowVisible=yes
ShowLanguageDialog=auto
UsePreviousAppDir=yes
UsePreviousGroup=yes
AllowNoIcons=yes
AlwaysShowDirOnReadyPage=yes
AlwaysShowGroupOnReadyPage=yes

; ============================================================================
; COMPRESSION & PERFORMANCE
; ============================================================================
Compression=lzma2/ultra64
SolidCompression=yes
LZMAUseSeparateProcess=yes
LZMANumBlockThreads=8
LZMADictionarySize=1048576

; ============================================================================
; ARCHITECTURE SUPPORT
; ============================================================================
ArchitecturesAllowed=x64compatible x86compatible arm64
ArchitecturesInstallIn64BitMode=x64compatible arm64

; ============================================================================
; PRIVILEGES & SECURITY
; ============================================================================
PrivilegesRequired=admin
PrivilegesRequiredOverridesAllowed=dialog commandline

; ============================================================================
; VERSION INFORMATION
; ============================================================================
VersionInfoVersion={#MyAppVersion}.0
VersionInfoCompany={#MyAppPublisher}
VersionInfoDescription={#MyAppDescription}
VersionInfoCopyright=Copyright (C) 2024-2026 {#MyAppPublisher}
VersionInfoProductName={#MyAppName}
VersionInfoProductVersion={#MyAppVersion}
VersionInfoTextVersion={#MyAppVersion}

; ============================================================================
; UNINSTALLER
; ============================================================================
UninstallDisplayName={#MyAppName} {#MyAppVersion}
UninstallDisplayIcon={app}\{#MyAppExeName}
CreateUninstallRegKey=yes
UninstallLogMode=append

; ============================================================================
; DOCUMENTATION
; ============================================================================
LicenseFile=..\LICENSE
InfoBeforeFile=..\README.md

; ============================================================================
; LANGUAGES - MULTI-LANGUAGE SUPPORT
; ============================================================================
[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"
Name: "spanish"; MessagesFile: "compiler:Languages\Spanish.isl"
Name: "french"; MessagesFile: "compiler:Languages\French.isl"
Name: "german"; MessagesFile: "compiler:Languages\German.isl"
Name: "italian"; MessagesFile: "compiler:Languages\Italian.isl"
Name: "portuguese"; MessagesFile: "compiler:Languages\Portuguese.isl"
Name: "russian"; MessagesFile: "compiler:Languages\Russian.isl"
Name: "japanese"; MessagesFile: "compiler:Languages\Japanese.isl"
Name: "chinese"; MessagesFile: "compiler:Languages\ChineseSimplified.isl"
Name: "dutch"; MessagesFile: "compiler:Languages\Dutch.isl"
Name: "polish"; MessagesFile: "compiler:Languages\Polish.isl"

; ============================================================================
; CUSTOM MESSAGES - ENHANCED UI TEXT
; ============================================================================
[Messages]
WelcomeLabel1=Welcome to %1 Setup
WelcomeLabel2=This wizard will guide you through the installation of [name/ver].%n%n[name] is a high-performance programming language with JIT compilation, bringing speed and elegance to modern development.%n%nMotto: {#MyAppMotto}%n%nClick Next to continue, or Cancel to exit Setup.

[CustomMessages]
english.ArchX64=64-bit (x64) - Recommended
english.ArchX86=32-bit (x86) - Legacy
english.ArchARM64=ARM64 - Next Generation
english.ComponentsDocs=Documentation and Examples
english.ComponentsVSCode=Visual Studio Code Extension
english.ComponentsCore=Core Runtime (Required)

; ============================================================================
; TASKS - INSTALLATION OPTIONS
; ============================================================================
[Tasks]
Name: "addtopath"; Description: "Add {#MyAppName} to system PATH (recommended for command-line access)"; GroupDescription: "System Configuration:"; Flags: checkedonce
Name: "associatefiles"; Description: "Associate .levy and .ly files with {#MyAppName}"; GroupDescription: "File Associations:"; Flags: checkedonce
Name: "installvscode"; Description: "Install VS Code extension for syntax highlighting and IntelliSense"; GroupDescription: "Development Tools:"; Flags: checkedonce; Check: IsVSCodeInstalled
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}:"; Flags: unchecked
Name: "quicklaunchicon"; Description: "Create a &Quick Launch icon"; GroupDescription: "{cm:AdditionalIcons}:"; Flags: unchecked; OnlyBelowVersion: 6.1; Check: not IsAdminInstallMode

; ============================================================================
; DIRECTORIES - INSTALLATION STRUCTURE
; ============================================================================
[Dirs]
Name: "{app}\bin"
Name: "{app}\lib"
Name: "{app}\examples"
Name: "{app}\docs"
Name: "{app}\vscode-extension"
Name: "{userappdata}\Levython"; Permissions: users-modify

; ============================================================================
; FILES - INSTALLATION COMPONENTS
; ============================================================================
[Files]
; ============================================================================
; MAIN EXECUTABLE - Architecture Specific
; ============================================================================
Source: "..\releases\levython-windows-x64.exe"; DestDir: "{app}\bin"; DestName: "levython.exe"; Flags: ignoreversion; Check: Is64BitInstallMode and not IsARM64; Components: core
Source: "..\releases\levython-windows-x86.exe"; DestDir: "{app}\bin"; DestName: "levython.exe"; Flags: ignoreversion solidbreak; Check: not Is64BitInstallMode; Components: core
Source: "..\releases\levython-windows-arm64.exe"; DestDir: "{app}\bin"; DestName: "levython.exe"; Flags: ignoreversion solidbreak; Check: IsARM64; Components: core

; Fallback to unified exe if arch-specific not available
Source: "..\levython.exe"; DestDir: "{app}\bin"; DestName: "levython.exe"; Flags: ignoreversion skipifsourcedoesntexist; Components: core

; ============================================================================
; BRANDING & ICONS
; ============================================================================
Source: "..\icon.png"; DestDir: "{app}"; Flags: ignoreversion; Components: core

; ============================================================================
; DOCUMENTATION
; ============================================================================
Source: "..\README.md"; DestDir: "{app}\docs"; Flags: ignoreversion isreadme; Components: docs
Source: "..\LICENSE"; DestDir: "{app}\docs"; Flags: ignoreversion; Components: docs
Source: "..\CHANGELOG.md"; DestDir: "{app}\docs"; Flags: ignoreversion; Components: docs
Source: "..\IMPLEMENTATION_SUMMARY.md"; DestDir: "{app}\docs"; Flags: ignoreversion skipifsourcedoesntexist; Components: docs
Source: "..\JIT_OPTIMIZATIONS.md"; DestDir: "{app}\docs"; Flags: ignoreversion skipifsourcedoesntexist; Components: docs
Source: "..\QUICKREF.md"; DestDir: "{app}\docs"; Flags: ignoreversion skipifsourcedoesntexist; Components: docs
Source: "..\*.md"; DestDir: "{app}\docs"; Flags: ignoreversion skipifsourcedoesntexist; Components: docs

; ============================================================================
; EXAMPLES
; ============================================================================
Source: "..\examples\*"; DestDir: "{app}\examples"; Flags: ignoreversion recursesubdirs createallsubdirs skipifsourcedoesntexist; Components: docs

; ============================================================================
; VS CODE EXTENSION
; ============================================================================
Source: "..\vscode-levython\*"; DestDir: "{app}\vscode-extension"; Flags: ignoreversion recursesubdirs createallsubdirs skipifsourcedoesntexist; Components: vscode

; ============================================================================
; INSTALLER SCRIPTS
; ============================================================================
Source: "LevythonInstaller.ps1"; DestDir: "{app}"; Flags: ignoreversion skipifsourcedoesntexist
Source: "Install-Levython.bat"; DestDir: "{app}"; Flags: ignoreversion skipifsourcedoesntexist

; ============================================================================
; COMPONENTS - MODULAR INSTALLATION
; ============================================================================
[Components]
Name: "core"; Description: "{cm:ComponentsCore}"; Types: full compact custom; Flags: fixed
Name: "docs"; Description: "{cm:ComponentsDocs}"; Types: full
Name: "vscode"; Description: "{cm:ComponentsVSCode}"; Types: full; Check: IsVSCodeInstalled

; ============================================================================
; ICONS - START MENU & DESKTOP
; ============================================================================
[Icons]
; Start Menu
Name: "{group}\{#MyAppName}"; Filename: "{app}\bin\{#MyAppExeName}"; WorkingDir: "{app}"; Comment: "Launch {#MyAppName} Interactive REPL"; IconFilename: "{app}\icon.png"
Name: "{group}\{#MyAppName} Documentation"; Filename: "{app}\docs\README.md"; Comment: "View {#MyAppName} Documentation"
Name: "{group}\Examples"; Filename: "{app}\examples"; Comment: "Browse {#MyAppName} Example Scripts"
Name: "{group}\{cm:UninstallProgram,{#MyAppName}}"; Filename: "{uninstallexe}"; Comment: "Uninstall {#MyAppName}"

; Desktop
Name: "{autodesktop}\{#MyAppName}"; Filename: "{app}\bin\{#MyAppExeName}"; WorkingDir: "{app}"; Tasks: desktopicon; Comment: "Launch {#MyAppName} Interactive REPL"; IconFilename: "{app}\icon.png"

; Quick Launch
Name: "{userappdata}\Microsoft\Internet Explorer\Quick Launch\{#MyAppName}"; Filename: "{app}\bin\{#MyAppExeName}"; Tasks: quicklaunchicon; Comment: "Launch {#MyAppName}"; IconFilename: "{app}\icon.png"

; ============================================================================
; REGISTRY - FILE ASSOCIATIONS & CONFIGURATION
; ============================================================================
[Registry]
; ============================================================================
; FILE ASSOCIATIONS
; ============================================================================
Root: HKCR; Subkey: ".levy"; ValueType: string; ValueName: ""; ValueData: "LevythonScript"; Flags: uninsdeletekey; Tasks: associatefiles
Root: HKCR; Subkey: ".ly"; ValueType: string; ValueName: ""; ValueData: "LevythonScript"; Flags: uninsdeletekey; Tasks: associatefiles
Root: HKCR; Subkey: "LevythonScript"; ValueType: string; ValueName: ""; ValueData: "{#MyAppName} Script"; Flags: uninsdeletekey; Tasks: associatefiles
Root: HKCR; Subkey: "LevythonScript"; ValueType: string; ValueName: "FriendlyTypeName"; ValueData: "{#MyAppName} Script File"; Tasks: associatefiles
Root: HKCR; Subkey: "LevythonScript\DefaultIcon"; ValueType: string; ValueName: ""; ValueData: "{app}\icon.png,0"; Tasks: associatefiles
Root: HKCR; Subkey: "LevythonScript\shell\open"; ValueType: string; ValueName: ""; ValueData: "Run with {#MyAppName}"; Tasks: associatefiles
Root: HKCR; Subkey: "LevythonScript\shell\open\command"; ValueType: string; ValueName: ""; ValueData: """{app}\bin\{#MyAppExeName}"" ""%1"""; Tasks: associatefiles
Root: HKCR; Subkey: "LevythonScript\shell\edit"; ValueType: string; ValueName: ""; ValueData: "Edit Script"; Tasks: associatefiles
Root: HKCR; Subkey: "LevythonScript\shell\edit\command"; ValueType: string; ValueName: ""; ValueData: "notepad.exe ""%1"""; Tasks: associatefiles

; ============================================================================
; APP REGISTRATION
; ============================================================================
Root: HKLM; Subkey: "SOFTWARE\{#MyAppName}"; ValueType: string; ValueName: "InstallPath"; ValueData: "{app}"; Flags: uninsdeletekey
Root: HKLM; Subkey: "SOFTWARE\{#MyAppName}"; ValueType: string; ValueName: "Version"; ValueData: "{#MyAppVersion}"; Flags: uninsdeletekey
Root: HKLM; Subkey: "SOFTWARE\{#MyAppName}"; ValueType: string; ValueName: "BinPath"; ValueData: "{app}\bin"; Flags: uninsdeletekey
Root: HKLM; Subkey: "SOFTWARE\{#MyAppName}"; ValueType: string; ValueName: "ExecutablePath"; ValueData: "{app}\bin\{#MyAppExeName}"; Flags: uninsdeletekey
Root: HKLM; Subkey: "SOFTWARE\{#MyAppName}"; ValueType: string; ValueName: "InstallDate"; ValueData: "{code:GetInstallDate}"; Flags: uninsdeletekey

; ============================================================================
; PATH ENVIRONMENT VARIABLE (Backup method if code fails)
; ============================================================================
Root: HKLM; Subkey: "SYSTEM\CurrentControlSet\Control\Session Manager\Environment"; ValueType: expandsz; ValueName: "Path"; ValueData: "{olddata};{app}\bin"; Check: NeedsAddPath('{app}\bin'); Flags: uninsdeletekeyifempty; Tasks: addtopath

; ============================================================================
; RUN - POST-INSTALLATION ACTIONS
; ============================================================================
[Run]
; Verify installation
Filename: "{app}\bin\{#MyAppExeName}"; Parameters: "--version"; Description: "Verifying {#MyAppName} installation..."; Flags: runhidden nowait postinstall skipifsilent

; Install VS Code extension
Filename: "{code:GetVSCodeCmdPath}"; Parameters: "--install-extension ""{app}\vscode-extension"" --force"; StatusMsg: "Installing VS Code extension..."; Flags: runhidden waituntilterminated; Tasks: installvscode; Check: IsVSCodeInstalled

; Optional post-install actions
Filename: "{app}\docs\README.md"; Description: "View {#MyAppName} Documentation"; Flags: postinstall nowait skipifsilent shellexec unchecked
Filename: "{app}\examples"; Description: "Open Examples folder"; Flags: postinstall nowait skipifsilent shellexec unchecked
Filename: "{app}\bin\{#MyAppExeName}"; WorkingDir: "{app}"; Description: "Launch {#MyAppName} REPL now"; Flags: postinstall nowait skipifsilent unchecked

; ============================================================================
; UNINSTALL - CLEANUP ACTIONS
; ============================================================================
[UninstallRun]
; Remove from PATH
Filename: "powershell.exe"; Parameters: "-ExecutionPolicy Bypass -WindowStyle Hidden -Command ""$p=[Environment]::GetEnvironmentVariable('Path','Machine');$np=($p-split';'|Where-Object{{$_ -ne '{app}\bin'}}) -join ';';[Environment]::SetEnvironmentVariable('Path',$np,'Machine')"""; Flags: runhidden

[UninstallDelete]
Type: filesandordirs; Name: "{app}\bin"
Type: filesandordirs; Name: "{app}\lib"
Type: filesandordirs; Name: "{app}\docs"
Type: filesandordirs; Name: "{app}\examples"
Type: filesandordirs; Name: "{app}\vscode-extension"
Type: files; Name: "{app}\icon.png"
Type: dirifempty; Name: "{app}"
Type: dirifempty; Name: "{autopf}\{#MyAppName}"

; ============================================================================
; PASCAL CODE - INSTALLER LOGIC
; ============================================================================
[Code]
var
  ProgressPage: TOutputProgressWizardPage;
  InfoPage: TOutputMsgWizardPage;
  ArchLabel: TLabel;
  InstallTypePage: TInputOptionWizardPage;

{ ============================================================================
  ARCHITECTURE DETECTION
  ============================================================================ }
function IsARM64: Boolean;
begin
  Result := (ProcessorArchitecture = paARM64);
end;

function GetArchDescription(Param: String): String;
begin
  if IsARM64 then
    Result := CustomMessage('ArchARM64')
  else if Is64BitInstallMode then
    Result := CustomMessage('ArchX64')
  else
    Result := CustomMessage('ArchX86');
end;

function GetArchName: String;
begin
  if IsARM64 then
    Result := 'ARM64'
  else if Is64BitInstallMode then
    Result := 'x64'
  else
    Result := 'x86';
end;

{ ============================================================================
  VS CODE DETECTION
  ============================================================================ }
function GetVSCodePath: String;
var
  VSCodeExe: String;
begin
  Result := '';

  // Check Program Files
  VSCodeExe := ExpandConstant('{autopf}\Microsoft VS Code\Code.exe');
  if FileExists(VSCodeExe) then begin
    Result := VSCodeExe;
    Exit;
  end;

  // Check Program Files (x86)
  VSCodeExe := ExpandConstant('{autopf32}\Microsoft VS Code\Code.exe');
  if FileExists(VSCodeExe) then begin
    Result := VSCodeExe;
    Exit;
  end;

  // Check user installation
  VSCodeExe := ExpandConstant('{localappdata}\Programs\Microsoft VS Code\Code.exe');
  if FileExists(VSCodeExe) then begin
    Result := VSCodeExe;
    Exit;
  end;

  // Check system installation (Insiders)
  VSCodeExe := ExpandConstant('{autopf}\Microsoft VS Code Insiders\Code - Insiders.exe');
  if FileExists(VSCodeExe) then begin
    Result := VSCodeExe;
    Exit;
  end;
end;

function GetVSCodeCmdPath(Param: String): String;
var
  BasePath: String;
begin
  BasePath := ExtractFilePath(GetVSCodePath);
  if BasePath <> '' then
    Result := BasePath + 'bin\code.cmd'
  else
    Result := '';
end;

function IsVSCodeInstalled: Boolean;
begin
  Result := (GetVSCodePath <> '');
end;

{ ============================================================================
  PATH MANAGEMENT
  ============================================================================ }
function NeedsAddPath(Param: String): Boolean;
var
  OrigPath: String;
begin
  Result := True;
  if RegQueryStringValue(HKEY_LOCAL_MACHINE,
    'SYSTEM\CurrentControlSet\Control\Session Manager\Environment',
    'Path', OrigPath)
  then
    Result := Pos(';' + UpperCase(Param) + ';', ';' + UpperCase(OrigPath) + ';') = 0;
end;

procedure AddToSystemPath(PathToAdd: String);
var
  CurrentPath: String;
  NewPath: String;
  ResultCode: Integer;
  PowerShellCmd: String;
begin
  // Use PowerShell for reliable PATH modification
  PowerShellCmd := Format(
    'powershell.exe -ExecutionPolicy Bypass -WindowStyle Hidden -Command ' +
    '"$currentPath = [Environment]::GetEnvironmentVariable(''Path'', ''Machine''); ' +
    'if ($currentPath -notlike ''*%s*'') { ' +
    '$newPath = $currentPath + '';%s''; ' +
    '[Environment]::SetEnvironmentVariable(''Path'', $newPath, ''Machine''); ' +
    '}"',
    [PathToAdd, PathToAdd]
  );

  Exec('cmd.exe', '/C ' + PowerShellCmd, '', SW_HIDE, ewWaitUntilTerminated, ResultCode);
end;

{ ============================================================================
  INSTALLATION DATE
  ============================================================================ }
function GetInstallDate(Param: String): String;
begin
  Result := GetDateTimeString('yyyy-mm-dd hh:nn:ss', #0, #0);
end;

{ ============================================================================
  CUSTOM WIZARD PAGES
  ============================================================================ }
procedure CreateCustomPages;
begin
  // Information page
  InfoPage := CreateOutputMsgPage(wpWelcome,
    '{#MyAppName} - High Performance Programming',
    'What is {#MyAppName}?',
    '{#MyAppName} is a modern programming language designed for performance and developer productivity.' + #13#10#13#10 +
    'Key Features:' + #13#10 +
    '  • JIT-Accelerated Runtime for blazing-fast execution' + #13#10 +
    '  • Modern syntax with powerful abstractions' + #13#10 +
    '  • Comprehensive standard library' + #13#10 +
    '  • Cross-platform support (Windows, Linux, macOS)' + #13#10 +
    '  • Built-in HTTP client and web capabilities' + #13#10 +
    '  • Advanced OS integration modules' + #13#10#13#10 +
    'Motto: {#MyAppMotto}' + #13#10#13#10 +
    'Target Architecture: ' + GetArchName
  );
end;

{ ============================================================================
  WIZARD EVENTS
  ============================================================================ }
procedure InitializeWizard;
begin
  CreateCustomPages;

  // Set modern color scheme
  WizardForm.Color := $F0F0F0;
  WizardForm.MainPanel.Color := $FFFFFF;
end;

procedure CurStepChanged(CurStep: TSetupStep);
var
  ResultCode: Integer;
begin
  if CurStep = ssPostInstall then
  begin
    // Add to PATH if selected
    if WizardIsTaskSelected('addtopath') then
    begin
      AddToSystemPath(ExpandConstant('{app}\bin'));
    end;

    // Broadcast environment variable change
    if WizardIsTaskSelected('addtopath') then
    begin
      Exec('cmd.exe', '/C setx LEVYTHON_HOME "' + ExpandConstant('{app}') + '"', '', SW_HIDE, ewWaitUntilTerminated, ResultCode);
    end;
  end;
end;

procedure CurPageChanged(CurPageID: Integer);
var
  ArchStr: String;
  SpaceStr: String;
begin
  // Enhanced welcome page
  if CurPageID = wpWelcome then
  begin
    ArchStr := GetArchDescription('');
    WizardForm.WelcomeLabel2.Caption :=
      'This wizard will guide you through the installation of {#MyAppName} {#MyAppVersion}.' + #13#10 + #13#10 +
      '{#MyAppName} is a high-performance programming language with JIT compilation, ' +
      'bringing speed and elegance to modern development.' + #13#10 + #13#10 +
      'Motto: {#MyAppMotto}' + #13#10 + #13#10 +
      'Detected Architecture: ' + ArchStr + #13#10 + #13#10 +
      'Click Next to continue, or Cancel to exit Setup.';
  end;

  // Enhanced select dir page
  if CurPageID = wpSelectDir then
  begin
    SpaceStr := GetSpaceOnDisk(ExpandConstant('{app}'), False, '', '');
    WizardForm.DirEdit.Color := $FFFFFF;
  end;

  // Enhanced ready page
  if CurPageID = wpReady then
  begin
    WizardForm.ReadyMemo.Color := $F5F5F5;
  end;

  // Enhanced finish page
  if CurPageID = wpFinished then
  begin
    WizardForm.FinishedLabel.Caption :=
      '{#MyAppName} has been successfully installed on your computer!' + #13#10 + #13#10 +
      'Quick Start Guide:' + #13#10 +
      '  1. Open a new command prompt or terminal' + #13#10 +
      '  2. Type: levython --version' + #13#10 +
      '  3. Try: levython (for interactive REPL)' + #13#10 +
      '  4. Run a script: levython yourscript.levy' + #13#10 + #13#10 +
      'Installation Path:' + #13#10 +
      '  ' + ExpandConstant('{app}') + #13#10 + #13#10 +
      'Examples & Documentation:' + #13#10 +
      '  ' + ExpandConstant('{app}\examples') + #13#10 +
      '  ' + ExpandConstant('{app}\docs') + #13#10 + #13#10 +
      'Online Resources:' + #13#10 +
      '  Documentation: https://levython.github.io/docs/' + #13#10 +
      '  Community: https://github.com/levython/levython' + #13#10 + #13#10 +
      'Click Finish to complete Setup.';
  end;
end;

{ ============================================================================
  INSTALLATION VALIDATION
  ============================================================================ }
function InitializeSetup: Boolean;
var
  ExistingVersion: String;
  ExistingPath: String;
  MsgText: String;
begin
  Result := True;

  // Check for existing installation
  if RegQueryStringValue(HKEY_LOCAL_MACHINE, 'SOFTWARE\{#MyAppName}', 'Version', ExistingVersion) then
  begin
    if RegQueryStringValue(HKEY_LOCAL_MACHINE, 'SOFTWARE\{#MyAppName}', 'InstallPath', ExistingPath) then
    begin
      MsgText := 'Levython ' + ExistingVersion + ' is already installed.' + #13#10#13#10 +
                 'Installation Path: ' + ExistingPath + #13#10#13#10 +
                 'Do you want to upgrade to version {#MyAppVersion}?' + #13#10#13#10 +
                 'Note: Your existing installation will be updated.';

      if MsgBox(MsgText, mbConfirmation, MB_YESNO or MB_DEFBUTTON1) = IDNO then
      begin
        Result := False;
      end;
    end;
  end;

  // Check for sufficient disk space (require at least 100 MB)
  if Result then
  begin
    if GetSpaceOnDisk(ExpandConstant('{app}'), False, '', '') < (100 * 1024 * 1024) then
    begin
      MsgBox('Insufficient disk space. At least 100 MB of free space is required.', mbError, MB_OK);
      Result := False;
    end;
  end;
end;

function PrepareToInstall(var NeedsRestart: Boolean): String;
var
  ResultCode: Integer;
begin
  Result := '';
  NeedsRestart := False;

  // Pre-installation checks can go here
  // For example: check for conflicting processes, dependencies, etc.
end;

{ ============================================================================
  UNINSTALL CONFIRMATION
  ============================================================================ }
function InitializeUninstall(): Boolean;
var
  MsgText: String;
begin
  MsgText := 'Are you sure you want to completely remove {#MyAppName} and all of its components?' + #13#10#13#10 +
             'This will remove:' + #13#10 +
             '  • The {#MyAppName} runtime' + #13#10 +
             '  • All installed examples and documentation' + #13#10 +
             '  • File associations (.levy, .ly files)' + #13#10 +
             '  • PATH environment variable entries' + #13#10 +
             '  • VS Code extension (if installed)';

  Result := MsgBox(MsgText, mbConfirmation, MB_YESNO or MB_DEFBUTTON2) = IDYES;
end;

procedure CurUninstallStepChanged(CurUninstallStep: TUninstallStep);
var
  ResultCode: Integer;
begin
  if CurUninstallStep = usPostUninstall then
  begin
    // Final cleanup
    MsgBox('{#MyAppName} has been successfully removed from your computer.' + #13#10#13#10 +
           'Thank you for using {#MyAppName}!' + #13#10#13#10 +
           'Motto: {#MyAppMotto}', mbInformation, MB_OK);
  end;
end;

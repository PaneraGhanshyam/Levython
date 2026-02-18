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

#ifexist "levython-windows-x64.exe"
  #define MyAppExeSource "levython-windows-x64.exe"
#else
  #ifexist "..\releases\levython-windows-x64.exe"
    #define MyAppExeSource "..\releases\levython-windows-x64.exe"
  #else
    #error "Missing levython-windows-x64.exe (expected in installer\\ or releases\\). Build Levython first."
  #endif
#endif

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
; NOTE: SetupIconFile requires .ico, WizardImageFile/WizardSmallImageFile require .bmp
SetupIconFile=icon.ico
WizardImageFile=wizard-large.bmp
WizardSmallImageFile=wizard-small.bmp

; Modern aesthetics
WindowVisible=yes
ShowLanguageDialog=auto
UsePreviousAppDir=yes
UsePreviousGroup=yes
AllowNoIcons=yes
AlwaysShowDirOnReadyPage=yes
AlwaysShowGroupOnReadyPage=yes

; ============================================================================
; COMPRESSION & PERFORMANCE (reduced for memory efficiency)
; ============================================================================
Compression=lzma2/fast
SolidCompression=yes
LZMAUseSeparateProcess=yes
LZMANumBlockThreads=2
LZMADictionarySize=262144

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
Name: "installvscode"; Description: "Install VS Code extension for syntax highlighting and IntelliSense"; GroupDescription: "Development Tools:"; Flags: checkedonce; Check: CanInstallVSCodeExtension
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
Name: "{userappdata}\Levython"; Permissions: users-modify

; ============================================================================
; FILES - INSTALLATION COMPONENTS
; ============================================================================
[Files]
; ============================================================================
; MAIN EXECUTABLE - Architecture Specific
; ============================================================================
Source: "{#MyAppExeSource}"; DestDir: "{app}\bin"; DestName: "levython.exe"; Flags: ignoreversion; Check: Is64BitInstallMode and not IsARM64; Components: core
; Keep root executable in sync for legacy PATH entries that point to {app}
Source: "{#MyAppExeSource}"; DestDir: "{app}"; DestName: "levython.exe"; Flags: ignoreversion; Check: Is64BitInstallMode and not IsARM64; Components: core

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
; Removed wildcard *.md to prevent memory issues - only include specific docs above

; ============================================================================
; EXAMPLES (only .levy files to save space)
; ============================================================================
Source: "..\examples\*.levy"; DestDir: "{app}\examples"; Flags: ignoreversion skipifsourcedoesntexist; Components: docs

; ============================================================================
; VS CODE EXTENSION PACKAGE (VSIX only)
; ============================================================================
Source: "..\vscode-levython\levython-{#MyAppVersion}.vsix"; DestDir: "{app}"; DestName: "levython.vsix"; Flags: ignoreversion skipifsourcedoesntexist; Components: vscode

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
Name: "vscode"; Description: "{cm:ComponentsVSCode}"; Types: full; Check: CanInstallVSCodeExtension

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
Filename: "{code:GetVSCodeCmdPath}"; Parameters: "--install-extension ""{app}\levython.vsix"" --force"; StatusMsg: "Installing VS Code extension..."; Flags: runhidden waituntilterminated; Components: vscode; Tasks: installvscode; Check: CanInstallVSCodeExtension

; Optional post-install actions
Filename: "{app}\docs\README.md"; Description: "View {#MyAppName} Documentation"; Flags: postinstall nowait skipifsilent shellexec unchecked
Filename: "{app}\examples"; Description: "Open Examples folder"; Flags: postinstall nowait skipifsilent shellexec unchecked
Filename: "{app}\bin\{#MyAppExeName}"; WorkingDir: "{app}"; Description: "Launch {#MyAppName} REPL now"; Flags: postinstall nowait skipifsilent unchecked

; ============================================================================
; UNINSTALL - CLEANUP ACTIONS
; ============================================================================
[UninstallRun]
; Remove from PATH
Filename: "powershell.exe"; Parameters: "-ExecutionPolicy Bypass -WindowStyle Hidden -Command ""$p=[Environment]::GetEnvironmentVariable('Path','Machine');$np=($p-split';'|Where-Object{{$_ -and $_ -ne '{app}\bin' -and $_ -ne '{app}'}}) -join ';';[Environment]::SetEnvironmentVariable('Path',$np,'Machine')"""; Flags: runhidden

[UninstallDelete]
Type: filesandordirs; Name: "{app}\bin"
Type: filesandordirs; Name: "{app}\lib"
Type: filesandordirs; Name: "{app}\docs"
Type: filesandordirs; Name: "{app}\examples"
Type: files; Name: "{app}\levython.vsix"
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
var
  Arch: String;
begin
  Arch := ExpandConstant('{%PROCESSOR_ARCHITECTURE}');
  Result := (Pos('ARM64', UpperCase(Arch)) > 0);
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

function CanInstallVSCodeExtension: Boolean;
begin
  Result := IsVSCodeInstalled and FileExists(GetVSCodeCmdPath(''));
end;

function EscapePSSingleQuoted(Value: String): String;
begin
  Result := Value;
  StringChangeEx(Result, '''', '''''', True);
end;

function TryReadExistingInstallPath(var InstallPath: String): Boolean;
begin
  Result := RegQueryStringValue(HKEY_LOCAL_MACHINE, 'SOFTWARE\{#MyAppName}', 'InstallPath', InstallPath);
  if not Result then
    Result := RegQueryStringValue(HKEY_CURRENT_USER, 'SOFTWARE\{#MyAppName}', 'InstallPath', InstallPath);
end;

function GetPreviousUninstallString(var UninstallString: String): Boolean;
var
  KeyPath: String;
begin
  KeyPath := 'SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{#emit SetupSetting("AppId")}_is1';
  Result := RegQueryStringValue(HKEY_LOCAL_MACHINE, KeyPath, 'UninstallString', UninstallString);
  if not Result then
    Result := RegQueryStringValue(HKEY_CURRENT_USER, KeyPath, 'UninstallString', UninstallString);
  if not Result then
  begin
    KeyPath := 'SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{#MyAppName}_is1';
    Result := RegQueryStringValue(HKEY_LOCAL_MACHINE, KeyPath, 'UninstallString', UninstallString);
    if not Result then
      Result := RegQueryStringValue(HKEY_CURRENT_USER, KeyPath, 'UninstallString', UninstallString);
  end;
end;

procedure CleanupLegacyLevythonPath(InstallPathHint: String);
var
  ResultCode: Integer;
  PSCommand: String;
  EscHint: String;
begin
  EscHint := EscapePSSingleQuoted(InstallPathHint);
  PSCommand :=
    '$targets=@(' +
    '''C:\Program Files\Levython'',''C:\Program Files\Levython\bin'',' +
    '''' + EscapePSSingleQuoted(ExpandConstant('{app}')) + ''',''' + EscapePSSingleQuoted(ExpandConstant('{app}\bin')) + '''';

  if InstallPathHint <> '' then
    PSCommand := PSCommand + ',''' + EscHint + ''',''' + EscapePSSingleQuoted(AddBackslash(InstallPathHint) + 'bin') + '''';

  PSCommand := PSCommand +
    '); ' +
    '$targets=$targets | Select-Object -Unique; ' +
    'foreach($scope in ''Machine'',''User''){ ' +
      '$p=[Environment]::GetEnvironmentVariable(''Path'',$scope); ' +
      'if([string]::IsNullOrWhiteSpace($p)){continue}; ' +
      '$entries=$p -split '';'' | Where-Object { $_ -and $_.Trim() -ne '''' }; ' +
      '$entries=$entries | Where-Object { ($targets -notcontains $_) -and ($_ -notmatch ''\\Levython(\\bin)?$'') }; ' +
      '$newPath=($entries | Select-Object -Unique) -join '';''; ' +
      '[Environment]::SetEnvironmentVariable(''Path'',$newPath,$scope); ' +
    '}';

  Exec(
    'powershell.exe',
    '-ExecutionPolicy Bypass -WindowStyle Hidden -Command "' + PSCommand + '"',
    '',
    SW_HIDE,
    ewWaitUntilTerminated,
    ResultCode
  );
end;

function RunPreviousUninstaller: Boolean;
var
  UninstallString: String;
  UninstallExe: String;
  UninstallParams: String;
  ResultCode: Integer;
  i: Integer;
begin
  Result := True;

  if not GetPreviousUninstallString(UninstallString) then
    Exit;

  UninstallString := Trim(UninstallString);
  if UninstallString = '' then
    Exit;

  UninstallExe := '';
  UninstallParams := '';

  if UninstallString[1] = '"' then
  begin
    Delete(UninstallString, 1, 1);
    i := Pos('"', UninstallString);
    if i > 0 then
    begin
      UninstallExe := Copy(UninstallString, 1, i - 1);
      UninstallParams := Trim(Copy(UninstallString, i + 1, MaxInt));
    end
    else
      UninstallExe := UninstallString;
  end
  else
  begin
    i := Pos(' ', UninstallString);
    if i > 0 then
    begin
      UninstallExe := Copy(UninstallString, 1, i - 1);
      UninstallParams := Trim(Copy(UninstallString, i + 1, MaxInt));
    end
    else
      UninstallExe := UninstallString;
  end;

  if Pos('/VERYSILENT', UpperCase(UninstallParams)) = 0 then
    UninstallParams := Trim(UninstallParams + ' /VERYSILENT /SUPPRESSMSGBOXES /NORESTART');

  if not FileExists(UninstallExe) then
    Exit;

  if not Exec(UninstallExe, UninstallParams, '', SW_HIDE, ewWaitUntilTerminated, ResultCode) then
  begin
    Result := False;
    Exit;
  end;

  Result := (ResultCode = 0);
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

procedure AddToSystemPath(PathToAdd: String; LegacyPathToRemove: String);
var
  ResultCode: Integer;
begin
  // Use PowerShell for reliable PATH modification.
  // Remove legacy path entries and move {app}\bin to the front.
  Exec(
    'powershell.exe',
    '-ExecutionPolicy Bypass -WindowStyle Hidden -Command "' +
      '$target=''' + PathToAdd + '''; ' +
      '$legacy=''' + LegacyPathToRemove + '''; ' +
      '$currentPath=[Environment]::GetEnvironmentVariable(''Path'',''Machine''); ' +
      '$entries=@(); if($currentPath){$entries=$currentPath -split '';'' | Where-Object { $_ -and $_.Trim() -ne '''' }}; ' +
      '$entries=$entries | Where-Object { $_ -ne $target -and $_ -ne $legacy }; ' +
      '$newPath=$target; if($entries.Count -gt 0){$newPath=$target + '';'' + ($entries -join '';'')}; ' +
      '[Environment]::SetEnvironmentVariable(''Path'', $newPath, ''Machine'');"',
    '',
    SW_HIDE,
    ewWaitUntilTerminated,
    ResultCode
  );
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
      AddToSystemPath(ExpandConstant('{app}\bin'), ExpandConstant('{app}'));
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
  FreeMB: Cardinal;
  TotalMB: Cardinal;
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
    if GetSpaceOnDisk(ExpandConstant('{sd}'), True, FreeMB, TotalMB) then
    begin
      if FreeMB < 100 then
      begin
        MsgBox('Insufficient disk space. At least 100 MB of free space is required.', mbError, MB_OK);
        Result := False;
      end;
    end;
  end;
end;

function PrepareToInstall(var NeedsRestart: Boolean): String;
var
  ExistingPath: String;
begin
  Result := '';
  NeedsRestart := False;

  ExistingPath := '';
  TryReadExistingInstallPath(ExistingPath);

  // Always clean stale Levython PATH entries first to avoid command conflicts.
  CleanupLegacyLevythonPath(ExistingPath);

  // If a previous Levython install exists, uninstall it before continuing.
  if not RunPreviousUninstaller then
  begin
    Result :=
      'Failed to uninstall the previous Levython version automatically.' + #13#10#13#10 +
      'Close any running levython.exe processes and run this installer again as Administrator.';
    Exit;
  end;

  CleanupLegacyLevythonPath(ExistingPath);
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
begin
  if CurUninstallStep = usPostUninstall then
  begin
    // Final cleanup
    MsgBox('{#MyAppName} has been successfully removed from your computer.' + #13#10#13#10 +
           'Thank you for using {#MyAppName}!' + #13#10#13#10 +
           'Motto: {#MyAppMotto}', mbInformation, MB_OK);
  end;
end;

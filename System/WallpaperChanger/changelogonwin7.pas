unit ChangeLogonWin7;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, windirs,windows, registry,FileUtil;

var
  F: file of byte;
  Wow64FsEnableRedirection: LongBool;
 Function Wow64DisableWow64FsRedirection(Var Wow64FsEnableRedirection: LongBool): LongBool; StdCall;
  External 'Kernel32.dll' Name 'Wow64DisableWow64FsRedirection';
Function Wow64EnableWow64FsRedirection(Wow64FsEnableRedirection: LongBool): LongBool; StdCall;
  External 'Kernel32.dll' Name 'Wow64EnableWow64FsRedirection';
procedure ChangeLogon(imgPath: string);
procedure DefaultLogon;

implementation




procedure ChangeLogon(imgPath: string);
var

  Reg: TRegistry;
  windir: string;

begin
  Reg := TRegistry.Create(KEY_WRITE or KEY_WOW64_64KEY);
  try

    if not (FileExists(imgPath)) then
    begin
      WriteLn('File Not Found');
      Exit;
    end;
    Assign(F, imgPath);
    Reset(F);
    if (FileSize(F) > 256000) then
    begin
      WriteLn('File Bigger then 256 KB try another');
     Exit;
    end;
    Close(f);
    windir := (windirs.GetWindowsSpecialDir(windirs.CSIDL_WINDOWS, False));



      if not DirectoryExists(windir+'System32\oobe\info\backgrounds') then
      if not ForceDirectories(windir+'System32\oobe\info\backgrounds') then
      begin
        Writeln('Failed to create directory !');
        exit;
      end ;
       Writeln('Directory Created ');

       if not CopyFile(imgPath,windir+'System32\oobe\info\backgrounds\backgroundDefault.jpg',[cffOverwriteFile])then
             begin
               Writeln('Failed to copy the file !');
        exit;
             end;
             Writeln('File Created ');

     if not( Reg.OpenKey('\SOFTWARE\Microsoft\Windows\CurrentVersion\Authentication\LogonUI\Background',true) )  then
         Begin

                 Writeln('Failed to open the registry !');
                   exit;

         end;



     Reg.WriteInteger('OEMBackground',1);
           Writeln('registry data  Created ');

  finally
    Reg.Free;
  end;
end;

procedure DefaultLogon;
var
  Reg: TRegistry;
begin
  Reg := TRegistry.Create(KEY_WRITE or KEY_WOW64_64KEY);
  try

    Reg.RootKey := HKEY_LOCAL_MACHINE;
  //  Write('Checking... HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Authentication\LogonUI\Background');
    if (Reg.OpenKey(
      '\SOFTWARE\Microsoft\Windows\CurrentVersion\Authentication\LogonUI\Background', True))
    then
      Reg.WriteInteger('OEMBackground', 0);

  finally
    Reg.Free;

  end;

end;

 initialization
    Wow64DisableWow64FsRedirection(Wow64FsEnableRedirection) ;
  finalization
    Wow64EnableWow64FsRedirection(Wow64FsEnableRedirection);

end.

















program clwc;

{$mode objfpc}{$H+}

uses {$IFDEF UNIX} {$IFDEF UseCThreads}
  cthreads, {$ENDIF} {$ENDIF}
  Classes,
  SysUtils,
  CustApp,
  strutils,
  character,
  ChangeLogonWin7,
  ChangeWallpaper { you can add units after this };

type

  { TCmmandLineWallpaperChanger }

  TCmmandLineWallpaperChanger = class(TCustomApplication)
  protected
    procedure DoRun; override;
  public
    constructor Create(TheOwner: TComponent); override;
    destructor Destroy; override;
    procedure WriteHelp; virtual;
    procedure pChangeLogonWin7; virtual;
    procedure pChangeWallpaperWin; virtual;

  end;

  { TCmmandLineWallpaperChanger }

  procedure TCmmandLineWallpaperChanger.DoRun;
  var
    ErrorMsg: string;


  begin
    // quick check parameters
  {ErrorMsg:=CheckOptions('h', 'help');
  if ErrorMsg<>'' then begin
    ShowException(Exception.Create(ErrorMsg));
    Terminate;
    Exit;
  end;  }
       if(GetParamCount=0)then
       begin
        WriteHelp;

        Terminate;
        exit;
       end;





    // parse parameters
    if HasOption('h', 'help') then
    begin
      WriteHelp;
      Terminate;
      Exit;
    end;

    pChangeLogonWin7;
    pChangeWallpaperWin ;














    Terminate;
  end;

  constructor TCmmandLineWallpaperChanger.Create(TheOwner: TComponent);
  begin
    inherited Create(TheOwner);
    StopOnException := True;

  end;

  destructor TCmmandLineWallpaperChanger.Destroy;
  begin
    inherited Destroy;
  end;

  procedure TCmmandLineWallpaperChanger.WriteHelp;
  begin
    WriteLn('CommandLine Wallpaper Changer v 0.1 Alpha');
    WriteLn('Copyright Mahdi Jouini (github.com/mahdix18) 2018 under the do What The Fuck you want to Public License (WTFPL)');
    writeln('Usage: ', ExeName, ' -h');
    writeln('-l [imagePath]',' Change Windows 7 Logon Image, Must be under 256 KB');
    writeln('-w [imagePath]',' Change Wallpaper');
    writeln('-s [Style]',' Wallpaper Style (Tile, Center, Stretch, Fit, Fill, XY)');
    writeln('-x [pos]','Set X ');
    writeln('-y [pos]','Set Y ');
  end;
  procedure TCmmandLineWallpaperChanger.pChangeLogonWin7;
  begin
      if HasOption('l', 'logon') then
    begin
      Wow64DisableWow64FsRedirection(ChangeLogonWin7.Wow64FsEnableRedirection);
      ChangeLogon(GetOptionValue('l', 'logon'));
      Wow64EnableWow64FsRedirection(Wow64FsEnableRedirection);
    end;
      end;
    procedure TCmmandLineWallpaperChanger.pChangeWallpaperWin;
    var   x, y: integer;
    wstyle: WallpaperStyle;
    styles: array[0..5] of string = ('tile', 'center', 'stretch', 'fit', 'fill', 'xy');
    path:string;
  begin
    wstyle := WallpaperStyle.Stretch;

       if HasOption('s', 'style') then
       begin
         Writeln('Setting Up ...');

         if (AnsiIndexStr(GetOptionValue('s', 'style'),styles) <> -1) then
           wstyle := WallpaperStyle(AnsiIndexStr(GetOptionValue('s', 'style'),styles))
         else
         if (IsNumber( GetOptionValue('s', 'style'){%H-},1)) then
           if (StrToInt(GetOptionValue('s', 'style')) in [0..5]) then
             wstyle := WallpaperStyle(StrToInt(GetOptionValue('s', 'style')))
           else
             wstyle := WallpaperStyle.Stretch;
       end;

       x := 0;
       y := 0;
       if HasOption('x', 'left') then
       begin
         x := StrToInt(GetOptionValue('x', 'left'));
       end;

       if HasOption('y', 'top') then
       begin
         y := StrToInt(GetOptionValue('y', 'top'));
       end;




       if HasOption('w', 'wall') then

       path :=   GetOptionValue('w', 'wall')
       else
       path:='';


         WriteLn(path);
         WriteLn(wstyle);
         WriteLn(x);
         WriteLn(y);

         SetWallpaperExt( path
           ,
           wstyle,
           x, y);

  end;




var
  Application: TCmmandLineWallpaperChanger;
begin
  Application := TCmmandLineWallpaperChanger.Create(nil);
  Application.Title := 'CLWC';
  Application.Run;
  Application.Free;
end.

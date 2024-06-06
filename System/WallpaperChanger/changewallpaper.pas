unit ChangeWallpaper;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Windows, registry;

type
   WallpaperStyle = (Tile, Center, Stretch, Fit, Fill, XY);

procedure SetWallpaperExt(sWallpaperBMPPath: string; style: WallpaperStyle;
  X: integer = 0; Y: integer = 0);

implementation

procedure writeKeyValue(key, Value: string);
var
  reg: TRegIniFile;
  s1: integer;
  X, Y: integer;
begin
  reg := TRegIniFile.Create(KEY_WRITE or KEY_WOW64_64KEY);
  reg.OpenKey('Control Panel\Desktop', True);
  reg.WriteString('', key, Value);
  reg.Free;
end;

procedure SetWallpaperExt(sWallpaperBMPPath: string; style: WallpaperStyle;
  X: integer = 0; Y: integer = 0);

begin



  if(sWallpaperBMPPath<>'') then
     writeKeyValue('Wallpaper', sWallpaperBMPPath);

     // writeKeyValue('WallpaperOriginX', 0);
    //  writeKeyValue('WallpaperOriginY', 0);





  case style of
    WallpaperStyle.Tile:
    begin
      writeKeyValue('WallpaperStyle', '0');
      writeKeyValue('TileWallpaper', '1');
    end;
    WallpaperStyle.Center:
    begin
      writeKeyValue('WallpaperStyle', '0');
      writeKeyValue('TileWallpaper', '0');
    end;
    WallpaperStyle.Stretch:
    begin
      writeKeyValue('WallpaperStyle', '2');
      writeKeyValue('TileWallpaper', '0');
    end;
    WallpaperStyle.Fit:
    begin
      writeKeyValue('WallpaperStyle', '6');
      writeKeyValue('TileWallpaper', '0');
    end;
    WallpaperStyle.Fill:
    begin
      writeKeyValue('WallpaperStyle', '10');
      writeKeyValue('TileWallpaper', '0');
    end;
    WallpaperStyle.XY:
    begin
    //  writeKeyValue('WallpaperStyle', '0');
     // writeKeyValue('TileWallpaper', '2');

    end;
  end;
      writeKeyValue('WallpaperOriginX', IntToStr(x));
      writeKeyValue('WallpaperOriginY', IntToStr(Y));




















  // let everyone know that we
  // changed a system parameter

  SystemParametersInfo(
    SPI_SETDESKWALLPAPER,
    0,
    nil,
    SPIF_SENDWININICHANGE);
end;

end.

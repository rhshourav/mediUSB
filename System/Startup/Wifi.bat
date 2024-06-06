@echo off

title= ---- Connection Wifi ----
::::::::::::::::::::::::::::::::::::::
:: By AAA3A on @GBAtemp and Discord ::
::::::::::::::::::::::::::::::::::::::
setlocal enabledelayedexpansion enableextensions
:: If this variable is set to Y (instead of N), you will enter generation mode. The wifi will not be connected and the .xml will be created or recreated with the information of your wifi network that you have entered.
set generation=N
:: Variable to fill in with the name of your wifi network to connect to after importing the settings. If it is not for the generation, you do not have to fill this variable. Be aware that the name of your wifi network is displayed in the .xml and not encrypted.
set WIFI_NAME=
:: Variable to be filled with the password of your wifi. If it is not for the generation, you do not have to fill this variable. Be aware that your password is displayed in the .xml and not encrypted.
set WIFI_PASSWORD=
for %%D in ( Z Y X W V U T S R Q P O N M L K J I H G F E D C B A ) do (
	If exist "%%D:\System\" (
		set LETTER=%%D
		If %generation%==Y goto generation
		goto connection
	)
)
exit

:generation
If exist "%LETTER%:\System\Wifi.xml" del /Q /S /F "%LETTER%:\System\Wifi.xml"
echo ^<^?^xml version="1.0"^?^>^ >> "%LETTER%:\System\Wifi.xml"
echo ^<^WLANProfile xmlns="http://www.microsoft.com/networking/WLAN/profile/v1"^>^ >> "%LETTER%:\System\Wifi.xml"
echo 	^<^name^>^%WIFI_NAME%^<^/name^>^ >> "%LETTER%:\System\Wifi.xml"
echo 	^<^SSIDConfig^>^ >> "%LETTER%:\System\Wifi.xml"
echo 		^<^SSID^>^ >> "%LETTER%:\System\Wifi.xml"
echo 			^<^name^>^%WIFI_NAME%^<^/name^>^ >> "%LETTER%:\System\Wifi.xml"
echo 		^<^/SSID^>^ >> "%LETTER%:\System\Wifi.xml"
echo 	^<^/SSIDConfig^>^ >> "%LETTER%:\System\Wifi.xml"
echo 	^<^connectionType^>^ESS^<^/connectionType^>^ >> "%LETTER%:\System\Wifi.xml"
echo 	^<^connectionMode^>^auto^<^/connectionMode^>^ >> "%LETTER%:\System\Wifi.xml"
echo 	^<^MSM^>^ >> "%LETTER%:\System\Wifi.xml"
echo 		^<^security^>^ >> "%LETTER%:\System\Wifi.xml"
echo 			^<^authEncryption^>^ >> "%LETTER%:\System\Wifi.xml"
echo 				^<^authentication^>^WPA2PSK^<^/authentication^>^ >> "%LETTER%:\System\Wifi.xml"
echo 				^<^encryption^>^AES^<^/encryption^>^ >> "%LETTER%:\System\Wifi.xml"
echo 				^<^useOneX^>^false^<^/useOneX^>^ >> "%LETTER%:\System\Wifi.xml"
echo 			^<^/authEncryption^>^ >> "%LETTER%:\System\Wifi.xml"
echo 			^<^sharedKey^>^ >> "%LETTER%:\System\Wifi.xml"
echo 				^<^keyType^>^passPhrase^<^/keyType^>^ >> "%LETTER%:\System\Wifi.xml"
echo 				^<^protected^>^false^<^/protected^>^ >> "%LETTER%:\System\Wifi.xml"
echo 				^<^keyMaterial^>^%WIFI_PASSWORD%^<^/keyMaterial^>^ >> "%LETTER%:\System\Wifi.xml"
echo 			^<^/sharedKey^>^ >> "%LETTER%:\System\Wifi.xml"
echo 		^<^/security^>^ >> "%LETTER%:\System\Wifi.xml"
echo 	^<^/MSM^>^ >> "%LETTER%:\System\Wifi.xml"
echo 	^<^MacRandomization xmlns="http://www.microsoft.com/networking/WLAN/profile/v3"^>^ >> "%LETTER%:\System\Wifi.xml"
echo 		^<^enableRandomization^>^false^<^/enableRandomization^>^ >> "%LETTER%:\System\Wifi.xml"
echo 		^<^randomizationSeed^>^3216620153^<^/randomizationSeed^>^ >> "%LETTER%:\System\Wifi.xml"
echo 	^<^/MacRandomization^>^ >> "%LETTER%:\System\Wifi.xml"
echo ^<^/WLANProfile^>^ >> "%LETTER%:\System\Wifi.xml"
If %ERRORLEVEL%==0 (
	echo The XML file containing your wifi network information has been saved to the following path: "%LETTER%:\System\Wifi.xml". By deactivating the generation mode, you will be able to connect automatically to this network.
) else (
	echo There was a problem when creating the XML file containing your wifi network information. There may be errors in the file "%LETTER%:\System\Wifi.xml" or it simply has not been created.
)
pause
exit

::timeout 10 /nobreak
::WAIT 10000

:connection
cd /D "%LETTER%:\System\"

If exist "%LETTER%:\System\Wifi.xml" (
	netsh wlan add profile filename="%LETTER%:\System\Wifi.xml"
)
exit
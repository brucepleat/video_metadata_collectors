@Echo Off
Goto :Loop

:StartLoop
Cls
Echo Testing for 15s from %date% %time% whether quota has been reset...
"C:\Program Files\Filebot\filebot" -get-subtitles -r "d:/Movies/_Concerts/" -non-strict --lang es --output srt --encoding utf-8 --log warning > "%temp%\filebot.err"
for /F "usebackq" %%E in (`type "%temp%\filebot.err"`) do If "%%E" == "0" (Goto :Loop) Else (Goto :ExitLoop)

:Loop
For /D %%D in (D:\Movies\*.*) do ( For %%L in ( en eng it ita es spa heb ) do (
Echo.& Echo.& Time /T
Echo %%~nxD %%L & echo ==== ====
"C:\Program Files\Filebot\filebot" -get-subtitles -r d:/Movies/%%~nxD/ -non-strict --lang %%L --output srt --encoding utf-8 --log warning
REM If Not "%ERRORLEVEL%" == "0" Goto :ExitLoop
) )
REM cls
REM _Tools\Copy_D_to_PZ.bat

:: Cls
:: Echo Copying to ensure sync...
:: For %D in (P S E) do (cls & Robo D:\Movies %D:\Movies)
Goto :EOF

:ExitLoop
Cls
Echo Sleeping for 15 minutes...
Sleep 15m
Goto :StartLoop

:EOF
:: #
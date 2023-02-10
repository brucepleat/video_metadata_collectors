@Echo Off
For /R %%A in (*.mkv *.avi *.mp4 *.mpg *.m4v) do (
  If Not Exist "%%~dpnA.srt" ( 
    Echo %%~dpnA
    If "%%~xA"==".avi" ( subliminal download -l en "%%~nA" & If Exist "%%~nA*.srt" move "%%~nA*.srt" "%%~dpA" ) >Nul: 2>Nul:
    If "%%~xA"==".mkv" ( subliminal download -l en "%%~nA" & If Exist "%%~nA*.srt" move "%%~nA*.srt" "%%~dpA" ) >Nul: 2>Nul:
    If "%%~xA"==".mp4" ( subliminal download -l en "%%~nA" & If Exist "%%~nA*.srt" move "%%~nA*.srt" "%%~dpA" ) >Nul: 2>Nul:
    If "%%~xA"==".mpg" ( subliminal download -l en "%%~nA" & If Exist "%%~nA*.srt" move "%%~nA*.srt" "%%~dpA" ) >Nul: 2>Nul:
    If "%%~xA"==".m4v" ( subliminal download -l en "%%~nA" & If Exist "%%~nA*.srt" move "%%~nA*.srt" "%%~dpA" ) >Nul: 2>Nul:
  )
)
:Done
Goto :Done2

@Echo Off
REM https://github.com/Diaoul/subliminal
For /R %%A in (*.mkv *.avi *.mp4 *.mpg *.m4v) do (
  If Not Exist "%%~dpnA.srt" ( 
    Echo %%~dpnA
    ( subliminal download -l en "%%~nA" & If Exist "%%~nA*.srt" move "%%~nA*.srt" "%%~dpA" ) >Nul: 2>Nul:
  )
)
:Done2


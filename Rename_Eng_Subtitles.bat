@Echo Off

For /R %%Z In ( *.mp4 *.avi *.mkv ) do (
  If exist "%%~dpnZ.en.srt" If Not exist "%%~dpnZ.eng.srt" Ren "%%~dpnZ.en.srt" "%%~nZ.eng.srt" & echo Renamed: %%~nZ
  If exist "%%~dpnZ.srt"    If not exist "%%~dpnZ.eng.srt" Ren "%%~dpnZ.srt"    "%%~nZ.eng.srt" & echo Renamed: %%~nZ
)

::

@Echo Off

Call DirTotal
For /R %%Z In ( *.mp4 *.avi *.mkv ) do (
  If exist "%%~dpnZ.eng.srt" If exist "%%~dpnZ.srt"    Del "%%~dpnZ.srt"
  If exist "%%~dpnZ.eng.srt" If exist "%%~dpnZ.en.srt" Del "%%~dpnZ.en.srt"
)
Call DirTotal

::

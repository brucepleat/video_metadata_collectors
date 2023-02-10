@Echo Off

If "%*" == "" (
Set _P=%CD%
) Else (
Set _P=%*
)
Echo Path: %_P%

Dir *.srt /a-d/b/s|wc -l
:: Removed heb
For %%L in ( en eng it ita es spa ) do (
:Repeat
Echo.& Echo.& Time /T
Echo        %%L & echo ==== ====
"C:\Program Files\Filebot\filebot" -get-subtitles -r "%_P%" -non-strict --lang %%L --log warning -no-probe -no-xattr

:: Check for Filebot limit, pause if at it...
Set _C24=
"C:\Program Files\Filebot\filebot" -script fn:osdb.stats | tee "%temp%\Filebot_Stats.dat"  | grep "client_24h_download_count" | cut -d " " -f 3 > "%temp%\Filebot_Count.dat"
Echo Filebot quota:
Cat "%temp%\Filebot_Count.dat"
for /f "usebackq delims=" %%A in ( "%temp%\Filebot_Count.dat" ) do set "_C24=%%A"
If "%_C24%" GEQ "999" (
  Echo At Filebot Limit, sleeping for 15mins from...
  Date /T & Time /T
  Echo ...and then repeating last command - but you should consider aborting...
  Dir *.srt /a-d/b/s|wc -l
  Sleep 15m
  Goto :Repeat
) Else (
  Echo %_C24% in last 24 hours, so continuing...
	)

)
Dir *.srt /a-d/b/s|wc -l

Set _P=
:: "C:\Program Files\Filebot\filebot" -get-subtitles -r "%_P%" -non-strict --lang %%L --output srt --encoding utf-8 --log warning

:: Advised to remove "--output srt"

@Echo Off

:: Check for Filebot limit, pause if at it...
Set _C24=
Date /T & Time /T
"C:\Program Files\Filebot\filebot" -script fn:osdb.stats | tee "%temp%\Filebot_Stats.dat"  | grep "client_24h_download_count" | cut -d " " -f 3 > "%temp%\Filebot_Count.dat"
Echo Filebot quota:
Cat "%temp%\Filebot_Count.dat"
for /f "usebackq delims=" %%A in ( "%temp%\Filebot_Count.dat" ) do set "_C24=%%A"
If "%_C24%" GEQ "999" (
  Echo At Filebot Limit
) Else (
  Echo %_C24% in last 24 hours, so continuing...
	)

)

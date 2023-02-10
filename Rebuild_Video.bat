@Echo Off
Cls
I:
Goto :OnlySubtitles
For %%F in (Movies "TV series" "Latest Movies" "Latest TV series" _TooBigToDropbox) do (
    Cd /D "\%%~F"
    Del *.txt /f/q/s/a >Nul: 2>Nul:
    Start IMDB_Fetch
    Start Call TV_Fetch
)
Cd \
Echo Wait until all ten windows are completed, then...
Pause
For %%F in (Movies "TV series" "Latest Movies" "Latest TV series" _TooBigToDropbox) do (
    Cd /D "\%%~F"
    Del *.gif *.jpg *.png /f/q/s/a >Nul: 2>Nul:
    Start Text2Pic
)
Cd \
Echo Wait until all ten windows are completed, then...
Echo Check Filebot, then...
Pause
:OnlySubtitles
:: For %%F in (Movies "TV series" "Latest Movies" "Latest TV series" _TooBigToDropbox) do ()
For %%F in (_TooBigToDropbox) do (
    Cd /D "\%%~F"
    Echo Before:
    Dir *.srt /a-d/b/s|wc -l
    Call Get_Subtitles
    Echo After:
    Dir *.srt /a-d/b/s|wc -l
)
Cd \

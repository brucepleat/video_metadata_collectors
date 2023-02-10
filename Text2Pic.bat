@Echo Off
setlocal EnableDelayedExpansion

Set _P=C:\Program Files\ImageMagick-7.1.0-Q16-HDRI

:: Cleanup in testing
If "%1" EQU "/D" Del /s *.jpg *.gif *.png >Nul: 2>Nul:
If "%1" EQU "/d" Del /s *.jpg *.gif *.png >Nul: 2>Nul:
dir /b/s *.jpg *.gif *.png 2>Nul: | Wc -l >Nul:


For /R %%F in (*.txt) do (
    Echo == "%%~dpnF.txt" ==
    If exist "%%~dpnF.txt" ( 
        Echo Exist1 "%%~dpnF.txt" >Nul:
        Echo Exist2 "%%~dpnF.txt" >Nul:
        For %%X in (gif jpg png) do (
            Echo Considering "%%~dpnF.%%X" >Nul:
            If Not Exist "%%~dpnF.%%X" (
                Echo Creating "%%~dpnF.%%X" >Nul:
                type "%%~dpnF.txt" | "%_P%\magick.exe" -font Courier-New -pointsize 64 label:"@-" "%%~dpnF.%%X"
            )
        )
        Echo Exist3 "%%~dpnF.txt" >Nul:
        set smallestSize=9999999999
        for %%X in ("%%~dpnF.gif" "%%~dpnF.jpg" "%%~dpnF.png") do (        
            set size=%%~zX
            echo Ck %%X !size! >Nul:
            if !size! lss !smallestSize! (
                echo !size! lss !smallestSize! >Nul:
                set smallestSize=!size!
                echo smallestSize=!smallestsize! >Nul:
                set smallestName=%%~X
                echo smallestName=!smallestName! >Nul:
            ) Else (
                echo NOT !size! lss !smallestSize! >Nul:
                Echo Delete %%~X >Nul:
        
            )
            echo. >Nul:
        )
        for %%D in ("%%~dpnF.gif" "%%~dpnF.jpg" "%%~dpnF.png") do (
            if "%%~D" neq "!smallestName!" (
                del "%%~D"
            )
        )

    )
)
dir /b/s *.jpg *.gif *.png 2>Nul: | Wc -l >Nul:

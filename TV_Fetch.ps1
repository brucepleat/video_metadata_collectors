function Get-TVMazeMatch
{
    <#
    .Synopsis
       Retrieves information about a TV show from TVMaze.
    .DESCRIPTION
       This cmdlet fetches information about the TV show matching the specified filename.
    .EXAMPLE
        Get-TVMazeMatch -Title 'Battlestar Galactica - S01E04.mkv'
        Get-TVMazeMatch -Title 'WKRP in Cincinatti - S01E01 Pilot.avi'
    .PARAMETER Title
       Specify the name and episode number of the TV show you want get. Format examples:
    #>

 
    [cmdletbinding()]
    param
    (
        [Parameter(
            Mandatory=$True, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
            [Alias('Name')]
            [string[]] $Title)
 
    BEGIN { }
 
    PROCESS {

        foreach ($MediaTitle in $Title) {
            $EpFilename = $MediaTitle
#            If ( $EpFilename.Split("-").Count -gt 1 ) { 
    #Test
    #            $EpFilename = "Hanna - S02E05.mkv"

    #### TODO
                #$EpSeasonEpisode = $EpFilename.Split("-")[1].Trim().Substring(0,6)
    # Line gets confused if there is a second dash in the filename
    # Need to somehow find substring of " S??E?? " and work on that instead
                $EpFilename -match " [Ss][0-9][0-9][Ee][0-9][0-9] "
                Try {
                    $EpSeasonEpisode = $Matches[0]
                    $EpSeasonEpisode = $EpSeasonEpisode.Trim()
        #### TODO: 
        #Parse passed Title into Show Name and Episode Number
                    #$EpTitle = $EpFilename.Split("-")[0].Trim()
        #            write-host $EpTitle
                    $EpFilename -match " [Ss][0-9][0-9][Ee][0-9][0-9]"
                    $EpSeasonEpisode = $Matches[0]
                    $EpSeasonEpisode = $EpSeasonEpisode.Trim()
                    $EpTitle = $EpFilename.substring(0,$EpFilename.IndexOf($EpSeasonEpisode)).Trim()

                    If ( $EpTitle  -match '-$') {
                        $EpTitle = $EpTitle.Substring(0,$EpTitle.Length-1)
                    }
                    $EpTitle = $EpTitle.Trim()

        #Parse Episode Info
                    $Season  = $EpSeasonEpisode.Substring(1,2)
                    $Episode = $EpSeasonEpisode.Substring(4,2)

        #Download Show Info
                    $ShowURI = "https://api.tvmaze.com/search/shows?q=$($EpTitle -replace " ","+")"
                    #write-host $ShowURI
                
                    Try {
                        $ShowRes = Invoke-WebRequest -Uri $ShowURI -UseBasicParsing 

            #Parse Show Info to get Show ID
                        #Assume first result is best result
                        $ShowJSON = $ShowRes[0] | ConvertFrom-Json 

            #TODO:
            # IF $ShowJSON.Count = 0 then nothing returned!

                        #$ShowCSV = $ShowJSON[0] | ConvertTo-Csv
                        $ShowCSV = $ShowJSON | ConvertTo-Csv -NoTypeInformation
                        $ShowInfo = $ShowCSV[1]
                        #$URL = $ShowInfo.Split(" ")[1].Split("=")[1].Split(";")[0]

                        $ShowInfo = $ShowInfo.Split("{")[1].Split("}")[0]

            ## Do I care about anything other than ID yet?
            #Parse Show Info
                        $ID      = $ShowInfo.Split(";")[0].Trim().Split("=")[1]
                        $URL     = $ShowInfo.Split(";")[1].Trim().Split("=")[1]
                        $Name    = $ShowInfo.Split(";")[2].Trim().Split("=")[1]
                        $Type    = $ShowInfo.Split(";")[3].Trim().Split("=")[1]
                        $Lang    = $ShowInfo.Split(";")[4].Trim().Split("=")[1]
                        $Genres  = $ShowInfo.Split(";")[5].Trim().Split("=")[1]
                        $Status  = $ShowInfo.Split(";")[6].Trim().Split("=")[1]
                        $RunTime = $ShowInfo.Split(";")[7].Trim().Split("=")[1]
                        $AvgRunT = $ShowInfo.Split(";")[8].Trim().Split("=")[1]
                        $Debut   = $ShowInfo.Split(";")[9].Trim().Split("=")[1]
                        $Ended   = $ShowInfo.Split(";")[10].Trim().Split("=")[1]
                        $IMDB    = $ShowInfo.Split(";")[11].Trim().Split("=")[1]
                        $Summary = $ShowInfo.Split(";")[20].Trim().Split("=")[1].Replace("<p>","").Replace("</p>","").Replace("<b>","").Replace("</b>","").Replace("<i>","").Replace("</i>","").Replace("<u>","").Replace("</u>","")

            #Download Episode Info
                    Try {
                            $EpURI = "https://api.tvmaze.com/shows/$ID/episodebynumber?season=$Season&number=$Episode"

                            #write-host $EpURI
                            $EpRes = Invoke-WebRequest -Uri $EpURI -UseBasicParsing 

                            $EpJSON = $EpRes[0] | ConvertFrom-Json 
                            $EpCSV = $EpJSON[0] | ConvertTo-Csv
                            $EpPrep = $EpJSON | ConvertTo-Csv -NoTypeInformation

                            $EpInfo = ConvertFrom-csv $EpPrep -Delimiter ","
                            $EpInfo = $EpInfo[0]
                            #$URL = $ShowInfo.Split(" ")[1].Split("=")[1].Split(";")[0]
            
                            #$EpInfo = $EpPrep.Split("{")[1].Split("}")[0]
                            #write-host $EpInfo
            
                            $EpID      = $EpInfo.ID      
                            $EpURL     = $EpInfo.URL     
                            $EpName    = $EpInfo.Name    
                            $EpSeason  = $EpInfo.Season  
                            $EpNumber  = $EpInfo.Number  
                            $EpType    = $EpInfo.Type    
                            $EpAirDate = $EpInfo.AirDate 
                            $EpRunTime = $EpInfo.RunTime 
                            $EpSummary = $EpInfo.Summary.Replace("<p>","").Replace("</p>","").Replace("<b>","").Replace("</b>","").Replace("<i>","").Replace("</i>","").Replace("<u>","").Replace("</u>","")
                            If ( $EpInfo.Image.Length -gt 0 ) {
                                $EpImage   = $EpInfo.Image.Split("{")[1].Split("}")[0]
                                $EpImage  = $EpImage.Split(";")[1].Trim().Split("=")[1]
                            } Else { $EpImage = "" }
                            #$EpLinks   = $EpInfo.Links   

                            <#
                            write-host $EpID
                            write-host $EpURL
                            write-host $EpName
                            write-host $EpSeason
                            write-host $EpNumber
                            write-host $EpType
                            write-host $EpAirdate
                            write-host $EpRunTime
                            write-host $EpImage
                            write-host $EpSummary
                            write-host $EpLinks
                            #>

 
                            <#
                            $returnObject = New-Object System.Object
                            $returnObject | Add-Member -Type NoteProperty -Name "Show Name"         -Value $Name
                            $returnObject | Add-Member -Type NoteProperty -Name "Episode Name"      -Value $EpName
                            $returnObject | Add-Member -Type NoteProperty -Name "Episode Season"    -Value $EpSeason
                            $returnObject | Add-Member -Type NoteProperty -Name "Episode Number"    -Value $EpNumber
                            If ($EpSummary.Length -gt 0 ) { $returnObject | Add-Member -Type NoteProperty -Name "Episode Summary"   -Value $EpSummary }
                            If ($EpImage.Length   -gt 0 ) { $returnObject | Add-Member -Type NoteProperty -Name "Episode Image"     -Value $EpImage }
                            If ($EpAirDate.Length -gt 0 ) { $returnObject | Add-Member -Type NoteProperty -Name "Episode AirDate"   -Value $EpAirDate }
                            If ($EpRunTime.Length -gt 0 ) { $returnObject | Add-Member -Type NoteProperty -Name "Episode RunTime"   -Value $EpRunTime }
                            If ($EpID.Length      -gt 0 ) { $returnObject | Add-Member -Type NoteProperty -Name "Episode ID"        -Value $EpID }
                            If ($EpURL.Length     -gt 0 ) { $returnObject | Add-Member -Type NoteProperty -Name "Episode URL"       -Value $EpURL }
                            If ($EpType.Length    -gt 0 ) { $returnObject | Add-Member -Type NoteProperty -Name "Episode Type"      -Value $EpType }
                            #>

                            $returnObject = New-Object System.Object
                            If ($Name.Length      -gt 0 ) { $returnObject | Add-Member -Type NoteProperty -Name "Show"      -Value $Name      }
                            If ($EpName.Length    -gt 0 ) { $returnObject | Add-Member -Type NoteProperty -Name "Episode"   -Value $EpName    }
                            If ($EpSeason.Length  -gt 0 ) { $returnObject | Add-Member -Type NoteProperty -Name "Season"    -Value $EpSeason  }
                            If ($EpNumber.Length  -gt 0 ) { $returnObject | Add-Member -Type NoteProperty -Name "Number"    -Value $EpNumber  }
                            If ($EpSummary.Length -gt 0 ) { $returnObject | Add-Member -Type NoteProperty -Name "Summary"   -Value $EpSummary }
                            If ($EpAirDate.Length -gt 0 ) { $returnObject | Add-Member -Type NoteProperty -Name "AirDate"   -Value $EpAirDate }
                            If ($EpRunTime.Length -gt 0 ) { $returnObject | Add-Member -Type NoteProperty -Name "RunTime"   -Value $EpRunTime }



                            <#
                            If ($Debut.Length     -gt 0 ) { $returnObject | Add-Member -Type NoteProperty -Name "Show Debut"        -Value $Debut }
                            If ($Ended.Length     -gt 0 ) { $returnObject | Add-Member -Type NoteProperty -Name "Show Ended"        -Value $Ended }
                            If ($Type.Length      -gt 0 ) { $returnObject | Add-Member -Type NoteProperty -Name "Show Type"         -Value $Type }
                            If ($Lang.Length      -gt 0 ) { $returnObject | Add-Member -Type NoteProperty -Name "Show Language"     -Value $Lang }
                            If ($Status.Length    -gt 0 ) { $returnObject | Add-Member -Type NoteProperty -Name "Show Status"       -Value $Status }
                            If ($AvgRunT.Length   -gt 0 ) { $returnObject | Add-Member -Type NoteProperty -Name "Show Avg Runtime"  -Value $AvgRunT }
                            If ($ID.Length        -gt 0 ) { $returnObject | Add-Member -Type NoteProperty -Name "Show ID"           -Value $ID }
                            If ($URL.Length       -gt 0 ) { $returnObject | Add-Member -Type NoteProperty -Name "Show URL"          -Value $URL }
                            If ($IMDB.Length      -gt 0 ) { $returnObject | Add-Member -Type NoteProperty -Name "Show IMDB"         -Value $IMDB }
                            If ($Summary.Length   -gt 0 ) { $returnObject | Add-Member -Type NoteProperty -Name "Show Summary"      -Value $Summary }
                            #If ($Genres.Length    -gt 0 ) { $returnObject | Add-Member -Type NoteProperty -Name "Show Genres"       -Value $Genres }
                            If ($RunTime.Length   -gt 0 ) { $returnObject | Add-Member -Type NoteProperty -Name "Show RunTime"      -Value $RunTime }
                            #If ($EpLinks.Length   -gt 0 ) { $returnObject | Add-Member -Type NoteProperty -Name "Episode Links"     -Value $EpLinks }
                            #>

                            Write-Output $returnObject

                            <# 
                            Remove-Variable MediaTitle, EpFilename, EpTitle, EpSeasonEpisode, Season, Episode

                            Remove-Variable ShowRes, ShowJSON, ShowCSV, ShowInfo, ShowURI
                            Remove-Variable ID, URL, Name, Type, Lang, Genres, Status, RunTime, AvgRunT, Debut, Ended, IMDB, Summary

                            Remove-Variable EpRes, EpJSON, EpCSV, EpInfo, EpURI
                            Remove-Variable EpID, EpURL, EpName, EpSeason, EpNumber, EpType, EpAirDate, EpRunTime, EpSummary, EpImage
                            #>
                        }
                        catch {}
                    }
                    catch {}
                }
                catch {}
<#
            }
            catch {}
#>
        }
    }
 
    END { }
}




function _Unused
{
    <#
    param (
	    [Parameter(Mandatory=$true)][string]$title,
	    [Parameter(Mandatory=$true)][string]$year
    )
    #>

    $CodedP = $args[0]

    If($CodedP) {
        #Not empty - no change
    } Else {
        #Empty

    # 2021-09 Disable to prevent input
    #    $CodedP = Read-Host -Prompt 'Input path'
        If($CodedP) {
            #Not empty
            $CodedP = $CodedP
        } Else {
            #Empty
            $CodedP = $Pwd
        }
    }

    write-host 'Pwd = ' $Pwd

    write-host '==== Recursing through: ' $CodedP

    ForEach ($FN in Get-ChildItem -Recurse -Path $CodedP) {
    $F = $FN.Name
    $X = ""
    If ( $F.length -ge 5 ) { $X = $F.substring($F.length-4,4) }

    If ( ($X -eq ".mp4") -or ($X -eq ".mkv") -or ($X -eq ".avi") -or ($X -eq ".mpg") -or ($X -eq ".m4v") ) {
    <# write-host -NoNewLine 45 $F #>
    $P = $FN.directory

    $F = $F.substring(0,$F.length-4) <# Remove extension #>
    $Out = "$P\$F.txt"

    <# Checking whether file exists; if so, don't repeat the work #>
    <# 2021-09-19 Forcing writing for testing purposes #>
    <# If ( -not (Test-Path $Out -PathType Leaf) ) { #>

        write-output "=$F= to =$Out="

        <# Assume Year is last four digits and title is the rest#>
        $Year = $F.substring($F.length-4,4)
        $Title = $F.substring(0,$F.length-5)

    #write-host "Processing $Year $Title"
    #write-host -NoNewline
        (get-IMDBMatch -Title $Title | Where { $_.Released -eq $Year } | Where-Object { $_.Type -eq 'Movie'} | Get-IMDBItemXML ) > $Out
    #write-host -NoNewline
    #write-host "Processed $Year $Title"

        <# Changing "-eq 0" to "-lt 500" so under 500 is deleted #>
        If ( ( (Get-Item $Out).length) -lt 500 ) {
        <#    write-host -NoNewLine "Deleting Too-small-file: $Out" #>
            Remove-Item $Out
        }

        If ( ( (Get-Item $Out).length) -eq 0 ) {
            <#    write-host -NoNewLine "Deleting Too-small-file: $Out" #>
            Remove-Item $Out
        }
    <# } #>

    }

    }
    <#
    Derived from:
    https://www.reddit.com/r/PowerShell/comments/61kib6/query_imdb_for_movies_and_information/
    https://pastebin.com/5k3ad8TM

    Note:
	    Get-IMDBItemMatch is not altered (to the best of my knowledge)
	    Get-IMDBItemHTML is not altered (to the best of my knowledge)
	    Get-IMDBItemXML has been altered heavily


    Example: get-IMDBMatch -Title '$Title' | Where { $_.Released -eq '$Year' | Get-IMDBItemXML

    #>
}


function _Original
{

    $SrchJSON = $SrchRes[0] | ConvertFrom-Json 
    $SrchCSV = $SrchJSON[0] | ConvertTo-Csv
    $Prep = $SrchJSON | ConvertTo-Csv -NoTypeInformation
    $C = $Prep[1]
    $URL = $C.Split(" ")[1].Split("=")[1].Split(";")[0]

    $C = $C.Split("{")[1].Split("}")[0]

    <#
    id=28449
    url=https://www.tvmaze.com/shows/28449/hanna
    name=Hanna
    type=Scripted
    language=English
    genres=System.Object[]
    status=Running
    runtime=
    averageRuntime=50
    premiered=2019-02-03
    ended=
    officialSite=https://www.amazon.com/HANNA/dp/B07L4ZH37D
    schedule=
    rating=
    weight=99
    network=
    webChannel=
    dvdCountry=
    externals=
    image=
    summary=<p>In equal parts high-concept thriller and coming-of-age drama, <b>Hanna</b> follows the journey of an extraordinary youn
    g girl raised in the forest, as she evades the relentless pursuit of an off-book CIA agent and tries to unearth the truth behind w
    ho she is.</p>
    updated=1611425009
    _links=
    #>

    $ID      = $C.Split(";")[0].Trim().Split("=")[1]
    $URL     = $C.Split(";")[1].Trim().Split("=")[1]
    $Name    = $C.Split(";")[2].Trim().Split("=")[1]
    $Type    = $C.Split(";")[3].Trim().Split("=")[1]
    $Lang    = $C.Split(";")[4].Trim().Split("=")[1]
    #$Genres  = $C.Split(";")[5].Trim().Split("=")[1]
    $Status  = $C.Split(";")[6].Trim().Split("=")[1]
    $RunTime = $C.Split(";")[7].Trim().Split("=")[1]
    $AvgRunT = $C.Split(";")[8].Trim().Split("=")[1]
    $Debut   = $C.Split(";")[9].Trim().Split("=")[1]
    $Ended   = $C.Split(";")[10].Trim().Split("=")[1]
    $IMDB    = $C.Split(";")[11].Trim().Split("=")[1]
    $Summary = $C.Split(";")[20].Trim().Split("=")[1]

    <#
    write-host "ID         = $ID"
    write-host "URL        = $URL"
    write-host "Name       = $Name"
    write-host "Type       = $Type"
    write-host "Language   = $Lang"
    write-host "Status     = $Status"
    write-host "RunTime    = $RunTime"
    write-host "AvgRunTime = $AvgRunT"
    write-host "Debuted    = $Debut"
    write-host "Ended      = $Ended"
    write-host "IMDB       = $IMDB"
    write-host "Summary    = $Summary"
    #>

#    $EpFilename = "WKRP in Cincinatti - S02E05 Pilot.avi"
    $EpTitle = $EpFilename.Split("-")[0].Trim()
    write-host $EpTitle
    $EpSeasonEpisode = $EpFilename.Split("-")[1].Trim().Substring(0,6)
    write-host $EpSeasonEpisode

    $Season  = $EpSeasonEpisode.Substring(1,2)
    $Episode = $EpSeasonEpisode.Substring(4,2)
    write-host "Season  = $Season"
    write-host "Episode = $Episode"

    $EpRes = Invoke-WebRequest -Uri "https://api.tvmaze.com/shows/$ID/episodebynumber?season=$Season&number=$Episode" -UseBasicParsing 

    $EpJSON = $EpRes[0] | ConvertFrom-Json 
    $EpCSV = $EpJSON[0] | ConvertTo-Csv
    $EpPrep = $EpJSON | ConvertTo-Csv -NoTypeInformation
    #$EpC = $EpPrep[1]
    #$EpURL = $EpC.Split(" ")[1].Split("=")[1].Split(";")[0]

    ##$C = $C.Split(""",""")[1]
    #$EpC = $EpC.Split("{")[1].Split("}")[0]



}

#################
## Starts here ##
#################

$CodedP = $args[0]

If($CodedP) {
    #Not empty - no change
} Else {
    #Empty

# 2021-09 Disable to prevent input
    $CodedP = Read-Host -Prompt 'Input path'

    If($CodedP) {
        #Not empty
        $CodedP = $CodedP
    } Else {
        #Empty
        $CodedP = $Pwd
    }
}

write-host '==== Recursing through: ' $CodedP


ForEach ($FN in Get-ChildItem -Recurse -Path $CodedP) {
    $F = $FN.Name
    $X = ""
    If ( $F.length -ge 5 ) { $X = $F.substring($F.length-4,4) }

    If ( ($X -eq ".mp4") -or ($X -eq ".mkv") -or ($X -eq ".avi") -or ($X -eq ".mpg") -or ($X -eq ".m4v") ) {
        <# write-host -NoNewLine 45 $F #>
        $P = $FN.directory


        # For Movies
        $F = $F.substring(0,$F.length-4) <# Remove extension #>
        $Out = "$P\$F.txt"

        <# Checking whether file exists; if so, don't repeat the work #>
        <# 2021-09-19 Forcing writing for testing purposes #>
        #If ( -not (Test-Path $Out -PathType Leaf) ) {

            write-output "=$F= to =$Out="

            $Title = $F

            $Content = (get-TVMazeMatch -Title $Title )
            #If multiple parts returned, usually it's the last
            If ( $Content.Count -gt 0) { $Content = $Content[$Content.Count-1] }
                
            #Check that episode URL is long enough - proxy for good data
            If ($Content.Summary.Length -gt 5 ) {
                $Content > $Out

                #Check that written file is long enough to have real content
                Try {
                    If ( ( (Get-Item $Out).length) -lt 200 ) {
                        write-host -NoNewLine "==== Deleting Too-small-file: $Out"
                        Remove-Item $Out
                    }
                } Catch {}
            }
        #}

    }

}

<#
Derived from:
https://www.reddit.com/r/PowerShell/comments/61kib6/query_imdb_for_movies_and_information/
https://pastebin.com/5k3ad8TM

Note:
	Get-IMDBItemMatch is not altered (to the best of my knowledge)
	Get-IMDBItemHTML is not altered (to the best of my knowledge)
	Get-IMDBItemXML has been altered heavily


Example: get-IMDBMatch -Title '$Title' | Where { $_.Released -eq '$Year' | Get-IMDBItemXML

#>

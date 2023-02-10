Clear
            $EpFilename = "Hanna - S02E05.mkv"

#Parse passed Title into Show Name and Episode Number
            $EpTitle = $EpFilename.Split("-")[0].Trim()
#            write-host $EpTitle
            $EpSeasonEpisode = $EpFilename.Split("-")[1].Trim().Substring(0,6)
#            write-host $EpSeasonEpisode

#Parse Episode Info
            $Season  = $EpSeasonEpisode.Substring(1,2)
            $Episode = $EpSeasonEpisode.Substring(4,2)

#Download Show Info
            $ShowRes = Invoke-WebRequest -Uri "https://api.tvmaze.com/search/shows?q=$($EpTitle -replace " ","+")" -UseBasicParsing 

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
            $Summary = $ShowInfo.Split(";")[20].Trim().Split("=")[1]

#Download Episode Info
            $EpRes = Invoke-WebRequest -Uri "https://api.tvmaze.com/shows/$ID/episodebynumber?season=$Season&number=$Episode" -UseBasicParsing 

            $EpJSON = $EpRes[0] | ConvertFrom-Json 
            $EpCSV = $EpJSON[0] | ConvertTo-Csv
            $EpPrep = $EpJSON | ConvertTo-Csv -NoTypeInformation

            $EpInfo = ConvertFrom-csv $EpPrep -Delimiter ","
            $EpInfo = $EpInfo[0]
            #$URL = $ShowInfo.Split(" ")[1].Split("=")[1].Split(";")[0]
            
            #$EpInfo = $EpPrep.Split("{")[1].Split("}")[0]
#            write-host $EpInfo
            
            $EpID      = $EpInfo.ID      
            $EpURL     = $EpInfo.URL     
            $EpName    = $EpInfo.Name    
            $EpSeason  = $EpInfo.Season  
            $EpNumber  = $EpInfo.Number  
            $EpType    = $EpInfo.Type    
            $EpAirDate = $EpInfo.AirDate 
            $EpRunTime = $EpInfo.RunTime 
#            $EpLinks   = $EpInfo._Links   
            $EpImage   = $EpInfo.Image.Split("{")[1].Split("}")[0]
            $EpSummary = $EpInfo.Summary.Replace("<p>","").Replace("</p>","")
            
#            $EpImage   = $EpImage.Split("{")[1].Split("}")[0]
#            $EpImage1  = $EpImage.Split(";")[0].Trim().Split("=")[1]
            $EpImage  = $EpImage.Split(";")[1].Trim().Split("=")[1]

            write-host "Show Name        = $Name"
            write-host "Episode Season   = $EpSeason"
            write-host "Episode Number   = $EpNumber"
            write-host "Episode Name     = $EpName"
            write-host "Episode Type     = $EpType"
            write-host "Episode Air Date = $EpAirdate"
            write-host "Episode Run Time = $EpRunTime"
            write-host "Episode ID       = $EpID"
            write-host "Episode URL      = $EpURL"
            write-host "Episode Image    = $EpImage"
            write-host "Episode Summary  = $EpSummary"
#            write-host "Episode Links    = $EpLinks"



            write-host
            write-host

<#
#>
$EpFilename  = "MASH - S03E07.mkv"
$EpFilename  = "MASH S03E07.mkv"
$EpFilename  = "MASH - S03E07 Check-Up.mkv"
$EpFilename  = "MASH S03E07 Check-Up.mkv"

$EpFilename = "3rd Rock From the Sun - S01E01 Brains and Eggs.mkv"

$EpFilename -match " [Ss][0-9][0-9][Ee][0-9][0-9] "
$EpSeasonEpisode = $Matches[0]
$EpSeasonEpisode = $EpSeasonEpisode.Trim
$EpTitle = $EpFilename.substring(0,$EpFilename.IndexOf($EpSeasonEpisode)).Trim()



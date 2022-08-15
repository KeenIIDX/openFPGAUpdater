$CoreSource = "https://joshcampbell191.github.io/openfpga-cores-inventory/analogue-pocket"

function Get-MainCoreList {
    param (
        $url
    )

    return Invoke-WebRequest -Uri $url -UseBasicParsing -UserAgent "KeenIIDX"
}

function Parse-CoreList {
    param (
        $content
    )

    $coreUrls = $content.Links | Where-Object {$_.Href -match "^([^/]*/){4}[^/]*$"} | select -Property href | ForEach-Object {($_.href + "/releases").Replace("//github.com/", "//api.github.com/repos/")}

    return $coreUrls
}

try {
    # Grab central list of cores available.  Pluck out the links to their github repositories
    $cores = Get-MainCoreList -url $CoreSource
    $cores = Parse-CoreList -content $cores
} catch {
    Throw $_
}

# Grabbing each core.
Foreach ($link in $cores) {
    $Response = (Invoke-RestMethod -uri $link -UserAgent "KeenIIDX")[0]
    Foreach ($file in $Response.assets) {
        if ($file.browser_download_url -like "*.zip") {
            $downloadLink = $file.browser_download_url
            $fileName = $file.name
            $downloadPath = "$env:TEMP\$fileName"

            #Download the core.
            Invoke-WebRequest -Uri $downloadLink -OutFile $downloadPath

            #Unzip the core to here.
            Expand-Archive -Path $downloadPath -DestinationPath .\ -Force

            #Delete the downloaded file.
            Remove-Item -Path $downloadPath -Force
        }
    }
}
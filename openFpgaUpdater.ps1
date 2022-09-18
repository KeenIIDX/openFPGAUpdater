$CoreSource = "https://joshcampbell191.github.io/openfpga-cores-inventory/analogue-pocket"
$localCores = "core_repos.json"
Add-Type -AssemblyName 'System.IO.Compression.FileSystem'

if (Test-Path ".token") {
    $token = Get-Content -Raw -Path ".token"
    $headers = @{ Authorization = "Bearer $token" }
}

function Get-MainCoreList {
    param (
        $url
    )

    Invoke-WebRequest -Uri $url -UseBasicParsing -UserAgent "KeenIIDX"
}

function ConvertTo-CoreList {
    param (
        $content
    )

    $content.Links | Where-Object {$_.Href -match "^([^/]*/){4}[^/]*$"} | select -ExpandProperty href
}

# Grab central list of cores available.  Pluck out the links to their github repositories
$newCores = Get-MainCoreList -url $CoreSource
$newCores = ConvertTo-CoreList -content $newCores

# Load local list of cores
$installed = Get-Content -Raw -ErrorAction:Ignore -Path $localCores | ConvertFrom-Json

# Prep list of cores
if ($installed) {
    foreach ( $core in $newCores ) {
        if ( $core -notin $installed.link ) {
            $installed += [PSCustomObject]@{ 
                link = $core 
                version = "0.0.0" 
            }
        }
    }
} else {
    $installed = $newCores | foreach { [PSCustomObject]@{ link = $_ ; version = "0.0.0" } }
}

# Grabbing each core.
Foreach ($core in $installed) {
    $apiLink = ($core.link + "/releases").Replace("//github.com/", "//api.github.com/repos/")
    $Response = (Invoke-RestMethod -uri $apiLink -UserAgent "KeenIIDX" -Headers $headers)[0]
    $availableVersion = $Response.tag_name -replace( '.*(?<version>\d+\.\d+\.\d+).*', '${version}' )
    if ( ($availableVersion -eq $Response.tag_name) -and ($Response.tag_name -notmatch '^\d+\.\d+\.\d+$')) {
        $availableVersion = $Response.tag_name -replace( '.*(?<version>\d+\.\d+).*', '${version}' )
    }

    if ( [System.Version]$core.version -lt [System.Version]$availableVersion ) {
        Foreach ($file in $Response.assets) {
            if ($file.browser_download_url -like "*.zip") {
                $downloadLink = $file.browser_download_url
                $fileName = $file.name
                $downloadPath = "$env:TEMP\$fileName"

                #Download the core.
                Invoke-WebRequest -Uri $downloadLink -OutFile $downloadPath

                #Validate it's a core.
                $zipFile = [IO.Compression.ZipFile]::OpenRead($downloadPath)
                $itsACore = $false
                foreach ($coreFile in $zipFile.Entries) {
                    if ( $coreFile.FullName -like 'Cores/*' ) {
                        $itsACore = $true
                        break
                    }
                }
                $zipFile.Dispose()

                if ($itsACore) {
                    #Update cached version
                    $core.version = $availableVersion

                    #Unzip the core to here.
                    Expand-Archive -Path $downloadPath -DestinationPath .\ -Force
                }

                #Delete the downloaded file.
                Remove-Item -Path $downloadPath -Force
            }
        }
    }
}

$installed | ConvertTo-Json -depth 3 | Out-File $localCores
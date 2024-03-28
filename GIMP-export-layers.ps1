function Convert-XCFLayersToPNG {
    param (
        [Parameter(Mandatory=$true)]
        [string]$InputFile
    )

    $inputFileName = [System.IO.Path]::GetFileNameWithoutExtension($InputFile)
    $outputFolder = Join-Path -Path (Get-Location) -ChildPath $inputFileName

    # Create the output folder if it doesn't exist
    if (-not (Test-Path $outputFolder)) {
        New-Item -ItemType Directory -Path $outputFolder | Out-Null
    }

    $i = 0
    $keepConverting = $true

    while ($keepConverting) {
        $outputFile = Join-Path -Path $outputFolder -ChildPath ("{0}.png" -f $i)
        $output = magick convert "$InputFile[$i]" $outputFile 2>&1
        if ($output -like '*invalid image index*') {
            $keepConverting = $false
        }
        else {
            $i++
        }
    }

    Write-Output "Converted $i layers to individual PNG files in the '$outputFolder' folder."
}

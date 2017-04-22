import-module $PSScriptRoot\powershell-yaml
import-module $Env:ChocolateyInstall\helpers\chocolateyInstaller.psm1 
ls $PSScriptRoot/hmt/*.ps1 | % { . $_ }
ls $PSScriptRoot/internal/*.ps1 | % { . $_ }

$yaml = gc $PSScriptRoot\hmt.yaml -Raw
$yaml = ConvertFrom-Yaml $yaml -Ordered
$global:hmt = $yaml

ConvertTo-HMTScript $yaml
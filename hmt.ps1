import-module -force $PSScriptRoot\powershell-yaml

function ConvertTo-HMTScript {
    param(
        [System.Collections.Specialized.OrderedDictionary] $cfg
    )

    $options = $hmt._
    $stages = $hmt.Keys | ? {$_ -ne '_'}
    foreach( $stage in $stages) {
         $s = Convert-Stage2Script $hmt.$stage
    }
}

function Convert-Stage2Script {
    param(
        [System.Collections.Specialized.OrderedDictionary] $stage
    )
    
    
}


$yaml = gc $PSScriptRoot\hmt.yaml -Raw
$yaml = ConvertFrom-Yaml $yaml -Ordered
$yaml
#ConvertTo-HMTScript $yaml
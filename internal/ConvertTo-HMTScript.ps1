function ConvertTo-HMTScript {
    param(
        [System.Collections.Specialized.OrderedDictionary] $cfg
    )

    $hmt_options = $hmt._
    $stages = keys $hmt '_'
    foreach( $stage in $stages) {
         $s = Convert-Stage2Script $stage $hmt.$stage
    }
}

function Convert-Stage2Script {
    param(
        [string] $StageName,
        [System.Collections.Specialized.OrderedDictionary] $StageData
    )
    Write-Verbose "Converting stage $StageName to script"
    
    $options = $StageData.stage
    $runners = keys $StageData 'stage'
    foreach ( $r in $runners ) {
        $rdef = Get-RunnerDefinition $r
    }
}

function Get-RunnerDefinition( $Name )
{
    # if ($Name.EndsWith(':')) { 
    #     $Name = $Name.Substring(0, $Name.Length-2)
    #     $explicit = $true
    # } 

    $n = gcm $Name -ea 0
    if (!$n) { 
        $n = $Name.Replace(' ', '-')
        $n = gcm $n -ea 0
        if (!$n) { throw "Can't find command: $Name" }
    }
    if ($n.CommandType -eq 'Alias') { $n = $n.Definition }
    return $n
}


function keys( $hash, $exclude ) { $hash.Keys | ? { $exclude -notcontains $_ } }
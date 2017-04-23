function ConvertTo-HMTScript {
    param(
        [System.Collections.Specialized.OrderedDictionary] $hmt
    )
    
    function keys( $Hash, $Exclude ) { $Hash.Keys | ? { $Exclude -notcontains $_ } }
    
    $hmt_options = $hmt._
    $stages = keys $hmt -Exclude '_'

    $res = "# This script is automatically generated by HMT`n`n"
    foreach( $stage in $stages) {
        Write-Verbose "Generating code for $stage"

        $options  = $stages.stage
        $commands = keys $hmt.$stage -Exclude 'stage'
        foreach ( $cmd in $commands ) { $res += Get-CommandCode $cmd $hmt.$stage.$cmd }
        $res += "stage '$stage' {`n" + $s + "}`n`n"
    }

    $res | Set-Content $PSScriptRoot\..\hmt-script.ps1
}

function titlecase($a) {
    (Get-Culture).TextInfo.ToTitleCase($a)
}

function Get-CommandCode($CmdName, $CmdData) {

    # Remove options from command names
    $options_re = '\(.+', '\$$'
    foreach ($re in $options_re) {
        $m = $CmdName -match $re 
        if (!$m) { continue }

        $cmd_opts = $Matches[0].Trim()
        if ($cmd_opts.StartsWith('(')) { $cmd_opts = $cmd_opts.Substring(1) }
        $CmdName = ($CmdName -replace $re).Trim()
        break
    } else { $cmd_opts = '' }

    $cmd_def = Get-CommandDefinition $CmdName

    $res = ''
    if ($cmd_opts.Contains('s')) {
        $CmdData | % { $res += ' -' + (titlecase $_).Replace(' ','') }
    } 
}

function Get-CommandDefinition($CmdName) {
    $n = gcm $CmdName -ea 0
    if (!$n) { 
        $n = $CmdName.Replace(' ', '-')
        $n = gcm $n -ea 0
        if (!$n) { throw "Can't find command: $CmdName" }
    }
    if ($n.CommandType -eq 'Alias') { $n = $n.Definition }
    $n
}

function to_yaml_param($name, $val) {
    $pname = "`$p_${name}"
    $pval  = "${pname} = ConvertFrom-Yaml @""`n" 
    $pval += Expand-PoshString (ConvertTo-Yaml $val)
    $pval += """@`n"
    $pname, $pval
}

function Get-RunnerParams($data, $opts) {
    $res = $pre = ''

    if ($opts.Contains('s')) {
        $data | % { $res += ' -' + (titlecase $_).Replace(' ','') }
    } 
    else { 
        if ($data -is [System.Collections.Specialized.OrderedDictionary]) {
            $data.Keys | % { 
                $prop = $_;  $val = $data.$prop

                if ($_.StartsWith('$')) {   #TODO: Ovo ide u script neizmenjeno god damnit, zapravo sve sto moze
                    $var = titlecase $prop.Substring(1).Trim()
                    Set-Variable $var (Invoke-Expression $val)
                    return
                }
                
                if ($prop -eq 'args') { 
                    $res += "'{0}'" -f (Expand-PoshString $val)
                    return
                }

                if ($val -is [string]) { $val = Expand-PoshString $val }
                elseif ( $val.GetType().BaseType.Name -ne 'ValueType' ) {
                    $val, $p = to_yaml_param $prop $val
                    $pre += $p
                }

                $res += ' -{0} {1}' -f (titlecase $_), $val
            } 
        }
        if ($data -is [string]) { $res = "'$data'" }
        
        if ($data.GetType().Name -eq 'List`1') {
            for($i = 0; $i -lt $data.Count; $i++){
                $val = $data[ $i ]
                if ($val -is [string]) { $val = Expand-PoshString $val }
                else {
                    $val, $p = to_yaml_param $i $val
                    $pre += $p
                }
                $res += $val
            }

        }
    }
    if ($opts.Contains('f')) { $res += ' -Force' }

    $res.Trim(), $pre
}
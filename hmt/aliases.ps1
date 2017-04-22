# Aliases are loaded only for HMT session

sal autologon               Set-Autologon
sal packages                Use-Packages
sal chocolatey              Use-Chocolatey
sal 'git repositories'      Use-GitRepositories
sal 'explorer options'      Set-WindowsExplorerOptions
sal 'proxy'                 Update-Proxy

# Chocolatey

if ($Env:ChocolateyInstall) {
    sal 'pinned applications'   Install-ChocolateyPinnedTaskBarItem
}

# Windows
sal 'language list'         Set-WinUserLanguageList
sal 'culture'               Set-Culture
sal 'time zone'             Set-TimeZone
sal 'computer name'         Rename-Computer
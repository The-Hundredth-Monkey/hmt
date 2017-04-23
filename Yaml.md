# Yaml parsing

HMT allows for configuration specification using Yaml syntax. Yaml file is translated into Powershell script which is then executed. You don't have to use yaml syntax, but it is significantly more human readable. If you later change your mind, you can continue using and modifying translated script directly so you can never be locked into yaml.

Yaml representation contains of a dictionary which keys represent **stages** and each stage contains **commands**. Yaml commands are regular PowerShell commands with few syntax rules on naming and parameter passing. To be human readable, all out of the box commands are refered by the PowerShell aliases defined by HMT or set by the user.

Yaml commands contain PowerShell command parameters with few syntax suggars so that they are human readable. Yaml commands can also have options which are suffixes after the `(` symbol. 

If no option is given command parameters are passed as a dictionary. If we have the following Powershell command:

```powershell
    Update-Proxy -Server:'myserver.com -Enable:1 -Override:'meh.com'
```
and given that alias proxy exists (`Set-Alias proxy Update-Proxy`) it can be represented in yaml file as

```yaml
    proxy:
        server: myserver.com        # Yaml dictionary keys map to
        enable: 1                   # Powershell parameters
        override: meh.com
```

In other words, if command contains yaml dictionary its keys will be mapped to PowerShell arguments. If, instead of yaml dictionary, you provide yaml array, such as:

```yaml
    proxy:
        - myserver.com     
        - 1
        - meh.com
```
it will be mapped to the same command according to parameter ordering:

```powershell
    Update-Proxy "myserver.com" 1 "meh.com
```

There is one special key, `args` that can be used to mix named and unnamed parameters:

```yaml
    computer name:
        args: my-computer
        force: true
        protocol: WSMan
```
which is translated to `Rename-Computer "my-computer" -Force:$true -Protocol:'WSMan'`.

There are few options that can change this behavior to something more appropriate in specific contexts. One of such options is `s` that turns array into list of switches:

```yaml
  explorer options (s:
    - show hidden files
    - show protected OS files
    - show file extensions
```
maps to `Set-ExplorerOptions -ShowHiddenFiles -ShowProtectedOSFiles -ShowFileExtensions`. 

One impoortant command options is `$` which turns command into arbitrary peace of code:

```yaml
time sync $: |
    W32tm.exe /register
    Get-Service W32Time | Start-Service
    w32tm.exe /config /manualpeerlist:"3.rs.pool.ntp.org 3.europe.pool.ntp.org" /syncfromflags:manual /update
    w32tm.exe /resync
```
This code will show in output script intact and single `Write-Host 'time sync'` will be added before it. 
Option `$` can be specified without `(`.

The example bellow contain simple but full YAML setup with 2 stages:

```yaml
packages and tools:                        # Starting stage "packages and tools"
    chocolatey (s:                         # HMT\chocolatey is alias to Use-Chocolatey
        - latest                           # It will be called with 2 switch parameters
        - update packages                  # Use-Chocolatey -Latest -UpdatePackages

    packages:                              # HMT\packages is alias to Use-Packages and it
        chocolatey:                        # has 2 parameters -Chocolatey and -Gem
            - less                         # which are arrays:
            - curl                         # Use-Packages -Chocolatey 'less','curl' -Gem 'gist','nanoc'
        gem:
            - gist
            - nanoc

windows config:                            # Starting stage "windows config"
  explorer options (s:                     # Translates to `Set-ExplorerOptions` with switches
    - show hidden files
    - show protected OS files
    - show file extensions
  proxy:                                   # Translates to Update-Proxy -Server proxysrv.com -Enalbe 1
     server: proxysrv.com
     enable: 1
  computer name: my-computer               # Rename-Computer "my-computer"
  language list (@:                        # Parameter @ winds up array to first argumente so this is
    - en-us                                # Set-WinUserLanguageList 'enu-us','de'
    - de
  time zone: Central Europe Standard Time  # Set-TimeZone "Central Europe Standard Time"
  culture: de-DE                           # Set-Culture "de-DE"
```
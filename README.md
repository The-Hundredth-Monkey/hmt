# hmt

## Yaml parsing

See to make it module so it can be used with other projects.

### Executioners

- HMT yaml fields are posh aliases or powershel functions with :: syntax. There will be no guessing for now but it can come later based on verb priorities.
Example - to get function rename-computer available as 'computer name' define `set-alias 'computer name' rename-computer`. Double word aliases are great because they can almmost never colide with what user has. This customizes function name within HMT, to customize parameter names proxy functions could be used out of which alias is created.  
This would also allow for 3thd party aliases previously imported, i.e. `proxy:: server:port` would use `proxy` alias for `MM_Network\Update-Proxy`. There should be recommendation however that something must hijack this name if its simple enough. FQDN should be supported here, ie `MM_Network\proxy:: server:port` and this could be make easier with some stage option such as `use only modules: MM_Network, Microsoft*`.

- Stages should have options that could be set globally in _ key.

- Special syntax for non-alias usage, double colon. I.E `rename computer:: ....` would look into function `rename-computer` or `RenameComputer` [this type of parsing could be defined via options what is expected and from which modules etc.] 

- Guess based on verb, for example, for `chocolatey` try `Use-`, `Set-`, `Update-`, `Invoke-` prefixes. **This is however highly unpredictable for future releases of the same modules and different environments** but might be contained with options such as verb priorities and module limits. Doubt its worth it, especially aliases are very easy to define: `sal chocolatey Use-Chocolatey` or even more bullet proofed `sal chocolatey HMT\Use-Chocolatey`.

### Powershell

- Yaml values are considered Powershell strings so they can contain PowerShell evaluations. For example:
    ```
        computer name: mm-$((Get-Date).ToString('yyyy'))-win10
    ```
- Yaml `$` prefixed keys are evaluted as expressions (`iex`). For multiline scripts use | or >

- There can be arbitrary number of variables defined. See `windows config.computer name`

- Some cmdlets are unusable without Force. Autoforce where possible

- Commands 

### Special

#### Prefix $

- `$` prefix anywhere executes Posh expression and saves result into name.
- Could be suffix on commands: `time sync $: >'
- `$name` creates var `$name`, but also `$ name`
- `$ some description` will create var `$someDescription` which might or might not be used.
   It could also be used only for `Write-Hosts`
- `$` can be among commands or within commands 

#### Sufixes

All with | to allow for arbitrary inline params on commands ?

- `=` - Each array item generates 1 call 
- `@` - Wrap array into single argument
- `f` - Autoforce
- `s` - Use switch evaluation  (do not allow per argument? )
- `p` - Use params by order (default, perhaps modifiable globally)


### Data

Define data storage for all executioners:

```yaml
packages:   # Use-Packages -Chocolatey @(..) -Gem @(...) 
    - chocolatey         #get from data\packages\chocolatey
    - npm                   #get from data\packages\nmp

git repositories:   # Use-GitRepositories -Repos @() -Root
    root: c:\work
    repos:              # get from data\git repositories\repos  
                              # get from data\gitrepositories

```
        
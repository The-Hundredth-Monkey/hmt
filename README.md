# hmt

## Yaml parsing

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
        
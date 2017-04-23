## Command spec

1. <command>            - simple 
2. <command> ( <opts>   - with options
3. <command> $          - script, verbatim (command purpose? write-host)
4. <command> :          - with arrays uses ' instead of "
5. $<key>:              - ${key} = ...

<command> must be returned by Get-Commad. If not first space is replaced with '-' and rest words joined.
Example: set explorer options: Set-ExplorerOptions

## Argument spec

1. dictionary                - maps directly to params
2. array                     - maps to params by order
3. dictionary + 'args' key   - first named and then args

### Dictionary

0. <key>:: <value>          - -Key:'value'
1. <key> : <value>          - -Key:"value"
2. $<key>: value            - ${key} = . { value }    or   $key = value if no ';'
3. $<key>: |                - ${key} = . { multiline }
4. <key> : $var             - -Key:"$var" (same as 1)
5. key $ : $var             - -key:$($var)
6. key $ : $var meh 2 3     - -key:$($var meh 2 3)
7. key $ : |                - -key:$p_key   (multiline script value); $p_key above, same as 3
8. $<key>: value1; value2;  - ${key} = . { value1; value2 }
9. args: str or array       - non-named

### Array

0. [a,b]                  - "a", "b"
1.  - a                   - "a", "b"
    - b    
2. <command>::            - 'a', 'b'
        - a
        - b                   

NOTES:
    - <key> can be multiword and whatever, hence ${ }
    - params should be applied with : because of switches
    - human readability of resulting script ?
    - dicts should use double quotes unles double colon :: is set, allows string substitution

## Options





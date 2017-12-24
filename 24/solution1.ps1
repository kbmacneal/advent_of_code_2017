class component {
    [int]$connect_a
    [int]$connect_b
    [int]$strength
}

class bridge {
    [System.Collections.Generic.List[component]]$bridge
    [System.Collections.ArrayList]$connectors
    [int]$strength
    [int]$length
    [bool]$remaining
}

function spawn_bridge ($prev_connectors, $connectors, $strength, $length) {
    $bridge = New-Object bridge

    $bridge.bridge = $prev_connectors
    $bridge.connectors = $connectors
    $bridge.strength = $strength
    $bridge.length = $length
    $bridge.remaining = $true

    return $bridge
}

function get_next_connect($bridge) {

    if ($bridge.remaining -eq $true) {

        $connectors = $bridge.connectors
        $brig = $bridge.bridge
    
        $last_element = $brig[$($brig.Count - 1)]

        $new_bridges = new-object system.collections.arraylist
        
        $next_element = $connectors | where {$_.connect_a -eq $last_element.connect_b -or $_.connect_b -eq $last_element.connect_a -or $_.connect_a -eq $last_element.connect_a -or $_.connect_b -eq $last_element.connect_b}
    
        if ($($next_element | measure).count -gt 0) {
            foreach ($item in $next_element) {
                $new_bridge = spawn_bridge -prev_connectors $brig -connectors $connectors -strength $bridge.strength -length $bridge.length
        
                $new_bridge.connectors.Remove($item)
                $new_bridge.strength += $item.strength
                $new_bridge.length++
                [void]$new_bridge.connectors.Add($item)
        
                [void]$new_bridges.Add($new_bridge)
            }

            return $new_bridges
        }
        else {
            $brig.remaining = $false
        }
    }

}


$inputs = Get-Content .\input.txt

$connectors = new-object System.Collections.ArrayList

foreach ($line in $inputs) {
    
    $obj = New-Object component
    
    $arr = $line -split "/"

    $obj.connect_a = $arr[0]
    $obj.connect_b = $arr[1]
    $obj.strength = $obj.connect_a + $obj.connect_b
    [void]$connectors.Add($obj)
}

#install the first connector

$bridge = New-Object bridge
$bridges = New-Object System.Collections.ArrayList

$bridge.bridge = new-object 'System.Collections.Generic.List[component]'
$bridge.connectors = $connectors

[void]$bridge.bridge.Add($($connectors | where {$_.connect_b -eq 0 -or $_.connect_a -eq 0}))
[void]$bridge.connectors.Remove($($bridge[$($bridge.Count - 1)]))

$bridge.strength += $bridge.bridge[0].strength
$bridge.remaining = $true
[void]$bridges.Add($bridge)

    for ($i = 0; $i -lt $bridges.Count; $i++) {
        $item = $bridges[$i]
        [void]$bridges.AddRange($(get_next_connect -bridge $item))
    } 

Write-Host ($bridges | sort -Property strength -Descending |select -First 1).strength
write-host ($bridges | sort -Property length -Descending |select -First 1).strength

#1695
#1673
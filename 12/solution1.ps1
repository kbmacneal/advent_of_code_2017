class pipe{
    [int]$name;
    [System.Collections.ArrayList]$connected_to
}


$inputs = get-content .\input.txt

$pipes = new-object System.Collections.ArrayList

foreach ($pipe in $inputs) {
    $split = $pipe -split "<->"

    $ins = New-Object pipe

    $ins.name = $split[0].Trim()

    $children = New-Object System.Collections.ArrayList

    foreach ($item in $($split[1]).Replace(" ","") -split ",") {
        $null = $children.Add($item)
    }
    $ins.connected_to = $children

    $null = $pipes.add($ins)
}

$connected_to_0 = new-object system.collections.arraylist

$0_kids = $($pipes | Where-Object -Property name -eq "0").connected_to

foreach($kid in $0_kids)
{
    $null = $connected_to_0.Add($kid)
}

$limit = $pipes.Count

while ($limit -gt 0) {
    foreach ($pipe in $pipes) {
    if ($pipe.name -in $connected_to_0) {
        foreach($child in $pipe.connected_to)
        {
            if($child -notin $connected_to_0)
            {
                $connected_to_0.Add($child.trim())
            }
        }
    }
}

$limit--
}

return $connected_to_0.Count + 1
$inputs = 316

$step_limit = $inputs


$indexes = new-object System.Collections.ArrayList

[void]$indexes.Add(0)


$position = 0 

for ($i = 1; $i -lt 2018; $i++) {
    $position = ($position + $step_limit) % $indexes.Count + 1

    [void]$indexes.Insert($position,$i)
}


return $indexes[$position + 1]

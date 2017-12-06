#part two

$contents = get-content .\out.txt

$last = $contents | select -Last 1

$indexes = @()

for ($i = 0; $i -lt $contents.Count; $i++) {

    

    if($contents[$i] -eq $last)
    {
        $indexes += $i
    }
    
   
}

$i = $indexes[0]
$j = $indexes[1]

[Math]::abs($j - $i)
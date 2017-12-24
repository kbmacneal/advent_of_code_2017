$data = New-Object 'System.Collections.Generic.List[System.Tuple]'

$inputs = get-content .\input.txt

foreach ($line in $inputs) {
    $a,$b = $line -split "/"
    $tuple = [System.Tuple]::Create([int]$a,[int]$b)
    [void]$data.Insert($tuple)
}

$empty_list = New-Object 'System.Collections.Generic.List[int]'

$bridge = [System.Tuple]::Create($empty_list,0)

function run($b,$d)
{
    $available = New-Object 'System.Collections.Generic.List[System.Tuple]'

    foreach ($a in $d) {
        if($b[1] -in $a)
        {
            [void]$available.Add($a)
        }
    }

    if($available.Count -eq 0) 
    {
        return $b
    }
    else {
        foreach ($a in $available) {
            $d_ = $d
            $d_.remove($a)

            $first = if($b[1] -eq $a[1]){return $a[1]}else{return $a[0]}
         

            foreach ($q in run($first,$d_)) {
             return $q   
            }
        }
    }
}




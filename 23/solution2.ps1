function isPrime($number)
{

    if ($number -eq 1) {return $false}
    if ($number -eq 2) {return $true}

    for ($i = 2; $i -le [Math]::Ceiling([Math]::Sqrt($number)); $i++) {
        if($number % $i -eq 0){return $false}
    }

    return $true;

}

$b = 109300
$c = 126300
$h = 0

$range = @()

for ($i = $b; $i -lt $c+1; $i = $i + 17) {
    $range += $i
}

foreach ($item in $range) {
    if(!(isPrime($item)))
    {$h++}
}

return $h
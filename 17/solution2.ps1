$inputs = 316

$step_limit = $inputs


$result = 0
for ($i = 0; $i -lt 50000000; $i++) {
    $nextPos = ($pos + $step_limit) % ($i+1)
    
    if ($nextPos -eq 0) {
        $result = $i+1
    }
    $pos = $nextPos + 1
}
return $result



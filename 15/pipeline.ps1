[long]$factor_a = 16807
[long]$factor_b = 48271

[long]$gen_a_start = 722
[long]$gen_b_start = 354

#use modulo
[long]$shared_divisor = 2147483647

[long]$a_val = $gen_a_start
[long]$b_val = $gen_b_start

$bitmask = 65535

$count = 0

0..40000000 | %{
    [long]$a_val = ($a_val * $factor_a) % $shared_divisor
    [long]$b_val = ($b_val * $factor_b) % $shared_divisor
    if($($a_val -band $bitmask) -eq $($b_val -band $bitmask)){$count++}
}

return $count
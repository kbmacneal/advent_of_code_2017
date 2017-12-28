$factor_a = 16807
$factor_b = 48271

$gen_a_start = 722
$gen_b_start = 354

#use modulo
$shared_divisor = 2147483647

function calc_value([long]$value, $multiple, $divisor) {
    [long]$val = ($value * $multiple) % $divisor

    return $val
}

$count = 0

$a_val_list = new-object 'System.Collections.Generic.List[long]'

$b_val_list = new-object 'System.Collections.Generic.List[long]'

[void]$a_val_list.Add($gen_a_start)

[void]$b_val_list.Add($gen_b_start)

$bitmask = 65535


for ($i = 0; $i -lt 40000000; $i++) {
	
    [long]$a_val = calc_value -value $($a_val_list[$a_val_list.Count - 1]) -multiple $factor_a -divisor $shared_divisor
    [void]$a_val_list.Add($a_val)
    $a_compare = $($a_val -band $bitmask)
	
    [long]$b_val = calc_value -value $($b_val_list[$b_val_list.Count - 1]) -multiple $factor_b -divisor $shared_divisor
    [void]$b_val_list.Add($b_val)
    $b_compare = $($b_val -band $bitmask)

    if($a_compare -eq $b_compare){$count++}
}

#612
return $count
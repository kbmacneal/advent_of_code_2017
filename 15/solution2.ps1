$factor_a = 16807
$factor_b = 48271

$gen_a_start = 722
$gen_b_start = 354

#use modulo
$shared_dividend = 2147483647

function calc_value([long]$value, $multiple, $dividend, $check) {
    [long]$val = (($value * $multiple) % $dividend) % $check

    if ($val -eq 0) {
        return (($value * $multiple) % $dividend)
    }
    else {
        return 0
    }
}

function convert_to_bin([long]$value) {
    $bitmask = 65535

    return ($value -band $bitmask)	
}

$count = 0

$a_val_list = new-object 'System.Collections.Generic.List[long]'

$b_val_list = new-object 'System.Collections.Generic.List[long]'

[void]$a_val_list.Add($gen_a_start)
[void]$b_val_list.Add($gen_b_start)

$a_compare_list = new-object 'System.Collections.Generic.List[int]'

$b_compare_list = new-object 'System.Collections.Generic.List[int]'


for ($i = 0; $i -lt 5000000; $i++) {
	$last_val = $a_val_list[$($a_val_list.count-1)]
    [long]$a_val = calc_value -value $last_val -multiple $factor_a -dividend $shared_dividend -check 4
    [void]$a_val_list.Add($a_val)
    if ($a_val -gt 0) {
        $a_compare = convert_to_bin -value $a_val
        [void]$a_compare_list.add($a_compare)
    } 
    
    $last_val = $b_val_list[$($b_val_list.count-1)]
    [long]$b_val = calc_value -value $last_val -multiple $factor_b -dividend $shared_dividend -check 8
    [void]$b_val_list.Add($b_val)
    if ($b_val -gt 0) {
        $b_compare = convert_to_bin -value $b_val
        [void]$b_compare_list.add($b_compare)
    }
}

for ($i = 0; $i -lt $a_compare_list.count; $i++) {
    if ($a_compare_list[$i] -eq $b_compare_list[$i]) {
        $count++
    }
}

#should be 285
$count
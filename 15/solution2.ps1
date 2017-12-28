$factor_a = 16807
$factor_b = 48271

$gen_a_start = 722
$gen_b_start = 354

$shared_dividend = 2147483647

$count = 0

$a_compare_list = new-object 'System.Collections.Generic.List[int]'

$b_compare_list = new-object 'System.Collections.Generic.List[int]'

$a_val = $gen_a_start
$b_val = $gen_b_start

$bitmask = 65535


while (($a_compare_list.Count -lt 5000000) -or ($b_compare_list.Count -lt 5000000))
{
	$prev_a = $a_val
	$prev_b = $b_val
    
    
    [long]$a_val = ($prev_a * $factor_a) % $shared_dividend
    $temp = $a_val % 4

	if ($temp -eq 0)
 {
		[void]$a_compare_list.Add($a_val)
    }

    [long]$b_val = ($prev_b * $factor_b) % $shared_dividend
    $temp = $b_val % 8

	if ($temp -eq 0)
 {
		[void]$b_compare_list.Add($b_val)
    }
}


for ($i = 0; $i -lt 5000000; $i++)
{
	if (($a_compare_list[$i] -band $bitmask) -eq ($b_compare_list[$i] -band $bitmask))
 { 
		$count++
	}
}

#285
$count
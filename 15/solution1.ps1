$factor_a = 16807
$factor_b = 48271

$gen_a_start = 722
$gen_b_start = 354

#use modulo
$shared_divisor = 2147483647

$hex = @{
	'0' = '0000'
	'1' = '0001'
	'2' = '0010'
	'3' = '0011'
	'4' = '0100'
	'5' = '0101'
	'6' = '0110'
	'7' = '0111'
	'8' = '1000'
	'9' = '1001'
	'a' = '1010'
	'b' = '1011'
	'c' = '1100'
	'd' = '1101'
	'e' = '1110'
	'f' = '1111'
}

function calc_value([System.Uint64]$value, $multiple, $divisor)
{
	[System.Uint64]$val = ($value * $multiple) % $divisor

	return $val
}

function convert_to_bin([System.Uint64]$value)

{
	$binary_Str_array = new-object 'System.Collections.Generic.List[int]'

	$null = -join ($value.tostring().getenumerator() | foreach {$hex["$_"]} | foreach {[void]$binary_Str_array.Add([int]$_)})

	#$binary_Str = -join ($rows| foreach {$_.getenumerator().foreach{$hex["$_"]}})

	#$binary_Str.GetEnumerator() | foreach {[void]$binary_Str_array.Add([int]$_)}

	[string]$final_bin_string = $binary_Str_array -join ""

	if ($final_bin_string.ToString().Length -le 16)
	{
		return $final_bin_string.ToString()
	}
	else
 {
		return $final_bin_string.ToString().Substring($($final_bin_string.ToString().Length - 16),16)
	}

	
}

$count = 0

$a_val_list = new-object 'System.Collections.Generic.List[System.Uint64]'

$b_val_list = new-object 'System.Collections.Generic.List[System.Uint64]'

[void]$a_val_list.Add($gen_a_start)
[void]$b_val_list.Add($gen_b_start)

$a_compare_list = new-object 'System.Collections.Generic.List[System.String]'

$b_compare_list = new-object 'System.Collections.Generic.List[System.String]'


for ($i = 0; $i -lt 40000000; $i++)
{
	
	[System.Uint64]$a_val = calc_value -value $($a_val_list[$a_val_list.Count - 1]) -multiple $factor_a -divisor $shared_divisor
	[void]$a_val_list.Add($a_val)
	$a_compare = convert_to_bin -value $a_val
	
	[System.Uint64]$b_val = calc_value -value $($b_val_list[$b_val_list.Count - 1]) -multiple $factor_b -divisor $shared_divisor
	[void]$b_val_list.Add($b_val)
	$b_compare = convert_to_bin -value $b_val

	[void]$a_compare_list.add($a_compare)
	[void]$b_compare_list.add($b_compare)

	
	Write-Progress -Activity "calculating list" -Status $count.tostring() -PercentComplete $(($i/4000000)*100)
	
}

write-progress -completed

for($i = 0; $i -lt $a_compare_list.count; $i++){
	if($a_compare_list[$i] -eq $b_compare_list[$i])
	{
		$count++
	}
}


#should be 612
$count
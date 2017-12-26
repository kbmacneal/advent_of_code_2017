$lines = get-content .\input.txt

$edges = New-Object System.Collections.Arraylist

function do_search ($list, [int]$current = 0, [int]$strength = 0, $strength_list)
{

	$compares = $list | ? {$_.Item1 -eq $current -or $_.Item2 -eq $current}

	

	$compares | % {

		#$sublist = new-object System.Collections.Arraylist
		$sublist = $list.Clone()
		
		[void]$sublist.Remove($_)
		
		if ($_.item1 -eq $current) 
		{$x = $_.Item2}
		else {$x = $_.Item1}
		
		$st = $strength + $_.Item1 + $_.Item2
		
		[void]$strength_list.Add($st)
		
		do_search -list $sublist -current $x -strength $st -strength_list $strength_list
	} 
	
	
	
}

foreach ($line in $lines)
{
	$a,$b = $line -split "/"
	$tuple = [System.Tuple]::Create([int]$a,[int]$b)

	[void]$edges.Add($tuple)
}

$str_list = New-Object System.Collections.Arraylist

$str_list.Add(0)


do_search -list $edges -current 0 -strength 0 -strength_list $str_list

$str_list | Measure-Object -Maximum


#1695
#1673
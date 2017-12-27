class lenstren
{
	[int]$length
	[int]$strength
}

$lines = get-content .\input.txt

$edges = New-Object System.Collections.Arraylist

function do_search2 ($list, [int]$current = 0, [int]$strength = 0, [int]$length = 0, $len_list)
{
		$list | ? {$_.Item1 -eq $current -or $_.Item2 -eq $current} | % {
		
		$sublist = $list.Clone()
		
		[void]$sublist.Remove($_)
		
		if ($_.item1 -eq $current) 
		{$x = $_.Item2}
		else {$x = $_.Item1}
		
		$st = $strength + $_.Item1 + $_.Item2
		$len = $length++

		$obj = New-Object lenstren
		$obj.length = $len
		$obj.strength = $st

		[void]$len_list.Add($obj)
		
		do_search2 -list $sublist -current $x -strength $st -length $len -len_list $len_list
	} 	
}

foreach ($line in $lines)
{
	$a,$b = $line -split "/"
	$tuple = [System.Tuple]::Create([int]$a,[int]$b)

	[void]$edges.Add($tuple)
}

$len_list = New-Object System.Collections.Arraylist

do_search2 -list $edges -current 0 -strength 0 -length 0 -len_list $len_list

$len_list | sort -property strength -descending | select -first 1
$len_list | sort -Property length,strength -Descending | select -First 5

#1695
#1673
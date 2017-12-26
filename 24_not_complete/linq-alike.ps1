$lines = get-content .\input.txt

$edges = New-Object System.Collections.Arraylist

function do_search ($list, $current = 0, $strength = 0)
{

	$compares = $list | ? {$_.Item1 -eq $current -or $_.Item2 -eq $current}

	

	[Linq.Enumberable]::Concat($($compares | % {[void]$list.Remove($_);if ($_.item1 -eq $current) {$x = $_.Item1}else {$x = $_.Item2};do_search -list $list -current $x -strength ($strength + $_.Item1 + $_.Item2)}),
	
	
	<#if (($strength + $_.Item1 + $_.Item2) -gt $strength)
	{
		return [int]$($strength + $_.Item1 + $_.Item2)
	}
	else {
		return [int]$strength
	}#>
	
}

foreach ($line in $lines)
{
	$a,$b = $line -split "/"
	$tuple = [System.Tuple]::Create([int]$a,[int]$b)

	[void]$edges.Add($tuple)
}



do_search -list $edges -current 0 -strength 0

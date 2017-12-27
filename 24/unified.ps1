class lenstren {
    [int]$length
	[int]$strength
	$tuple
}

$lines = get-content .\input.txt

$edges = New-Object System.Collections.Arraylist

function do_search2 ($edges, [int]$current = 0, [int]$strength = 0, [int]$length = 0, $list) {
    $edges | ? {$_.Item1 -eq $current -or $_.Item2 -eq $current} | % {

		$st = $strength + $_.Item1 + $_.Item2
        $len = $length++
	
        $obj = New-Object lenstren
        $obj.length = $len
		$obj.strength = $st
		[int]$a = $_.Item1
		[int]$b = $_.Item2
		$obj.tuple = [System.Tuple]::Create([int]$a,[int]$b)
	
        [void]$list.Add($obj)
		
        $sublist = $edges.Clone()
		
        [void]$sublist.Remove($_)
		
        if ($_.item1 -eq $current) 
        {$x = $_.Item2}
        else {$x = $_.Item1}	
		
        do_search2 -edges $sublist -current $x -strength $st -length $len -list $list
    } 	
}

foreach ($line in $lines) {
    $a, $b = $line -split "/"
    $tuple = [System.Tuple]::Create([int]$a, [int]$b)

    [void]$edges.Add($tuple)
}

$list = New-Object System.Collections.Arraylist

do_search2 -edges $edges -current 0 -strength 0 -length 0 -list $list

$list | sort -property strength -descending | select -first 1

#part 2 isnt working atm, and i don't know why
$list | sort -Property length -Descending | select -First 1

Pause

$list

#1695
#1673
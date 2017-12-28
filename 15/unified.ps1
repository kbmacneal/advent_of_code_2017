#from https://www.reddit.com/r/adventofcode/comments/7jxkiw/2017_day_15_solutions/dr9zhqg/

[long]$gA = 722
[long]$gB = 354

$bitmask = 65535
$numMatches = 0

for ($i = 0; $i -lt 40000000; $i++)
{

	$gA = ($gA * 16807) % 2147483647
	$gB = ($gB * 48271) % 2147483647

	if ( ($gA -band $bitmask) -eq ($gB -band $bitmask) ) { $numMatches++ }
}

$numMatches

[long]$gA = 722
[long]$gB = 354

$bitmask = 65535
$numMatches = 0

$As = [System.Collections.ArrayList]@()
$Bs = [System.Collections.ArrayList]@()

while (($As.Count -lt 5000000) -or ($Bs.Count -lt 5000000))
{    
	$gA = ($gA * 16807) % 2147483647
	$gB = ($gB * 48271) % 2147483647

	if ( ($gA % 4 -eq 0) ) { [void]$As.Add($gA) }
	if ( ($gB % 8 -eq 0) ) { [void]$Bs.Add($gB) }
}

for ($i = 0; $i -lt 5000000; $i++)
{
	if (($As[$i] -band $bitmask) -eq ($Bs[$i] -band $bitmask))
 { 
		$numMatches++
	}
}

$numMatches

#612
#285
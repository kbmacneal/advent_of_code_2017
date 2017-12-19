class point
{
	[int]$x;
	[int]$y;
}

class direction
{
	[ValidateSet('North','South','East','West')][String]$Direction
}


function get_next_point($position, $direction)
{
	
}

$inputs = get-content .\input.txt

$letters = New-Object 'System.collections.generic.list[char]'

$steps = 1

foreach ($line in $inputs)
{
	foreach ($char in $line.GetEnumerator())
	{
		[void]$letters.add($char)
	}
	
}
class position
{
	[int]$x
	[int]$y
}

function get_next_point($position, $direction)
{
	switch ($direction)
 {
		"up"
		{ 
			$point = new-object -TypeName position
			$point.x = $position.x
			$point.y = $($position.y - 1)
			return $point
		}
		"down"
		{ 
			$point = new-object -TypeName position
			$point.x = $position.x
			$point.y = $($position.y + 1)
			return $point
		}
		"left"
		{ 
			$point = new-object -TypeName position
			$point.x = $($position.x - 1)
			$point.y = $position.y
			return $point
		}
		"right"
		{ 
			$point = new-object -TypeName position
			$point.x = $($position.x + 1)
			$point.y = $position.y
			return $point
		}
		Default {}
	}
}

function get_next_direction($positon, $direction, $lines)
{
	if ($direction -eq "up" -or $direction -eq "down")
	{
		if ($lines[$position.y][$($position.x - 1)] -eq "-")
		{
			return "left"
		}
		if ($lines[$position.y][$($position.x + 1)] -eq "-")
		{
			return "right"
		}
		if ($lines[$position.y][$($position.x - 1)] -match "[A-Z]")
		{
			return "left"
		}
		if ($lines[$position.y][$($position.x + 1)] -match "[A-Z]")
		{
			return "right"
		}
	}
	if ($direction -eq "left" -or $direction -eq "right")
	{
		if ($lines[$($position.y - 1)][$position.x] -eq "|")
		{
			return "up"
		}
		if ($lines[$($position.y + 1)][$position.x] -eq "|")
		{
			return "down"
		}
		if ($lines[$($position.y - 1)][$position.x] -match "[A-Z]")
		{
			return "up"
		}
		if ($lines[$($position.y + 1)][$position.x] -match "[A-Z]")
		{
			return "down"
		}
	}
}


$inputs = get-content .\input.txt

$letters = New-Object system.collections.arraylist

$lines = New-Object system.collections.arraylist

$lines.AddRange($inputs)

$steps = 1

$direction = "down"

$position = New-Object -typename position

$position.x = $($inputs[0].IndexOf("|"))

$position.y = 0

while ($true)
{

	$position = get_next_point -position $position -direction $direction
	
	$steps++

	$nextchar = $lines[$($position.y)][$($position.x)]

	if ($nextchar -eq ' ')
 {
		$steps--
		return $steps.ToString() + "`r`n" + $($letters -join "")
			
	}

	if ($nextchar -eq '|' -or $nextchar -eq '-')
 {
		continue
	}

	if ($nextchar -match "[A-Z]")
 {
		[void]$letters.Add($nextchar)
		continue
	}

	if ($nextchar -eq '+')
 {
		$direction = get_next_direction -positon $position -direction $direction -lines $lines
		continue
	}

}
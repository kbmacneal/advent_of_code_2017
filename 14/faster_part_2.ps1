#from https://www.reddit.com/r/adventofcode/comments/7jpelc/2017_day_14_solutions/dr896p6/

# part 2, grid
$g = $rows | foreach { ,[string[]][char[]](( -join ($_.getenumerator().foreach{$h["$_"]})) -replace '0','.' -replace '1','#') }

# add a border of '.' so the group check doesn't wrap around the edges
$border = [string[]][char[]]('.' * 128)

# top/bottom borders
$g = @(,$border) + @($g) + @(,$border)

# left/right borders:
$g = $g | % { ,(@('.') + @($_) + @('.')) }

$groupCount = 0

# render grid, for debugging
$g| % { -join $_}

# recursive fill for an assigned group
function fix ($y, $x, $group)
{

	$g[$y][$x] = $group

	foreach ($pair in @((($y - 1),$x),(($y + 1),$x),($y,($x - 1)),($y,($x + 1))))
 {
		$newy, $newx = $pair
		if ($g[$newy][$newx] -eq '#')
		{
			fix $newy $newx $group
		}
	}
}

# check all positions and trigger recursive fill, and group count
:o for ($y = 1; $y -lt 129; $y++)
{
	for ($x = 1; $x -lt 129; $x++)
 {
		$thing = $g[$y][$x]
		if ($thing -eq '#')
		{
			$groupCount++
			fix $y $x $groupCount
		}
	}
}
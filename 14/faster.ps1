class cell
{
	[bool]$Occupied;
	[int]$Link_Num;
}

function get-knothash
{
	# Parameter help description
	Param(
		[Parameter(ValueFromPipeline = $true)]
		[string]$input_string
	)


	$lengths = @([int[]][System.Text.Encoding]::ASCII.GetBytes($input_string)) + @(17, 31, 73, 47, 23)
	$list = 0..255
    
	$curPos = 0
	$skipSize = 0
    
    
	0..63 | ForEach-Object {
    
		foreach ($len in $lengths)
		{
			# Get the indexes of items to reverse, handling wraparound
			# for a given length greater than the length of the array, will return positions at the beginning
			$indexesToReverse = for ($i = 0; $i -lt $len; $i++) { ($curPos + $i) % $list.Count }
    
			# Swap first and last, seconds and penultimate, third and .. etc unto the middle one: 0,-1  1,-2, 2,-3 etc.
			for ($i = 0; $i -lt [int]($indexesToReverse.Count / 2); $i++)
			{
				$temp = $list[$indexesToReverse[$i]]
				$list[$indexesToReverse[$i]] = $list[$indexesToReverse[0 - ($i + 1)]]
				$list[$indexesToReverse[0 - ($i + 1)]] = $temp
			}
			# the next position including wraparound, increment the skip value
			$curPos = ($curPos + $len + $skipSize) % $list.count
			$skipSize++
		}
	}
    
	#generates 16 sets of 16
	$sixteens = 0..15| % { , ((($_ * 16)..(($_ * 16) + 15)))}
    
	#kid of odd way to do it, two nested loops could have done it
    
	$denseHash = foreach ($set in $sixteens)
 {
		$out = $list[$set[0]]
		foreach ($index in $set[1..15]) { $out = $out -bxor $list[$index] }
		$out
	}
    
	return -join ($denseHash | foreach { '{0:x2}' -f $_ })
    
	#from https://www.reddit.com/r/adventofcode/comments/7irzg5/2017_day_10_solutions/dr12q92/
}

function get-connectedcells($cell_list, [int]$start_x, [int]$start_y, [int]$regnum)
{
	$up_cell = $null
	$down_cell = $null
	$left_cell = $null
	$right_cell = $null

	$up = $start_y + 1
	$down = $start_y - 1
	$left = $start_x - 1
	$right = $start_x + 1
	
	if ($up -lt 128)
	{
		$up_cell = $cell_list[$start_x,$up]
	}
	if ($down -gt 0)
	{
		$down_cell = $cell_list[$start_x,$down]
	}

	if ($left -gt 0) {
		$left_cell = $cell_list[$left,$start_y]
	}
	if ($right -lt 128)
	{
		$right_cell = $cell_list[$right,$start_y]
	}

	"$start_x : $start_y"

	if ($up_cell -ne $null)
 {
		if ($up_cell.Occupied -eq $true -and $up_cell.link_num -eq 0)
		{
			$up_cell.Link_Num = $regnum
			get-connectedcells -cell_list $cell_list -start_x $start_x -start_y $up -regnum $regnum
		}
	}

	if ($down_cell -ne $null)
 {
		if ($down_cell.Occupied -eq $true -and $down_cell.link_num -eq 0)
		{
			$down_cell.Link_Num = $regnum
			get-connectedcells -cell_list $cell_list -start_x $start_x -start_y $down -regnum $regnum
		}
	}

	if ($left_cell -ne $null)
 {
		if ($left_cell.Occupied -eq $true -and $left_cell.link_num -eq 0)
		{
			$left_cell.Link_Num = $regnum
			get-connectedcells -cell_list $cell_list -start_x $left -start_y $start_y -regnum $regnum
		}
	}

	if ($right_cell -ne $null)
 {
		if ($right_cell.Occupied -eq $true -and $right_cell.link_num -eq 0)
		{
			$right_cell.Link_Num = $regnum
			get-connectedcells -cell_list $cell_list -start_x $right -start_y $start_y -regnum $regnum
		}
	}

}


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


function new-cell
{
		   
	$properties = @{
		'Occupied' = $false
		'Link_Num' = $null
	}
    
	$cell = New-Object -TypeName cell -Property $properties
    
	return $cell
}

	



$inputs = "jzgqcdpd"

$grid = new-object 'object[,]' 128, 128

for ($i = 0; $i -lt 128; $i++)
{
	for ($j = 0; $j -lt 128; $j++)
 {
		$cell = new-cell
		$grid[$i,$j] = $cell
		#$grid.add($cell)
	}
}
#for debuggin, no sense wasting time generating the hashes over and over again
$rows = 0..127 | foreach {
	(get-knothash "$inputs-$_")
}

#$rows | export-clixml .\rows.xml

#$rows = import-clixml .\rows.xml

"Hashes Generated"

$counter = 0

$binary_Str_array = new-object 'System.Collections.Generic.List[int]'

$binary_Str = -join ($rows| foreach {$_.getenumerator().foreach{$hex["$_"]}})

$binary_Str.GetEnumerator() | foreach {[void]$binary_Str_array.Add([int]$_)}

"Binary String completed building"


for ($i = 0; $i -lt 128; $i++)
{
	for ($j = 0; $j -lt 128; $j++)
 {
        
		$grid[$j,$i].Occupied = [Convert]::ToBoolean([int]$binary_Str_array[$counter])
		$counter++
	}
}

"Grid Populated"

$region_number = 1

for ($i = 0; $i -lt 128; $i++)
{
	for ($j = 0; $j -lt 128; $j++)
 {
		$cell = $grid[$j,$i]
		if ($cell.link_num -eq 0 -and $cell.Occupied -eq $true)
		{
			"---------"			
			get-connectedcells -cell_list $grid -start_x $j -start_y $i -regnum $region_number
			$region_number++
			"---------"
		}
	}
}

#should be 1212

return $region_number

[GC]::Collect()
class cell {
    [int]$x;
    [int]$y;
    [bool]$Occupied;
    [int]$Link_Num;
}

function get-knothash {
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
    
        foreach ($len in $lengths) {
            # Get the indexes of items to reverse, handling wraparound
            # for a given length greater than the length of the array, will return positions at the beginning
            $indexesToReverse = for ($i = 0; $i -lt $len; $i++) { ($curPos + $i) % $list.Count }
    
            # Swap first and last, seconds and penultimate, third and .. etc unto the middle one: 0,-1  1,-2, 2,-3 etc.
            for ($i = 0; $i -lt [int]($indexesToReverse.Count / 2); $i++) {
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
    
    $denseHash = foreach ($set in $sixteens) {
        $out = $list[$set[0]]
        foreach ($index in $set[1..15]) { $out = $out -bxor $list[$index] }
        $out
    }
    
    return -join ($denseHash | foreach { '{0:x2}' -f $_ })
    
    #from https://www.reddit.com/r/adventofcode/comments/7irzg5/2017_day_10_solutions/dr12q92/
}

function get-connectedcells($cell_list, [cell]$cell_start, [int]$regnum) {
    $connected = new-object System.Collections.ArrayList
    $up_cell = $cell_list | Where-Object -Property X -EQ $cell_start.X | Where-Object -Property Y -eq $($cell_start.Y + 1)
    $down_cell = $cell_list | Where-Object -Property X -EQ $cell_start.X | Where-Object -Property Y -eq $($cell_start.Y + 1)
    $left_cell = $cell_list | Where-Object -Property X -EQ $($cell_start.X - 1)| Where-Object -Property Y -eq $cell_start.Y
    $right_cell = $cell_list | Where-Object -Property X -EQ $($cell_start.X + 1) | Where-Object -Property Y -eq $cell_start.Y

    [void]$connected.Add($up_cell)
    [void]$connected.Add($down_cell)
    [void]$connected.Add($left_cell)
    [void]$connected.Add($right_cell)

    foreach ($cell in $connected) {
        if ($cell -ne $null) {
            if ($cell.Occupied -eq $true -and $cell.link_num -eq $null) {
                $cell.Link_Num = $regnum
                get-connectedcells -cell_list $cell_list -cell_start $cell -regnum $regnum
            }
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

function generate-grid() {

    function new-cell {
        Param($x, $y)
    
        $properties = @{
            'X'        = $x
            'Y'        = $y
            'Occupied' = $false
            'Link_Num' = $null
        }
    
        $cell = New-Object -TypeName cell -Property $properties
    
        return $cell
    }

    $grid = new-object system.collections.arraylist

    for ($i = 0; $i -lt 128; $i++) {
        for ($j = 0; $j -lt 128; $j++) {
            $cell = new-cell -x $i -y $j
            $grid.add($cell)
        }
    }

    return $grid

}



$inputs = "jzgqcdpd"

$grid = generate-grid

$rows = 0..127 | foreach {
    (get-knothash "$inputs-$_")
}

$counter = 0

$binary_Str_array = new-object 'System.Collections.Generic.List[int]'

$binary_Str = -join ($rows| foreach {$_.getenumerator().foreach{$hex["$_"]}})

$binary_Str.GetEnumerator() | foreach {[void]$binary_Str_array.Add([int]$_)}


for ($i = 0; $i -lt 128; $i++) {
    for ($j = 0; $j -lt 128; $j++) {
        
        $($grid | Where-Object -Property X -eq $j | Where-Object -Property Y -eq $i).Occupied = [Convert]::ToBoolean([int]$binary_Str_array[$counter])
        $counter++
    }
}

$region_number = 0

for ($i = 0; $i -lt 128; $i++) {
    for ($j = 0; $j -lt 128; $j++) {
        
        $cell = $grid | Where-Object -Property X -eq $j | Where-Object -Property Y -eq $i
        if ($cell.link_num -eq $null) {
            $region_number++
            get-connectedcells -cell_list $grid -cell_start $cell -regnum $region_number
        }
    }
}


$region_number
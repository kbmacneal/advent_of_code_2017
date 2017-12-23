class point {
    [int]$position_x
    [int]$position_y
    [bool]$infected
}

class virus_carrier {
    [int]$position_x
    [int]$position_y
    [string]$facing_direction = "north"
    [int]$infected_count = 0
    [int]$clean_count = 0
    do_work($points) {
        if (($points | Where-Object -Property position_x -eq $this.position_x | Where-Object -Property position_y -EQ $this.position_y | measure-object).count -eq 0) {
            $point = New-Object -TypeName point
            $point.position_x = $this.position_x
            $point.position_y = $this.position_y
            $point.infected = $false
            $points.Add($point)
        }

        $current_point = $($points | Where-Object -Property position_x -eq $this.position_x | Where-Object -Property position_y -EQ $this.position_y)

        
        if ($current_point.infected -eq $true) {
            $turn = "right"
            
            $current_point.infected = $false
            $this.clean_count++
            switch ($this.facing_direction) {
                "north" { 
                    $this.facing_direction = "east"
                    $this.position_x++
                }
                "south" { 
                    $this.facing_direction = "west"
                    $this.position_x--
                }
                "east" { 
                    $this.facing_direction = "south"
                    $this.position_y--
                }
                "west" { 
                    $this.facing_direction = "north"
                    $this.position_y++
                }
                Default {

                    write-host "stop"
                }
            }
        }
        else {
            $turn = "left"
            
            $current_point.infected = $true
            $this.infected_count++
            switch ($this.facing_direction) {
                "north" { 
                    $this.facing_direction = "west"
                    $this.position_x--
                    
                }
                "south" { 
                    $this.facing_direction = "east"
                    $this.position_x++
                }
                "east" { 
                    $this.facing_direction = "north"
                    $this.position_y++
                    
                }
                "west" { 
                    $this.facing_direction = "south"
                    $this.position_y--
                }
                Default {
                    write-host "stop"
                }
            }
            
        }
    }
    
}

$inputs = get-content  .\input.txt

$array = New-Object System.Collections.ArrayList

foreach ($line in $inputs) {
    $list = New-Object System.Collections.ArrayList
    foreach ($char in $line.GetEnumerator()) {
        [void]$list.Add($char.ToString())
    }
    [void]$array.Add($list)
}

$points = New-Object System.Collections.ArrayList



$arr_y_size = $inputs.count
$arr_x_size = $inputs[0].Length

for ($y = 0; $y -lt $arr_y_size; $y++) {
    for ($x = 0; $x -lt $arr_x_size; $x++) {
        $infected = $false
        if ($array[$y][$x] -like "#") {
            $infected = $true
        }

        $point = New-Object point
        $point.position_x = $x
        $point.position_y = $y
        $point.infected = $infected
        [void]$points.Add($point)
    }
}

[int]$pos_x = [Math]::Floor($arr_x_size / 2)

[int]$pos_y = [Math]::Floor($arr_y_size / 2)

$virus = New-Object -TypeName virus_carrier
$virus.position_x = $pos_x
$virus.position_y = $pos_y
$virus.facing_direction = "north"

$tick = 0

do {
    
    $virus.do_work($points)
    $tick++
} while ($tick -lt 10000)

return $virus.infected_count
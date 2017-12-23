class point {
    [int]$position_x
    [int]$position_y
    [bool]$infected
    [bool]$cleaned
    [bool]$weakened
    [bool]$flagged
}
    
class virus_carrier {
    [int]$position_x
    [int]$position_y
    [string]$facing_direction = "north"
    [int]$infected_count = 0
    [int]$clean_count = 0
    [int]$flagged_count = 0
    [int]$weakened_count = 0
    do_work($points) {
        $current_point = $($points | Where-Object -Property position_x -eq $this.position_x | Where-Object -Property position_y -EQ $this.position_y)

        if (($points | Where-Object -Property position_x -eq $this.position_x | Where-Object -Property position_y -EQ $this.position_y | measure-object).count -eq 0) {
            $point = New-Object -TypeName point
            $point.position_x = $this.position_x
            $point.position_y = $this.position_y
            $point.infected = $false
            [void]$points.Add($point)
        }
    
        $turn = ""

        if ($current_point.infected -eq $true) {$turn = "right"}
        if ($current_point.cleaned -eq $true) {$turn = "left"}
        if ($current_point.flagged -eq $true) {$turn = "reverse"}
        if ($current_point.weakened -eq $true) {$turn = "steady"}

        switch ($turn) {
            "right" {
                $this.clean_count++
                ($points | Where-Object -Property position_x -eq $this.position_x | Where-Object -Property position_y -EQ $this.position_y) | % {$_.flagged = $true, $_.infected = $false}
    
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
            "left" { 
                $this.infected_count++
                ($points | Where-Object -Property position_x -eq $this.position_x | Where-Object -Property position_y -EQ $this.position_y) | % {$_.cleaned = $false; $_.weakened = $true}
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
            "reverse" { 
                $this.flagged_count++
                ($points | Where-Object -Property position_x -eq $this.position_x | Where-Object -Property position_y -EQ $this.position_y) | % {$_.flagged = $false; $_.cleaned = $true}
                switch ($this.facing_direction) {
                    "north" { 
                        $this.facing_direction = "south"
                        $this.position_y--
                        
                    }
                    "south" { 
                        $this.facing_direction = "north"
                        $this.position_y++
                    }
                    "east" { 
                        $this.facing_direction = "west"
                        $this.position_x--
                        
                    }
                    "west" { 
                        $this.facing_direction = "east"
                        $this.position_x++
                    }
                    Default {
                        write-host "stop"
                    }
                }
            }
            "steady" { 
                $this.infected_count++
                ($points | Where-Object -Property position_x -eq $this.position_x | Where-Object -Property position_y -EQ $this.position_y) | % {$_.weakened = $false; $_.infected = $true}
                switch ($this.facing_direction) {
                    "north" { 
                        $this.facing_direction = "north"
                        $this.position_y++
                        
                    }
                    "south" { 
                        $this.facing_direction = "south"
                        $this.position_y--
                    }
                    "east" { 
                        $this.facing_direction = "east"
                        $this.position_x++
                        
                    }
                    "west" { 
                        $this.facing_direction = "west"
                        $this.position_x--
                    }
                    Default {
                        write-host "stop"
                    }
                }
            }
            Default {
                write-host "stop"
            }
        }

    }
        
}
    
    
    
    
$inputs = get-content  .\input_test.txt
    
$array = New-Object System.Collections.ArrayList
    
foreach ($line in $inputs) {
    $list = New-Object System.Collections.ArrayList
    foreach ($char in $line.GetEnumerator()) {
        [void]$list.Add($char.ToString())
    }
    [void]$array.Add($list)
}
    
$points = New-Object Systen.Collections.ArrayList
    
    
    
$arr_y_size = $inputs.count
$arr_x_size = $inputs[0].Length
    
for ($y = 0; $y -lt $arr_y_size; $y++) {
    for ($x = 0; $x -lt $arr_x_size; $x++) {
        $infected = $false
        $cleaned = $false
        if ($array[$y][$x] -like "#") {
            $infected = $true
        }
        else {
            $cleaned = $true
        }
    
        $point = New-Object point
        $point.position_x = $x
        $point.position_y = $y
        $point.infected = $infected
        $point.cleaned = $cleaned
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
    
while ($tick -lt 10000000) {
        
    $virus.do_work($points)
    $tick++
}
    
return $virus.infected_count
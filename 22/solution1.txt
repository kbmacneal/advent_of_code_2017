class virus_carrier {
    [int]$position_x
    [int]$position_y
    [string]$facing_direction = "north"
    [int]$infected_count = 0
    [int]$clean_count = 0
    do_work($array)
    {
        increase_gridsize -array $array
        $turn = ""
        if($array[$this.position_y][$this.position_x] -eq "#")
        {
            $turn = "right"
            $this.clean_count++
            $array[$this.position_y][$this.position_x] = "."
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
                Default {}
            }
        }
        else{
            $turn = "left"
            $this.infected_count++
            $array[$this.position_y][$this.position_x] = "#"
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
                Default {}
            }
            
        }
    }
    
}

function increase_gridsize([System.Collections.ArrayList]$array)
{
    $new_top_size = $array[0].count
    $top = "." * $new_top_size

    $top_bot_arr = New-Object System.Collections.ArrayList
    foreach ($char in $top.GetEnumerator()) {
        [void]$top_bot_arr.Add($char)
    }

    $array.Insert(0,$top_bot_arr)
    $array.Insert($($array.count),$top_bot_arr)

    foreach ($item in $array) {
        $item.Insert(0,".")
        $item.Insert($($item.count),".")
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

$arr_y_size = $inputs.count
$arr_x_size = $inputs[0].Length

[int]$pos_x = [Math]::Ceiling($arr_x_size/2) -1

[int]$pos_y = [Math]::Ceiling($arr_y_size/2) -1

$virus = New-Object -TypeName virus_carrier
$virus.position_x = $pos_x
$virus.position_y = $pos_y
$virus.facing_direction = "north"

$tick = 0

while ($tick -lt 70) {
    
    $virus.do_work($array)
    $tick++
}

return $virus.infected_count

#5330
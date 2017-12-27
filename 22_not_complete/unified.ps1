#from https://www.reddit.com/r/adventofcode/comments/7lf943/2017_day_22_solutions/drm5ql1/

function turn ($current, $direction) {
    if ($direction -eq 'left') {
        $current--
    } elseif ($direction -eq 'right') {
        $current++
    } elseif ($direction -eq 'reverse') {
        $current += 2
    }
    $directions[$current % $directions.count]
}

function move-virus ($x, $y, $direction) {
    switch ($direction) {
        3 {$y--; break}
        2 {$x--; break}
        1 {$y++; break}
        0 {$x++; break}
    }
    $x
    $y
}
$directions = 0, 1, 2, 3  # 0 Right \  1 Down \ 2 Left \ 3 Up
$infected_count = 0
$in = Get-Content input.txt
$current_direction = 3 # up
$x = [math]::Floor($in[0].length / 2)
$y = [math]::Floor($in.count / 2)
$row_num = 0
$grid = foreach ($row in $in) {
    $col_num = 0
    foreach ($col in $row.ToCharArray()) {
        [pscustomobject] @{
            desc = "$row_num;$col_num"      
            val  = $col
        }
        $col_num++
    }
    $row_num++
}
#for part 2 set to true
$part2 = $false
if ($part2) {
    $loops = 10000000
} else {
    $loops = 10000
}

for ($i = 0; $i -lt $loops; $i++) {
    #Write-Verbose "x: $x y: $y dir: $current val: $(($grid.where{$_.desc -eq `"$y;$x`"}).val)"
    if (($t = $grid.IndexOf($($grid.where{$_.desc -eq "$y;$x"}))) -ge 0) {
        #exists
        switch ($grid[$t].val) {
            "." { #clear                                
                if (-not $part2) {
                    $infected_count++
                    $grid[$t].val = "#"
                } else {$grid[$t].val = "-"}
                $current_direction = turn -current $current_direction -direction left
                break
            }
            "#" { #infected
                if (-not $part2) {
                    $grid[$t].val = "."
                } else {
                    $grid[$t].val = "+"
                }
                $current_direction = turn -current $current_direction -direction right
                break
            }           
            "-" { #weakened
                if ($part2) {
                    $grid[$t].val = "#"
                    $infected_count++
                }
                break
            }
            "+" { #flagged
                if ($part2) {
                    $grid[$t].val = "."             
                    $current_direction = turn -current $current_direction -direction reverse
                }
                break
            }
        }       
    } else {
        #add new element to "grid"
        $grid += [pscustomobject] @{
            desc = "$y;$x"          
            val  = $(if ($part2) {"-"}else {"#"; $infected_count++})
        }               
        $current_direction = turn -current $current_direction -direction left        
    }
    $x, $y = move-virus -x $x -y $y -direction $current_direction
}
$infected_count
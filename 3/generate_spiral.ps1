function new-cell {

    Param($x, $y)

    $properties = [ordered]@{
        'X' = $x
        'Y' = $y
    }

    $cell = New-Object -TypeName psobject -Property $properties

    return $cell
}

function find-cellincelllist{

    Param($cell_to_find, $cell_list)

    foreach($cell in $cell_list){
        $return = $false
        if($cell_to_find.X -eq $cell.X -and $cell_to_find.Y -eq $cell.Y){$return = $true}
    }

    return $return
}


function determine-direction{

    param([System.Collections.ArrayList]$gridlist)



#rules
#when to go up: if there is no up and there is left and no right and there is down
#when to go down: if there is up, no down and there is a right
#when to go right: if there is an up, no right
#when to go left: if there is no left, there is a down, 

$last_cell = $gridlist | Select-Object -Last 1
$last_x = $last_cell.X
$last_y = $last_cell.Y

$up_cell = new-cell -x $last_x -y $($last_y+1)

$down_cell = new-cell -x $last_x -y $($last_y -1)

$left_cell = new-cell -x $($last_x -1) -y $last_y

$right_cell =new-cell -x $($last_x +1) -y $last_y


$go_up = if($(find-cellincelllist -cell_to_find $up_cell -cell_list $gridlist) -and $(find-cellincelllist -cell_to_find $left_cell -cell_list $gridlist)){$true}else{$false} 

$go_down = if($(find-cellincelllist -cell_to_find $up_cell -cell_list $gridlist) -and !$(find-cellincelllist -cell_to_find $down_cell -cell_list $gridlist) -and $(find-cellincelllist -cell_to_find $right_cell -cell_list $gridlist)){$true} else{$false}

$go_right = if($(find-cellincelllist -cell_to_find $up_cell -cell_list $gridlist) -and !$(find-cellincelllist -cell_to_find $right_cell -cell_list $gridlist)){$true} else{$false}

$go_down = if(!$(find-cellincelllist -cell_to_find $left_cell -cell_list $gridlist) -and $(find-cellincelllist -cell_to_find $down_cell -cell_list $gridlist)){$true} else{$false}

<#$go_up = if($gridlist -contains $up_cell -and $gridlist -contains $left_cell -and $gridlist -contains $right_cell){$true}else{$false}    
$go_down = if($up_cell -in $gridlist -and $down_cell -notin $gridlist -and $right_cell -in $gridlist){$true} else{$false}
$go_right = if($up_cell -in $gridlist -and $right_cell -notin $gridlist){$true}else{$false}
$go_left = if($left_cell -notin $gridlist -and $down_cell -in $gridlist){$true}else{$false}#>

if($go_up){return "up"}

if($go_down){return "down"}

if($go_left){return "left"}

if($go_right){return "right"}


}

  $point = new-cell -x 0 -y 0

  $grid = New-Object -TypeName System.Collections.ArrayList

  $null = $grid.Add($point)

  $point1 = new-cell -x 1 -y 0

  $null = $grid.Add($point1)

  $numbers = 0..23

  foreach($num in $numbers){

    $last_cell = $grid | Select-Object -Last 1
    $last_x = $last_cell.X
    $last_y = $last_cell.Y

    switch (determine-direction -gridlist $grid) {
        "up" {$null = $grid.Add($(new-cell -x $last_x -y $last_y+1))}
        "down"{$null = $grid.Add($(new-cell -x $last_x -y $last_y+1))}
        "left"{$null = $grid.Add($(new-cell -x $last_x -y $last_y+1))}
        "right"{$null =$grid.Add($(new-cell -x $last_x -y $last_y+1))}
        Default {break}
    }
  }

  $grid
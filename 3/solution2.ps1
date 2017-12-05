Import-Module -Name .\new_plan.psm1 -Force

function new-cell 
{
  Param($x, $y)

  $properties = [ordered]@{
    'X' = $x
    'Y' = $y
    'Ring' = $null
  }

  $cell = New-Object -TypeName psobject -Property $properties

  return $cell
}

function get-cell ($grid, $x, $y) {
  
  if(($grid | Where-Object -Property X -eq $x | Where-Object -Property y -eq $y) -eq $null)
  {
    $obj = New-Object -TypeName psobject -Property @{'Value' = 0}
    
        return $obj
  }
else
{
  return $($grid | Where-Object -Property X -eq $x | Where-Object -Property y -eq $y)
}

}

$grid = new-spiral -max_ring_size 5

foreach($cell in $grid)
{
  $cell.Value = 0
}

$grid[0].Value = 1

for ($i = 1; $i -lt $grid.Count; $i++) 
{
  $cell = $grid[$i]  

  $up_cell = get-cell -grid $grid -x $($cell.x) -y $($cell.Y + 1)
  $down_cell= get-cell -grid $grid -x $($cell.x) -y $($cell.Y - 1)
  $right_cell= get-cell -grid $grid -x $($cell.x + 1) -y $($cell.Y)
  $left_cell= get-cell -grid $grid -x $($cell.x - 1) -y $($cell.Y)

  #diagonals

  $diag_up_left_cell = get-cell -grid $grid -x $($cell.x-1) -y $($cell.Y + 1)
  $diag_up_right= get-cell -grid $grid -x $($cell.x+1) -y $($cell.Y + 1)
  $diag_down_left= get-cell -grid $grid -x $($cell.x - 1) -y $($cell.Y-1)
  $diag_down_right= get-cell -grid $grid -x $($cell.x + 1) -y $($cell.Y-1)

  $cell.Value = $($up_cell.Value) + $($down_cell.Value) + $($left_cell.Value) + $($right_cell.Value) + $($diag_up_left_cell.Value) + $($diag_up_right.Value) + $($diag_down_left.Value) + $($diag_down_right.Value)
} 

$grid | where-object -Property Value -gt 325489 | select -first 1
function new-spiral
{
  Param([int]$max_ring_size)

function new-cell 
{
  Param($x, $y)

  $properties = [ordered]@{
    'X' = $x
    'Y' = $y
  }

  $cell = New-Object -TypeName psobject -Property $properties

  return $cell
}

function get-middlecells 
{
  param($first_cell, $second_cell, [string]$direction)

  switch ($direction) {
    'up' 
    {
      [int]$x = $first_cell.X

      [int]$min_y = $first_cell.Y

      [int]$max_y = $second_cell.Y

      $results = New-Object -TypeName 'System.Collections.Generic.List[object]'

      [int]$i = $min_y + 1

      for ($i; $i -lt $max_y; $i++) 
      {
        $null = $results.Add($(new-cell -x $x -y $i))
      }

      return $results
    }
    'down' 
    {
      [int]$x = $first_cell.X
        
      [int]$min_y = $first_cell.Y #2
        
      [int]$max_y = $second_cell.Y #-2
        
      $results = New-Object -TypeName 'System.Collections.Generic.List[object]'
        
      [int]$i = $min_y - 1
        
      for ($i; $i -gt $max_y; $i--) 
      {
        $null = $results.Add($(new-cell -x $x -y $i))
      }

      return $results
    }
    'left' 
    {
      [int]$y = $first_cell.Y
        
      [int]$min_x = $first_cell.X
        
      [int]$max_x = $second_cell.X
        
      $results = New-Object -TypeName 'System.Collections.Generic.List[object]'
        
      [int]$i = $min_x - 1
        
      for ($i; $i -gt $max_x; $i--) 
      {
        $null = $results.Add($(new-cell -x $i -y $y))
      }

      return $results
    }
    'right' 
    {
      [int]$y = $first_cell.Y
        
      [int]$min_x = $first_cell.X
        
      [int]$max_x = $second_cell.X
        
      $results = New-Object -TypeName 'System.Collections.Generic.List[object]'
        
      [int]$i = $min_x + 1
        
      for ($i; $i -lt $max_x; $i++) 
      {
        $null = $results.Add($(new-cell -x $i -y $y))
      }

      return $results
    }
    Default 
    {

    }
  }
}

$grid = New-Object -TypeName 'System.Collections.Generic.List[object]'

[int[]]$rings = 2..$max_ring_size

[int[]]$first_xs = @(0, 1, 1, 0, -1, -1, -1, 0, 1)

[int[]]$first_ys = @(0, 0, 1, 1, 1, 0, -1, -1, -1)

for ($i = 0; $i -lt $first_xs.Count; $i++) 
{
  $cell = new-cell -x $first_xs[$i] -y $first_ys[$i]
  $null = $grid.Add($cell)
}

foreach($ring in $rings)
{
  $top_left = new-cell -x $(-1*$ring) -y $ring
  $top_right = new-cell -x $ring -y $ring
  $bottom_left = new-cell -x $($ring * -1) -y $($ring * -1)
  $bottom_right = new-cell -x $ring -y $($ring * -1)
  $curr_ring_first = new-cell -x $ring -y $(($ring * -1)+1)
  $last_ring_max = new-cell -x $ring -y $($ring + 1)

  $null = $grid.Add($curr_ring_first)

  $points = New-Object 'System.Collections.Generic.List[object]'

  $points = get-middlecells -first_cell $curr_ring_first -second_cell $top_right -direction up

  foreach($point in $points){$null = $grid.Add($point)}

  $null = $grid.Add($top_right)

  $points = New-Object 'System.Collections.Generic.List[object]'
    
  $points = get-middlecells -first_cell $top_right -second_cell $top_left -direction left

  foreach($point in $points){$null = $grid.Add($point)}

  $null = $grid.Add($top_left)

  $points = New-Object 'System.Collections.Generic.List[object]'
    
  $points = get-middlecells -first_cell $top_left -second_cell $bottom_left -direction down

  foreach($point in $points){$null = $grid.Add($point)}

  $null = $grid.Add($bottom_left)

  $points = New-Object 'System.Collections.Generic.List[object]'
    
  $points = get-middlecells -first_cell $bottom_left -second_cell $bottom_right -direction right

  foreach($point in $points){$null = $grid.Add($point)}

  $null = $grid.Add($bottom_right)

  "finished ring $ring"
}

$i = 1

foreach($point in $grid)
{
  $point | add-member -MemberType NoteProperty -Name "Value" -Value $i

  $i++
}

[GC]::Collect()

 return $grid
}



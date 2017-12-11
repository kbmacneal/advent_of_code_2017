function new-point
{
  Param($x, $y, $z)

  $properties = [ordered]@{
    'X' = $x
    'Y' = $y
    'Z' = $z
    'Distance' = ([Math]::Abs($x) + [Math]::Abs($y) + [Math]::Abs($z))/2
  }

  $obj = new-object -TypeName psobject -Property $properties

  return $obj
}
#use https://www.redblobgames.com/grids/hexagons/ for a guide on generating hex grids, casting to a normal rectangular grid won't work


$inputs = (get-content .\input.txt) -split ","

$position = new-point -x 0 -y 0

$pointlist = New-Object -TypeName System.Collections.ArrayList

$null = $pointlist.Add($position)

foreach ($command in $inputs) {

    $last_position = $pointlist[$($pointlist.Count-1)]
    switch ($command) {
        "n" { 
            $point = new-point -x $($last_position.X) -y $($last_position.Y + 1) -z $($last_position.Z - 1)
         }
         "ne" { 
            $point = new-point -x $($last_position.X +1) -y $($last_position.Y) -z $($last_position.Z - 1)
         }
         "se" { 
            $point = new-point -x $($last_position.X+1) -y $($last_position.Y - 1) -z $($last_position.Z)
         }
         "s" { 
            $point = new-point -x $($last_position.X) -y $($last_position.Y - 1) -z $($last_position.Z + 1)
         }
         "sw" { 
            $point = new-point -x $($last_position.X -1) -y $($last_position.Y) -z $($last_position.Z + 1)
         }
         "nw" { 
            $point = new-point -x $($last_position.X-1) -y $($last_position.Y + 1) -z $($last_position.Z)
         }
        Default {}
    }

    $null = $pointlist.Add($point)
}
$pointlist | Export-Csv -Delimiter "`t" -Path pointlist.txt -NoTypeInformation
$pointlist[$($pointlist.Count-1)]
$pointlist[$($pointlist.Count-1)].Distance
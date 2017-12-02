$input_array = New-Object -TypeName System.Collections.ArrayList

[int]$counter = 0

foreach($line in Get-Content -Path input.txt)
{
  $properties = [ordered]@{
    'LineNumber' = $counter
    'Array'    = $line -split '<TAB>'
  }
  $obj = New-Object -TypeName psobject -Property $properties

  [void]$input_array.Add($obj)

  $counter++
}


foreach($obj in $input_array)
{
  $intarray = New-Object -TypeName System.Collections.ArrayList

  foreach($item in $obj.Array)
  {
    [void]$intarray.Add([int]::Parse($item))
  }

  $max = $intarray |
  Sort-Object -Descending |
  Select-Object -First 1

  $min = $intarray |
  Sort-Object |
  Select-Object -First 1

  $obj | Add-Member -MemberType NoteProperty -Name Hash -Value $($max - $min) -TypeName int
}

$total = 0

foreach($hash in $input_array.hash)
{
  $total += $hash
}

$total
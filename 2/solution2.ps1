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

$total = 0


foreach($obj in $input_array)
{
  $results = New-Object -TypeName System.Collections.ArrayList

  for($i = 0; $i -lt $($obj.Array.Count); $i++)
  {
    $i_num = [int]::Parse($obj.Array[$i])
    
    for($p = 0; $p -lt $($obj.Array.Count); $p++)
    {
      $p_num = [int]::Parse($obj.Array[$p])

      if($i_num % $p_num -eq 0 -and $i_num -ne $p_num)
      {
        [void]$results.Add($i_num)
        [void]$results.Add($p_num)
      }
    }
  }

  $max = $results |
  Sort-Object -Descending |
  Select-Object -First 1

  $min = $results |
  Sort-Object |
  Select-Object -First 1

  $obj | Add-Member -MemberType NoteProperty -Name Hash -Value $($max / $min) -TypeName int
}

$total = 0

foreach($hash in $input_array.hash)
{
  $total += $hash
}

$total

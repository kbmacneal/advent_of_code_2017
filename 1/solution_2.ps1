function ToArray
{
  begin
  {
    $output = @()
  }
  process
  {
    $output += $_
  }
  end
  {
    return ,$output
  }
}

$initial_data = Get-Content -Path $PSScriptRoot\input.txt
#$initial_data = '12131415'

$input_collection = New-Object -TypeName System.Collections.Arraylist

foreach($item in $initial_data.GetEnumerator())
{
  [void]$input_collection.Add([Convert]::ToInt32($item.ToString()))
}

[int[]]$input_cleaned = $input_collection | ToArray


$first_half = $input_cleaned[0..$(($input_cleaned.Count/2)-1)]

$second_half = $input_cleaned[$($input_cleaned.Count/2)..$($input_cleaned.Count - 1)]

$results = New-Object -TypeName System.collections.arraylist

for($i = 0; $i -lt $first_half.Count; $i++)
{
  if($first_half[$i] -eq $second_half[$i])
  {
    [void]$results.Add($first_half[$i])
  }
}


[int]$total = 0 

$results | ForEach-Object -Process {
  $total = $total + [convert]::ToInt32($_,10)
}


$total * 2

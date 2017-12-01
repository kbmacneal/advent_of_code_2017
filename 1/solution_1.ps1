$initial_data = get-content $PSScriptRoot\input.txt
#$initial_data = "1122"

$input_collection = New-Object System.Collections.Arraylist

foreach($item in $initial_data.GetEnumerator())
{
    [void]$input_collection.Add($item)
}

$adjust = 8

$duplicates = New-Object system.Collections.Arraylist

for($i = 0; $i -lt $($input_collection.Count); $i++){

if($input_collection[$i] -eq $input_collection[$($i+1)])
{
[void]$duplicates.Add($input_collection[$i])

}    
}



[int]$total = 0 

$duplicates | ForEach-Object { 

$total = $total + [convert]::ToInt32($_,10)
}
 

$total += $adjust

$total
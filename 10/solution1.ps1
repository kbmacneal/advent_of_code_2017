function ToArray
{
  begin
  {
    $output = @(); 
  }
  process
  {
    $output += $_; 
  }
  end
  {
    return ,$output; 
  }
}

function loop-control ($i, $count) {
    if ($i -ge $($count - 1))
    {$i = 0}
    
    else {$i++}

    return $i
}

function clip-intlist([int]$startpos, [int]$length, $array)
{
    $reverse_string = new-object system.collections.arraylist

    $remain = new-object system.collections.arraylist

    $reversed = new-object system.collections.arraylist

    $left = [Math]::ABS($array.count - $length)

    $i = $startpos

    $decrement = $length


    while ($decrement -gt 0) {
        
            $reverse_string += [int]$array[$i]

            $decrement--

            $i = loop-control -i $i -count $array.count
        
    }   

    $j = $i
    while ($j -lt $array.count -and $left -gt 0) {
        $null = $remain.Add([int]$array[$j])
        $j++
        $left--
    }

    for($j = $i; $j -lt $left; $j++)
    {
        $null = $remain.add([int]$array[$j])
    }

    for ($i = $reverse_string.Count - 1; $i -ge 0 ; $i--) {
        $null = $reversed.add($reverse_string[$i])
    }
 
    $exit = New-Object -TypeName System.Collections.ArrayList
 
 
    foreach ($item in $reversed) {
        $null = $exit.Add($item)
    }
 
    foreach ($item in $remain) {
     $null = $exit.Add($item)
 }

    return $exit
}

#$range = 0..255

$range = 0..4

$list_of_numbers = new-object System.Collections.ArrayList

foreach ($item in $range) {
    $null = $list_of_numbers.Add($item)
}

$final = $list_of_numbers

$current_position = 0

$skip_size = 0

[int[]]$length_sequence = (get-content .\input_test.txt) -split ","

for ($i = 0; $i -lt $length_sequence.Count; $i++) {

    $return = New-Object System.Collections.ArrayList
    
   $return = clip-intlist -startpos $current_position -length $length_sequence[$i] -array $final

   $final = $null

   $final = New-Object System.Collections.ArrayList

   $final = $return
   

    $current_position = 1 + $skip_size

    $skip_size++

   
}

$final

return $final[0] * $final[1]
class intake {
    [string]$original
    [string]$transformation
    [object]$original_array
    [object]$transformation_array
}

$inputs = get-content .\input.txt

$intakes = New-Object System.Collections.ArrayList

foreach ($item in $inputs) {
    $arr = $item -split "=>"

    $intake = new-object intake

    $intake.original = $arr[0]
    $intake.transformation = $arr[1]

    $orig_size = ($intake.original -split "/")[0].Length

    $intake.original_array = New-Object 'object[,]' $orig_size,$orig_size
    $pos = 0
    for ($y = 0; $y -lt $orig_size; $y++) {
        for ($x = 0; $x -lt $orig_size; $x++) {
            $intake.original_array[$x,$y] = ($intake.original).Replace("/","")[$pos]

            $pos++
        }
        $pos++
    }
}

$array = New-Object 'object[,]' 4,5
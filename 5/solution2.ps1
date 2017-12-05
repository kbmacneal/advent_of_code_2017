$inputs = import-csv input.txt

#$inputs = import-csv input_test.txt

$instruction_list = @()

for ($i = 0; $i -lt $inputs.Count; $i++) {

    $properties = [ordered]@{
        'Instruction' = [Convert]::ToInt32($inputs[$i].INSTRUCTIONS)
        'Index' = $i
    }

    $obj = New-Object -TypeName psobject -Property $properties

    $instruction_list += $obj
}

$last_index = 0

    $i = 0

    $size = $instruction_list.Count

    $last_index = 0

    $counter = 0

    while ($i -lt $size -and $i -ge 0) {

        $counter++

        $last_instruction = $($instruction_list[$i].Instruction)

        $jump = $($instruction_list[$i]).Instruction

        
        if($jump -ge 3)
        {
            $($instruction_list[$i]).Instruction = $last_instruction - 1
        }
        else
        {
            $($instruction_list[$i]).Instruction = $last_instruction + 1
        }         

        $i += $jump
                     
    }
    return $counter

    
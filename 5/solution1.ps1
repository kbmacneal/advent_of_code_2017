$inputs = import-csv input.txt

#$instruction_list = New-Object 'System.Collections.Generic.List[object]'

$instruction_list = @()

for ($i = 0; $i -lt $inputs.Count; $i++) {
    #$inputs[$i] | Add-Member -MemberType NoteProperty -Name Index -Value $i

    $properties = [ordered]@{
        'Instruction' = $inputs[$i].INSTRUCTIONS
        'Index' = $i
    }

    $obj = New-Object -TypeName psobject -Property $properties

    #$null = $instruction_list.Add($obj)

    $instruction_list += $obj
}

$last_index = 0

    $i = 0

    $size = $instruction_list.Count

    $last_index = 0

    $counter = 1

    while ($i -lt $size -and $i -ge 0) {

        $last_index = $($instruction_list[$i]).Index

        $last_instruction = [Convert]::ToInt32(($instruction_list | where-object -Property Index -eq $last_index).Instruction)

        $jump = [Convert]::ToInt32($($instruction_list[$i]).Instruction)

        $($instruction_list[$last_index]).Instruction = $last_instruction + 1

        #$($instruction_list | where-object -Property Index -eq $last_index).Instruction = $last_instruction + 1

        $i = $i + $jump

        #$i

        $counter++       
    }

    return $counter





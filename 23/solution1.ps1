class command {
    [string]$command;
    [string]$register;
    [string]$value;
}


$inputs = get-content .\input.txt

$command_array = @()

foreach ($command in $inputs) {
    $obj = New-Object -TypeName command
    $arr = $command -split " "

    $obj.command = $arr[0]
    $obj.register = $arr[1]

    if ($arr.count -gt 2) {
        $obj.value = $arr[2]
    }
    $command_array += $obj
}

$registers = @{}

foreach ($command in $command_array) {
    if (!($registers[$command.register]) -and $command.register -match "[a-z]") {
        $registers[$command.register] = 0
    }
}

$registers["a"] = 1

$mul_count = 0

for ($i = 0; $i -lt $command_array.Count; $i++) {

    $command = $command_array[$i]

    if (!($registers[$($command.register)])) {
        $registers[$($command.register)] = 0
    }

    switch ($($command.command)) {  
        "set" { 

            $parse_test = 0

            if ([Int64]::TryParse($($command.value), [ref]$parse_test)) {
                $registers[$($command.register)] = [long]($command.value)
            }
            else {
                $registers[$($command.register)] = [long]$registers[$($command.value)]
            }
        }
        "sub" { 
            $parse_test = 0

            if ([Int64]::TryParse($($command.value), [ref]$parse_test)) {
                $registers[$($command.register)] = $registers[$($command.register)] - [long]$command.value
            }
            else {
                $registers[$($command.register)] = $registers[$($command.register)] - [long]$registers[$($command.value)]
            }
        }
        "mul" { 

            $parse_test = 0
            $mul_count++

            if ([Int64]::TryParse($($command.value), [ref]$parse_test)) {
                $registers[$($command.register)] = [long]$registers[$($command.register)] * $($command.value)
            }
            else {
                $registers[$($command.register)] = [long]$registers[$($command.register)] * [long]$registers[$($command.value)]
            }
        }
        "jnz" { 
            $parse_test = 0

            if ([Int64]::TryParse($($command.register), [ref]$parse_test)) {
                if ([long]$($command.register) -ne 0) {
                    $i = $i + [long]$command.value - 1 
                }
            }
            else {
                if ([long]$registers[$($command.register)] -ne 0) {
                    $i = $i + [long]$command.value - 1
                }
            }			
        }

        Default {}
    }
}

#return $mul_count
return $registers["h"]
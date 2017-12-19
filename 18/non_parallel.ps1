

class command {
    [string]$command;
    [string]$register;
    [string]$value;
}

class Program {
    [HashTable]$regs = @{};
    [system.collections.queue]$queue;
    [system.collections.queue]$otherqueue;
    [int]$program_id;
    [bool]$locked = $false
    [int]$send_count = 0;
    [int]$position = 0;
    [System.Collections.ArrayList]$command_list;
    run()
    {
        $this.execute_next($this.command_list)
    }
    snd($command) {
        $parse_test = 0
        $registers = $this.regs

        $this.send_count++
        if ([Int64]::TryParse($($command.register), [ref]$parse_test)) {
            $this.otherqueue.Enqueue([long]$($command.register))
        }
        else {
            $this.otherqueue.Enqueue($([long]$registers[$($command.register)]))
        }
    }
    set($command) {
        $registers = $this.regs

        $parse_test = 0

        if ([Int64]::TryParse($($command.value), [ref]$parse_test)) {
            $registers[$($command.register)] = [long]($command.value)
        }
        else {
            $registers[$($command.register)] = [long]$registers[$($command.value)]
        }
    }
    add($command) {
        $registers = $this.regs

        $registers[$($command.register)] = $registers[$($command.register)] + [long]$command.value
    }
    mul($command) {
        $registers = $this.regs
        $parse_test = 0

        if ([Int64]::TryParse($($command.value), [ref]$parse_test)) {
            $registers[$($command.register)] = [long]$registers[$($command.register)] * $($command.value)
        }
        else {
            $registers[$($command.register)] = [long]$registers[$($command.register)] * [long]$registers[$($command.value)]
        }
    }
    mod($command) {
        $registers = $this.regs
        $parse_test = 0

        if ([Int64]::TryParse($($command.value), [ref]$parse_test)) {
            $registers[$($command.register)] = [long]$registers[$($command.register)] % [long]$($command.value)
        }
        else {
            $registers[$($command.register)] = [long]$registers[$($command.register)] % [long]$registers[$($command.value)]
        }
    }
    rcv($command) {
        $registers = $this.regs
        if ($this.queue.Count -gt 0) {
            $this.locked = $false
            $registers[$($command.register)] = [long]$this.queue.Dequeue()
        }
        else {
            $this.locked = $true
        }
    }
    [int] jgz($command, $i) {
        $registers = $this.regs

        $parse_test = 0

        if([long]::TryParse($($command.value), [ref]$parse_test))
        {
            if([long]::TryParse($($command.register), [ref]$parse_test))
            {
                if([long]$command.register -gt 0)
                {
                    $i = $i + $command.value -1
                }
            }
            else {
                if($registers[$($command.register)] -gt 0)
                {
                    $i = $i + [long]$command.value - 1
                }

            }
        }
        else{
            if ($registers[$command.register] -gt 0) {
                
            }
            $i = $i + [long]$registers[$command.value] -1
        }

        <#if ([Int64]::TryParse($($command.register), [ref]$parse_test)) {
            if ([long]$($command.register) -gt 0) {
                $i = $i + [long]$command.value -1
            }
        }
        else {
            if ([long]$registers[$($command.register)] -gt 0) {

                #3+17-1
                $i = $i + $registers[$($command.value)] - 1
            }
        }#>

        return $i
    }
    execute_next($command_list) {
        if ($this.position -gt $command_list.count) {
            $this.locked = $true
        }

        $pos = [int]$this.position

        $command = $command_list[$pos]

        switch ($command.command) {
            "set" { 
                $this.set($command)
            }
            "add" { 
                $this.add($command)
            }
            "mul" {
                $this.mul($command)
            }
            "mod" { 
                $this.mod($command)
            }
            "snd" {
                $this.snd($command)
            }
            "rcv" {
                $this.rcv($command)
            }
            "jgz" { 
                $this.position = $this.jgz($command, $this.position)
            }
            Default {}
        }

        if ($this.locked) {
            return
        }
        else {
            $this.position++
        }
    }

}


$inputs = get-content .\input.txt

$command_array = new-object system.collections.arraylist
	

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

$program1 = New-Object -TypeName Program
$program1.regs = @{}
$program1.queue = New-Object System.collections.queue
$program1.program_id = 0
$program1.regs["p"] = 0
$program1.locked = $false


$program2 = New-Object -TypeName program
$program2.regs = @{}
$program2.queue = New-Object System.collections.queue
$program2.program_id = 1
$program2.regs["p"] = 1
$program2.locked = $false

$program1.otherqueue = $program2.queue
$program2.otherqueue = $program1.queue

$program1.position = 0
$program2.position = 0

foreach ($command in $command_array) {
    if (!($program1.regs[$command.register]) -and $command.register -match "[a-z]") {
        $program1.regs[$command.register] = 0
    }
    if (!($program2.regs[$command.register]) -and $command.register -match "[a-z]") {
        $program2.regs[$command.register] = 0
    }
}
$count = 0

<#while ($true) {
    
    $count++

    $program1.execute_next($command_array)
    $program2.execute_next($command_array)

    if ($program1.locked -eq $true -and $program2.locked -eq $true) {
        return $program1.send_count
    }
	
}#>

$program1.command_list = $command_array
$program2.command_list = $command_array

do {
    
write-host $program1.command_list[$program1.position]

    $program1.run()
    $program2.run()

    

} until ($program1.locked -and $program2.locked)
return $program1.send_count

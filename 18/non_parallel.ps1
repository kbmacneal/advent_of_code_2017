

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

        if ([Int64]::TryParse($($command.register), [ref]$parse_test)) {
            if ([long]$($command.register) -gt 0) {
                $i = $i + [long]$command.value - 1 
            }
        }
        else {
            if ([long]$registers[$($command.register)] -gt 0) {
                $i = $i + $registers[$($command.register)] - 1
            }
        }

        return $i
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

$position1 = 0
$position2 = 0

foreach($command in $command_array)
{
	if(!($program1.regs[$command.register]) -and $command.register -match "[a-z]")
	{
		$program1.regs[$command.register] = 0
	}
	if(!($program2.regs[$command.register]) -and $command.register -match "[a-z]")
	{
		$program2.regs[$command.register] = 0
	}
}

do {
    $command1 = $command_array[$position1]
    $command2 = $command_array[$position2]

    switch ($command1.command) {
        "set" { 
            $program1.set($command1)
        }
        "add" { 
            $program1.add($command1)
        }
        "mul" {
            $program1.mul($command1)
        }
        "mod" { 
            $program1.mod($command1)
        }
        "snd" {
            $program1.snd($command1)
        }
        "rcv" {
            $program1.rcv($command1)
        }
        "jgz" { 
            $position1 = $program1.jgz($command1, $position1)
        }
        Default {}
    }

    switch ($command2.command) {
        "set" { 
            $program2.set($command2)
        }
        "add" { 
            $program2.add($command2)
        }
        "mul" {
            $program2.mul($command2)
        }
        "mod" { 
            $program2.mod($command2)
        }
        "snd" {
            $program2.snd($command2)
        }
        "rcv" {
            $program2.rcv($command2)
        }
        "jgz" { 
            $position2 = $program2.jgz($command2, $position2)
        }
        Default {}
    }

    if ($program1.locked -eq $false) {
        $position1++
    }
    if ($program2.locked -eq $false) {
        $position2++
	}
	

} until (($program1.locked -eq $true -and $program2.locked -eq $true))

return $program1.send_count
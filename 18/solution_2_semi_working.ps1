

class command
{
	[string]$command;
	[string]$register;
	[string]$value;
}

class Program
{
	[HashTable]$regs = @{};
	[system.collections.queue]$queue;
	[system.collections.queue]$otherqueue;
	[int]$program_id;
	[bool]$locked = $false
	[int]$send_count = 0;
	[int]$position = 0;
	[System.Collections.ArrayList]$command_list;

	snd($command)
 {
		#snd X sends the value of X to the other program. These values wait in a queue until that program is ready to receive them. Each program has its own message queue, so a program can never receive a message it sent.
        
		$registers = $this.regs

		$this.send_count++
		$reg = $command.register
        

		if ($reg -match "[a-z]")
		{
			$this.otherqueue.Enqueue($([long]$registers[$($command.register)]))
		}
		else
		{
			$this.otherqueue.Enqueue([long]$($command.register))
		}

	}
	set($command)
 {
		#set X Y sets register X to the value of Y.

		$registers = $this.regs
        
		$val = $command.value


		if ($val -match "[a-z]")
		{
			$registers[$($command.register)] = [long]$registers[$($command.value)]
		}
		else
		{
			$registers[$($command.register)] = [long]($command.value)
		}

	}
	add($command)
 {
		#add X Y increases register X by the value of Y.

		$registers = $this.regs
        
		$val = $command.value

		if ($val -match "[a-z]")
		{
			$registers[$($command.register)] = $registers[$($command.register)] + $registers[$($command.value)]
		}
		else
		{
			$registers[$($command.register)] = $registers[$($command.register)] + [long]$command.value
		}

        
	}
	mul($command)
 {
		#mul X Y sets register X to the result of multiplying the value contained in register X by the value of Y.

		$registers = $this.regs
        
		$val = $command.value
        
		if ($val -match "[a-z]")
		{
			$registers[$($command.register)] = [long]$registers[$($command.register)] * [long]$registers[$($command.value)]
		}
		else
		{
			$registers[$($command.register)] = [long]$registers[$($command.register)] * $($command.value)
		}

	}
	mod($command)
 {
		#mod X Y sets register X to the remainder of dividing the value contained in register X by the value of Y (that is, it sets X to the result of X modulo Y).

		$registers = $this.regs
        
		$val = $command.value
        
		if ($val -match "[a-z]")
		{
			$registers[$($command.register)] = [long]$registers[$($command.register)] % [long]$registers[$($command.value)]
		}
		else
		{
			$registers[$($command.register)] = [long]$registers[$($command.register)] % [long]$($command.value)
		}
	}
	rcv($command)
 {
		#rcv X receives the next value and stores it in register X. If no values are in the queue, the program waits for a value to be sent to it. Programs do not continue to the next instruction until they have received a value. Values are received in the order they are sent.

		$registers = $this.regs
		if ($this.queue.Count -gt 0)
		{
			$this.locked = $false
			$registers[$($command.register)] = [long]$this.queue.Dequeue()
		}
		else
		{
			$this.locked = $true
		}
	}
	[int] jgz($command, $i)
 {
		#jgz X Y jumps with an offset of the value of Y, but only if the value of X is greater than zero. (An offset of 2 skips the next instruction, an offset of -1 jumps to the previous instruction, and so on.)

		$reg = $command.register
		$val = $command.value

		$registers = $this.regs

		$parse_test = 0

		if ($val -match "[a-z]")
		{

			if ($reg -match ".[0-9]")
			{
				if ($reg -gt 0)
				{
					$i = $i + $registers[$val] - 1
				}
			}
			else
			{
				if ($($registers[$reg]) -gt 0)
				{
					$i = $i + $registers[$val] - 1
				}
			}
		}
		else
		{
			if ($reg -match ".[0-9]")
			{
				if ($reg -gt 0)
				{
					$i = $i + $val - 1
				}
			}
			else
			{
				if ($($registers[$reg]) -gt 0)
				{
					$i = $i + $val - 1
				}
			}
		}

		return $i
	}
	execute_next($command_list)
 {
		if ($this.position -gt $command_list.count)
		{
			$this.locked = $true
		}

		$pos = [int]$this.position

		$command = $command_list[$pos]

		switch ($command.command)
		{
			"set"
			{ 
				$this.set($command)
			}
			"add"
			{ 
				$this.add($command)
			}
			"mul"
			{
				$this.mul($command)
			}
			"mod"
			{ 
				$this.mod($command)
			}
			"snd"
			{
				$this.snd($command)
			}
			"rcv"
			{
				$this.rcv($command)
			}
			"jgz"
			{ 
				$this.position = $this.jgz($command, $this.position)
			}
			Default {}
		}

		if ($this.locked)
		{
			return
		}
		else
		{
			$this.position++
		}
	}

}


$inputs = get-content .\input.txt

$command_array = new-object system.collections.arraylist
	

foreach ($command in $inputs)
{
	$obj = New-Object -TypeName command
	$arr = $command -split " "

	$obj.command = $arr[0]
	$obj.register = $arr[1]

	if ($arr.count -gt 2)
 {
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

foreach ($command in $command_array)
{
	if (!($program1.regs[$command.register]) -and $command.register -match "[a-z]")
 {
		$program1.regs[$command.register] = 0
	}
	if (!($program2.regs[$command.register]) -and $command.register -match "[a-z]")
 {
		$program2.regs[$command.register] = 0
	}
}

$program1.command_list = $command_array
$program2.command_list = $command_array

do
{
    if($program1.regs["i"] -lt 1)
    {
        write-host here
    }
	$program1.execute_next($program1.command_list)
	$program2.execute_next($program2.command_list)
  
} until ($program1.locked -and $program2.locked)
return $program1.send_count

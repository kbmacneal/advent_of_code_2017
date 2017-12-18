class command
{
	[string]$command;
	[string]$register;
	[string]$value;
}

class program
{
	[HashTable]$registers = @{};
	[system.collections.queue]$input_queue;
	[int]$program_id;
	[int]$send_count = 0;
	[bool]$locked = $false;
}

function snd($registers, $command, $sender)
{ 
	#$last_frequency = [long]$registers[$($command.register)]
	if ($sender -eq 1)
 {
		$parse_test = 0
		
		$program1.send_count++
		if ([Int64]::TryParse($($command.register), [ref]$parse_test))
		{
			$program2.input_queue.enqueue($($command.register))
		}
		else 
		{
			$program2.input_queue.enqueue($([long]$registers[$($command.register)]))
			#$registers[$($command.register)] = [long]$registers[$($command.value)]
		}
					
	}
	else
 {
		$parse_test = 0
		
		$program2.send_count++
		if ([Int64]::TryParse($($command.register), [ref]$parse_test))
		{
			$program1.input_queue.enqueue($($command.register))
		}
		else 
		{
			$program1.input_queue.enqueue($([long]$registers[$($command.register)]))
			#$registers[$($command.register)] = [long]$registers[$($command.value)]
		}
	}
}
function set ($registers, $command, $sender)
{ 

	$parse_test = 0

	if ([Int64]::TryParse($($command.value), [ref]$parse_test))
 {
		$registers[$($command.register)] = [long]($command.value)
	}
	else 
 {
		$registers[$($command.register)] = [long]$registers[$($command.value)]
	}


			
}
function add ($registers, $command, $sender)
{ 
	$registers[$($command.register)] = $registers[$($command.register)] + [long]$command.value
}
function mul($registers, $command, $sender)
{ 

	$parse_test = 0

	if ([Int64]::TryParse($($command.value), [ref]$parse_test))
 {
		$registers[$($command.register)] = [long]$registers[$($command.register)] * $($command.value)
	}
	else 
 {
		$registers[$($command.register)] = [long]$registers[$($command.register)] * [long]$registers[$($command.value)]
	}

			
}
function mod($registers, $command, $sender)
{
	$parse_test = 0

	if ([Int64]::TryParse($($command.value), [ref]$parse_test))
 {
		$registers[$($command.register)] = [long]$registers[$($command.register)] % [long]$($command.value)
	}
	else 
 {
		$registers[$($command.register)] = [long]$registers[$($command.register)] % [long]$registers[$($command.value)]
	}


			
}
function rcv($registers, $command, $sender)
{
	if ($sender -eq 1)
 {
		if ($program1.input_queue.Count -gt 0)
		{
			$registers[$($command.register)] = [long]$($command.value)
		}
		else
		{
			$program1.locked = $true
		}
	}
	else
	{
		if ($program2.input_queue.Count -gt 0)
		{
			$registers[$($command.register)] = [long]$($command.value)
		}
		else
		{
			$program2.locked = $true
		}
	}
	
}
function jgz 
{ 
	$parse_test = 0

	if ([Int64]::TryParse($($command.register), [ref]$parse_test))
 {
		if ([long]$($command.register) -gt 0)
		{
			$i = $i + [long]$command.value - 1 
		}
	}
	else 
 {
		if ([long]$registers[$($command.register)] -gt 0)
		{
			$i = $i + $registers[$($command.register)] - 1
		}
	}

					
}

$inputs = get-content .\input.txt

$command_array = new-object system.collections.arraylist

$programs = @()
	

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


$program1 = New-Object -TypeName program
$program1.registers = @{}
$program1.input_queue = New-Object System.collections.queue
$program1.program_id = 0
$program1.registers["p"] = 0

$program2 = New-Object -TypeName program
$program2.registers = @{}
$program2.input_queue = New-Object System.collections.queue
$program2.program_id = 1
$program2.registers["p"] = 1

$programs += $program1
$programs += $program2

foreach ($command in $command_array)
{
	foreach ($program in $programs) {
		
	}
	
}


return $program2.send_count
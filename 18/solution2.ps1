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
	run($reg, $send)
	{
		do_commands -registers $reg -sender $send
		#$scriptblock = {do_commands -registers $reg -sender $send}
		#Start-Job -ScriptBlock $scriptblock
	}
}

function do_commands($registers, $sender)
{

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

	for ($i = 0; $i -lt $command_array.Count; $i++)
 {
	 
		$command = $command_array[$i]

		if (!($registers[$($command.register)]))
		{
			$parse_test = 0

			if ([Int64]::TryParse($($command.register), [ref]$parse_test))
			{

			}
			else 
			{
				$registers[$($command.register)] = 0
			}
			
		}

		switch ($($command.command))
		{
			"snd"
			{ 
				#$last_frequency = [long]$registers[$($command.register)]
				if ($sender -eq 1)
				{
					$parse_test = 0
					$Global:program1.send_count++
					if ([Int64]::TryParse($($command.register), [ref]$parse_test))
					{
						$Global:program2.input_queue.enqueue($($command.register))
					}
					else 
					{
						$Global:program2.input_queue.enqueue($([long]$registers[$($command.register)]))
						#$registers[$($command.register)] = [long]$registers[$($command.value)]
					}
					
				}
				else
				{
					$parse_test = 0
					$Global:program2.send_count++
					if ([Int64]::TryParse($($command.register), [ref]$parse_test))
					{
						$Global:program1.input_queue.enqueue($($command.register))
					}
					else 
					{
						$Global:program1.input_queue.enqueue($([long]$registers[$($command.register)]))
						#$registers[$($command.register)] = [long]$registers[$($command.value)]
					}
				}
			}
			"set"
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
			"add"
			{ 
				$registers[$($command.register)] = $registers[$($command.register)] + [long]$command.value
			}
			"mul"
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
			"mod"
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
			"rcv"
			{
				#if ([int]$registers[$($command.register)] -gt 0)
				#{
				#return [long]$last_frequency
				#$registers[$($command.register)] = [long]$last_frequency

				if ($sender -eq 1)
				{
					if ($Global:program1.input_queue.Count -gt 0)
					{
						$registers[$($command.register)] = [long]$($command.value)
					}
					else
					{
						$Global:program1.locked = $true

						
						do
						{
							if ($Global:program2.locked -eq $true)
							{
								return
							}
							start-sleep -Seconds 1
						} until ($Global:program1.input_queue.Count -gt 0)
						$i--
					}
				}
				else
				{
					if ($Global:program2.input_queue.Count -gt 0)
					{
						$registers[$($command.register)] = [long]$($command.value)
					}
					else
					{
						$Global:program2.locked = $true

						if ($Global:program1.locked -eq $true)
						{
							return
						}
						do
						{
							if ($Global:program1.locked -eq $true)
							{
								return
							}
							start-sleep -Seconds 1
						} until ($Global:program2.input_queue.Count -gt 0)
						$i--
					}
				}
				#}
			}
			"jgz"
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
						$i = $i + [long]$command.value - 1
					}
				}

					
			}

			Default {}
		}


	}
}




$Global:program1 = New-Object -TypeName program
$Global:program1.registers = @{}
$Global:program1.input_queue = New-Object System.collections.queue
$Global:program1.program_id = 0
$Global:program1.registers["p"] = 0

$Global:program2 = New-Object -TypeName program
$Global:program2.registers = @{}
$Global:program2.input_queue = New-Object System.collections.queue
$Global:program2.program_id = 1
$Global:program2.registers["p"] = 1

$scriptblock = {
	$Global:program1.run($Global:program1.registers,1)
}
start-job -ScriptBlock $scriptblock -name "Program1"

$scriptblock = {
	$Global:program2.run($Global:program2.registers,2)
}

start-job -ScriptBlock $scriptblock -name "Program2"

Wait-Job -Name "Program1"
return $Global:program1.send_count
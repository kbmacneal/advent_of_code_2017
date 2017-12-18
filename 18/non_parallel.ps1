#after reding this https://github.com/PowerShell/PowerShell/issues/3651 it may not be possible to code this in powershell due to class methods running serially insttead of concurrently. run dotnet run on the dueling_programs directory to get the answer, but at this point it looks like its not possible in powershell to run methods concurrently

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
	[int]$send_count = 0;
	run()
 {

		$registers = $this.regs

		$inputs = get-content .\input_test_2.txt

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
					$parse_test = 0

					$this.send_count++
					if ([Int64]::TryParse($($command.register), [ref]$parse_test))
					{
						$this.otherqueue.Enqueue($($command.register))
					}
					else 
					{
						$this.otherqueue.Enqueue($([long]$registers[$($command.register)]))
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
					if ($this.queue.Count -gt 0)
					{
						$registers[$($command.register)] = [long]$this.queue.Dequeue()
					}
					else
					{
						return
					}
					
					
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
							$i = $i + $registers[$($command.register)] - 1
						}
					}

					
				}

				Default {}
			}


		}
	}
}

Import-Module -Name .\CreateClassInstanceHelper.psm1

$Global:program1 = New-UnboundClassInstance -type program -arguments $null
#$Global:Global:program1 = New-Object -TypeName program
$Global:program1.regs = @{}
$Global:program1.queue = New-Object System.collections.queue
$Global:program1.program_id = 0
$Global:program1.regs["p"] = 0

$Global:program2 = New-UnboundClassInstance -type program -arguments $null
#$Global:program2 = New-Object -TypeName program
$Global:program2.regs = @{}
$Global:program2.queue = New-Object System.collections.queue
$Global:program2.program_id = 1
$Global:program2.regs["p"] = 1


$Global:program1.otherqueue = $Global:program2.queue
$Global:program2.otherqueue = $Global:program1.queue



do
{
	#[System.Windows.Threading.Dispatcher]::InvokeAsync($program1.run())
	#[System.Windows.Threading.Dispatcher]::InvokeAsync($program2.run())
	$Global:program2.run()
	$Global:program1.run()
	

} while ($Global:program2.queue.Count -ne 0)

#$program1 | Format-List
#$program2 | Format-List
return $Global:program1.send_count
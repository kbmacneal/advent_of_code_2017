class command
{
	[string]$command;
	[string]$register;
	[string]$value;
}


$inputs = get-content .\input.txt

$command_array = @()

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

$registers = @{}

$last_frequency = 0

for ($i = 0; $i -lt $command_array.Count; $i++)
{

	$command = $command_array[$i]

	if (!($registers[$($command.register)]))
	{
		$registers[$($command.register)] = 0
	}

	switch ($($command.command))
 {
		"snd"
		{ 
			$last_frequency = [long]$registers[$($command.register)]
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
			if ([int]$registers[$($command.register)] -gt 0)
			{
				return [long]$last_frequency
				#$registers[$($command.register)] = [long]$last_frequency
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
					$i = $i + [long]$command.value - 1
				}
			}

					
		}

		Default {}
	}


}

	
return $last_frequency
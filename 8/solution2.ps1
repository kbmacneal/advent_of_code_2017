class register {
    [string]$Name
    [int]$Value = 0
  }
  
  class command {
    [string]$register
    [string]$increase
    [int]$amount
    [string]$condition_target
    [string]$operator
    [int]$comparator
  
  }
  
  $inputs = get-content .\input.txt
  $commands = new-object System.Collections.ArrayList
  
  $max = 0
  
  foreach ($item in $inputs) {
      
    $item_array = $item -split " "
  
    $command = New-Object -typename command
  
    $command.register = $item_array[0]
    $command.increase = $item_array[1]
    $command.amount = $item_array[2]
    $command.condition_target = $item_array[4]
    $command.operator = $item_array[5]
    $command.comparator = $item_array[6]
  
    $null = $commands.add($command)
  }
  
  $register_list = new-object -TypeName 'System.Collections.Generic.Dictionary[string,int]'
  
  foreach($command in $commands)
  {
    if(!($register_list.ContainsKey($($command.register))))
    {        
        $register_list.Add($command.register, 0)
    }
  }
  
  foreach($command in $commands)
  {
  switch ($command.increase) {
    "inc"
    { 
      $operator = $command.comparator
      switch ($command.operator) {
        '>' 
        { 
            if($register_list["$($command.condition_target)"]  -gt $operator)
            {
                $register_list["$($command.register)"] = $register_list[$($command.register)] + $($command.amount)
            }
          
        }
        '<' 
        {
            if($register_list["$($command.condition_target)"]  -lt $operator)
            {
                $register_list["$($command.register)"] = $register_list[$($command.register)] + $($command.amount)
            }
        }
        '>=' 
        {
            if($register_list["$($command.condition_target)"]  -ge $operator)
            {
                $register_list["$($command.register)"] = $register_list[$($command.register)] + $($command.amount)
            }
        }
        '<=' 
        {
            if($register_list["$($command.condition_target)"]  -le $operator)
            {
                $register_list["$($command.register)"] = $register_list[$($command.register)] + $($command.amount)
            }
        }
        '==' 
        {
            if($register_list["$($command.condition_target)"]  -eq $operator)
            {
                $register_list["$($command.register)"] = $register_list[$($command.register)] + $($command.amount)
            }
        }
        '!=' 
        {
            if($register_list["$($command.condition_target)"]  -ne $operator)
            {
                $register_list["$($command.register)"] = $register_list[$($command.register)] + $($command.amount)
            }
        }
  
        Default 
        {
  
        }
      }
    }
    "dec"
    {
        $operator = $command.comparator
        switch ($command.operator) {
          '>' 
          { 
              if($register_list["$($command.condition_target)"]  -gt $operator)
              {
                $register_list["$($command.register)"] = $register_list[$($command.register)] - $($command.amount)
              }
            
          }
          '<' 
          {
              if($register_list["$($command.condition_target)"]  -lt $operator)
              {
                $register_list["$($command.register)"] = $register_list[$($command.register)] - $($command.amount)
              }
          }
          '>=' 
          {
              if($register_list["$($command.condition_target)"]  -ge $operator)
              {
                $register_list["$($command.register)"] = $register_list[$($command.register)] - $($command.amount)
              }
          }
          '<=' 
          {
              if($register_list["$($command.condition_target)"]  -le $operator)
              {
                $register_list["$($command.register)"] = $register_list[$($command.register)] - $($command.amount)
              }
          }
          '==' 
          {
              if($register_list["$($command.condition_target)"]  -eq $operator)
              {
                $register_list["$($command.register)"] = $register_list[$($command.register)] - $($command.amount)
              }
          }
          '!=' 
          {
              if($register_list["$($command.condition_target)"]  -ne $operator)
              {
                $register_list["$($command.register)"] = $register_list[$($command.register)] - $($command.amount)
              }
          }
  
          Default 
          {
  
          }
        }
    }
    Default 
    {
  
    }
  }
foreach($key in $register_list.Values)
{
    if($key -gt $max)
    {
        $max = $key
    }
}

  }
  
$max
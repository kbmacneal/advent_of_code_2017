#based on the math posted to the subreddit, you know that the string loops back into a predictable state somewhere in the first 19600 attempts. if you know that, you can build the algorithm that way from the beginning

function perform_dance($programs, $inputs) {
    
    
    foreach ($command in $inputs) {
        switch ($command.tostring().substring(0, 1)) {
            "s" { 
                $number = [int]$command.tostring().substring(1, $($command.tostring().length - 1))
                [string[]]$temp_array = , "" * $number
                [string[]]$beg_array = , "" * ($programs.count - $number)
                
                [Array]::Copy($programs, $($programs.Count - $number), $temp_array, 0, $number)
    
    
                for ($i = 0; $i -lt $($programs.count - $number); $i++) {
                    $beg_array[$i] = $programs[$i]
                }
    
                $list_temp = New-Object 'System.Collections.Generic.List[string]'
                
                $list_temp.InsertRange(0, $beg_array)
                $list_temp.InsertRange(0, $temp_array)
                
                            
                for ($i = 0; $i -lt $list_temp.Count; $i++) {
                    $programs[$i] = $list_temp[$i]
                }
                
            }
            "x" {
                $numbers = ($command.substring(1, $command.tostring().length - 1)) -split "/"
                $temp = $programs[$numbers[0]]
                $programs[$numbers[0]] = $programs[$numbers[1]]
                $programs[$numbers[1]] = $temp
    
            }
            "p" {
                $prog_swaps = ($command.substring(1, $command.tostring().length - 1)) -split "/"
    
                $swap_a = $prog_swaps[0].tostring()
                $swap_b = $prog_swaps[1].tostring()
                
                $index_a = $programs.IndexOf($swap_a)
                $index_b = $programs.IndexOf($swap_b)
    
                $temp = $programs[$index_a]
                $programs[$index_a] = $programs[$index_b]
                $programs[$index_b] = $temp
    
            }
            Default {}
        }
    }
    
    return $programs
    
}

$inputs = (Get-Content .\input.txt) -split ","

[string[]]$programs = @()

$letters = [char[]]([char]'a'..[char]'p')

foreach($letter in $letters)
{
    $programs += $letter
}

$first = $programs

$known_states = New-Object 'System.Collections.Generic.List[Array]'
$known_states.Add($programs)

$end = 19600

$iteration = for ($i = 0; $i -lt $end; $i++) {
    
    $programs = perform_dance -programs $programs -inputs $inputs
    
    [void]$known_states.Add($programs)
    write-host $i
}

#it will loop somewhere, and that loop will begin with the first element 

$loop_begin = $known_states.LastIndexOf($first)

$indexes_remaining = $end % $loop_begin
$end_index = $loop_begin - $indexes_remaining
$programs = $known_states[$end_index]

return $programs

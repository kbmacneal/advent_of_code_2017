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

for ($i = 0; $i -lt 16; $i++) {
    $programs += $letters[$i]
}

$known_states = New-Object 'System.Collections.Generic.List[string]'

[void]$known_states.Add($($programs -join ""))

$end = 1000000000

for ($i = 0; $i -lt $end; $i++) {
    write-host $i
    $programs = perform_dance -programs $programs -inputs $inputs
    if ($($programs -join "") -in $known_states) {
        [int]$index = $($end % ($i+1))
        
        return $known_states[$index] 
    }
    [void]$known_states.Add($($programs -join ""))
    
}

#bfcdeakhijmlgopn
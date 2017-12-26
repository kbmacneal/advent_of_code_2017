class read_head {
    [int]$current_position
    [string]$current_state

    perform_action($strip) {

        switch ($this.current_state) {
            "A" { 
                if ($strip[$this.current_position] -eq 0) {
                    $strip[$this.current_position] = 1
                    $this.current_position++
                    $this.current_state = "B"
                }
                else {
                    $strip[$this.current_position] = 0
                    $this.current_position--
                    $this.current_state = "C"
                }
            }
            "B" { 
                if ($strip[$this.current_position] -eq 0) {
                    $strip[$this.current_position] = 1
                    $this.current_position--
                    $this.current_state = "A"
                }
                else {
                    $strip[$this.current_position] = 1
                    $this.current_position--
                    $this.current_state = "D"
                }
            }
            "C" { 
                if ($strip[$this.current_position] -eq 0) {
                    $strip[$this.current_position] = 1
                    $this.current_position++
                    $this.current_state = "D"
                }
                else {
                    $strip[$this.current_position] = 0
                    $this.current_position++
                    $this.current_state = "C"
                }
            }
            "D" { 
                if ($strip[$this.current_position] -eq 0) {
                    $strip[$this.current_position] = 0
                    $this.current_position--
                    $this.current_state = "B"
                }
                else {
                    $strip[$this.current_position] = 0
                    $this.current_position++
                    $this.current_state = "E"
                }
            }
            "E" { 
                if ($strip[$this.current_position] -eq 0) {
                    $strip[$this.current_position] = 1
                    $this.current_position++
                    $this.current_state = "C"
                }
                else {
                    $strip[$this.current_position] = 1
                    $this.current_position--
                    $this.current_state = "F"
                }
            }
            "F" { 
                if ($strip[$this.current_position] -eq 0) {
                    $strip[$this.current_position] = 1
                    $this.current_position--
                    $this.current_state = "E"
                }
                else {
                    $strip[$this.current_position] = 1
                    $this.current_position++
                    $this.current_state = "A"
                }
            }
            Default {}
        }
    }
}

$tick = 0
$max = 12172063

$strip = new-object 'System.Collections.Generic.List[int]'

[void]$strip.Add(0)

$head = New-Object read_head

$head.current_position = 0
$head.current_state = "A"

while ($tick -lt $max) {
    
    if ($head.current_position -lt 0) {
        [void]$strip.Insert(0, 0)
        $head.current_position = 0
    }
    if($head.current_position -ge $strip.Count)
    {
        [void]$strip.Add(0)
        $head.current_position = $strip.Count-1
    }

    $head.perform_action($strip)


    $tick++
}

$count = 0

return [System.Linq.Enumerable]::Sum([int[]]$strip)
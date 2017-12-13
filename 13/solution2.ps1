
$input = get-content .\input.txt

$firewalls = @{}

$input | ForEach-Object {

    $split = $_ -split ": "

    [int]$Left = $split[0]
    
    [int]$Right = $split[1]

    $firewalls[$Left] = $Right
}

$time = 0

$caught = $false

while ($caught) {
    $caught = $false

    $time
    for($i=0; $i -lt $($firewalls.Keys | measure -Maximum).Maximum + 1 ; $i++)
    {
        if ($firewalls[$i] -ne $null) {
            if(($i+$time)%(2*$firewalls[$i] - 2) -eq 0)
            {
                $caught = $true
                $time ++

                break
            }
        }   
    
    }
}

$time
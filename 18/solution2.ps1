[CmdletBinding()]
Param(
    [string[]]
    $song
)
 
if (-not $song) {
    $song = gc .\input.txt
    #$song = "set a 1,add a 2,mul a a,mod a 5,snd a,set a 0,rcv a,jgz a -1,set a 1,jgz a -2" -split ','
    #$song = "snd 1,snd 2,snd p,rcv a,rcv b,rcv c,rcv d" -split ','
}
 
class program {
    [hashtable]$register = @{}
    [system.collections.queue]$rcvValues= @{}
    [bool]$waiting = $false
    [bool]$finished = $false
    [int]$position=0
}
 
$actions = $song | % {
    if ($_ -match "(?<instruciton>\w{3}) (?<x>[-\d]+|[\w])( (?<y>[-\d]+|[\w])|)") {
        [pscustomobject]$Matches | select instruciton, x, y
    }
}
 
$programs = [System.Collections.ArrayList]@()
[void]$programs.Add(
    [program]@{
    Register = @{p=0}
    rcvValues= @{}
    waiting = $false
    finished = $false
    position=0
})
[void]$programs.Add([program]@{
    Register = @{p=1}
    rcvValues= @{}
    waiting = $false
    finished = $false
    position=0
})
 
$digit = [regex]"[-\d]+"
 
$currentprogram = 1
$otherprogram = 0
$moretodo = $true
 
$onesend = 0
 
while ( $moretodo ) {
    if ( $programs[0].finished -and $programs[1].finished ){
        $moretodo = $false
        continue
    }
    if ( ($programs[0].waiting -and $programs[0].rcvValues.count -eq 0) -and ($programs[1].waiting -and $programs[1].rcvValues.count -eq 0) ) {
        $moretodo = $false
    } else {
        if ($programs[$currentprogram].waiting -or $programs[$currentprogram].finished){
            if ($programs[$currentprogram].rcvValues.count -gt 0 -and (-not $programs[$currentprogram].finished)){
                $programs[$currentprogram].waiting = $false
            } else {
                $currentprogram= ($currentprogram+1) %2
                $otherprogram= ($otherprogram+1) %2
            }
        } else {
            $thisprog = $programs[$currentprogram]
            $currenta = $actions[$thisprog.position]
            $x = if ($digit.Match( $currenta.x ).Success) { [int]$currenta.x } else { if ($thisprog.register[$currenta.x]) {$thisprog.register[$currenta.x]} else {0} }
            $y = if ($digit.Match( $currenta.y ).Success) { [int]$currenta.y } else { if ($currenta.y) {if ($thisprog.register[$currenta.y]) {$thisprog.register[$currenta.y]} else {0} } }
 
            switch ($currenta.instruciton) {
                jgz {
                    $addvalue = if ($x -gt 0) { $y } else { 1 }
                    $thisprog.position = $thisprog.position + $addvalue
                }
                snd {
                    $programs[$otherprogram].rcvValues.enqueue($x)
                    $thisprog.position = $thisprog.position +1
                    if ($currentprogram -eq 1){
                        $onesend++
                    }
                }
                set {
                    $thisprog.register[$currenta.x] = $y
                    $thisprog.position = $thisprog.position +1
                }
                add {
                    $thisprog.register[$currenta.x] = $thisprog.register[$currenta.x] + $y
                    $thisprog.position = $thisprog.position +1
                }
                mul {
                    $thisprog.register[$currenta.x] = $thisprog.register[$currenta.x] * $y
                    $thisprog.position = $thisprog.position +1
                }
                mod {
                    $thisprog.register[$currenta.x] = $thisprog.register[$currenta.x] % $y
                    $thisprog.position = $thisprog.position +1
                }
                rcv {
                    if ($programs[$currentprogram].rcvValues.count -gt 0){
                        $value = $thisprog.rcvValues.dequeue()
                        $thisprog.register[$currenta.x] = $value
                        $thisprog.position = $thisprog.position +1
                    } else {
                        $thisprog.waiting = $true
                    }
                }
            }
           
            if ($thisprog.position -lt 0 -or $thisprog.position -ge $actions.Count ) {
                $thisprog.finished = $true
            }
        }
    }
}
 
$onesend
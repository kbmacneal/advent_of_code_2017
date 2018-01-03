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
# SIG # Begin signature block
# MIIKywYJKoZIhvcNAQcCoIIKvDCCCrgCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUMTS3Mki3/qsTgqy1EbaaD+4o
# hfagggagMIIB/zCCAWigAwIBAgIQRrLr3K6l7ZdPZc3K61xe8zANBgkqhkiG9w0B
# AQUFADAaMRgwFgYDVQQDDA9LZW5uZXRoIE1hY05lYWwwHhcNMTcwMTA2MTUxNjI5
# WhcNMjEwMTA2MDAwMDAwWjAaMRgwFgYDVQQDDA9LZW5uZXRoIE1hY05lYWwwgZ8w
# DQYJKoZIhvcNAQEBBQADgY0AMIGJAoGBALVfHgCosplTcgqE1tpyjfGWp9YzrtxG
# cDU/oit9XSK5dMGogy/tenwyRQmqwBnTfpKbqW5gN1+cNB8rcNnlavJY03/C6VIh
# 8ka3i8SPPCrpIc1PVxRiju8d3vxC3HRmoUANHS/MmFsNzL0QB5akD4C+8jLUsQO6
# J28VMSEHjf+NAgMBAAGjRjBEMBMGA1UdJQQMMAoGCCsGAQUFBwMDMB0GA1UdDgQW
# BBSLeD/1Ou0WzAiOpCCcAXPHdx3JAjAOBgNVHQ8BAf8EBAMCB4AwDQYJKoZIhvcN
# AQEFBQADgYEAA/4vOSNsACbh5UFKLd2Eb0u4gLR+BVf8rYO7foRBM/M60p1rfUgN
# 97ONJtt1ba+JOD8vtmluc9DKMR7R2hapG1RC8g2B/NlWLH0PlInSfYdLe9AM1vzB
# 6jAVb0ALYUuPLvZbc41ZwWNNsEDAEgfqaRcl+BGSjvwib3YaFRdZtjAwggSZMIID
# gaADAgECAg8WiPA5JV5jjmkUOQfmMwswDQYJKoZIhvcNAQEFBQAwgZUxCzAJBgNV
# BAYTAlVTMQswCQYDVQQIEwJVVDEXMBUGA1UEBxMOU2FsdCBMYWtlIENpdHkxHjAc
# BgNVBAoTFVRoZSBVU0VSVFJVU1QgTmV0d29yazEhMB8GA1UECxMYaHR0cDovL3d3
# dy51c2VydHJ1c3QuY29tMR0wGwYDVQQDExRVVE4tVVNFUkZpcnN0LU9iamVjdDAe
# Fw0xNTEyMzEwMDAwMDBaFw0xOTA3MDkxODQwMzZaMIGEMQswCQYDVQQGEwJHQjEb
# MBkGA1UECBMSR3JlYXRlciBNYW5jaGVzdGVyMRAwDgYDVQQHEwdTYWxmb3JkMRow
# GAYDVQQKExFDT01PRE8gQ0EgTGltaXRlZDEqMCgGA1UEAxMhQ09NT0RPIFNIQS0x
# IFRpbWUgU3RhbXBpbmcgU2lnbmVyMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIB
# CgKCAQEA6ek939c3CMkeOLJSU0JtIvGxxAYEa579gnRQQ33GoLsfTvkCcSax70PY
# g4xI/OcPl3qa65zepqMOOxxEGHWOeKUXaf5JGKTiu1xO/o4qVHpQ8NX2zJHnmXnX
# 3nmU15Yz/g6DviK/YxYso90oG689q+qX0vG/BBDnPUhF/R9oZcF/WZlpwCIxDGJu
# p1xlASGwY8QiGCfu5vzSAD1HLqi4hlZdBNwTFyVuHN9EDxXNt9ulV3ZCbwBogpnS
# 48He8IuUV0zsCJAiIc4iK5gMQuZCk5SYk+/9Btk/vFubVDwgse5q1kd6xauA6TCa
# 3vGkP1VNCgk0inUp0mmtlw9Qv/jKCQIDAQABo4H0MIHxMB8GA1UdIwQYMBaAFNrt
# ZHQUnBQ8q92Zqb1bKE2LPMnYMB0GA1UdDgQWBBSOay0za/Qzp5OzE5ql4Ar3EjVq
# iDAOBgNVHQ8BAf8EBAMCBsAwDAYDVR0TAQH/BAIwADAWBgNVHSUBAf8EDDAKBggr
# BgEFBQcDCDBCBgNVHR8EOzA5MDegNaAzhjFodHRwOi8vY3JsLnVzZXJ0cnVzdC5j
# b20vVVROLVVTRVJGaXJzdC1PYmplY3QuY3JsMDUGCCsGAQUFBwEBBCkwJzAlBggr
# BgEFBQcwAYYZaHR0cDovL29jc3AudXNlcnRydXN0LmNvbTANBgkqhkiG9w0BAQUF
# AAOCAQEAujMkQECMfNtYn7NgmLL1wDH+6x9uUPYK4OTmga0mh6Lf/bPa9HPzAPsp
# G4kbFT7ba1KTK8SsOYHXPGdXmjk24CgImuM5T5uJCX97xWF/WYkyJQpqrho+8KIn
# qLbDuIf3FgRIQT1c2OyfTSAxBNlloe3NaQdTFj3dNgIKiOtA5QYwC7gWS9zvvFUJ
# /8Y+Ei52s9zOQu/5dlfhtwoFQJhYml1xFpNxjGWB6m/ziff7c62057/Zjm+qC08l
# 87jh1d11mGiB+KrA0YDCxMQ5icH2yZ5s13T52Zf4T8KaCs1ej/gZ6eCln8TwkiHm
# LXklySL5w/A6hFetOhb0Y5QQHV3QxjGCA5UwggORAgEBMC4wGjEYMBYGA1UEAwwP
# S2VubmV0aCBNYWNOZWFsAhBGsuvcrqXtl09lzcrrXF7zMAkGBSsOAwIaBQCgeDAY
# BgorBgEEAYI3AgEMMQowCKACgAChAoAAMBkGCSqGSIb3DQEJAzEMBgorBgEEAYI3
# AgEEMBwGCisGAQQBgjcCAQsxDjAMBgorBgEEAYI3AgEVMCMGCSqGSIb3DQEJBDEW
# BBRoLTjjxtJss8mfXuQaMF0yeRUeTzANBgkqhkiG9w0BAQEFAASBgC/h9TZHtJjC
# aouNULbFaeVNnSuAS6H/m8Y7XO6uR4COAetmRs0OY24O6+l2LPmX/cy9oUbasr4r
# mZRIlYEnXRf9jaAhijVR8hd6CwtCCibBZw4TpRM85wVd0ri5l/39RUfYfRkb9BZd
# 0373YHsXRMR8XlSb0cgyWeDDDTFIXkqhoYICQzCCAj8GCSqGSIb3DQEJBjGCAjAw
# ggIsAgEBMIGpMIGVMQswCQYDVQQGEwJVUzELMAkGA1UECBMCVVQxFzAVBgNVBAcT
# DlNhbHQgTGFrZSBDaXR5MR4wHAYDVQQKExVUaGUgVVNFUlRSVVNUIE5ldHdvcmsx
# ITAfBgNVBAsTGGh0dHA6Ly93d3cudXNlcnRydXN0LmNvbTEdMBsGA1UEAxMUVVRO
# LVVTRVJGaXJzdC1PYmplY3QCDxaI8DklXmOOaRQ5B+YzCzAJBgUrDgMCGgUAoF0w
# GAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTgwMTAz
# MTYyMTE2WjAjBgkqhkiG9w0BCQQxFgQU5nsNaqhXc4iqk6NsOB9NwITrtPswDQYJ
# KoZIhvcNAQEBBQAEggEAkSwpa0aITyHEQge+0Tbzq48oAJFxQKUKXKZ/+3TEANyF
# zcDImcSPPQLZR65PxmUvhp3h0c8Zud35JuqRChBpAKhkddEfHeUESAnny28r7lLW
# BT5PLMyLSKPcdX5CjaYgGe+cNoOErwNYY/TbZ+fyZYIyUwwFCzKDvakyvOARSOCT
# oXAB1GAPbAMirLQ7qSbTliuaNQ2FbM0YKsFjjR0Z43QCfmsHst2Z+mD1ooyKtim6
# vl/SbvPcpzbr9cZP2bSqEzSRBLqc7buqlMENuBcU79ZuiQCiun+dQkDT0Z+kOBDc
# OJCZyR0CplWU3ENZu8XjK8H/p/qVDc5z5HOdS/PKrw==
# SIG # End signature block

#from https://www.reddit.com/r/adventofcode/comments/7lf943/2017_day_22_solutions/drm5ql1/

function turn ($current, $direction) {
    if ($direction -eq 'left') {
        $current--
    } elseif ($direction -eq 'right') {
        $current++
    } elseif ($direction -eq 'reverse') {
        $current += 2
    }
    $directions[$current % $directions.count]
}

function move-virus ($x, $y, $direction) {
    switch ($direction) {
        3 {$y--; break}
        2 {$x--; break}
        1 {$y++; break}
        0 {$x++; break}
    }
    $x
    $y
}
$directions = 0, 1, 2, 3  # 0 Right \  1 Down \ 2 Left \ 3 Up
$infected_count = 0
$in = Get-Content input.txt
$current_direction = 3 # up
$x = [math]::Floor($in[0].length / 2)
$y = [math]::Floor($in.count / 2)
$row_num = 0
$grid = foreach ($row in $in) {
    $col_num = 0
    foreach ($col in $row.ToCharArray()) {
        [pscustomobject] @{
            desc = "$row_num;$col_num"      
            val  = $col
        }
        $col_num++
    }
    $row_num++
}
#for part 2 set to true
$part2 = $true
if ($part2) {
    $loops = 10000000
} else {
    $loops = 10000
}

for ($i = 0; $i -lt $loops; $i++) {
    #Write-Verbose "x: $x y: $y dir: $current val: $(($grid.where{$_.desc -eq `"$y;$x`"}).val)"
    if (($t = $grid.IndexOf($($grid.where{$_.desc -eq "$y;$x"}))) -ge 0) {
        #exists
        switch ($grid[$t].val) {
            "." { #clear                                
                if (-not $part2) {
                    $infected_count++
                    $grid[$t].val = "#"
                } else {$grid[$t].val = "-"}
                $current_direction = turn -current $current_direction -direction left
                break
            }
            "#" { #infected
                if (-not $part2) {
                    $grid[$t].val = "."
                } else {
                    $grid[$t].val = "+"
                }
                $current_direction = turn -current $current_direction -direction right
                break
            }           
            "-" { #weakened
                if ($part2) {
                    $grid[$t].val = "#"
                    $infected_count++
                }
                break
            }
            "+" { #flagged
                if ($part2) {
                    $grid[$t].val = "."             
                    $current_direction = turn -current $current_direction -direction reverse
                }
                break
            }
        }       
    } else {
        #add new element to "grid"
        $grid += [pscustomobject] @{
            desc = "$y;$x"          
            val  = $(if ($part2) {"-"}else {"#"; $infected_count++})
        }               
        $current_direction = turn -current $current_direction -direction left        
    }
    $x, $y = move-virus -x $x -y $y -direction $current_direction
}
$infected_count
# SIG # Begin signature block
# MIIKywYJKoZIhvcNAQcCoIIKvDCCCrgCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUrsvMfCZD4cBV3UNqcLcENiNz
# s7ygggagMIIB/zCCAWigAwIBAgIQRrLr3K6l7ZdPZc3K61xe8zANBgkqhkiG9w0B
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
# BBQZnDWSv502I1D2+ef1I0fE0r1FWjANBgkqhkiG9w0BAQEFAASBgCggrwUcKznO
# 5Eh3vpcpMk1h1IBHHcXROzmKPCbfinxYNI+EZpMDIDbmEAfqldl1i5c8Az+uaQJF
# Odv53b6mkiANe1DDdhqnxG5Ii7F1gbKedv9jim6DxBTxvPICc1Wr51+BFtdsnrAt
# Ru/BzkB9uWnL/aTGfJCmGX6OyEmudEYOoYICQzCCAj8GCSqGSIb3DQEJBjGCAjAw
# ggIsAgEBMIGpMIGVMQswCQYDVQQGEwJVUzELMAkGA1UECBMCVVQxFzAVBgNVBAcT
# DlNhbHQgTGFrZSBDaXR5MR4wHAYDVQQKExVUaGUgVVNFUlRSVVNUIE5ldHdvcmsx
# ITAfBgNVBAsTGGh0dHA6Ly93d3cudXNlcnRydXN0LmNvbTEdMBsGA1UEAxMUVVRO
# LVVTRVJGaXJzdC1PYmplY3QCDxaI8DklXmOOaRQ5B+YzCzAJBgUrDgMCGgUAoF0w
# GAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTgwMTAz
# MTYyMTQwWjAjBgkqhkiG9w0BCQQxFgQUYq2xLnHuI52SIzW7T4yvmwxrvLswDQYJ
# KoZIhvcNAQEBBQAEggEAid/Z1vGTPhJqaeATLeOjKSEq6VBhQsRIc6Q54ynIAza8
# yVk25KWNfxMBrtsvuBAY/hYAtdI4OXLiN6FylAW7nyY/xNCwqRrCu2+Elc5GR21u
# bTpv35wsa89rBWEQm6xZcY8zp/qk9wyFBfuO80J+VQ+rlH0jU89cmZalTNZgdIcC
# gUDm7235bLzht5QNFKzKGQUI/IwuIWNdboW7O30i0vov4m0JMMlkBqKagtZV8C3l
# ugeWX35rf+V+q/g40oWVVzUExulZAUXXElxe9lhBf4q7juiILxtuE3N6JhqOxEeX
# VMWVutYCnI4JzrUe4sO3x6P7xdDgtoQe8opXkA6fQA==
# SIG # End signature block

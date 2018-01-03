$lengths = @([int[]][System.Text.Encoding]::ASCII.GetBytes('102,255,99,252,200,24,219,57,103,2,226,254,1,0,69,216')) + @(17,31,73,47,23)
$list = 0..255

$curPos = 0
$skipSize = 0


0..63 | ForEach-Object {

    foreach ($len in $lengths)
    {
        # Get the indexes of items to reverse, handling wraparound
        # for a given length greater than the length of the array, will return positions at the beginning
        $indexesToReverse = for ($i=0; $i -lt $len; $i++){ ($curPos + $i) % $list.Count }

        # Swap first and last, seconds and penultimate, third and .. etc unto the middle one: 0,-1  1,-2, 2,-3 etc.
        for ($i=0; $i -lt [int]($indexesToReverse.Count/2); $i++)
        {
            $temp = $list[$indexesToReverse[$i]]
            $list[$indexesToReverse[$i]] = $list[$indexesToReverse[0-($i+1)]]
            $list[$indexesToReverse[0-($i+1)]] = $temp
        }
        # the next position including wraparound, increment the skip value
        $curPos = ($curPos + $len + $skipSize) % $list.count
        $skipSize++
    }
}

#generates 16 sets of 16
$sixteens = 0..15|%{ ,((($_*16)..(($_*16)+15)))}

#kid of odd way to do it, two nested loops could have done it

$denseHash = foreach ($set in $sixteens)
{
    $out = $list[$set[0]]
    foreach ($index in $set[1..15]){ $out = $out -bxor $list[$index] }
    $out
}

-join ($denseHash | foreach { '{0:x2}' -f $_ })

#from https://www.reddit.com/r/adventofcode/comments/7irzg5/2017_day_10_solutions/dr12q92/
# SIG # Begin signature block
# MIIKywYJKoZIhvcNAQcCoIIKvDCCCrgCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUzvmt53zijwTlgRpTI7Hiik+F
# IoKgggagMIIB/zCCAWigAwIBAgIQRrLr3K6l7ZdPZc3K61xe8zANBgkqhkiG9w0B
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
# BBRmVI0JIw9CX2O8ToH5udlv3YmESzANBgkqhkiG9w0BAQEFAASBgDDhSo76B3Xf
# /QbLAXX0HcStq2HQtJOsMfMW/DPAUteADNI3kAzoc6w4zsoNqZTvlnZT0UJFZ+cw
# a0YgyL/vHuJTIXrFZDSvWyGTqNB4568UOVxZuMThnNbq0jQL1qS1eqLX5p/+egYe
# S84jjKtAd6HDCRqn3JgJHJXMRnlV9ZwGoYICQzCCAj8GCSqGSIb3DQEJBjGCAjAw
# ggIsAgEBMIGpMIGVMQswCQYDVQQGEwJVUzELMAkGA1UECBMCVVQxFzAVBgNVBAcT
# DlNhbHQgTGFrZSBDaXR5MR4wHAYDVQQKExVUaGUgVVNFUlRSVVNUIE5ldHdvcmsx
# ITAfBgNVBAsTGGh0dHA6Ly93d3cudXNlcnRydXN0LmNvbTEdMBsGA1UEAxMUVVRO
# LVVTRVJGaXJzdC1PYmplY3QCDxaI8DklXmOOaRQ5B+YzCzAJBgUrDgMCGgUAoF0w
# GAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTgwMTAz
# MTYyMDE5WjAjBgkqhkiG9w0BCQQxFgQUhDhUa2VKwCUQIWk1OKxZfo7RioIwDQYJ
# KoZIhvcNAQEBBQAEggEATPrRfur7cMWRJWCQmzcIhcK0dbO7GAK+SjRs/XwbXifw
# /hxFUvxIO7RjpjFmeJ6ROPzj+x6u0WehHHSRgmksUOuWhFT/B9SPK55+1QNxH+Ks
# Rl4fSPK1AWLANyrhqW5+gRAcOYtZVzKeyQTn9GKZw1R3sG783kuEdz8h5DgF7cw9
# JWsxP/K7V8254zRV24vm1BekYnkIN485YLZyYl+4ZdmCQFhthM0tLrGHL7sIqQ3Q
# VcX/Sux7MhqJbeT2lhNdHuokb9pyjwb2iDEsA7JL0Rig5PUpQm5g4zqdnwRhTVEf
# 1/Gt4wjLTSUj3KXHFDNCniE66iGiocl6o88X/D9hRw==
# SIG # End signature block

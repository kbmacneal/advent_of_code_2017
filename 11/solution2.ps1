function new-point
{
  Param($x, $y, $z)

  $properties = [ordered]@{
    'X' = $x
    'Y' = $y
    'Z' = $z
    'Distance' = ([Math]::Abs($x) + [Math]::Abs($y) + [Math]::Abs($z))/2
  }

  $obj = new-object -TypeName psobject -Property $properties

  return $obj
}
#use https://www.redblobgames.com/grids/hexagons/ for a guide on generating hex grids, casting to a normal rectangular grid won't work


$inputs = (get-content .\input.txt) -split ","

$position = new-point -x 0 -y 0

$pointlist = New-Object -TypeName System.Collections.ArrayList

$null = $pointlist.Add($position)

foreach ($command in $inputs) {

    $last_position = $pointlist[$($pointlist.Count-1)]
    switch ($command) {
        "n" { 
            $point = new-point -x $($last_position.X) -y $($last_position.Y + 1) -z $($last_position.Z - 1)
         }
         "ne" { 
            $point = new-point -x $($last_position.X +1) -y $($last_position.Y) -z $($last_position.Z - 1)
         }
         "e" { 
            $point = new-point -x $($last_position.X +1) -y $($last_position.Y) -z $($last_position.Z + 1)
         }
         "se" { 
            $point = new-point -x $($last_position.X+1) -y $($last_position.Y - 1) -z $($last_position.Z)
         }
         "s" { 
            $point = new-point -x $($last_position.X) -y $($last_position.Y - 1) -z $($last_position.Z + 1)
         }
         "sw" { 
            $point = new-point -x $($last_position.X -1) -y $($last_position.Y) -z $($last_position.Z + 1)
         }
         "w" { 
            $point = new-point -x $($last_position.X-1) -y $($last_position.Y) -z $($last_position.Z + 1)
         }
         "nw" { 
            $point = new-point -x $($last_position.X-1) -y $($last_position.Y + 1) -z $($last_position.Z)
         }
        Default {}
    }

    $null = $pointlist.Add($point)
}


$pointlist | sort -Property Distance -Descending | select -First 1


$pointlist | Export-Csv -Delimiter "`t" -Path pointlist.txt

# SIG # Begin signature block
# MIIKywYJKoZIhvcNAQcCoIIKvDCCCrgCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUX2JEqnnFmJjAM0E+CV9ifFZs
# 44igggagMIIB/zCCAWigAwIBAgIQRrLr3K6l7ZdPZc3K61xe8zANBgkqhkiG9w0B
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
# BBRMsBPZVW9iQFtF2gm24FqAuwmWXTANBgkqhkiG9w0BAQEFAASBgAWMak/u6z3n
# QmkHPqIJEt8eAWcJel2DYRPAjfXgsykfzofASSN6FSEUtXm9gL06gxPPOuB7l209
# nlW0sMavaGVXqwJgdS+i+0Mvd9vycnlAds/T5v673Xf+zx92OiGlgLgvgpY3oDbt
# mE8PcOQLfBk/fS3dEUK4gV+UZ8EdANkmoYICQzCCAj8GCSqGSIb3DQEJBjGCAjAw
# ggIsAgEBMIGpMIGVMQswCQYDVQQGEwJVUzELMAkGA1UECBMCVVQxFzAVBgNVBAcT
# DlNhbHQgTGFrZSBDaXR5MR4wHAYDVQQKExVUaGUgVVNFUlRSVVNUIE5ldHdvcmsx
# ITAfBgNVBAsTGGh0dHA6Ly93d3cudXNlcnRydXN0LmNvbTEdMBsGA1UEAxMUVVRO
# LVVTRVJGaXJzdC1PYmplY3QCDxaI8DklXmOOaRQ5B+YzCzAJBgUrDgMCGgUAoF0w
# GAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTgwMTAz
# MTYyMDI1WjAjBgkqhkiG9w0BCQQxFgQUXL4ecP3qICUYBGAbIiknV9Ye+E8wDQYJ
# KoZIhvcNAQEBBQAEggEAkNapNn9p0BvmfSyVaHq/Baj3krYS+VGi0Tj8icHJ2rku
# PFdaDdCzoBzFNwTysNE8Z4Q0yPqQihW1JruuYJo1sXzKlH0w7ZDtcQv0SfxZ/OB3
# TRd6uZBX1A5RoTAR+ML52K5HpHGxka4T6xOHj/AoGuV5suPlDy7LEfqyEsCELMek
# AbvXqpptrYWJEFaqnbU26hKtXsvR5aWMcFPq4VTX51jq9/ir79gv3TQAw8Ex0wn6
# zoS7enRWBVMD+Nx1KLRNytOnhX/gGwubDdrlO+h+HDcJh4GMnhvzlQt8voPZs61R
# nC8rJ1AvPwW1ZvSHxVyVoM6eJ6Hlpli6Qc0cYbTcWw==
# SIG # End signature block

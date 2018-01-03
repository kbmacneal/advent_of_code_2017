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
         "se" { 
            $point = new-point -x $($last_position.X+1) -y $($last_position.Y - 1) -z $($last_position.Z)
         }
         "s" { 
            $point = new-point -x $($last_position.X) -y $($last_position.Y - 1) -z $($last_position.Z + 1)
         }
         "sw" { 
            $point = new-point -x $($last_position.X -1) -y $($last_position.Y) -z $($last_position.Z + 1)
         }
         "nw" { 
            $point = new-point -x $($last_position.X-1) -y $($last_position.Y + 1) -z $($last_position.Z)
         }
        Default {}
    }

    $null = $pointlist.Add($point)
}
$pointlist | Export-Csv -Delimiter "`t" -Path pointlist.txt -NoTypeInformation
$pointlist[$($pointlist.Count-1)]
$pointlist[$($pointlist.Count-1)].Distance
# SIG # Begin signature block
# MIIKywYJKoZIhvcNAQcCoIIKvDCCCrgCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQU/bA9aww6p6WT2IfeI3hzhNbg
# jZWgggagMIIB/zCCAWigAwIBAgIQRrLr3K6l7ZdPZc3K61xe8zANBgkqhkiG9w0B
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
# BBRzN+PgpsvfEmooNGUswoAfltTKjzANBgkqhkiG9w0BAQEFAASBgAxmd7Bi1J1T
# O/ntnOdNr+vNIFeH/OJ7wqSluKowebpr/jyBKO0ipoaerFETTVWpSrW5WvHD7ndV
# eXmMPXkx3Sc+CScKz3XVgUN2MqD1KWDyEV6KhJKKOMghYlwKWJJX2XSDBRc30kq5
# SaNlZ9xyWZaplhmik6xWsNWAHALEmAbmoYICQzCCAj8GCSqGSIb3DQEJBjGCAjAw
# ggIsAgEBMIGpMIGVMQswCQYDVQQGEwJVUzELMAkGA1UECBMCVVQxFzAVBgNVBAcT
# DlNhbHQgTGFrZSBDaXR5MR4wHAYDVQQKExVUaGUgVVNFUlRSVVNUIE5ldHdvcmsx
# ITAfBgNVBAsTGGh0dHA6Ly93d3cudXNlcnRydXN0LmNvbTEdMBsGA1UEAxMUVVRO
# LVVTRVJGaXJzdC1PYmplY3QCDxaI8DklXmOOaRQ5B+YzCzAJBgUrDgMCGgUAoF0w
# GAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTgwMTAz
# MTYyMDIyWjAjBgkqhkiG9w0BCQQxFgQUj1IxlhfvXDLv9fseftPtoTwj/70wDQYJ
# KoZIhvcNAQEBBQAEggEAHfjRASru7R1gWI0/Jd/V/VuPAIZAAF8zb3LOqa87xWyG
# 2Cotbk7YLfXiWGAuR9KuMxfAxjpL7F4Go7zTPmhrUydb55rpMzQVFwdO48lp47uT
# AchHP1JUWseAgZdYZsufhg1kpl6GPM4FiUP1pVUPMeEImhUrLGEk1Hg+zOFhZ0lQ
# N5Nq59mPU4R4tIloGnhiJI9fajpLqIs32U9iFZXv/ZZqLUfunlPTn52iYNDRknFw
# DVQj57V+Nf/Qtdnh7lFAzfl5pxPPfP/+XupBow+hNkPEGg8cNsDvS7zRP9f2D54X
# cgCjH47p8qIDF5iqi6mnOU9kQEbtR8geKUxZVTRhkw==
# SIG # End signature block

#it turns out htat the instructions are parsable YAML, so you could in theory parse the input using this module
#https://www.red-gate.com/simple-talk/blogs/psyaml-powershell-yaml/
# and load the instructionset dynamically. Not wanting to give myself a massive migraine for doing that, i went with hardcoded values.

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
# SIG # Begin signature block
# MIIKywYJKoZIhvcNAQcCoIIKvDCCCrgCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUyYaXoSVRa2iJSCq8HoKtKyMN
# gQ+gggagMIIB/zCCAWigAwIBAgIQRrLr3K6l7ZdPZc3K61xe8zANBgkqhkiG9w0B
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
# BBTcKeMySGGO8sEFBp9S0N3zFUXmpzANBgkqhkiG9w0BAQEFAASBgFogyTx9wu7x
# YhCyQuUmMYqhsW1WzIA11FpkYqvR/DGfOjUiOBF85mOIbvk4hYT7IrHpt3vYyTKi
# OFMuDClrNZxSBfF6nH+bWyMo30cAjC+XVJBFbMXGtNxJ0DtNHY0tDAYA+Ske60I0
# o6uXbw5shJfC4xm2zvSWsjp3VyQvWq6OoYICQzCCAj8GCSqGSIb3DQEJBjGCAjAw
# ggIsAgEBMIGpMIGVMQswCQYDVQQGEwJVUzELMAkGA1UECBMCVVQxFzAVBgNVBAcT
# DlNhbHQgTGFrZSBDaXR5MR4wHAYDVQQKExVUaGUgVVNFUlRSVVNUIE5ldHdvcmsx
# ITAfBgNVBAsTGGh0dHA6Ly93d3cudXNlcnRydXN0LmNvbTEdMBsGA1UEAxMUVVRO
# LVVTRVJGaXJzdC1PYmplY3QCDxaI8DklXmOOaRQ5B+YzCzAJBgUrDgMCGgUAoF0w
# GAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTgwMTAz
# MTYyMTUyWjAjBgkqhkiG9w0BCQQxFgQU85tPkkRjFQUMHOBWI7EvoFdIUZswDQYJ
# KoZIhvcNAQEBBQAEggEAEJ8EzS4UuNHMkiF1X5+vGFF7azfW3gXVPreHQX/Whwil
# KHVA/oLYtF/oK8AdPL8qSrFGimyHxiy15LdGP9q2qMyd12HxP8JB6T2QwivWjyfS
# k/67w+yttNdoqn2g36DAdvWGmaxuLLqWSBAaN/7CNPwJq5PybWHuhFc/YTC4s3E8
# 2EBqBUYPBGa1/W71rL01UBR9d/7xkRgCyex023VFsYyWDLkPrem8Ar82imQ5PD44
# yRrzWZ5O0MjFiMn1MHpYo+x/+NDec+nvHHF3/Vr8GWIQcr49odVpJSaEYfG35I2R
# dGJ0xOVmlhoN73VzQfD7xfc4yO3tWUrdZpLuRhxqfg==
# SIG # End signature block

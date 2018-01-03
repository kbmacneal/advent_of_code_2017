class command {
    [string]$command;
    [string]$register;
    [string]$value;
}


$inputs = get-content .\input.txt

$command_array = @()

foreach ($command in $inputs) {
    $obj = New-Object -TypeName command
    $arr = $command -split " "

    $obj.command = $arr[0]
    $obj.register = $arr[1]

    if ($arr.count -gt 2) {
        $obj.value = $arr[2]
    }
    $command_array += $obj
}

$registers = @{}

foreach ($command in $command_array) {
    if (!($registers[$command.register]) -and $command.register -match "[a-z]") {
        $registers[$command.register] = 0
    }
}

$mul_count = 0

for ($i = 0; $i -lt $command_array.Count; $i++) {
    $command = $command_array[$i]
    
    if (!($registers[$($command.register)])) {
        $registers[$($command.register)] = 0
    }
    
    switch ($($command.command)) {  
        "set" { 
    
            $parse_test = 0
    
            if ([Int64]::TryParse($($command.value), [ref]$parse_test)) {
                $registers[$($command.register)] = [long]($command.value)
            }
            else {
                $registers[$($command.register)] = [long]$registers[$($command.value)]
            }
        }
        "sub" { 
            $parse_test = 0
    
            if ([Int64]::TryParse($($command.value), [ref]$parse_test)) {
                $registers[$($command.register)] = $registers[$($command.register)] - [long]$command.value
            }
            else {
                $registers[$($command.register)] = $registers[$($command.register)] - [long]$registers[$($command.value)]
            }
        }
        "mul" { 
    
            $parse_test = 0
            $mul_count++
    
            if ([Int64]::TryParse($($command.value), [ref]$parse_test)) {
                $registers[$($command.register)] = [long]$registers[$($command.register)] * $($command.value)
            }
            else {
                $registers[$($command.register)] = [long]$registers[$($command.register)] * [long]$registers[$($command.value)]
            }
        }
        "jnz" { 
            $parse_test = 0
    
            if ([Int64]::TryParse($($command.register), [ref]$parse_test)) {
                if ([long]$($command.register) -ne 0) {
                    $i = $i + [long]$command.value - 1 
                }
            }
            else {
                if ([long]$registers[$($command.register)] -ne 0) {
                    $i = $i + [long]$command.value - 1
                }
            }			
        }
    
        Default {}
    }
}


return $mul_count

#8281
# SIG # Begin signature block
# MIIKywYJKoZIhvcNAQcCoIIKvDCCCrgCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUnS8VRqcBzr1lxcD7hTw/JHYD
# QqOgggagMIIB/zCCAWigAwIBAgIQRrLr3K6l7ZdPZc3K61xe8zANBgkqhkiG9w0B
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
# BBR+tqNcI6y3gLeoDCFkxeJ+WHjEdzANBgkqhkiG9w0BAQEFAASBgGZs8lmVf+Xy
# LEyioY8BEbYkjKjWoOV1ZnarXNTmAeqmh2zShBnIvBNpMSDYFLpiUovsrhwCQ+qP
# T2nPohKO3n+2XtJEloyUZqu/+ulsRVOiZiWK0epeshHejuyIknusq2HL2MV7e9pP
# 0UcqDXc7UeLQtVqimYnCxhCbkxjqVO5boYICQzCCAj8GCSqGSIb3DQEJBjGCAjAw
# ggIsAgEBMIGpMIGVMQswCQYDVQQGEwJVUzELMAkGA1UECBMCVVQxFzAVBgNVBAcT
# DlNhbHQgTGFrZSBDaXR5MR4wHAYDVQQKExVUaGUgVVNFUlRSVVNUIE5ldHdvcmsx
# ITAfBgNVBAsTGGh0dHA6Ly93d3cudXNlcnRydXN0LmNvbTEdMBsGA1UEAxMUVVRO
# LVVTRVJGaXJzdC1PYmplY3QCDxaI8DklXmOOaRQ5B+YzCzAJBgUrDgMCGgUAoF0w
# GAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTgwMTAz
# MTYyMTQzWjAjBgkqhkiG9w0BCQQxFgQU8TKGOAinQwTfTNrJrer2WPMyD6IwDQYJ
# KoZIhvcNAQEBBQAEggEAM8fwwhMVL1U7IwsEHAX7fsTf+8SW2mzgLR9qJRgVmE/S
# x0lzxj9Ey/cFOys8vSUNyII3wLIX5DK5llX3upMGeT5pUj3GGASHnsk1Bb0GQHnI
# 2v9asMAV78xy/hpczqkZAfxAA2tQ34yGSTMjGrHcOOh3oCXij+KjxEC7F/UIzcIv
# hIkH2ufF9slTfo5NxLcO1qgCGumTWmVESifId+wHXnjYrnL00oZtjjo6JdYlVWVb
# hNalDgmfUQ8inCbJgpiIYTpoAyMCsNcwXehq4P5n2HqHMmnT7CwiwXkJaMdF+/Ne
# JCU6ZcAPSG1WIvUSXmoHPEYj0clEZ8BBJrYWIVm3vw==
# SIG # End signature block

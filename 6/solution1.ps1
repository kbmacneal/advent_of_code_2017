function loop-control ($i, $count) {
    if ($i -ge $($count - 1))
    {$i = 0}
    
    else {$i++}

    return $i
}


$inputs = get-content .\input.txt

$clean = $inputs -split "<TAB>"

$index = 0

$mem_banks = new-object System.Collections.ArrayList

foreach ($item in $clean) {
    $properties = [ordered]@{
        'Blocks' = [Convert]::ToInt32($item)
        'Index'  = $index
    }

    $obj = New-Object -TypeName psobject -Property $properties

    $null = $mem_banks.Add($obj)
    $index++
}



$known_states = New-Object System.Collections.ArrayList


$copier = $($mem_banks.Blocks) -join "<TAB>"

$null = $known_states.add($copier)

$copier = $null

$counter = 0

$is_present = $false

do {

    #$start = $($mem_banks | sort -Property Blocks -Descending | select -First 1).Index

    $max = $($mem_banks.Blocks | measure -Maximum).Maximum

    $blocks = @()
    
    
    $mem_banks | where -Property Blocks -eq $max | % {$blocks += $_}

    if ($blocks.Count -eq 1) {
        $start = $($mem_banks | sort -Property Blocks -Descending | select -First 1).Index
    }
    else {
        $start = $($blocks | sort -Property Index | select -First 1).Index
    }

    
    $redistribute = $mem_banks[$start].Blocks
    
    $mem_banks[$start].Blocks = 0
    
    if($start -eq $($mem_banks.Count - 1))
    {
        $i = 0
    }
    else {
        $i = $($start + 1)
    }
    for ($i; $i -lt $mem_banks.Count; $i = loop-control -i $i -count $($mem_banks.Count - 1) ) {

        if ($redistribute -gt 0) {
            $mem_banks[$i].Blocks = $mem_banks[$i].Blocks + 1
        }
        
    
        $redistribute--
        
        if ($redistribute -le 0) {
            break
        }


    }
    foreach ($item in $known_states) {
        $known = $item

        $current = $($mem_banks.Blocks) -join "<TAB>"
        

        if ($known -eq $current) {
            $current
            $null = $known_states.add($current)
            $is_present = $true
            break
        }

        
    }
    if ($is_present -eq $false) {
        $copier = $($mem_banks.Blocks) -join "<TAB>"
        
        $null = $known_states.add($copier)
        
        $copier = $null
    
    }
    
    $counter++
    
} until ($is_present -eq $true)

$known_states | %{$_.Tostring().Replace("<TAB>","`t")} | Out-File .\out.txt



# SIG # Begin signature block
# MIIKywYJKoZIhvcNAQcCoIIKvDCCCrgCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQU6NZd6e2slxIV6O+eJndGgz4G
# I/ugggagMIIB/zCCAWigAwIBAgIQRrLr3K6l7ZdPZc3K61xe8zANBgkqhkiG9w0B
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
# BBTm3qjVFaemklNnVTMpT7O22hZH4jANBgkqhkiG9w0BAQEFAASBgEWBBtwZnZH3
# NtmN8ImI1OJpe1XlBTqXN+EXVZCykXc/L9PY0/350GKwotnTMm76JcWZsZ3j/oaJ
# ye4UVd2U6ROHmBfnb1XBvmMXfryqK/nwVbStoyKcCNyUBQMdPdfLx5rqMK5HTqok
# JJL4vFfXUiMnqsk1AtU6KCqWidAliy78oYICQzCCAj8GCSqGSIb3DQEJBjGCAjAw
# ggIsAgEBMIGpMIGVMQswCQYDVQQGEwJVUzELMAkGA1UECBMCVVQxFzAVBgNVBAcT
# DlNhbHQgTGFrZSBDaXR5MR4wHAYDVQQKExVUaGUgVVNFUlRSVVNUIE5ldHdvcmsx
# ITAfBgNVBAsTGGh0dHA6Ly93d3cudXNlcnRydXN0LmNvbTEdMBsGA1UEAxMUVVRO
# LVVTRVJGaXJzdC1PYmplY3QCDxaI8DklXmOOaRQ5B+YzCzAJBgUrDgMCGgUAoF0w
# GAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTgwMTAz
# MTYyMjE2WjAjBgkqhkiG9w0BCQQxFgQUaXD2svyrOC8nBmioICJWuzXXeDQwDQYJ
# KoZIhvcNAQEBBQAEggEAhuEqoy3wYcBFAN/oItOeUAYO5GiT62E9ORA2xbk+yrJe
# 6RvZilaJNvv54+F0Lfrn2VihUb/zOVtuX8P6cpkrHd5l4zc+58RYxlCn2c/rITaU
# wcNXXpU9PqZScRPqrQxTn2jLm0jwHpdrp+VtZgwFc4qf/MVMIMVV8waKGiY3qmrc
# zHbKHgPnXx9zVlOOQnpp4IfOSr2HhZaZOrnYDKLOi51PaN1z+i6+7B6I56NbYjLJ
# 5PJ4/zUIpl0u5jX4NI3P4vHiqMMucLvae6fHaZ9/YDGyxt0pQpMPCilFPonRnhX+
# Z5s7kBCCUBnoUjA4Zn5JK9md6Yoy390Buout13X3RA==
# SIG # End signature block

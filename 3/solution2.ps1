Import-Module -Name .\new_plan.psm1 -Force

function new-cell 
{
  Param($x, $y)

  $properties = [ordered]@{
    'X' = $x
    'Y' = $y
    'Ring' = $null
  }

  $cell = New-Object -TypeName psobject -Property $properties

  return $cell
}

function get-cell ($grid, $x, $y) {
  
  if(($grid | Where-Object -Property X -eq $x | Where-Object -Property y -eq $y) -eq $null)
  {
    $obj = New-Object -TypeName psobject -Property @{'Value' = 0}
    
        return $obj
  }
else
{
  return $($grid | Where-Object -Property X -eq $x | Where-Object -Property y -eq $y)
}

}

$grid = new-spiral -max_ring_size 5

foreach($cell in $grid)
{
  $cell.Value = 0
}

$grid[0].Value = 1

for ($i = 1; $i -lt $grid.Count; $i++) 
{
  $cell = $grid[$i]  

  $up_cell = get-cell -grid $grid -x $($cell.x) -y $($cell.Y + 1)
  $down_cell= get-cell -grid $grid -x $($cell.x) -y $($cell.Y - 1)
  $right_cell= get-cell -grid $grid -x $($cell.x + 1) -y $($cell.Y)
  $left_cell= get-cell -grid $grid -x $($cell.x - 1) -y $($cell.Y)

  #diagonals

  $diag_up_left_cell = get-cell -grid $grid -x $($cell.x-1) -y $($cell.Y + 1)
  $diag_up_right= get-cell -grid $grid -x $($cell.x+1) -y $($cell.Y + 1)
  $diag_down_left= get-cell -grid $grid -x $($cell.x - 1) -y $($cell.Y-1)
  $diag_down_right= get-cell -grid $grid -x $($cell.x + 1) -y $($cell.Y-1)

  $cell.Value = $($up_cell.Value) + $($down_cell.Value) + $($left_cell.Value) + $($right_cell.Value) + $($diag_up_left_cell.Value) + $($diag_up_right.Value) + $($diag_down_left.Value) + $($diag_down_right.Value)
} 

$grid | where-object -Property Value -gt 325489 | select -first 1
# SIG # Begin signature block
# MIIKywYJKoZIhvcNAQcCoIIKvDCCCrgCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUB3lc/wKrEajUDVpMy0VHfD2v
# DAmgggagMIIB/zCCAWigAwIBAgIQRrLr3K6l7ZdPZc3K61xe8zANBgkqhkiG9w0B
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
# BBSqBqCN4vrvjXJb8rrmVYMRnVTahTANBgkqhkiG9w0BAQEFAASBgKyEwSuaHDX9
# +fQf3ouLLRUBAcelYS9AGu7mG9GiaannFrb4u256Nugk5UhxtoWI+F40hqmc+ZFO
# H1xOYcso5hgT0XZi7C3HZ/P4Q+KYDYU822JwB81at0sP8fWsJUp+OL8jN1YK5yJg
# 0z9rnSPMlbV9jaQ4u7Y2rn9Fr7KGVcBLoYICQzCCAj8GCSqGSIb3DQEJBjGCAjAw
# ggIsAgEBMIGpMIGVMQswCQYDVQQGEwJVUzELMAkGA1UECBMCVVQxFzAVBgNVBAcT
# DlNhbHQgTGFrZSBDaXR5MR4wHAYDVQQKExVUaGUgVVNFUlRSVVNUIE5ldHdvcmsx
# ITAfBgNVBAsTGGh0dHA6Ly93d3cudXNlcnRydXN0LmNvbTEdMBsGA1UEAxMUVVRO
# LVVTRVJGaXJzdC1PYmplY3QCDxaI8DklXmOOaRQ5B+YzCzAJBgUrDgMCGgUAoF0w
# GAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTgwMTAz
# MTYyMjAxWjAjBgkqhkiG9w0BCQQxFgQUeW8gbDu8Y0jNtKF7dQXbbBd5DBwwDQYJ
# KoZIhvcNAQEBBQAEggEAqBHMVzB2qRMZ36ZKLOc7K8zioTSwqHcQ+QilIpmUOCf8
# yOB9glpYuBW5/2X8bj+GMVoP6muEawLikoqGtmhHmiwzkRV+mZdFCZoQblY322q7
# VbSdldYkb2IJ9C6zbXrK4EQAxqki1//QhqfOTXRFsk3AvE4yNyXcJUenqOW4Advq
# GSG8s83WBUbmtJBUXll3UZ8IACr+rAJH+7WA+bleTXEZm0j2/Ohy7N/7tug3t9ye
# prVYYDy1TffG4+ncklcWhjJuViot19t6Z26GkbKA6JnnqGnadgL7TCFmhACn6L9w
# bzfsXL/xOqWrJiylT0RbhXgAMyeBXak4V38md85XKQ==
# SIG # End signature block

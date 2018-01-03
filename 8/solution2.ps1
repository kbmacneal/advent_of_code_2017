class register {
    [string]$Name
    [int]$Value = 0
  }
  
  class command {
    [string]$register
    [string]$increase
    [int]$amount
    [string]$condition_target
    [string]$operator
    [int]$comparator
  
  }
  
  $inputs = get-content .\input.txt
  $commands = new-object System.Collections.ArrayList
  
  $max = 0
  
  foreach ($item in $inputs) {
      
    $item_array = $item -split " "
  
    $command = New-Object -typename command
  
    $command.register = $item_array[0]
    $command.increase = $item_array[1]
    $command.amount = $item_array[2]
    $command.condition_target = $item_array[4]
    $command.operator = $item_array[5]
    $command.comparator = $item_array[6]
  
    $null = $commands.add($command)
  }
  
  $register_list = new-object -TypeName 'System.Collections.Generic.Dictionary[string,int]'
  
  foreach($command in $commands)
  {
    if(!($register_list.ContainsKey($($command.register))))
    {        
        $register_list.Add($command.register, 0)
    }
  }
  
  foreach($command in $commands)
  {
  switch ($command.increase) {
    "inc"
    { 
      $operator = $command.comparator
      switch ($command.operator) {
        '>' 
        { 
            if($register_list["$($command.condition_target)"]  -gt $operator)
            {
                $register_list["$($command.register)"] = $register_list[$($command.register)] + $($command.amount)
            }
          
        }
        '<' 
        {
            if($register_list["$($command.condition_target)"]  -lt $operator)
            {
                $register_list["$($command.register)"] = $register_list[$($command.register)] + $($command.amount)
            }
        }
        '>=' 
        {
            if($register_list["$($command.condition_target)"]  -ge $operator)
            {
                $register_list["$($command.register)"] = $register_list[$($command.register)] + $($command.amount)
            }
        }
        '<=' 
        {
            if($register_list["$($command.condition_target)"]  -le $operator)
            {
                $register_list["$($command.register)"] = $register_list[$($command.register)] + $($command.amount)
            }
        }
        '==' 
        {
            if($register_list["$($command.condition_target)"]  -eq $operator)
            {
                $register_list["$($command.register)"] = $register_list[$($command.register)] + $($command.amount)
            }
        }
        '!=' 
        {
            if($register_list["$($command.condition_target)"]  -ne $operator)
            {
                $register_list["$($command.register)"] = $register_list[$($command.register)] + $($command.amount)
            }
        }
  
        Default 
        {
  
        }
      }
    }
    "dec"
    {
        $operator = $command.comparator
        switch ($command.operator) {
          '>' 
          { 
              if($register_list["$($command.condition_target)"]  -gt $operator)
              {
                $register_list["$($command.register)"] = $register_list[$($command.register)] - $($command.amount)
              }
            
          }
          '<' 
          {
              if($register_list["$($command.condition_target)"]  -lt $operator)
              {
                $register_list["$($command.register)"] = $register_list[$($command.register)] - $($command.amount)
              }
          }
          '>=' 
          {
              if($register_list["$($command.condition_target)"]  -ge $operator)
              {
                $register_list["$($command.register)"] = $register_list[$($command.register)] - $($command.amount)
              }
          }
          '<=' 
          {
              if($register_list["$($command.condition_target)"]  -le $operator)
              {
                $register_list["$($command.register)"] = $register_list[$($command.register)] - $($command.amount)
              }
          }
          '==' 
          {
              if($register_list["$($command.condition_target)"]  -eq $operator)
              {
                $register_list["$($command.register)"] = $register_list[$($command.register)] - $($command.amount)
              }
          }
          '!=' 
          {
              if($register_list["$($command.condition_target)"]  -ne $operator)
              {
                $register_list["$($command.register)"] = $register_list[$($command.register)] - $($command.amount)
              }
          }
  
          Default 
          {
  
          }
        }
    }
    Default 
    {
  
    }
  }
foreach($key in $register_list.Values)
{
    if($key -gt $max)
    {
        $max = $key
    }
}

  }
  
$max
# SIG # Begin signature block
# MIIKywYJKoZIhvcNAQcCoIIKvDCCCrgCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUA8X4seqYtsp4looR8cB4UOiq
# SrGgggagMIIB/zCCAWigAwIBAgIQRrLr3K6l7ZdPZc3K61xe8zANBgkqhkiG9w0B
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
# BBSEN8rkUMAuNMWfMT5lTAvQ3dGgwjANBgkqhkiG9w0BAQEFAASBgKPW0IzjW6CM
# XlI+KUKjbQCGaTanPKO6nbWyYV+V9YtdU/IVxgwE2tPRin5R0qSsQu1wJbhtbLFI
# +d41i+rb04GjY9sJEYhOeX5VFJQBQqgTj4V5nlLvOu6vaEFx+h3PsZpH6O85svEn
# QXMPCFPrnos/aVJZMGbTfWt52iXETDOfoYICQzCCAj8GCSqGSIb3DQEJBjGCAjAw
# ggIsAgEBMIGpMIGVMQswCQYDVQQGEwJVUzELMAkGA1UECBMCVVQxFzAVBgNVBAcT
# DlNhbHQgTGFrZSBDaXR5MR4wHAYDVQQKExVUaGUgVVNFUlRSVVNUIE5ldHdvcmsx
# ITAfBgNVBAsTGGh0dHA6Ly93d3cudXNlcnRydXN0LmNvbTEdMBsGA1UEAxMUVVRO
# LVVTRVJGaXJzdC1PYmplY3QCDxaI8DklXmOOaRQ5B+YzCzAJBgUrDgMCGgUAoF0w
# GAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTgwMTAz
# MTYyMjMxWjAjBgkqhkiG9w0BCQQxFgQU6Ht4UVpjyMIPRmanbAeEOwwGLqYwDQYJ
# KoZIhvcNAQEBBQAEggEAIPl93LkfnTKKuIn15+IF3SUNvOY8bCwM4YTT28MkZHao
# i49fr3suyKv4D825pGEjfBT1/e8OhPZFWffCgOYRsEGSOF20vY+JuY//skHrZSTV
# eov425DyJyq6vZHffHAXyCJUwj9KMSBVPijurGkhdLjDqxK5rVKY3P6B0VSBt7vn
# MlPxeJG/ZCCnrTcbId8aLu/K7R7XFKcMmmyvj5a9iJRuhgbfxtQyfqcygD1obqoZ
# 2sdUy35PRigyaQ5EJ+/9MXepbtblbSJe9BU0tHOhfog+sqo2B0WkLyjP8jlIlemm
# WkivKhKcLn+PQjhmFlcU/xJ5zSglRzXbrZfKYiTLJw==
# SIG # End signature block

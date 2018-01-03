function new-cell {

    Param($x, $y)

    $properties = [ordered]@{
        'X' = $x
        'Y' = $y
    }

    $cell = New-Object -TypeName psobject -Property $properties

    return $cell
}

function find-cellincelllist{

    Param($cell_to_find, $cell_list)

    foreach($cell in $cell_list){
        $return = $false
        if($cell_to_find.X -eq $cell.X -and $cell_to_find.Y -eq $cell.Y){$return = $true}
    }

    return $return
}


function determine-direction{

    param([System.Collections.ArrayList]$gridlist)



#rules
#when to go up: if there is no up and there is left and no right and there is down
#when to go down: if there is up, no down and there is a right
#when to go right: if there is an up, no right
#when to go left: if there is no left, there is a down, 

$last_cell = $gridlist | Select-Object -Last 1
$last_x = $last_cell.X
$last_y = $last_cell.Y

$up_cell = new-cell -x $last_x -y $($last_y+1)

$down_cell = new-cell -x $last_x -y $($last_y -1)

$left_cell = new-cell -x $($last_x -1) -y $last_y

$right_cell =new-cell -x $($last_x +1) -y $last_y


$go_up = if($(find-cellincelllist -cell_to_find $up_cell -cell_list $gridlist) -and $(find-cellincelllist -cell_to_find $left_cell -cell_list $gridlist)){$true}else{$false} 

$go_down = if($(find-cellincelllist -cell_to_find $up_cell -cell_list $gridlist) -and !$(find-cellincelllist -cell_to_find $down_cell -cell_list $gridlist) -and $(find-cellincelllist -cell_to_find $right_cell -cell_list $gridlist)){$true} else{$false}

$go_right = if($(find-cellincelllist -cell_to_find $up_cell -cell_list $gridlist) -and !$(find-cellincelllist -cell_to_find $right_cell -cell_list $gridlist)){$true} else{$false}

$go_down = if(!$(find-cellincelllist -cell_to_find $left_cell -cell_list $gridlist) -and $(find-cellincelllist -cell_to_find $down_cell -cell_list $gridlist)){$true} else{$false}

<#$go_up = if($gridlist -contains $up_cell -and $gridlist -contains $left_cell -and $gridlist -contains $right_cell){$true}else{$false}    
$go_down = if($up_cell -in $gridlist -and $down_cell -notin $gridlist -and $right_cell -in $gridlist){$true} else{$false}
$go_right = if($up_cell -in $gridlist -and $right_cell -notin $gridlist){$true}else{$false}
$go_left = if($left_cell -notin $gridlist -and $down_cell -in $gridlist){$true}else{$false}#>

if($go_up){return "up"}

if($go_down){return "down"}

if($go_left){return "left"}

if($go_right){return "right"}


}

  $point = new-cell -x 0 -y 0

  $grid = New-Object -TypeName System.Collections.ArrayList

  $null = $grid.Add($point)

  $point1 = new-cell -x 1 -y 0

  $null = $grid.Add($point1)

  $numbers = 0..23

  foreach($num in $numbers){

    $last_cell = $grid | Select-Object -Last 1
    $last_x = $last_cell.X
    $last_y = $last_cell.Y

    switch (determine-direction -gridlist $grid) {
        "up" {$null = $grid.Add($(new-cell -x $last_x -y $last_y+1))}
        "down"{$null = $grid.Add($(new-cell -x $last_x -y $last_y+1))}
        "left"{$null = $grid.Add($(new-cell -x $last_x -y $last_y+1))}
        "right"{$null =$grid.Add($(new-cell -x $last_x -y $last_y+1))}
        Default {break}
    }
  }

  $grid
# SIG # Begin signature block
# MIIKywYJKoZIhvcNAQcCoIIKvDCCCrgCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUSvK/cOHbaH9ErORicgb7hhEQ
# l7ugggagMIIB/zCCAWigAwIBAgIQRrLr3K6l7ZdPZc3K61xe8zANBgkqhkiG9w0B
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
# BBRHXwIi0+7x296bXyYsOIm6AZegTzANBgkqhkiG9w0BAQEFAASBgENNb2amW4r/
# XlJrSVnpagYSWYau+5ZOTDTev7GZ9IzGf9OfPmzQV40Z8y0DpbLNgit+Edri/yhn
# rggjAK/FPqXWq5/FKtD3V84JqJK+cPCeuGBePTkTS0XBSxYg581XvF/hLz1at3fP
# e4Ff6PU98AVM5xjFsf7v5z3tXMtUILD8oYICQzCCAj8GCSqGSIb3DQEJBjGCAjAw
# ggIsAgEBMIGpMIGVMQswCQYDVQQGEwJVUzELMAkGA1UECBMCVVQxFzAVBgNVBAcT
# DlNhbHQgTGFrZSBDaXR5MR4wHAYDVQQKExVUaGUgVVNFUlRSVVNUIE5ldHdvcmsx
# ITAfBgNVBAsTGGh0dHA6Ly93d3cudXNlcnRydXN0LmNvbTEdMBsGA1UEAxMUVVRO
# LVVTRVJGaXJzdC1PYmplY3QCDxaI8DklXmOOaRQ5B+YzCzAJBgUrDgMCGgUAoF0w
# GAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTgwMTAz
# MTYyMTU1WjAjBgkqhkiG9w0BCQQxFgQUmVvMuLvCKu9emWTsQImUon8YqxUwDQYJ
# KoZIhvcNAQEBBQAEggEA6NxK6C1uISr0WFm8QY/DmENQcYOvcHLP7yYX/Khi456q
# xAmqAbFZc1rGu7TI77vZm/o5T9kQuLbnxA3wtH2ZvIKO3lKwhU06C4Y0fmRLtbqr
# Olih5no/NwzgMjRju163R3063W9pSa9d82hnc1/omjl5retIoPH3OARxJuCD/mfv
# bPMHQ2bdgdTMA4o/qozrR3go3qXqbeEsNZBmrnABw6O4W3RfnC7fq1kLhHIzTUkU
# 3LWyEUQUVLtzRWD70ysrlPW6lHjnzadS7Gb3Zn610UADeI6sr1evXk/rG9XNJDsK
# R5yr6OON2DQgxpUZpiIGW3HUiJC5tzYmiluIOMnFLw==
# SIG # End signature block

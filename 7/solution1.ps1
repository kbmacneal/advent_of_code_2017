function new-tree
{
    $inputs = get-content .\input.txt

    $nodes = New-Object -TypeName 'System.Collections.Generic.List[object]'

    $trees = New-Object -TypeName 'System.Collections.Generic.List[object]'


    foreach($line in $inputs)
    {
        $line=$line.ToString()
        if($line -like "*->*")
        {
            $name = (($line -split "->")[0] -split(" ",""))[0]


            [int]$weight = (($line -split "->")[0] -split(" ",""))[1].Replace("(","").Replace(")","")


            $children = ($line -split "->")[1].Replace(" ","") -split ","

            $child_array = New-Object System.Collections.ArrayList

            foreach($child in $children)
            {
                $properties = [ordered]@{
                    'Name' = $child
                    'Weight' = 0
                }

                $obj = New-Object -TypeName psobject -Property $properties
                $null = $child_array.Add($obj)
            }

            $properties = [ordered]@{
                'Name'=$name
                'Weight'=$weight
                'Children' = $child_array
            }

            $obj = New-Object -TypeName psobject -Property $properties

            $null = $trees.add($obj)
        }
        else 
        {
            $name = ($line -split " ")[0]
            [int]$weight = ($line -split " ")[1].Replace("(","").Replace(")","")

            $properties = [ordered]@{
                'Name'=$name
                'Weight'=$weight
            }

            $obj = New-Object -TypeName psobject -Property $properties

            $null = $nodes.add($obj)
        }

        

        
    }

    foreach($obj in $nodes)
    {
        $name = $obj.Name

        ($trees.Children | Where-Object -Property Name -eq $name).Weight = $obj.Weight
    }

    foreach($obj in $trees)
    {
        $name = $obj.Name

        if($trees.Children | Where-Object -Property Name -eq $name)
        {
            ($trees.Children | Where-Object -Property Name -eq $name).Weight = $obj.Weight
        }

        
    }


   
    return $trees
}

$tree = new-tree 

$tree | Where-Object  -Property Name -notin ($tree.Children).Name
# SIG # Begin signature block
# MIIKywYJKoZIhvcNAQcCoIIKvDCCCrgCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQU6ZFn6NdNf8gm7458kUMAGeeD
# ySigggagMIIB/zCCAWigAwIBAgIQRrLr3K6l7ZdPZc3K61xe8zANBgkqhkiG9w0B
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
# BBSCRXHCdghtTaaj/gUPUk9j4gvhZjANBgkqhkiG9w0BAQEFAASBgJuQAPlmyJ4E
# gyNOzC5Ze2JQptJ+AGzdrDqr6HEdXrb3CJu2DSX/draynuGK4RjvDQp462sKcPc7
# kjWITjLFSmknqxI/zK/v5tFy7D6reJ9aKDbNOwZL8SvYSBOEw0FbJbjzV4xC9ss9
# ttWQSnCBn1VLFdpeCfNuASLVpLDYQZWLoYICQzCCAj8GCSqGSIb3DQEJBjGCAjAw
# ggIsAgEBMIGpMIGVMQswCQYDVQQGEwJVUzELMAkGA1UECBMCVVQxFzAVBgNVBAcT
# DlNhbHQgTGFrZSBDaXR5MR4wHAYDVQQKExVUaGUgVVNFUlRSVVNUIE5ldHdvcmsx
# ITAfBgNVBAsTGGh0dHA6Ly93d3cudXNlcnRydXN0LmNvbTEdMBsGA1UEAxMUVVRO
# LVVTRVJGaXJzdC1PYmplY3QCDxaI8DklXmOOaRQ5B+YzCzAJBgUrDgMCGgUAoF0w
# GAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTgwMTAz
# MTYyMjIyWjAjBgkqhkiG9w0BCQQxFgQUTmp39J62ORJ/ZsdXcV9x7ExRoq4wDQYJ
# KoZIhvcNAQEBBQAEggEAfJgeCLscsIzJasOIjWD0FaA8sLzXKRA4OfzDb3cxopTd
# 9oqScrjCRNDhtVl3maorgZaDIBiCI7J2hQ6+dG+j1F6mBu8Dmp92WuT8VH1kPTvB
# 8/oRwNWVe3/Y6nuiBOKvDiCY3PMHNLrs6tgyrswgnp9oiMuESVzWvPGvmdR1t+QR
# 6E8GwPls/LuYVJsu79kXWL+044DpRCqKQLfVN4Ig4/wMi0rb2f3lTKteuMqWTOdF
# h8mzJScdCXh5kMCOCBwf5+c6U2vkizVLywf0gPMVbgRdxjzI0jBlAvAwnVdtCMol
# cTqHtSbUfClILdAuF/hVyVj5cHe7Q+fwFjoik49/kA==
# SIG # End signature block

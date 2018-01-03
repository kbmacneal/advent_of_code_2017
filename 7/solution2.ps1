function loop-control ($i, $count) {
    if ($i -ge $($count - 1))
    {$i = 0}
    
    else {$i++}

    return $i
}

function assign-tochildren($node, $parent)
{
    <#
    $found = $false
    if($parent.Children){
        foreach ($child in $($parent.Children)) {
            if($node.Name -eq $child.Name)
            {
                $child = $node
                $found = $true
                
            }
        }
            if($found){
                return $true
            }
            else{
                foreach ($child in $($parent.Children)) {
                assign-tochildren -node $node -parent $child
            }
        }
        }#>

        $found = $false
        if($parent.Children)
        {
            foreach ($child in $($parent.Children)) {
                if($node.Name -eq $child.Name)
                {
                    $child = $node
                    return $true
                    
                }
                else{
                    if($child.Children)
                    {
                        foreach ($child in $($child.Children)) {
                            assign-tochildren -node $node -parent $child
                        }
                    }
                    
                }
            }
        }
}

function new-tree
{
    $inputs = get-content .\input_test.txt
    #$inputs = get-content .\input.txt
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

#from https://stackoverflow.com/a/14970081
function Get-Properties($Object, $MaxLevels="5", $PathName = "`$_", $Level=0)
{
    <#
        .SYNOPSIS
        Returns a list of all properties of the input object

        .DESCRIPTION
        Recursively 

        .PARAMETER Object
        Mandatory - The object to list properties of

        .PARAMETER MaxLevels
        Specifies how many levels deep to list

        .PARAMETER PathName
        Specifies the path name to use as the root. If not specified, all properties will start with "."

        .PARAMETER Level
        Specifies which level the function is currently processing. Should not be used manually.

        .EXAMPLE
        $v = Get-View -ViewType VirtualMachine -Filter @{"Name" = "MyVM"}
        Get-Properties $v | ? {$_ -match "Host"}

        .NOTES
            FunctionName : 
            Created by   : KevinD
            Date Coded   : 02/19/2013 12:54:52
        .LINK
            http://stackoverflow.com/users/1298933/kevind
     #>

    if ($Level -eq 0) 
    { 
        $oldErrorPreference = $ErrorActionPreference
        $ErrorActionPreference = "SilentlyContinue"
    }

    #Initialize an array to store properties
    $props = @()

    # Get all properties of this level
    $rootProps = $Object | Get-Member -ErrorAction SilentlyContinue | Where-Object { $_.MemberType -match "Property"} 

    # Add all properties from this level to the array.
    $rootProps | ForEach-Object { $props += "$PathName.$($_.Name)" }

    # Make sure we're not exceeding the MaxLevels
    if ($Level -lt $MaxLevels)
    {

        # We don't care about the sub-properties of the following types:
        $typesToExclude = "System.Boolean", "System.Int32", "System.Char"

        #Loop through the root properties
        $props += $rootProps | ForEach-Object {

                    #Base name of property
                    $propName = $_.Name;

                    #Object to process
                    $obj = $($Object.$propName)

                    # Get the type, and only recurse into it if it is not one of our excluded types
                    $type = ($obj.GetType()).ToString()

                    # Only recurse if it's not of a type in our list
                    if (!($typesToExclude.Contains($type) ) )
                    {

                        #Path to property
                        $childPathName = "$PathName.$propName"

                        # Make sure it's not null, then recurse, incrementing $Level                        
                        if ($obj -ne $null) 
                        {
                            Get-Properties -Object $obj -PathName $childPathName -Level ($Level + 1) -MaxLevels $MaxLevels }
                        }
                    }
    }

    if ($Level -eq 0) {$ErrorActionPreference = $oldErrorPreference}
    $props
}

$rtn = new-tree 

$trees = New-Object -TypeName System.Collections.ArrayList

$root_node = $trees | Where-Object  -Property Name -notin ($trees.Children).Name

foreach ($item in $rtn) {
    $null = $trees.Add($item)    
}

$root_node = $trees | Where-Object  -Property Name -notin ($trees.Children).Name

$i = 0

do {
    $obj = $trees[$i]

    if($obj.Name -ne $root_node.Name)
    {
        for ($y = 0; $y -lt $trees.Count; $y++) {
            if(assign-tochildren -node $obj -parent $trees[$y])
            {
                $y = $trees.Count
                $trees.removeat($i)
                $i = loop-control -i $i -count $trees.Count
                break
            }
            else{
                $i = loop-control -i $i -count $trees.Count
            }
        }

    }
    else{
        $i = loop-control -i $i -count $trees.Count
    }
    

} until ($($trees | Measure-Object).count -eq 1)

$trees
# SIG # Begin signature block
# MIIKywYJKoZIhvcNAQcCoIIKvDCCCrgCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUw02x+84UqleIRrPGM7SGci1r
# 38GgggagMIIB/zCCAWigAwIBAgIQRrLr3K6l7ZdPZc3K61xe8zANBgkqhkiG9w0B
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
# BBSvS4Xg7GnJaEd0WJeXQIrLCHKyejANBgkqhkiG9w0BAQEFAASBgJtY5mExLLnE
# PgaBOVYXQALU84OfAlrP424gvGYbHY/iCvSYI0xURtW4Ju5905bbx4zx1829tBMF
# Fxkm4Dy/+9ER1vfZ/iqR8obvrORhzcUdDHaXESCEaNrOuaFt/w+3D9H53K+dNrp3
# 9pOxQezNrLUyWDzQhN+eC2XgDb5K+FBMoYICQzCCAj8GCSqGSIb3DQEJBjGCAjAw
# ggIsAgEBMIGpMIGVMQswCQYDVQQGEwJVUzELMAkGA1UECBMCVVQxFzAVBgNVBAcT
# DlNhbHQgTGFrZSBDaXR5MR4wHAYDVQQKExVUaGUgVVNFUlRSVVNUIE5ldHdvcmsx
# ITAfBgNVBAsTGGh0dHA6Ly93d3cudXNlcnRydXN0LmNvbTEdMBsGA1UEAxMUVVRO
# LVVTRVJGaXJzdC1PYmplY3QCDxaI8DklXmOOaRQ5B+YzCzAJBgUrDgMCGgUAoF0w
# GAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTgwMTAz
# MTYyMjI1WjAjBgkqhkiG9w0BCQQxFgQULyLgrPKc4mMdll1M9RPWWQ9jPyQwDQYJ
# KoZIhvcNAQEBBQAEggEAVC8DpJFDi8EnnRZTebE5CZF+S5prSI3CFQjvl/Sh3O73
# OI7l0eq8qRXlnX95eH2tEBt7XyaE3FjxL+qtVIlsR9NZCCgUJt6kPiuFjqez6zI+
# 79zJbyMheQtjpYvTqtn0lE4c1D0sBBeCFw2/r431jdRHjoXJiEm4l17mQub2ph8h
# b0mT9/FRmRGXB4EiHygvidyfOrRQu5mHWOsC3uQ0oV3elvJItOq+Z9a9lOMWsNgP
# dI+bPUV0mZHm27Cn6rzCfbTjVviSsQjp8oUn5G4fHUnrv8+UGIDf/Gw0IsV+Xa5d
# Nl1GV/IFjV6ciOEvg9ckv8U/YMVAL3hqLvTQBdkWSA==
# SIG # End signature block

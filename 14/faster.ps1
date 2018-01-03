class cell
{
	[bool]$Occupied;
	[int]$Link_Num;
}

function get-knothash
{
	# Parameter help description
	Param(
		[Parameter(ValueFromPipeline = $true)]
		[string]$input_string
	)


	$lengths = @([int[]][System.Text.Encoding]::ASCII.GetBytes($input_string)) + @(17, 31, 73, 47, 23)
	$list = 0..255
    
	$curPos = 0
	$skipSize = 0
    
    
	0..63 | ForEach-Object {
    
		foreach ($len in $lengths)
		{
			# Get the indexes of items to reverse, handling wraparound
			# for a given length greater than the length of the array, will return positions at the beginning
			$indexesToReverse = for ($i = 0; $i -lt $len; $i++) { ($curPos + $i) % $list.Count }
    
			# Swap first and last, seconds and penultimate, third and .. etc unto the middle one: 0,-1  1,-2, 2,-3 etc.
			for ($i = 0; $i -lt [int]($indexesToReverse.Count / 2); $i++)
			{
				$temp = $list[$indexesToReverse[$i]]
				$list[$indexesToReverse[$i]] = $list[$indexesToReverse[0 - ($i + 1)]]
				$list[$indexesToReverse[0 - ($i + 1)]] = $temp
			}
			# the next position including wraparound, increment the skip value
			$curPos = ($curPos + $len + $skipSize) % $list.count
			$skipSize++
		}
		
	}
    
	#generates 16 sets of 16
	$sixteens = 0..15| % { , ((($_ * 16)..(($_ * 16) + 15)))}
    
	#kid of odd way to do it, two nested loops could have done it
    
	$denseHash = foreach ($set in $sixteens)
 {
		$out = $list[$set[0]]
		foreach ($index in $set[1..15]) { $out = $out -bxor $list[$index] }
		$out
	}
    
	return -join ($denseHash | foreach { '{0:x2}' -f $_ })
    
	#from https://www.reddit.com/r/adventofcode/comments/7irzg5/2017_day_10_solutions/dr12q92/
}

function get-connectedcells($cell_list, [int]$start_x, [int]$start_y, [int]$regnum)
{
	$up_cell = $null
	$down_cell = $null
	$left_cell = $null
	$right_cell = $null

	$up = $start_y + 1
	$down = $start_y - 1
	$left = $start_x - 1
	$right = $start_x + 1
	
	if ($up -lt 128)
	{
		$up_cell = $cell_list[$start_x,$up]
	}
	if ($down -gt 0)
	{
		$down_cell = $cell_list[$start_x,$down]
	}

	if ($left -gt 0) {
		$left_cell = $cell_list[$left,$start_y]
	}
	if ($right -lt 128)
	{
		$right_cell = $cell_list[$right,$start_y]
	}

	"$start_x : $start_y"

	if ($up_cell -ne $null)
 {
		if ($up_cell.Occupied -eq $true -and $up_cell.link_num -eq 0)
		{
			$up_cell.Link_Num = $regnum
			get-connectedcells -cell_list $cell_list -start_x $start_x -start_y $up -regnum $regnum
		}
	}

	if ($down_cell -ne $null)
 {
		if ($down_cell.Occupied -eq $true -and $down_cell.link_num -eq 0)
		{
			$down_cell.Link_Num = $regnum
			get-connectedcells -cell_list $cell_list -start_x $start_x -start_y $down -regnum $regnum
		}
	}

	if ($left_cell -ne $null)
 {
		if ($left_cell.Occupied -eq $true -and $left_cell.link_num -eq 0)
		{
			$left_cell.Link_Num = $regnum
			get-connectedcells -cell_list $cell_list -start_x $left -start_y $start_y -regnum $regnum
		}
	}

	if ($right_cell -ne $null)
 {
		if ($right_cell.Occupied -eq $true -and $right_cell.link_num -eq 0)
		{
			$right_cell.Link_Num = $regnum
			get-connectedcells -cell_list $cell_list -start_x $right -start_y $start_y -regnum $regnum
		}
	}

}


$hex = @{
	'0' = '0000'
	'1' = '0001'
	'2' = '0010'
	'3' = '0011'
	'4' = '0100'
	'5' = '0101'
	'6' = '0110'
	'7' = '0111'
	'8' = '1000'
	'9' = '1001'
	'a' = '1010'
	'b' = '1011'
	'c' = '1100'
	'd' = '1101'
	'e' = '1110'
	'f' = '1111'
}


function new-cell
{
		   
	$properties = @{
		'Occupied' = $false
		'Link_Num' = $null
	}
    
	$cell = New-Object -TypeName cell -Property $properties
    
	return $cell
}

	



$inputs = "jzgqcdpd"

$grid = new-object 'object[,]' 128, 128

for ($i = 0; $i -lt 128; $i++)
{
	for ($j = 0; $j -lt 128; $j++)
 {
		$cell = new-cell
		$grid[$i,$j] = $cell
		#$grid.add($cell)
	}
}
#for debuggin, no sense wasting time generating the hashes over and over again
$rows = 0..127 | foreach {
	(get-knothash "$inputs-$_")
}

#$rows | export-clixml .\rows.xml

#$rows = import-clixml .\rows.xml

"Hashes Generated"

$counter = 0

$binary_Str_array = new-object 'System.Collections.Generic.List[int]'

$binary_Str = -join ($rows| foreach {$_.getenumerator().foreach{$hex["$_"]}})

$binary_Str.GetEnumerator() | foreach {[void]$binary_Str_array.Add([int]$_)}

"Binary String completed building"


for ($i = 0; $i -lt 128; $i++)
{
	for ($j = 0; $j -lt 128; $j++)
 {
        
		$grid[$j,$i].Occupied = [Convert]::ToBoolean([int]$binary_Str_array[$counter])
		$counter++
	}
}

"Grid Populated"

$region_number = 1

for ($i = 0; $i -lt 128; $i++)
{
	for ($j = 0; $j -lt 128; $j++)
 {
		$cell = $grid[$j,$i]
		if ($cell.link_num -eq 0 -and $cell.Occupied -eq $true)
		{
			"---------"			
			get-connectedcells -cell_list $grid -start_x $j -start_y $i -regnum $region_number
			$region_number++
			"---------"
		}
	}
}

#should be 1212

return $region_number

[GC]::Collect()
# SIG # Begin signature block
# MIIKywYJKoZIhvcNAQcCoIIKvDCCCrgCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUAmRKX8wAwpYjTSzl0B25YWB/
# gLugggagMIIB/zCCAWigAwIBAgIQRrLr3K6l7ZdPZc3K61xe8zANBgkqhkiG9w0B
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
# BBTAR4GD7ULuL3hPqlkzT1anvJMLPDANBgkqhkiG9w0BAQEFAASBgCvmQsj7nYV3
# Aeq+N84N/fJ0edpJ3Ut+ovaFAgQs4xDS18XDaQbuSHjHiW3UcdNDRkyFNIs+rHrc
# BWw2eY/R0nGF88LQDWq6cRyL0u5NxBEyMM+V4MybKKBp017r87fBRRl8gGVhfP7u
# zeyhttRpe/TyYt/sMN9mwpmB0xgFgIXSoYICQzCCAj8GCSqGSIb3DQEJBjGCAjAw
# ggIsAgEBMIGpMIGVMQswCQYDVQQGEwJVUzELMAkGA1UECBMCVVQxFzAVBgNVBAcT
# DlNhbHQgTGFrZSBDaXR5MR4wHAYDVQQKExVUaGUgVVNFUlRSVVNUIE5ldHdvcmsx
# ITAfBgNVBAsTGGh0dHA6Ly93d3cudXNlcnRydXN0LmNvbTEdMBsGA1UEAxMUVVRO
# LVVTRVJGaXJzdC1PYmplY3QCDxaI8DklXmOOaRQ5B+YzCzAJBgUrDgMCGgUAoF0w
# GAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTgwMTAz
# MTYyMDQwWjAjBgkqhkiG9w0BCQQxFgQU9+TA5Nr6V4KhI5nordJNsvvzrhEwDQYJ
# KoZIhvcNAQEBBQAEggEAsItiB6bh9lhgOD9F3fohEdF2YGw0mO2z/SHLXfjDx3wZ
# 7oaR57/mymFAhZnzImh8AhOVq2sk6wH82rwr3ptHLESTSkNRza7eIzFNlt5QuuC+
# KwDwS4Qt/S6zywVjE/Lf3m1+UZnvGilsjzZPRtsSjnf8BoAOKYEbsjAXdeg5BfEj
# aOf3r55ft0l+EDrn8k9mBcxaPhjHSJWo8JZOGe1VataqD3oaFnrxzTUPDBdcFCVz
# 6xglz4U/KTeRykqntYy+9U04xbVw0mJ/HeydBNcihoVocs7RX9F+Co/q73YmMejJ
# lNun2Ooj6lrRJoCn8dYoXEeZQd+b5nU+xYZrWPVBZg==
# SIG # End signature block

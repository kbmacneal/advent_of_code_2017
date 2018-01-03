class cell
{
	[int]$x;
	[int]$y;
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

function get-connectedcells($cell_list, [cell]$cell_start, [int]$regnum)
{
	$connected = new-object System.Collections.ArrayList
	$up_cell = $cell_list | Where-Object -Property X -EQ $cell_start.X | Where-Object -Property Y -eq $($cell_start.Y + 1)
	$down_cell = $cell_list | Where-Object -Property X -EQ $cell_start.X | Where-Object -Property Y -eq $($cell_start.Y + 1)
	$left_cell = $cell_list | Where-Object -Property X -EQ $($cell_start.X - 1)| Where-Object -Property Y -eq $cell_start.Y
	$right_cell = $cell_list | Where-Object -Property X -EQ $($cell_start.X + 1) | Where-Object -Property Y -eq $cell_start.Y

	[void]$connected.Add($up_cell)
	[void]$connected.Add($down_cell)
	[void]$connected.Add($left_cell)
	[void]$connected.Add($right_cell)

	foreach ($cell in $connected)
 {
		if ($cell -ne $null)
		{
			if ($cell.Occupied -eq $true -and $cell.link_num -eq $null)
			{
				$cell.Link_Num = $regnum
				get-connectedcells -cell_list $cell_list -cell_start $cell -regnum $regnum
			}
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

function generate-grid()
{

	function new-cell
 {
		Param($x, $y)
    
		$properties = @{
			'X'        = $x
			'Y'        = $y
			'Occupied' = $false
			'Link_Num' = $null
		}
    
		$cell = New-Object -TypeName cell -Property $properties
    
		return $cell
	}

	$grid = new-object system.collections.arraylist

	for ($i = 0; $i -lt 128; $i++)
 {
		for ($j = 0; $j -lt 128; $j++)
		{
			$cell = new-cell -x $i -y $j
			$grid.add($cell)
		}
	}

	return $grid

}



$inputs = "jzgqcdpd"

$grid = generate-grid

$rows = 0..127 | foreach {
	(get-knothash "$inputs-$_")
}

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
        
		$($grid | Where-Object -Property X -eq $j | Where-Object -Property Y -eq $i).Occupied = [Convert]::ToBoolean([int]$binary_Str_array[$counter])
		$counter++
	}
}


"Grid Populated"

$region_number = 0

for ($i = 0; $i -lt 128; $i++)
{
	for ($j = 0; $j -lt 128; $j++)
 {
        
		$cell = $grid | Where-Object -Property X -eq $j | Where-Object -Property Y -eq $i
		if ($cell.link_num -eq $null)
		{
			$region_number++
			get-connectedcells -cell_list $grid -cell_start $cell -regnum $region_number
		}
	}
}

#should be 1212
$grid 

$region_number
# SIG # Begin signature block
# MIIKywYJKoZIhvcNAQcCoIIKvDCCCrgCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUaDUSnZdhaBx3Enhh2eRXdULX
# QuigggagMIIB/zCCAWigAwIBAgIQRrLr3K6l7ZdPZc3K61xe8zANBgkqhkiG9w0B
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
# BBRbYOGvj4Rxto0lWWNlM6xNW/oIpTANBgkqhkiG9w0BAQEFAASBgH9+UBA6OTRR
# 6HIMZZl/nRyehzhc1uZRgOiXe/Es96YqbdpckM16KXXBNnhmOx26wib9zo8Ua/s8
# 12OV43L2i17Kzr4MTJibnIe+HM7B+Y3Cr6iOGuYU6ky1f1KxMACpD4JL+HlkjDro
# J4bkmwloofPZhj9kT0vN2xmJ9WFC1PZgoYICQzCCAj8GCSqGSIb3DQEJBjGCAjAw
# ggIsAgEBMIGpMIGVMQswCQYDVQQGEwJVUzELMAkGA1UECBMCVVQxFzAVBgNVBAcT
# DlNhbHQgTGFrZSBDaXR5MR4wHAYDVQQKExVUaGUgVVNFUlRSVVNUIE5ldHdvcmsx
# ITAfBgNVBAsTGGh0dHA6Ly93d3cudXNlcnRydXN0LmNvbTEdMBsGA1UEAxMUVVRO
# LVVTRVJGaXJzdC1PYmplY3QCDxaI8DklXmOOaRQ5B+YzCzAJBgUrDgMCGgUAoF0w
# GAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTgwMTAz
# MTYyMDQ5WjAjBgkqhkiG9w0BCQQxFgQU9SfQCciDxhdE2N3p1h+3FoEFmHEwDQYJ
# KoZIhvcNAQEBBQAEggEAkNyZ35a/iuBGsOlup9WpJd9Q9m4I1cMk1X72II4XJg7G
# erprQ5kf3mOcOPgWvR79sn9Av3h0pMaywyMG83XDuN49Sb826am7BCcoylzpz0ly
# kiCXDgoED+Bblj+YS7nykOWhqlJT6y5gtddkc9LuQ+seWApUkgI+5VLN6plIyOMh
# 32SVSj+fPofS1aqjD5741YR8665Y/0qquzBlpgx1PrIit3BQseGr04WNlNU94WKq
# PhjNjQuhaykVTF/DFDlSV9Qn4FSgD6EzEpy8Ps3aSraAiu41Ka2opzcNv3ZoMlgJ
# h2Wm27OQHoYiMzEnAa0ti46aQI642ro1PM771Apo2g==
# SIG # End signature block

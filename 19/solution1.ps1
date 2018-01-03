class position
{
	[int]$x
	[int]$y
}

function get_next_point($position, $direction)
{
	switch ($direction)
 {
		"up"
		{ 
			$point = new-object -TypeName position
			$point.x = $position.x
			$point.y = $($position.y - 1)
			return $point
		}
		"down"
		{ 
			$point = new-object -TypeName position
			$point.x = $position.x
			$point.y = $($position.y + 1)
			return $point
		}
		"left"
		{ 
			$point = new-object -TypeName position
			$point.x = $($position.x - 1)
			$point.y = $position.y
			return $point
		}
		"right"
		{ 
			$point = new-object -TypeName position
			$point.x = $($position.x + 1)
			$point.y = $position.y
			return $point
		}
		Default {}
	}
}

function get_next_direction($positon, $direction, $lines)
{
	if ($direction -eq "up" -or $direction -eq "down")
	{
		if ($lines[$position.y][$($position.x - 1)] -eq "-")
		{
			return "left"
		}
		if ($lines[$position.y][$($position.x + 1)] -eq "-")
		{
			return "right"
		}
		if ($lines[$position.y][$($position.x - 1)] -match "[A-Z]")
		{
			return "left"
		}
		if ($lines[$position.y][$($position.x + 1)] -match "[A-Z]")
		{
			return "right"
		}
	}
	if ($direction -eq "left" -or $direction -eq "right")
	{
		if ($lines[$($position.y - 1)][$position.x] -eq "|")
		{
			return "up"
		}
		if ($lines[$($position.y + 1)][$position.x] -eq "|")
		{
			return "down"
		}
		if ($lines[$($position.y - 1)][$position.x] -match "[A-Z]")
		{
			return "up"
		}
		if ($lines[$($position.y + 1)][$position.x] -match "[A-Z]")
		{
			return "down"
		}
	}
}


$inputs = get-content .\input.txt

$letters = New-Object system.collections.arraylist

$lines = New-Object system.collections.arraylist

$lines.AddRange($inputs)

$steps = 1

$direction = "down"

$position = New-Object -typename position

$position.x = $($inputs[0].IndexOf("|"))

$position.y = 0

while ($true)
{

	$position = get_next_point -position $position -direction $direction
	
	$steps++

	$nextchar = $lines[$($position.y)][$($position.x)]

	if ($nextchar -eq ' ')
 {
		$steps--
		return $steps.ToString() + "`r`n" + $($letters -join "")
			
	}

	if ($nextchar -eq '|' -or $nextchar -eq '-')
 {
		continue
	}

	if ($nextchar -match "[A-Z]")
 {
		[void]$letters.Add($nextchar)
		continue
	}

	if ($nextchar -eq '+')
 {
		$direction = get_next_direction -positon $position -direction $direction -lines $lines
		continue
	}

}

#PBAZYFMHT
#16072
# SIG # Begin signature block
# MIIKywYJKoZIhvcNAQcCoIIKvDCCCrgCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUZzuFtZWitobeJEpvbLfjyd7p
# BN2gggagMIIB/zCCAWigAwIBAgIQRrLr3K6l7ZdPZc3K61xe8zANBgkqhkiG9w0B
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
# BBStUctZ7sQh8g9R3GhvsSyhpWaWNzANBgkqhkiG9w0BAQEFAASBgDTQmnB/0QEM
# IgI9pAPz9Dia5TK+qjI7+/Rfu8Paf3+UKAyacLbsX02nXC0vcGrFaAa4KNvNIixp
# NSAUtp6ACo+OBe91HwEAOOYMVF0OWE1/pjVBKEvrVWk9RypM0DbaLmA7L8bySFWN
# jq462eJywFWNLWZcZmK2Bm9NhRQE6oKooYICQzCCAj8GCSqGSIb3DQEJBjGCAjAw
# ggIsAgEBMIGpMIGVMQswCQYDVQQGEwJVUzELMAkGA1UECBMCVVQxFzAVBgNVBAcT
# DlNhbHQgTGFrZSBDaXR5MR4wHAYDVQQKExVUaGUgVVNFUlRSVVNUIE5ldHdvcmsx
# ITAfBgNVBAsTGGh0dHA6Ly93d3cudXNlcnRydXN0LmNvbTEdMBsGA1UEAxMUVVRO
# LVVTRVJGaXJzdC1PYmplY3QCDxaI8DklXmOOaRQ5B+YzCzAJBgUrDgMCGgUAoF0w
# GAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTgwMTAz
# MTYyMTE5WjAjBgkqhkiG9w0BCQQxFgQUXZDuQz9FbPuR7OHwJN51AJ3sMLowDQYJ
# KoZIhvcNAQEBBQAEggEAN+U8Moby5xCxoos6t5uF0MqSVD1TFrh+d69xhJ5zWUWx
# mq7K0uDHftV7WEVASzT3bhoD3GEsWQ4wi6Q1M7n19ZbCKF9W9Mudb7JQL/kCK95r
# 5L0CG2BYIf8q2ROoocQG7dGwu6U8nJbtXTeaf9mSxWoSi3Bw4Ob1V04F1gEsSR9m
# MfWRx5eqtMnt4d75G7OnKqubFYeND8dmpy5WhfEDMU/McwLL0CqLT8yvVZElJBkV
# dkBtFXDaKKmFTiSbF2NN1LOJY9npFx3VwMW3ziieqNp93x1TIf0uKg421sTgxbw8
# 5dDG3cbLM/jk9evsjRFPAf0QrwB37XTM6jcZxLwezA==
# SIG # End signature block

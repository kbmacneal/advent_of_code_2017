class particle
{
	[int]$index;
	[long]$position_x;
	[long]$position_y;
	[long]$position_z;
	[long]$vel_x;
	[long]$vel_y;
	[long]$vel_z;
	[long]$acc_x;
	[long]$acc_y;
	[long]$acc_z;
	[long]$man_dist;
	[long]$total_acc;
	[long]$total_vel;
	[bool]$collided = $false;
	[long]$total_distance = 0
}

function total_distance ([particle]$particle)
{
	$total_distance += $particle.man_dist
}

function do_manhattan_dist([particle]$particle)
{
	$particle.man_dist = [Math]::Abs($particle.position_x) + [Math]::Abs($particle.position_y) + [Math]::Abs($particle.position_z)
}

function do_accellerate ([particle]$particle)
{	
	$particle.vel_x += $particle.acc_x
	$particle.vel_y += $particle.acc_y
	$particle.vel_z += $particle.acc_z
}

function do_move ([particle]$particle)
{
	$particle.position_x += $particle.vel_x
	$particle.position_y += $particle.vel_y
	$particle.position_z += $particle.vel_z
}

$inputs = get-content .\input.txt

$particles = New-Object system.collections.arraylist
$index = 0
foreach ($part in $inputs)
{
	
	$part_array = @()
	$icle = ($part.replace("p=","").replace("v=","").replace("a=", "")) -split ">,"
	
	foreach ($item in $icle)
 {
		$part_array += $item.replace("<","").replace(">","")
	}
	$particle = New-Object -TypeName particle		

	$particle.position_x = ($part_array[0] -split ",")[0]
	$particle.position_y = ($part_array[0] -split ",")[1]
	$particle.position_z = ($part_array[0] -split ",")[2]
	$particle.vel_x = ($part_array[1] -split ",")[0]
	$particle.vel_y = ($part_array[1] -split ",")[1]
	$particle.vel_z = ($part_array[1] -split ",")[2]
	$particle.acc_x = ($part_array[2] -split ",")[0]
	$particle.acc_y = ($part_array[2] -split ",")[1]
	$particle.acc_z = ($part_array[2] -split ",")[2]
	$particle.index = $index

	$particle.total_acc = [Math]::Abs($particle.acc_x) + [Math]::Abs($particle.acc_y) + [Math]::Abs($particle.acc_z)
	$particle.total_vel = [Math]::Abs($particle.vel_x) + [Math]::Abs($particle.vel_y) + [Math]::Abs($particle.vel_z)

	[void]$particles.Add($particle)

	$index++
	
}
foreach ($particle in $particles) {do_manhattan_dist -particle $particle}

$tick = 0

while($tick -lt 1000)
{
	foreach ($particle in $($particles | where collided -eq $false)) {
		
		do_accellerate -particle $particle
		do_move -particle $particle
		do_manhattan_dist -particle $particle
	}


	$collisions = $particles | Group-Object -Property position_x,position_y,position_z | Where-Object count -gt 1

	foreach ($collision in $collisions) {
		$collision.group | % {$_.collided = $true}
	}

	$tick++
}

return ($particles | where collided -eq $false).count
# SIG # Begin signature block
# MIIKywYJKoZIhvcNAQcCoIIKvDCCCrgCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUkTMRjfhCdRKvOJarwJfKiM4l
# FKmgggagMIIB/zCCAWigAwIBAgIQRrLr3K6l7ZdPZc3K61xe8zANBgkqhkiG9w0B
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
# BBSJKqD5noWr6GmCpRq0GTmnYt1fZDANBgkqhkiG9w0BAQEFAASBgI89yn7gviDF
# kTDoHklbifywb1bOfR/SUncR+xh+YJKoV/MpoZiqA2LN4NK1VOl3yIbM7RgRT91L
# re5dDhmQFcFsa9Eges8nhKoRfYYqL0fULrudeETL7Ua3TtL1XZK8eq9sDcaUYf7u
# iIMBlUXkOuS6HzEq4SVlZVrQey5FIsupoYICQzCCAj8GCSqGSIb3DQEJBjGCAjAw
# ggIsAgEBMIGpMIGVMQswCQYDVQQGEwJVUzELMAkGA1UECBMCVVQxFzAVBgNVBAcT
# DlNhbHQgTGFrZSBDaXR5MR4wHAYDVQQKExVUaGUgVVNFUlRSVVNUIE5ldHdvcmsx
# ITAfBgNVBAsTGGh0dHA6Ly93d3cudXNlcnRydXN0LmNvbTEdMBsGA1UEAxMUVVRO
# LVVTRVJGaXJzdC1PYmplY3QCDxaI8DklXmOOaRQ5B+YzCzAJBgUrDgMCGgUAoF0w
# GAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTgwMTAz
# MTYyMTMxWjAjBgkqhkiG9w0BCQQxFgQUftfHTTwiYImHZynlLMWQBi3VL5cwDQYJ
# KoZIhvcNAQEBBQAEggEAWGSJHRfbme2/uDB0Tkthe1APXy5VmS1PPLfNnlQBX+z0
# 86DwZ0MKreIUVQUacVTudR/ClEqgx3TGWoypB++6YfQIdgPAdTPyBULMvcy6aynT
# IhmD18ULxW4oe4UalmPdG7rLkIpRVeJroLW0ZW3hC0tHKxYca8K6LQzYKshScOOj
# 3o4KNEq2XZw2yDCAAnCi4usc0oLk2YHaKn+rdXsLKLtwsuAdj+F1pX9Kv7TlgXBO
# ZPxRY+ANIWZtn93eUJzOPb2kqbcMK/EDJx3/pWPyPuYku9PIg/S32xYG+bpygHuh
# agJRoZXdP8UHZBqQmpAt5R+9IX5DY++nAJpbi20yxA==
# SIG # End signature block

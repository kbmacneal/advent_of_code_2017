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

function do_manhattan_dist()
{
    Param(
    [Parameter(ValueFromPipeline)]
    [particle]
    $particle)
	$particle.man_dist = [Math]::Abs($particle.position_x) + [Math]::Abs($particle.position_y) + [Math]::Abs($particle.position_z)
}

function do_accellerate ()
{	
    Param(
    [Parameter(ValueFromPipeline)]
    [particle]
    $particle)
	$particle.vel_x += $particle.acc_x
	$particle.vel_y += $particle.acc_y
	$particle.vel_z += $particle.acc_z
}

function do_move ()
{
    Param(
    [Parameter(ValueFromPipeline)]
    [particle]
    $particle)
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

$particles | sort -Property total_acc,total_vel,man_dist | select index -first 1 | fl

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
        $collision.Group | %{$_.collided = $true}
    }


	$tick++
}

return ($particles | where collided -eq $false).count
$inputs = 325489


$ring = 0
$max_ring_val = 1

while($max_ring_val -lt $inputs)
{
    $ring++

    $max_ring_val = $max_ring_val + $(8 * $ring)
}

$sequence_index = ($inputs -1) % (2 * $ring)

$dist_along_edge = [math]::Abs($sequence_index - $ring)

$taxi_dist = $dist_along_edge + $ring


$taxi_dist
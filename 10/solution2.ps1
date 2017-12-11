$lengths = @([int[]][System.Text.Encoding]::ASCII.GetBytes('102,255,99,252,200,24,219,57,103,2,226,254,1,0,69,216')) + @(17,31,73,47,23)
$list = 0..255

$curPos = 0
$skipSize = 0


0..63 | ForEach-Object {

    foreach ($len in $lengths)
    {
        # Get the indexes of items to reverse, handling wraparound
        # for a given length greater than the length of the array, will return positions at the beginning
        $indexesToReverse = for ($i=0; $i -lt $len; $i++){ ($curPos + $i) % $list.Count }

        # Swap first and last, seconds and penultimate, third and .. etc unto the middle one: 0,-1  1,-2, 2,-3 etc.
        for ($i=0; $i -lt [int]($indexesToReverse.Count/2); $i++)
        {
            $temp = $list[$indexesToReverse[$i]]
            $list[$indexesToReverse[$i]] = $list[$indexesToReverse[0-($i+1)]]
            $list[$indexesToReverse[0-($i+1)]] = $temp
        }
        # the next position including wraparound, increment the skip value
        $curPos = ($curPos + $len + $skipSize) % $list.count
        $skipSize++
    }
}

#generates 16 sets of 16
$sixteens = 0..15|%{ ,((($_*16)..(($_*16)+15)))}

#kid of odd way to do it, two nested loops could have done it

$denseHash = foreach ($set in $sixteens)
{
    $out = $list[$set[0]]
    foreach ($index in $set[1..15]){ $out = $out -bxor $list[$index] }
    $out
}

-join ($denseHash | foreach { '{0:x2}' -f $_ })

#from https://www.reddit.com/r/adventofcode/comments/7irzg5/2017_day_10_solutions/dr12q92/
# from https://www.reddit.com/r/adventofcode/comments/7j89tr/2017_day_12_solutions/dr4grnp/ i'll definitely be studying this

$in = get-content .\input.txt

$connections = @{}
$in | ForEach-Object {

    [int]$Left, [string]$Right = $_ -split ' <-> '

    $connections[$Left] = [int[]]@($Right -split ', ')
}

$visited = New-Object System.Collections.ArrayList

[System.Collections.Generic.List[int]]$allNodes = $connections.Keys | ForEach-Object {$_}
$allNodes += $connections.Values | ForEach-Object {$_}

[System.Collections.Generic.List[int]]$allNodes = $allNodes | Sort-Object -Unique

function visit2 ([int]$id)
{
    foreach ($node in $connections[$id])
    {
        if ($node -notin $visited2)
       {
            [void]$visited2.Add($node)
            if ($node -in $allNodes)
            {
                [void]$allNodes.remove($node)
                visit2 $node
            }
        }
    }
}

$groups = 0
while ($allNodes)
{
    $visited2 = New-Object -TypeName System.Collections.ArrayList

    $node = $allNodes[0]
    [void]$allNodes.Remove($node)
    visit2 $node
    $groups++
}
$groups
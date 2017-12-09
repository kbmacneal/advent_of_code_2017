$inputs = get-content .\input.txt

$cleaned = new-object 'System.Collections.Generic.List[string]'

foreach ($char in $inputs.GetEnumerator()) {

$null = $cleaned.Add($char.tostring())
    
} 

$sum = 0;
$groupNestLevel = 0;
$inGarbage = $false;
$skipNext = $false;
$removedcharacters = 0;
foreach ($chr in $cleaned)
{
    if ($skipNext)
    {
        $skipNext = $false;
        continue;
    }

    if ($chr -eq '!')
    {
        $skipNext = $true;
        continue;
    }

    if ($chr -eq '<')
    {
        if ($inGarbage -eq $false)
        {
            $inGarbage = $true;
            continue;
        }
    }
    if ($chr -eq '>')
    {
        $inGarbage = $false;
        continue;
    }

    if ($chr -eq '{' -and !($inGarbage))
    {
        $groupNestLevel++;
    }

    if ($chr -eq '}' -and !$($inGarbage))
    {
        $sum += $groupNestLevel;
        $groupNestLevel--;

    }

    if($inGarbage)
    {
        $removedcharacters++;
    }
}

"star 1: $sum star 2: $removedcharacters"

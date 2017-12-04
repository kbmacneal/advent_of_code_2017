#$inputs = get-content input_test.txt
$inputs = get-content input.txt
$results = New-Object System.Collections.Arraylist

foreach($line in $inputs)
{
    $passwords = $line -split " "
    $valid = $true

    for($i =0; $i -lt $passwords.Length; $i++)
    {
        $skip = $i

        for ($y = 0; $y -lt $passwords.Length; $y++) {
            if($passwords[$i] -eq $passwords[$y] -and $y -ne $skip)
            {
                $valid = $false
                
            }
        }
    }
    $properties = 
    [ordered]@{
        'Password' = $passwords
        'Valid' = $valid
    }

    $obj = New-Object -TypeName psobject -Property $properties
    $null = $results.Add($obj)
}


($results | Where-Object -Property Valid -EQ $true).Count
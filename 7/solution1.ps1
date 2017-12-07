function new-tree
{
    $inputs = get-content .\input.txt

    $nodes = New-Object -TypeName 'System.Collections.Generic.List[object]'

    $trees = New-Object -TypeName 'System.Collections.Generic.List[object]'


    foreach($line in $inputs)
    {
        $line=$line.ToString()
        if($line -like "*->*")
        {
            $name = (($line -split "->")[0] -split(" ",""))[0]


            [int]$weight = (($line -split "->")[0] -split(" ",""))[1].Replace("(","").Replace(")","")


            $children = ($line -split "->")[1].Replace(" ","") -split ","

            $child_array = New-Object System.Collections.ArrayList

            foreach($child in $children)
            {
                $properties = [ordered]@{
                    'Name' = $child
                    'Weight' = 0
                }

                $obj = New-Object -TypeName psobject -Property $properties
                $null = $child_array.Add($obj)
            }

            $properties = [ordered]@{
                'Name'=$name
                'Weight'=$weight
                'Children' = $child_array
            }

            $obj = New-Object -TypeName psobject -Property $properties

            $null = $trees.add($obj)
        }
        else 
        {
            $name = ($line -split " ")[0]
            [int]$weight = ($line -split " ")[1].Replace("(","").Replace(")","")

            $properties = [ordered]@{
                'Name'=$name
                'Weight'=$weight
            }

            $obj = New-Object -TypeName psobject -Property $properties

            $null = $nodes.add($obj)
        }

        

        
    }

    foreach($obj in $nodes)
    {
        $name = $obj.Name

        ($trees.Children | Where-Object -Property Name -eq $name).Weight = $obj.Weight
    }

    foreach($obj in $trees)
    {
        $name = $obj.Name

        if($trees.Children | Where-Object -Property Name -eq $name)
        {
            ($trees.Children | Where-Object -Property Name -eq $name).Weight = $obj.Weight
        }

        
    }


   
    return $trees
}

$tree = new-tree 

$tree | Where-Object  -Property Name -notin ($tree.Children).Name
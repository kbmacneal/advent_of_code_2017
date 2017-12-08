function loop-control ($i, $count) {
    if ($i -ge $($count - 1))
    {$i = 0}
    
    else {$i++}

    return $i
}

function assign-tochildren($node, $parent)
{
    <#
    $found = $false
    if($parent.Children){
        foreach ($child in $($parent.Children)) {
            if($node.Name -eq $child.Name)
            {
                $child = $node
                $found = $true
                
            }
        }
            if($found){
                return $true
            }
            else{
                foreach ($child in $($parent.Children)) {
                assign-tochildren -node $node -parent $child
            }
        }
        }#>

        $found = $false
        if($parent.Children)
        {
            foreach ($child in $($parent.Children)) {
                if($node.Name -eq $child.Name)
                {
                    $child = $node
                    return $true
                    
                }
                else{
                    if($child.Children)
                    {
                        foreach ($child in $($child.Children)) {
                            assign-tochildren -node $node -parent $child
                        }
                    }
                    
                }
            }
        }
}

function new-tree
{
    $inputs = get-content .\input_test.txt
    #$inputs = get-content .\input.txt
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

#from https://stackoverflow.com/a/14970081
function Get-Properties($Object, $MaxLevels="5", $PathName = "`$_", $Level=0)
{
    <#
        .SYNOPSIS
        Returns a list of all properties of the input object

        .DESCRIPTION
        Recursively 

        .PARAMETER Object
        Mandatory - The object to list properties of

        .PARAMETER MaxLevels
        Specifies how many levels deep to list

        .PARAMETER PathName
        Specifies the path name to use as the root. If not specified, all properties will start with "."

        .PARAMETER Level
        Specifies which level the function is currently processing. Should not be used manually.

        .EXAMPLE
        $v = Get-View -ViewType VirtualMachine -Filter @{"Name" = "MyVM"}
        Get-Properties $v | ? {$_ -match "Host"}

        .NOTES
            FunctionName : 
            Created by   : KevinD
            Date Coded   : 02/19/2013 12:54:52
        .LINK
            http://stackoverflow.com/users/1298933/kevind
     #>

    if ($Level -eq 0) 
    { 
        $oldErrorPreference = $ErrorActionPreference
        $ErrorActionPreference = "SilentlyContinue"
    }

    #Initialize an array to store properties
    $props = @()

    # Get all properties of this level
    $rootProps = $Object | Get-Member -ErrorAction SilentlyContinue | Where-Object { $_.MemberType -match "Property"} 

    # Add all properties from this level to the array.
    $rootProps | ForEach-Object { $props += "$PathName.$($_.Name)" }

    # Make sure we're not exceeding the MaxLevels
    if ($Level -lt $MaxLevels)
    {

        # We don't care about the sub-properties of the following types:
        $typesToExclude = "System.Boolean", "System.Int32", "System.Char"

        #Loop through the root properties
        $props += $rootProps | ForEach-Object {

                    #Base name of property
                    $propName = $_.Name;

                    #Object to process
                    $obj = $($Object.$propName)

                    # Get the type, and only recurse into it if it is not one of our excluded types
                    $type = ($obj.GetType()).ToString()

                    # Only recurse if it's not of a type in our list
                    if (!($typesToExclude.Contains($type) ) )
                    {

                        #Path to property
                        $childPathName = "$PathName.$propName"

                        # Make sure it's not null, then recurse, incrementing $Level                        
                        if ($obj -ne $null) 
                        {
                            Get-Properties -Object $obj -PathName $childPathName -Level ($Level + 1) -MaxLevels $MaxLevels }
                        }
                    }
    }

    if ($Level -eq 0) {$ErrorActionPreference = $oldErrorPreference}
    $props
}

$rtn = new-tree 

$trees = New-Object -TypeName System.Collections.ArrayList

$root_node = $trees | Where-Object  -Property Name -notin ($trees.Children).Name

foreach ($item in $rtn) {
    $null = $trees.Add($item)    
}

$root_node = $trees | Where-Object  -Property Name -notin ($trees.Children).Name

$i = 0

do {
    $obj = $trees[$i]

    if($obj.Name -ne $root_node.Name)
    {
        for ($y = 0; $y -lt $trees.Count; $y++) {
            if(assign-tochildren -node $obj -parent $trees[$y])
            {
                $y = $trees.Count
                $trees.removeat($i)
                $i = loop-control -i $i -count $trees.Count
                break
            }
            else{
                $i = loop-control -i $i -count $trees.Count
            }
        }

    }
    else{
        $i = loop-control -i $i -count $trees.Count
    }
    

} until ($($trees | Measure-Object).count -eq 1)

$trees
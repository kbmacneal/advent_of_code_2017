#$inputs = get-content input_test2.txt
$inputs = get-content input.txt
$results = New-Object System.Collections.Arraylist


#from https://gist.github.com/jdhitsolutions/1a05db07a3bc1b5c93728755f631b34e modified a tad for the purposes of the challenge.

Function Get-Anagram {
    [cmdletbinding()]

    Param(
        [Parameter(Position = 0, Mandatory)]
        [ValidateNotNullorEmpty()]
        [Alias("word")]
        [string]$Text,

        [ValidateNotNullorEmpty()]
        [string[]]$WordList
    )

    Begin {
        Write-Verbose "[BEGIN  ] Starting: $($MyInvocation.Mycommand)"  
        Write-Verbose "[BEGIN  ] Loading word list: $wordlist"       
    
    } #begin

    Process {
        Write-Verbose "[PROCESS] Finding anagrams for: $Text"
        #set word to all lowercase so it sorts properly
        $a = ($text.ToLower().GetEnumerator() | Sort-Object) -join '' 
            
        #it was slightly faster to filter out the original word in a second Where filter
        $anagrams = $WordList | 
        Where-object {($_.length -eq $text.Length) -AND ((($_.ToLower().GetEnumerator() | Sort-Object) -join '') -eq $a)}   
    
            return $anagrams.Count
    } #process

    End {
        Write-Verbose "[END    ] Ending: $($MyInvocation.Mycommand)"
    } #end
} #close Get-Anagram function



foreach($line in $inputs)
{
    $passwords = $line -split " "
    $valid = $true

    for($i =0; $i -lt $passwords.Length; $i++)
    {
        $skip = $i

        for ($y = 0; $y -lt $passwords.Length; $y++) {

            $anagram_count = Get-Anagram -Text $passwords[$y] -WordList $passwords
            if($y -ne $skip -and $anagram_count -gt 1)
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
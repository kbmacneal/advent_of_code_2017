$Script:powershell = $null
$Script:body = @'
    function New-UnboundClassInstance ([Type] $type, [object[]] $arguments) {
        [activator]::CreateInstance($type, $arguments)
    }
'@
 
function Initialize {
    ## A runspace is created and NO powershell class is defined in it
    $Script:powershell = [powershell]::Create()
    ## Define a function in that runspace to create an instance using the given type and arguments
    $Script:powershell.AddScript($Script:body).Invoke()
    $Script:powershell.Commands.Clear()
}
 
function New-UnboundClassInstance ([Type] $type, [object[]] $arguments = $null)
{
    if ($Script:powershell -eq $null) { Initialize }
 
    try {
        ## Pass in the powershell class type and ctor arguments and run the helper function in the other runspace
        if ($arguments -eq $null) { $arguments = @() }
        $result = $Script:powershell.AddCommand("New-UnboundClassInstance").
                                     AddParameter("type", $type).
                                     AddParameter("arguments", $arguments).
                                     Invoke()
        return $result[0]
    } finally {
        $Script:powershell.Commands.Clear()
    }
}
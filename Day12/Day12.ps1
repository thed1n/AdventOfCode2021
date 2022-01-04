$data = get-content .\Day12\Input12.txt

#$data = Get-Content .\Day12\Test12.txt

function get-uniqpaths () {
[CmdletBinding()]
param(
    [string]$start, [string[]]$path = @(), [switch]$part2
)

    $path += @($start)

    write-verbose "[$start] [$($path -join ',')]"
    if ($start -eq 'end') {
       return ($path -join ',')
    }
    if ($part2 -eq $true) {

        #gets maxed visited caves
        $smallcaves = $path | ? {$_ -cmatch '^[a-z]{1,2}$'} | group | sort count | select -last 1 -ExpandProperty count
        
            foreach ($n in $nodes[$start]) {
                #$visited[$n]++
                write-verbose "N is [$n]"
            if ($n -cmatch '[A-Z]' -or $n -eq 'end') {
                
                # tried to do like this with a hashtable if ($n -cmatch '[a-z]' -and $nodes.ContainsKey($n) -eq $false) {}
                # but ended up with the above to handle the CAPITAL and lowercase in the array.
                get-uniqpaths $n $path -part2
            }

                #lowercase

            else {
                #if ($nodes[$n].count -eq 1 -and $visited[$n] -le 1) {
                    if ($smallcaves -eq 2 -and $path -cnotcontains $n) {
                #if ($nodes[$n].count -eq 1 -and $path -cnotcontains $n) {   
                    write-verbose "if #1 nodes -eq 1 -and visited le 1 ]"
                    Write-Verbose "if #1 [$n] $($path -join ',')"
                    get-uniqpaths $n $path -part2 
                }

                #elseif ($nodes[$n].count -gt 1 -and $visited[$n] -le 2) {
                #elseif ($nodes[$n].count -gt 1 -and $($path | where {$_ -eq $n}).count -le 2) {
                    elseif ($smallcaves -le 1 -and $n -ne 'start') {
                    write-verbose "if #2 nodes -gt 1 -and visited le 2"
                    Write-Verbose "if #2 [$n] $($path -join ',')"
                    get-uniqpaths $n $path -part2 
                }

                # else {
                #     Write-Verbose "break [$n] $($path -join ',')"
                #     write-verbose "break while"
                #     return
                #     #break :outer
                # }

            }
            }
            
        #}
        }
    
    else {
    foreach ($n in $nodes[$start]) {
            
        if ($n -cmatch '[A-Z]' -or $path -cnotcontains $n) { 
            # tried to do like this with a hashtable if ($n -cmatch '[a-z]' -and $nodes.ContainsKey($n) -eq $false) {}
            # but ended up with the above to handle the CAPITAL and lowercase in the array.
            get-uniqpaths $n $path
        }
        
    }
}

}



$nodes = @{}

#Had to rethink the node building, was on the right track but thanks to indented-automation,
#I took some inspiration to get to the same solution
$data | % {
    $a,$b = $_ -split '-'
    if ($a -ne 'end') {
        $nodes[$a] += @($b)
    }
    if ($a -ne 'start' -and $b -ne 'end') {
        $nodes[$b] += @($a)
    }
}


$part1 = get-uniqpaths 'start'
$part2 = get-uniqpaths 'start' -part2 

[PSCustomObject]@{
    part1 = $part1.count
    part2 = $part2.count
}
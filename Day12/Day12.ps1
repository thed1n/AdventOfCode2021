$data = get-content .\Day12\Input12.txt

#$data = Get-Content .\Day12\Test12.txt

function get-uniqpaths ([string]$start, [string[]]$path = @()) {

    $path += @($start)

    write-verbose "[$start] [$($path -join ',')]"
    if ($start -eq 'end') {
       return ($path -join ',')
    }

    foreach ($n in $nodes[$start]) {
            
        if ($n -cmatch '[A-Z]' -or $path -cnotcontains $n) { 
            # tried to do like this with a hashtable if ($n -cmatch '[a-z]' -and $nodes.ContainsKey($n) -eq $false) {}
            # but ended up with the above to handle the CAPITAL and lowercase in the array.
            get-uniqpaths $n $path
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

[PSCustomObject]@{
    part1 = $part1.count
}


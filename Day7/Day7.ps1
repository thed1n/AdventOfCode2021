$data = get-content .\Day7\Input7.txt
$data = $data -split ',' -as [int32[]]

$data= '16,1,2,0,4,2,7,1,2,14' -split ',' -as [int32[]]
$min, $max = $data | sort | select -first 1 -last 1



function find-optimizepath {
    param(
        [int32]$position,
        [int32]$target,
        $memo=@{}
    )

        return [math]::abs($position-$target)


}
function find-path {
    param(
        [int32[]]$position,
        [int32]$min,
        [int32]$max,
        [int32]$target,
        $memo=@{}
    )
        #if ($memo[$target]) {return $memo[$target]}
        
        for ($i = $min; $i -lt $max; $i++) {
            $result = 0
            foreach ($p in $position) {
                if (-not $memo["$p,$i"]) {
                    Write-Verbose "working: $p $i"
                    write-verbose "$(sumofline -steps ([math]::abs($p - $i)))"
                $memo["$p,$i"] = (sumofline -steps ([math]::abs($p - $i)))
                $result += $memo["$p,$i"]
                #$memo[$i] = find-path -position $p -target $i -memo $memo
                }
                else {$result += $memo["$p,$i"]}
            }
            write-verbose "$p [$($result | measure-object -sum | % sum)]"
            [pscustomobject]@{
                position = $i
                steps = $result | measure-object -sum | % sum
            }
        }
}

function sumofline {
    #Sum of finite series members
    param ([int32]$steps)
    return ($steps*(1+$steps)/2)
}

$calc = for ($i = $min; $i -lt $max; $i++) {
    
    $result = foreach ($d in $data) {
        find-optimizepath -position $d -target $data[$i]
    }
    [PSCustomObject]@{
        position = $i
        steps = $result | measure-object -sum |% sum
    }

}

$part2 = find-path -position $data.clone() -min $min -max $max
#(11*(1+11))/2
[PSCustomObject]@{
    part1 = ($calc | sort -property steps| select -first 1).steps
    part2 = ($part2 | sort -Property steps|select -first 1).steps
}
$part2 | ogv

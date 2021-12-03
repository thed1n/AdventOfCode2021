$data = get-content .\Day3\Input3.txt

[string]$gamma = ''
[string]$epsilon = ''

for ($i = 0 ; $i -le $data[0].length-1 ; $i++) {
    [int32]$count1 = 0
    [int32]$count0 = 0

    for ($x = 0; $x -lt $data.Count; $x++) {
        
        $chararr = $data[$x] -as [char[]]
        if ($chararr[$i] -eq '1') {
            $count1++
        }
        else {$count0++}

    }


    if ($count1 -gt $count0) {
        $gamma += '1'
        $epsilon += '0'
    }
    else {
        $gamma += '0'
        $epsilon += '1'
    }
}


[PSCustomObject]@{
    part1  = [Convert]::ToInt32($gamma,2) * [Convert]::ToInt32($epsilon,2)
    part2 = ''
}

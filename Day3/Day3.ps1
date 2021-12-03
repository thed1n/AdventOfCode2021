$data = get-content .\Day3\Input3.txt

[string]$gamma = ''
[string]$epsilon = ''

$oxygen = $null
$co2 = $null

for ($i = 0 ; $i -le $data[0].length - 1 ; $i++) {
    [int32]$count1 = 0
    [int32]$count0 = 0

    for ($x = 0; $x -lt $data.Count; $x++) {
        
        $chararr = $data[$x] -as [char[]]
        if ($chararr[$i] -eq '1') {
            $count1++
        }
        else { $count0++ }

    }


    if ($count1 -gt $count0) {
        $gamma += '1'
        $epsilon += '0'
    }
    if ($count0 -gt $count1) {
        $gamma += '0'
        $epsilon += '1'
    }

}


function get-oxygen ([string[]]$arrdata) {
    $oxygen = $null

    for ($i = 0 ; $i -le $arrdata[0].length - 1 ; $i++) {
        write-verbose "arrdata [$arrdata]"
        [int32]$count1 = 0
        [int32]$count0 = 0
    
        for ($x = 0; $x -lt $arrdata.Count; $x++) {
            $chararr = $arrdata[$x] -as [char[]]
            if ($chararr[$i] -eq '1') {
                $count1++
            }
            else { $count0++ }
        }
            write-verbose "[$count1] [$count0]"
        if ($count1 -gt $count0) {
            if ($oxygen.count -ne 1) {
                if ($oxygen) {$oxygen = $oxygen | ? { $_[$i] -eq '1' }} 
                else { $oxygen = $arrdata | ? { $_[$i] -eq '1' } }
            }
        }
        if ($count0 -gt $count1) {
            if ($oxygen.count -ne 1) {
                if ($oxygen) {$oxygen = $oxygen | ? { $_[$i] -eq '0' }} 
                else { $oxygen = $arrdata | ? { $_[$i] -eq '0' } }
            }
        }
        if ($count0 -eq $count1) {
            if ($oxygen.count -ne 1) {
                if ($oxygen) {$oxygen = $oxygen | ? { $_[$i] -eq '1' }} 
                else { $oxygen = $arrdata | ? { $_[$i] -eq '1' } }
            }
        }
        write-verbose "oxygen [$oxygen]"
        $arrdata = $oxygen.Clone()
    }

    return $arrdata
}
function get-co2 ([string[]]$arrdata) {
    $co2 = $null
    for ($i = 0 ; $i -le $arrdata[0].length - 1 ; $i++) {
        write-verbose "arrdata [$arrdata]"
        [int32]$count1 = 0
        [int32]$count0 = 0
    
        for ($x = 0; $x -lt $arrdata.Count; $x++) {
            $chararr = $arrdata[$x] -as [char[]]
            if ($chararr[$i] -eq '1') {
                $count1++
            }
            else { $count0++ }
        }
        write-verbose "[$count1] [$count0]"
        if ($count1 -gt $count0) {
            if ($co2.count -ne 1) {
                if ($co2) { $co2 = $co2 | ? { $_[$i] -eq '0' } }
                else { $co2 = $arrdata | ? { $_[$i] -eq '0' } }
            }
        }
        if ($count0 -gt $count1) {
            if ($co2.count -ne 1) {
                if ($co2) { $co2 = $co2 | ? { $_[$i] -eq '1' } }
                else { $co2 = $arrdata | ? { $_[$i] -eq '1' }}
            }
        }
        if ($count0 -eq $count1) {
            if ($co2.count -ne 1) {
                if ($co2) { $co2 = $co2 | ? { $_[$i] -eq '0' } }
                else { $co2 = $arrdata | ? { $_[$i] -eq '0' }}
            }
        }
        write-verbose "co2 [$co2]"
        $arrdata = $co2.Clone()
    }

    return $arrdata
}

$oxygen = get-oxygen $data
$co2 = get-co2 $data
[PSCustomObject]@{
    part1 = [Convert]::ToInt32($gamma, 2) * [Convert]::ToInt32($epsilon, 2)
    part2 = [Convert]::ToInt32($oxygen, 2) * [Convert]::ToInt32($co2, 2)
}

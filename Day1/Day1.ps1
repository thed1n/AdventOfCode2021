[CmdletBinding(SupportsShouldProcess)]

[int[]]$data = get-content .\Day1\Input1.txt
$increase = 0

for ($i=1;$i -le $data.count;$i++) {

    if ($data[$i-1] -lt $data[$i]) {
        $increase++
    }

  
    
}
$result = $increase


$sliding = 0

for ($i=0;$i -lt $data.count-3;$i+=1) {
[int32]$val1 = 0
[int32]$val2 = 0
$val1 = $data[$i]+$data[$i+1]+$data[$i+2]
$val2 = $data[$i+1]+$data[$i+2]+$data[$i+3]


if ($val2 -gt $val1) {
    $sliding++
}

write-verbose "[$i] [$val1] [$val2] [$sliding]"
}

$result2 = $sliding

[PSCustomObject]@{
   Part1 = $result
   Part2 = $result2
}
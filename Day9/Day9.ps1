$data = get-content .\Day9\Input9.txt
$data = Get-Content .\Day9\Test9.txt

$data

#9 highest
#0 lowest

$data[0].Length
$data.Count

function check-adjecentLava ($y,$x,[int32]$current) {

    $left = $x-1
    $right = $x+1
    $up = $y-1
    $down = $y+1

    [int32]$lowerThan = 0

    if ($left -lt 0) {$left = $null}
    if ($up -lt 0) {$up = $null}
    if ($right -ge $grid[0].count) {$right = $null}

    try {if ($current -lt $grid[$up][$x]) {$lowerThan++}} catch {$lowerThan++}
    try {if ($current -lt $grid[$down][$x]) {$lowerThan++}} catch {$lowerThan++}
    try {if ($current -lt $grid[$y][$left]) {$lowerThan++}} catch {$lowerThan++}
    try {if ($current -lt $grid[$y][$right]) {$lowerThan++}} catch {$lowerThan++}

    if ($lowerThan -eq 4) {return $current -as [int32]}
    return
}

#Instanciate Array X,Y
#To fit account for the array -1 on the string length
$grid = [int32[][]]::new($($data.count),$($data[0].Length))


#Fill grid
for ($i=0;$i -lt $data.count;$i++) {

    $x = 0
    #$data[$i].tochararray() | % {
        $data[$i] -split '' | ? {$false -eq [string]::IsNullOrWhiteSpace($_)}  | % {

        $grid[$i][$x]= $_
        $x++
    }
}


$lowpoints = for ($y = 0; $y -lt $grid.Count; $y++) {
    
    for ($x = 0; $x -lt $grid[$y].Count; $x++) {
    
        
        check-adjecentLava -y $y -x $x -current $grid[$y][$x]

    }

}

[PSCustomObject]@{
    part1 = $lowpoints.count + $($lowpoints | Measure-Object -sum | % sum)
}

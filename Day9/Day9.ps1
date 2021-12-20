$data = get-content .\Day9\Input9.txt
#$data = Get-Content .\Day9\Test9.txt

#$data

#9 highest
#0 lowest


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

function get-basinCount ($y,$x,$memo=@{}) {

    if ($memo["$y,$x"]) {return}
    
    write-verbose "$y,$x"
    if ($x -lt 0 -or $x -ge $grid[0].count) {return}
    if ($y -lt 0 -or $y -ge $grid.count) {return}
    #if ($x -ge $grid[0].count) {return}

    if ($grid[$y][$x] -eq 9) {return}

    #check up, down, left, rigth
    if ($grid[$y][$x] -lt 9) {
        $memo["$y,$x"] = 1
    }

    get-basinCount ($y+1) $x $memo
    get-basinCount ($y-1) $x $memo
    get-basinCount $y ($x+1) $memo
    get-basinCount $y ($x-1) $memo

    return 1

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


$mappingResult = for ($y = 0; $y -lt $grid.Count; $y++) {
    
    for ($x = 0; $x -lt $grid[$y].Count; $x++) {
    
        
        $lowpoints = check-adjecentLava -y $y -x $x -current $grid[$y][$x]

        if ($lowpoints -ge 0) {
         [PSCustomObject]@{
             lowpoint = $lowpoints
             pos = "$y,$x"
             basin = get-basinCount $y $x | Measure-Object -sum | % sum
         }
        }
        # $lowpoints = $null
    }

}
$part2 = 1
$mappingResult | sort basin -Descending | select -first 3 -ExpandProperty basin | % {
$part2 = $part2*$_
}

[PSCustomObject]@{
    part1 = $mappingresult.count + $($mappingResult.lowpoint | Measure-Object -sum | % sum)
    part2 = $part2
}

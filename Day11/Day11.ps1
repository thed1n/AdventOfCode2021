$data = get-content .\Day11\Input11.txt

#$data = get-content .\Day11\test11.txt

<#
function new-octoblink ([int32]$y,[int32]$x,$direction) {
    #Full line not just neighbour
    write-verbose "$y,$x"
    if ($x -lt 0 -or $x -ge $grid[0].count) {return}
    if ($y -lt 0 -or $y -ge $grid.count) {return}
    #if ($x -ge $grid[0].count) {return}

    #check up, down, left, rigth
    
    if ($grid[$y][$x] -lt 9) {
        $script:grid[$y][$x]++

        if ($script:grid[$y][$x] -gt 9) {
            new-octoblink $y $x
        }
    }
    

    switch ($direction) {
        'down' {new-octoblink ($y+1) $x 'down';break}
        'downleft' {new-octoblink ($y+1) ($x-1) 'downleft';break}
        'downright' {new-octoblink ($y+1) ($x+1) 'downright';break}
        'up'    {new-octoblink ($y-1) $x 'up';break}
        'upleft' {new-octoblink ($y-1) ($x-1) 'upleft';break}
        'upright' {new-octoblink ($y-1) ($x+1) 'upright';break}
        'right' {new-octoblink $y ($x+1) 'right';break}
        'left' {new-octoblink $y ($x-1) 'left';break}
        default {
            #Starts first fanout
            new-octoblink ($y+1) $x 'down'
            new-octoblink ($y+1) ($x-1) 'downleft'
            new-octoblink ($y+1) ($x+1) 'downright'
            new-octoblink ($y-1) $x 'up'
            new-octoblink ($y-1) ($x-1) 'upleft'
            new-octoblink ($y-1) ($x+1) 'upright'
            new-octoblink $y ($x+1) 'right'
            new-octoblink $y ($x-1) 'left'
    }
    }



}
#>
function new-octoblink ([int32]$y,[int32]$x,$direction) {
    
    write-verbose "$y,$x"
    if ($x -lt 0 -or $x -ge $grid[0].count) {return}
    if ($y -lt 0 -or $y -ge $grid.count) {return}
    #if ($x -ge $grid[0].count) {return}

    #check up, down, left, rigth
    
    if ($grid[$y][$x] -le 9) {
        $script:grid[$y][$x]++

        if ($script:grid[$y][$x] -gt 9) {
            new-octoblink $y $x
        }
    }
    

    switch ($direction) {
        'down' {break}
        'downleft' {break}
        'downright' {break}
        'up'    {break}
        'upleft' {break}
        'upright' {break}
        'right' {break}
        'left' {break}
        default {
            #Starts first fanout
            new-octoblink ($y+1) $x 'down'
            new-octoblink ($y+1) ($x-1) 'downleft'
            new-octoblink ($y+1) ($x+1) 'downright'
            new-octoblink ($y-1) $x 'up'
            new-octoblink ($y-1) ($x-1) 'upleft'
            new-octoblink ($y-1) ($x+1) 'upright'
            new-octoblink $y ($x+1) 'right'
            new-octoblink $y ($x-1) 'left'
    }
    }



}
function draw-octo () {
    clear-host
    foreach ($g in $grid) {

        foreach ($c in $g) {
        
        if ($c -ge 9) {
        write-host "$c" -NoNewline -ForegroundColor Yellow
        }
        elseif ($c -eq 0) {
            write-host "$c" -NoNewline -ForegroundColor red
        }
        else {
        write-host "$c" -NoNewline
            #write-host "$($g -join '')"  
        }
        }
        Write-Host ''
    }
    }

function increase-energy () {

    for ($y = 0; $y -lt $script:grid.Count; $y++) {

        for ($x = 0; $x -lt $script:grid[$y].Count; $x++) {
            #if (!($script:grid[$y][$x] -eq 9)) {
            $script:grid[$y][$x]++
            #}
        }
        
    }
}

function reset-energy () {

    $numFlash = 0
    for ($y = 0; $y -lt $script:grid.Count; $y++) {

        for ($x = 0; $x -lt $script:grid[$y].Count; $x++) {
            
            if ($script:grid[$y][$x] -gt 9) {
                $script:grid[$y][$x] = 0
                $script:flashes++
                $numFlash++
            }
        }
        
    }
        return $numFlash
}

function get-blinkers () {
    $blinkers = for ($y = 0; $y -lt $script:grid.Count; $y++) {

        for ($x = 0; $x -lt $script:grid[$y].Count; $x++) {
            
            if ($script:grid[$y][$x] -gt 9) {
                [PSCustomObject]@{
                    y = $y
                    x = $x
                    blink = $true
                }
                
            }
        }
        
    }
    return ,$blinkers
}

$grid = [int32[][]]::new($($data.count),$($data[0].Length))


for ($i=0;$i -lt $data.count;$i++) {

    $x = 0
        $data[$i] -split '' | ? {$false -eq [string]::IsNullOrWhiteSpace($_)}  | % {

        $grid[$i][$x]= $_
        $x++
    }
}

$flashes = 0

#draw-octo
for ($i=0;$i -lt 100000;$i++) {
#draw-octo

increase-energy
$blinkers = get-blinkers 
$blinkers | % {
    new-octoblink ($_.y) ($_.x)
}
$result = reset-energy
#draw-octo

if ($result -eq 100) {
    break
}
if ($i -eq 99) {
    $part1 = $flashes
}
}

[PSCustomObject]@{
    part1 = $part1
    part2 = $i+1
}

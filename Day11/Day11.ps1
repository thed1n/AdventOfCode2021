$data = get-content .\Day11\Input11.txt

$data = get-content .\Day11\test11.txt

function new-octoblink ([int32]$y,[int32]$x,$direction) {
    
    write-verbose "$y,$x"
    if ($x -lt 0 -or $x -ge $grid[0].count) {return}
    if ($y -lt 0 -or $y -ge $grid.count) {return}
    #if ($x -ge $grid[0].count) {return}

    #check up, down, left, rigth
    
    if ($grid[$y][$x] -lt 9) {
        $script:grid[$y][$x]++

        if ($script:grid[$y][$x] -eq 9) {
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

function new-octoblink ([int32]$y,[int32]$x,$direction) {
    
    write-verbose "$y,$x"
    if ($x -lt 0 -or $x -ge $grid[0].count) {return}
    if ($y -lt 0 -or $y -ge $grid.count) {return}
    #if ($x -ge $grid[0].count) {return}

    #check up, down, left, rigth
    
    if ($grid[$y][$x] -lt 9) {
        $script:grid[$y][$x]++

        if ($script:grid[$y][$x] -ge 9) {
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
    foreach ($g in $grid) {

        foreach ($c in $g) {
        
        if ($c -eq 9) {
        write-host "$c" -NoNewline -ForegroundColor Yellow
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
    for ($y = 0; $y -lt $script:grid.Count; $y++) {

        for ($x = 0; $x -lt $script:grid[$y].Count; $x++) {
            
            if ($script:grid[$y][$x] -ge 9) {
                $script:grid[$y][$x] = 0
                $script:flashes++
            }
        }
        
    }
}

function get-blinkers () {
    $blinkers = for ($y = 0; $y -lt $script:grid.Count; $y++) {

        for ($x = 0; $x -lt $script:grid[$y].Count; $x++) {
            
            if ($script:grid[$y][$x] -ge 9) {
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
    #$data[$i].tochararray() | % {
        $data[$i] -split '' | ? {$false -eq [string]::IsNullOrWhiteSpace($_)}  | % {

        $grid[$i][$x]= $_
        $x++
    }
}

$flashes = 0


for ($i=0;$i -lt 10;$i++) {
draw-octo

increase-energy
$blinkers = get-blinkers 
$blinkers | % {
    new-octoblink ($_.y) ($_.x)
}
#draw-octo
reset-energy
}

[PSCustomObject]@{
    part1 = $flashes
}
<#
First, the energy level of each octopus increases by 1.

Then, any octopus with an energy level greater than 9 flashes.
This increases the energy level of all adjacent octopuses by 1, 
including octopuses that are diagonally adjacent. 
If this causes an octopus to have an energy level greater than 9, it also flashes. 
This process continues as long as new octopuses keep having their energy level increased beyond 9. 
(An octopus can only flash at most once per step.)

Finally, any octopus that flashed during this step has its energy level set to 0, as it used all of its energy to flash.
#>
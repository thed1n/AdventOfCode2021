$data = get-content .\Day13\Input13.txt
$data = get-content .\Day13\Test13.txt

[System.Collections.ArrayList]$foldvectors = @()
$initialdots = $data | ForEach-Object {
    if ($_ -match '\d,\d') {
    [int32]$x,[int32]$y = $_ -split ','
    [PSCustomObject]@{
        x = $x
        y = $y
    }
    }
    elseif ($_ -like 'fold along*') {
        $blank,$fold, $vector = $_.trim() -split 'fold along ' -split '='
        
        $folding = [PSCustomObject]@{
            fold = $fold
            pos = $vector
        }
        [void]$foldvectors.add($folding)
    }
}

function init-grid () {
    $script:grid = [string[][]]::new(($initialdots.y | sort | select -last 1)+1,($initialdots.x | sort | select -last 1)+1 )
    for ([int32]$y = 0;$y -lt $script:grid.count; $y++) {

        for ([int32]$x = 0; $x -lt $script:grid[0].count; $x++) {
            $script:grid[$y][$x] = '.'
        } 
    }
}


function fill-grid ($p) {
    $y = $p.y
    $x = $p.x
    write-host "[$y] [$x]"
    $script:grid[$y][$x] = '#'
}

function draw-grid () {
    for ($i = 0; $i -lt $grid.Count; $i++) {
        write-host "$($grid[$i] -join '')"
    }
}

function fold-grid ($f) {
    $dir = ''
    switch ($f.fold) {
        'y' {$dir = 'left'}
        'x' {$dir = 'up'}
    }
    
    s


}
$initialdots | % {
    fill-grid $_
}

draw-grid

$foldvectors | % {
    fold-grid $_
}
[string[]]$data = get-content .\Day2\Input2.txt

[int32]$depth = 0
[int32]$horizontal = 0
[int32]$aim = 0
[int32]$depth2 = 0

$data| %{ 
    
    [string]$movement,[int32]$steps = $_ -split ' '

    switch ($movement) {
        'forward' {
            $horizontal += $steps;
             $depth2 += ($aim*$steps);
             break
            }
        'up' {
            $depth -= $steps;
            $aim-= $steps;
              break}
        'down' {
            $depth += $steps;
            $aim+=$steps; 
            break
        }
    }
    if ($aim -lt 0) {$aim = 0}
}





[pscustomobject]@{
    result1 = $depth * $horizontal
    result2 = $depth2 * $horizontal
}
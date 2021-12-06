$data = get-content .\Day5\Input5.txt

#$data = get-content .\Day5\Test5.txt

$grid = @{}
$griddiag = @{}

$cords = $data | % {
    $x1, $y1, $x2, $y2 = $_ -split ' -> ' -split ','
    $angle = $(
        #Delta Y and X
        $tempy = $y2 - $y1
        $tempx = $x2 - $x1
        #M = Slope of the line
        if ($tempy -ne 0 -and $tempx -ne 0) {
        $m = $tempy/$tempx
        #gets raidiens instead of angle by multiplying with (180/pi) you get angle
        [math]::ATan($m) * (180/[math]::pi)
         }
         else {0} 
    ) 
    [PSCustomObject]@{
        x1       = [int32]$x1
        y1       = [int32]$y1
        x2       = [int32]$x2
        y2       = [int32]$y2
        matching = $(
            if ($x1 -eq $x2) { 'X' } 
            elseif ($y1 -eq $y2) { 'Y' } 
            else { 'D' } )
        angle = $angle
        }
}

function set-cordinates ($cordinate,[switch]$diag) {

    if ($diag) {
    switch ($cordinate.matching) {
        'X' { 
            $($cordinate.y1)..$($cordinate.y2) | % {
                $script:griddiag["$($cordinate.x1),$_"]++
            }
            break
        }
        'Y' {
            $($cordinate.x1)..$($cordinate.x2) | % {
                $script:griddiag["$_,$($cordinate.y1)"]++
            }
            break
        }
        'D' {
            #I needed to facepalm the solution on the whileloop since it missed the last iteration.
            switch ($cordinate) {
                {$cordinate.x1 -gt $cordinate.x2 -and $cordinate.y1 -gt $cordinate.y2} {
                    #going up right
                    write-verbose "going up right"
                    [int32]$x1 = $cordinate.x1
                    [int32]$y1 = $cordinate.y1
                    [int32]$x2 = $cordinate.x2
                    write-verbose "Start point [$x1,$y1]"
                        while ($true) {
                            
                            $script:griddiag["$x1,$y1"]++
                            $x1--
                            $y1--

                            if ($x1 -eq $x2) {
                                $script:griddiag["$x1,$y1"]++
                                write-verbose "last set point [$x1,$y1]"
                                break}
                        }
                        
                        write-verbose "End point [$($cordinate.x2),$($cordinate.y2)]"
                        break
                 }
                {$cordinate.x1 -gt $cordinate.x2 -and $cordinate.y1 -lt $cordinate.y2} {
                    #going down right
                    write-verbose "going down right"
                    [int32]$x1 = $cordinate.x1
                    [int32]$y1 = $cordinate.y1
                    [int32]$x2 = $cordinate.x2
                    write-verbose "Start point [$x1,$y1]"
                            while ($true) {
                            #write-verbose "set point [$x1,$y1]"
                            $script:griddiag["$x1,$y1"]++
                            $x1--
                            $y1++

                            if ($x1 -eq $x2) {
                                $script:griddiag["$x1,$y1"]++
                                write-verbose "last set point [$x1,$y1]"
                                break}

                        }
                        #write-verbose "last set point [$x1,$y1]"
                        write-verbose "End point [$($cordinate.x2),$($cordinate.y2)]"
                        break
                }
                {$cordinate.x1 -lt $cordinate.x2 -and $cordinate.y1 -gt $cordinate.y2} {
                     #going up left
                     write-verbose "going up left"
                     [int32]$x1 = $cordinate.x1
                     [int32]$y1 = $cordinate.y1
                     [int32]$x2 = $cordinate.x2
                     write-verbose "Start point [$x1,$y1]"
                        while ($true) {
                            #write-verbose "set point [$x1,$y1]"
                             $script:griddiag["$x1,$y1"]++
                             $x1++
                             $y1--
                             if ($x1 -eq $x2) {
                                $script:griddiag["$x1,$y1"]++
                                write-verbose "last set point [$x1,$y1]"
                                break}
                         }
                         #write-verbose "last set point [$x1,$y1]"
                         write-verbose "End point [$($cordinate.x2),$($cordinate.y2)]"
                         break
                }
                {$cordinate.x1 -lt $cordinate.x2 -and $cordinate.y1 -lt $cordinate.y2} {
                    #going down left
                    write-verbose "going down left"
                    [int32]$x1 = $cordinate.x1
                    [int32]$y1 = $cordinate.y1
                    [int32]$x2 = $cordinate.x2
                    #write-verbose "Start point [$x1,$y1]"
                            while ($true) {
                            #write-verbose "set point [$x1,$y1]"
                            $script:griddiag["$x1,$y1"]++
                            $x1++
                            $y1++
                            if ($x1 -eq $x2) {
                                $script:griddiag["$x1,$y1"]++
                                write-verbose "last set point [$x1,$y1]"
                                break}
                        }
                        #write-verbose "last set point [$x1,$y1]"
                        write-verbose "End point [$($cordinate.x2),$($cordinate.y2)]"
                        break
                }
                Default {}
        }

    }
    #>
    default {break}
}
    }

    else {
        switch ($cordinate.matching) {
            'X' { 
                $($cordinate.y1)..$($cordinate.y2) | % {
                    $script:grid["$($cordinate.x1),$_"]++
                }
                break
            }
            'Y' {
                $($cordinate.x1)..$($cordinate.x2) | % {
                    $script:grid["$_,$($cordinate.y1)"]++
                }
                break
            }
            Default {break}
    }


}
}


$cords | % {
    set-cordinates $_
}
$cords | % {
    set-cordinates $_ -diag
}

[PSCustomObject]@{
    part1 = ($grid.values | ? {$_ -gt 1}).count
    part2 = ($griddiag.values | ? {$_ -gt 1}).count
}


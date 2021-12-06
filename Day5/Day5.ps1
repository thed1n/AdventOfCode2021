#$data = get-content .\Day5\Input5.txt

$data = get-content .\Day5\Test5.txt

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
        x1       = $x1
        y1       = $y1
        x2       = $x2
        y2       = $y2
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
            
            switch ($cordinate) {
                {$cordinate.x1 -gt $cordinate.x2 -and $cordinate.y1 -gt $cordinate.y2} {
                    #going north east
                    write-verbose "going north east"
                    [int32]$x1 = $cordinate.x1
                    [int32]$y1 = $cordinate.y1
                    write-verbose "Start point [$x1,$y1]"
                        while ($x1 -ne $cordinate.x2) { #-or $y1 -ge $cordinate.y2) {
                            write-verbose "set point [$x1,$y1]"
                            $script:griddiag["$x1,$y1"]++
                            $x1--
                            $y1--
                        }
                        break
                 }
                {$cordinate.x1 -gt $cordinate.x2 -and $cordinate.y1 -lt $cordinate.y2} {
                    #going south east
                    write-verbose "going south east"
                    [int32]$x1 = $cordinate.x1
                    [int32]$y1 = $cordinate.y1
                    write-verbose "Start point [$x1,$y1]"
                        while ($x1 -ge $cordinate.x2 -or $y1 -le $cordinate.y2) {
                            write-verbose "set point [$x1,$y1]"
                            $script:griddiag["$x1,$y1"]++
                            $x1--
                            $y1++
                        }
                        break
                }
                {$cordinate.x1 -lt $cordinate.x2 -and $cordinate.y1 -gt $cordinate.y2} {
                     #going north west
                     write-verbose "going north west"
                     [int32]$x1 = $cordinate.x1
                     [int32]$y1 = $cordinate.y1
                     write-verbose "Start point [$x1,$y1]"
                         while ($x1 -le $cordinate.x2 -or $y1 -ge $cordinate.y2) {
                            write-verbose "set point [$x1,$y1]"
                             $script:griddiag["$x1,$y1"]++
                             $x1++
                             $y1--
                         }
                         break
                }
                {$cordinate.x1 -lt $cordinate.x2 -and $cordinate.y1 -lt $cordinate.y2} {
                    #going south west
                    write-verbose "going south west"
                    [int32]$x1 = $cordinate.x1
                    [int32]$y1 = $cordinate.y1
                    write-verbose "Start point [$x1,$y1]"
                        while ($x1 -le $cordinate.x2 -or $y1 -le $cordinate.y2) {
                            write-verbose "set point [$x1,$y1]"
                            $script:griddiag["$x1,$y1"]++
                            $x1++
                            $y1++
                        }
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

function find-intersectpoint ($co1, $co2) {
    <#
Let the given lines be :

a1x + b1y = c1
a2x + b2y = c2
We have to now solve these 2 equations to find the point of intersection. To solve, we multiply 1. by b2 and 2 by b1
This gives us,
a1b2x + b1b2y = c1b2
a2b1x + b2b1y = c2b1

Subtracting these we get,
(a1b2 – a2b1) x = c1b2 – c2b1

This gives us the value of x. Similarly, we can find the value of y. (x, y) gives us the point of intersection.
#>

#Line1
[double]$a1 = $co1.y2 - $co1.y1
[double]$b1 = $co1.x1 -$co1.x2
[double]$c1 = $a1 * $co1.x1 + $b1 * $co1.y1

#Line2
[double]$a2 = $co2.y2 - $co2.y1
[double]$b2 = $co2.x1 -$co2.x2
[double]$c2 = $a2 * $co2.x1 + $b2 * $co2.y1

[double]$determinant = $a1 *$b2 - $a2 *$b1

if ($determinant -eq 0) {return $null}

[double]$x = ($b2 * $c1 - $b1 * $c2)/$determinant
[double]$y = ($a1 * $c2 - $a2 * $c1)/$determinant


#So the value is within diagonal range
if ($co1.x1 -le $co1.x2) {
    $xmax = $co1.x2
    $xmin = $co1.x1
} 
else {
    $xmax = $co1.x1
    $xmin = $co1.x2
}
if ($co1.y1 -le $co1.y2) {
    $ymax = $co1.y2
    $ymin = $co1.y1
} 
else {
    $ymax = $co1.y1
    $ymin = $co1.y2
}

if ($co2.x1 -le $co2.x2) {
    $x2max = $co2.x2
    $x2min = $co2.x1
} 
else {
    $x2max = $co2.x1
    $x2min = $co2.x2
}
if ($co2.y1 -le $co2.y2) {
    $y2max = $co2.y2
    $y2min = $co2.y1
} 
else {
    $y2max = $co2.y1
    $y2min = $co2.y2
}


if ((($x -ge $xmin -and $x -le $xmax) -and ($y -ge $ymin -and $y -le $ymax)) -and (($x -ge $x2min -and $x -le $x2max) -and ($y -ge $y2min -and $y -le $y2max))) {
return "$x,$y"
}
return $null

}


$cords | % {
    set-cordinates $_
}
$cords | % {
    set-cordinates $_ -diag
}

<#
$diagcords = $cords | ? {$_.matching -eq 'D'}


for ($x = 0; $x -lt $cords.Count; $x++) {
    if ($cords[$x].matching -eq 'D') {
        write-verbose "x is [$x]"
    for ($i = 0; $i -lt $cords.Count; $i++) {
        if ($i -eq $x) {write-host "skipping $i"; continue}
            $tempcord = find-intersectpoint -co1 $cords[$x] -co2 $cords[$i]
            if (-not [string]::IsNullOrWhiteSpace($tempcord) ) {
            #$griddiag["$(find-intersectpoint -co1 $cords[$x] -co2 $cords[$i])"]++
            write-verbose "instersect [$tempcord] $i"
            $griddiag[$tempcord]++
            }
        }
        }
    }
#>
 
[PSCustomObject]@{
    part1 = ($grid.values | ? {$_ -gt 1}).count
    part2 = ($griddiag.values | ? {$_ -gt 1}).count
}


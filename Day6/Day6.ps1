$data = (get-content .\Day6\Input6.txt) -split ','

#$data = "3,4,3,1,2" -split ','

#part1 recursion that didnt make the cut for  part2
$part1 = $data | foreach-object -Parallel {
function calc-laternfish ([int32]$fish,[int32]$rounds,[int32]$totalrounds) {
        write-verbose "round [$rounds]"
        write-verbose "fish [$fish]"
        if ($rounds -ge $totalrounds) {
            return 1
        }
    
        while ($true) {
            
    
            if ($rounds -eq $totalrounds) {
                return 1
            }
    
            if ($fish -eq 0) {
                $rounds++
                write-verbose "Spawning two new fishes on round [$rounds] fish [$fish]"
                calc-laternfish 8 $rounds $totalrounds
                calc-laternfish 6 $rounds $totalrounds
                return
            }
            $rounds++
            $fish--
    
        }
    
    }    
    
    calc-laternfish $_ 0 80
} | Measure-Object -Sum



#Works superfast for part1 & part2 (34msecs for part2)
$fish = [double[]]::new(9)

(get-content .\Day6\Input6.txt) -split ',' | Group-Object | % {
    $fish[$($_.name)] = $_.count
}

function get-fishyfishy {
    param(
        [double[]]$private:fishes,
        [int32]$days
    )
    [int32]$x = 0
    [double]$newborn7,[double]$newborn8 = 0

    while ($true) {
        Write-Verbose "Before: $($fishes[0]) $($fishes[1]) $($fishes[2]) $($fishes[3]) $($fishes[4]) $($fishes[5]) $($fishes[6]) $($fishes[7]) $($fishes[8])"
        [double]$temp = $fishes[0]
        #Rotate array
        for ($i = 0; $i -lt 6; $i++) {
            $fishes[$i] = $fishes[$i+1]
            #set amount
            if ($i -eq 5) {
                $fishes[6] = $temp+$fishes[7] #newborn into que
                $fishes[7] = $fishes[8]
                $fishes[8] = $temp
            }
        }
        Write-Verbose "After: $($fishes[0]) $($fishes[1]) $($fishes[2]) $($fishes[3]) $($fishes[4]) $($fishes[5]) $($fishes[6]) $($fishes[7]) $($fishes[8])"
        $x++
        if ($x -eq $days) {
            return $fishes[0]+$fishes[1]+$fishes[2]+$fishes[3]+$fishes[4]+$fishes[5]+$fishes[6]+$fishes[7]+$fishes[8]
        }
    }
}


[PSCustomObject]@{
    part1 = get-fishyfishy $fish.clone() -days 80
    part2 = get-fishyfishy $fish.clone() -days 256
}
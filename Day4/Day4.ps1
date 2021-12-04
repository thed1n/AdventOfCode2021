$data = get-content .\Day4\Input4.txt
function check-winner ($playfield, $field) {
    #Horizontal
    for ($i = 0; $i -lt 25; $i += 5) {
        if ($playfield.Item($i) -eq 'x' -and $playfield.Item($i + 1) -eq 'x' -and $playfield.Item($i + 2) -eq 'x' -and $playfield.Item($i + 3) -eq 'x' -and $playfield.Item($i + 4) -eq 'x') {
            return $field
        }
    }
    #Vertical
    for ($i = 0; $i -lt 5; $i++) {
        if ($playfield.Item($i) -eq 'x' -and $playfield.Item($i + 5) -eq 'x' -and $playfield.Item($i + 10) -eq 'x' -and $playfield.Item($i + 15) -eq 'x' -and $playfield.Item($i + 20) -eq 'x') {
            return $field
        }
    }
    return
}

function calculate-points ($playfield, $lastnumber) {
    $sum = ($playfield.GetEnumerator() | ? value -eq 'o' | select -ExpandProperty name) | Measure-Object -sum | % Sum
    return $sum * $lastnumber
}

function check-field ($playfields, $lottodraw, $field) {

        for ($i = 0; $i -lt $lottodraw.count; $i++) {
            if ($playfields.Contains($lottodraw[$i])) {
                $playfields[$lottodraw[$i]] = 'x'
            }
            if ($i -gt 4) {
                $winningfield = check-winner $playfields $field
                if ($winningfield -or $winningfield -eq 0) {
                    $lastnumber = $lottodraw[$i]
                    break
                }
            }
        }

    $info = [PSCustomObject]@{
        field      = $field
        lastnumber = $lastnumber
        index = $i
        points     = calculate-points $playfields $lastnumber
    }

    return $info
}

$lottodraw = $data[0] -split ','

[System.Collections.ArrayList]$playfields = @()
for ($i = 2; $i -lt $data.Count; $i = $i + 6) {
    [System.Collections.Specialized.OrderedDictionary]$tempfield = @{}
    $field = $data[$i..($i + 4)]
    $field.replace('  ', ' ').split(' ') | % {
        if (-not [string]::IsNullOrWhiteSpace($_)) {
            $tempfield.add($_, 'o')
        }
    }
    [void]$playfields.add($tempfield)
}

$allfields = for ($i = 0; $i -lt $playfields.Count; $i++) {
    check-field -playfield $playfields[$i] -lottodraw $lottodraw -field $i
}

$allfields = $allfields | sort index | select -First 1 -last 1

[PSCustomObject]@{
    part1 = $allfields[0].points
    part2 = $allfields[1].points
}

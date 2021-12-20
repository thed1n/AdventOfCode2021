$data = get-content .\Day8\Input8.txt
#$data = get-content .\Day8\test8.txt
#$data = 'acedgfb cdfbe gcdfa fbcad dab cefabd cdfgeb eafb cagedb ab | cdfeb fcadb cdfeb cdbaf'
$data = $data.trim()

<#
 0:      1:      2:      3:      4:
 aaaa    ....    aaaa    aaaa    ....
b    c  .    c  .    c  .    c  b    c
b    c  .    c  .    c  .    c  b    c
 ....    ....    dddd    dddd    dddd
e    f  .    f  e    .  .    f  .    f
e    f  .    f  e    .  .    f  .    f
 gggg    ....    gggg    gggg    ....

  5:      6:      7:      8:      9:
 aaaa    aaaa    aaaa    aaaa    aaaa
b    .  b    .  .    c  b    c  b    c
b    .  b    .  .    c  b    c  b    c
 dddd    dddd    ....    dddd    dddd
.    f  e    f  .    f  e    f  .    f
.    f  e    f  .    f  e    f  .    f
 gggg    gggg    ....    gggg    gggg
 #>
 function get-decodednumber ($one, $four, $word) {
    #foreach group
    $getLength = $word.length

    if ($getLength -ne 6) {
        #If length not eq 6 add 1 to $i to be able to retract anwser data
        $i = 1
    }

    [System.Collections.ArrayList]$wordhash = @()
    #$sixLetter.Group[0].ToCharArray() | % {
    Write-Verbose "Word [$word] length = [$getLength]"
    $word.ToCharArray() | % {

        [void]$wordhash.add($_)
    }

    [void]$wordhash.Remove($one[0])
    [void]$wordhash.Remove($one[1])

    write-verbose "$($wordhash -join '')"
    write-verbose "$($wordhash.count)"
    if ($i -eq 1) {
        if ($wordhash.count -eq 3) {
            return 3
        }
    }
    write-verbose "pre if"
    if ($wordhash.count -eq 5) {
        return 6
    }
    write-verbose "post if"
    [void]$wordhash.Remove($four[0])
    [void]$wordhash.Remove($four[1])
    [void]$wordhash.Remove($four[2])
    [void]$wordhash.Remove($four[3])

    if ($i -eq 1) {
        if ($wordhash.count -eq 3) {
            return 2
        }
        return 5
    }
    if ($wordhash.count -eq 3) {
        return 0
    }
    return 9

}

<#
 Try with enums
#  $segements = @{
#      0 = 6
#      1 = 2 #unik
#      2 = 5
#      3 = 5
#      4 = 4 #unik
#      5 = 5
#      6 = 6
#      7 = 3 #unik
#      8 = 7 #unik
#      9 = 6 
#  }

#  [Flags()] enum SegmentMap {
#     a = 1
#     b = 2
#     c = 4
#     d = 8
#     e = 16
#     f = 32
#     g = 64
# }

# function get-segment ($val) {
#     switch ($val) {
#         95 { return 0}
#         3 { return 1 }
#         109 { return 2}
#         47 { return 3}
#         51 { return 4}
#         62 { return 5}
#         126 { return 6}
#         11 { return 7}
#         127 { return 8}
#         63 { return 9}
#         Default {}
#     }
# }
#>
[int32]$count = 0


$data | % {
    $idata, $resultdata = $_.split('|')
    
    $idata = $idata.trim() -split ' ' | % { ($_.tochararray() | sort) -join '' }
    $resultdata = $resultdata.trim() -split ' ' | % { ($_.tochararray() | sort) -join '' }
    
    $idata | % {
        $size = $_.length
        $value = ($_.tochararray() | sort) -join ''
        if ($size -eq 2 -or $size -eq 3 -or $size -eq 4 -or $size -eq 7) {
            $resultdata | % {
                $rval = ($_.tochararray() | sort) -join ''
                if ($rval -eq $value) { $count++ }
            }
        }
    }


}
$count




<#
Try with enum.

$data[0] | % {
    $idata,$resultdata = $_.split('|')
    $idata = $idata.trim() -split ' ' | % {($_.tochararray()) -join ''}
    $resultdata = $resultdata.trim() -split ' ' | % {($_.tochararray()) -join ''}

    #Region Build dynamic Enum
 
        $enumarr = ($idata.Where({$_.length -eq 7}).tochararray())

        $segmentenum = @"
        [Flags()] enum SegmentMap {
            $($enumarr[0]) = 1
            $($enumarr[1]) = 2
            $($enumarr[2]) = 4
            $($enumarr[3]) = 8
            $($enumarr[4]) = 16
            $($enumarr[5]) = 32
            $($enumarr[6]) = 64
        }
"@
        Invoke-Expression $segmentenum
    #Endregion 

    #1 = 2 #unik
    #4 = 4 #unik
    #7 = 3 #unik
    #8 = 7 #unik

            $resultdata | % {
                [SegmentMap]$result = [SegmentMap]::new()
                $_.tochararray() | sort | % {
                    $result += "$_"
                }
                [pscustomobject]@{
                    string = $_
                    value = $result.value__
                    number = get-segment $($result.value__)
                }
             }
}
#>



<#Reference
$segmentenum = @"
[Flags()] enum SegmentMap {
    $($enumarr[0]) = 1
    $($enumarr[1]) = 2
    $($enumarr[2]) = 4
    $($enumarr[3]) = 8
    $($enumarr[4]) = 16
    $($enumarr[5]) = 32
    $($enumarr[6]) = 64
}
"@
Invoke-Expression $segmentenum
[segmentmap]::b.value__
[segments]$test = 'a'

[segments]$test += 'e'
$test.value__

[segments]
 -f $enumarr[0],$enumarr[1],$enumarr[2],$enumarr[3],$enumarr[4],$enumarr[5],$enumarr[6]

$CurrencyEnum = "[Flags()] enum Currency{$(foreach ($v in $enumarr){"`n$v`"})`n}"
Invoke-Expression $CurrencyEnum

[Flags()] enum Segments 
{ 
    "$($value[$i])" = 0
    "$($value[$i])" = 1
    "$($value[$i])" = 2
    "$($value[$i])" = 4
    "$($value[$i])" = 8
    "$($value[$i])" = 16
    "$($value[$i])" = 32 
}
    [segments].GetEnumNames()

    #>

$part2 = $data | % {
    #THE KEY IS Reduce with 1 then 4 to get the valid numbers and sort the characters
    #So two groups that needs to be sorted 6 lenght and 5 lenght.
    $idata, $resultdata = $_.split('|')
    $idata = $idata.trim() -split ' ' | % { ($_.tochararray() | sort) -join '' }
    $resultdata = $resultdata.trim() -split ' ' | % { ($_.tochararray() | sort) -join '' }
    $eight = $idata | ? { $_.length -eq 7 }
    $seven = $idata | ? { $_.length -eq 3 }
    $one = $idata | ? { $_.length -eq 2 } | % { $_.tochararray() }
    $four = $idata | ? { $_.length -eq 4 } | % { $_.tochararray() }

    $decodedWordList = @{
        $eight = 8
        $seven = 7
        $($one -join '') = 1
        $($four -join '') = 4
    }
        
    $fiveLetter = $idata | Group-Object -Property length | ? name -eq 5
    $sixLetter = $idata | Group-Object -Property length | ? name -eq 6

    $fiveLetter.Group | % {
        $word = $_
        $decodedwordlist[$word] = get-decodednumber $one $four $word
    }
    $sixLetter.Group | % {
        $word = $_
        $decodedwordlist[$word] = get-decodednumber $one $four $word
    }


    $decodedResult = $resultdata | % {
        $decodedWordList[$_]
    }

    $decodedResult -join ''
} | Measure-Object -sum | % sum

[PSCustomObject]@{
    part1 = $count
    part2 = $part2
}
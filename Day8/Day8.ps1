$data = get-content .\Day8\Input8.txt
$data = get-content .\Day8\test8.txt

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

 $segements = @{
     0 = 6
     1 = 2 #unik
     2 = 5
     3 = 5
     4 = 4 #unik
     5 = 5
     6 = 6
     7 = 3 #unik
     8 = 7 #unik
     9 = 6 
 }

 [int32]$count = 0

 $data[0] | % {
 $idata,$resultdata = $_.split('|')
 
 $idata = $idata.trim() -split ' ' | % {($_.tochararray() | sort) -join ''}
 $resultdata = $resultdata.trim() -split ' ' | % {($_.tochararray() | sort) -join ''}

 $idata | % {
    $size = $_.length
    $value = ($_.tochararray() | sort) -join ''
     if ($segements.ContainsValue($size)) {
        $resultdata | % {
            $rval = ($_.tochararray() | sort) -join ''
            if ($rval -eq $value) {$count++}
            
            #if ($_.length -eq $size) {$count++}
         }
     }
 }
 }

 $count
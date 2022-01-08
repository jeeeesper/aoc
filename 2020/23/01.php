<?php

$cups = fgets(STDIN);
$listLength = strlen($cups) - 1;

for ($i = 0; $i < 100; ++$i) {
    $current = $cups[0];
    $first = $cups[1];
    $second = $cups[2];
    $third = $cups[3];

    $dest = $current;
    while (in_array($dest, [$current, $first, $second, $third])) {
        --$dest;
        if ($dest < 1) $dest = $listLength;
    }

    $newCups = "";
    for ($j = 4; $j < $listLength; ++$j) {
        $newCups .= $cups[$j];
        if ($cups[$j] == $dest) {
            $newCups .= $first . $second . $third;
        }
    }
    $newCups .= $current;
    $cups = $newCups;
}

$start = strpos($cups, '1');
for ($i = 1; $i < $listLength; ++$i) {
    echo $cups[($i + $start) % $listLength];
}
echo "\n";

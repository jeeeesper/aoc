<?php

$n = 1000000;
$it = 10000000;

$cups = fgets(STDIN);
$cups = str_split($cups);
$listLength = count($cups) - 1;
unset($cups[$listLength]);

$succ = [];
$succ[$n] = intval($cups[0]);

for ($i = 1; $i < $listLength; ++$i) {
    $succ[intval($cups[$i-1])] = intval($cups[$i]);
}

$succ[$cups[$listLength - 1]] = $listLength + 1;

for (++$listLength; $listLength < $n; ++$listLength) {
    $succ[$listLength] = $listLength+1;
}

$current = $cups[0];

for ($i = 0; $i < $it; ++$i) {
    $first = $succ[$current];
    $second = $succ[$first];
    $third = $succ[$second];

    $dest = $current;
    while (in_array($dest, [$current, $first, $second, $third])) {
        --$dest;
        if ($dest < 1) $dest = $listLength;
    }

    $succThird = $succ[$third];
    $succDest = $succ[$dest];

    $succ[$current] = $succThird;
    $succ[$dest] = $first;
    $succ[$third] = $succDest;

    $current = $succ[$current];
}
echo ($succ[1] * $succ[$succ[1]]) . "\n";

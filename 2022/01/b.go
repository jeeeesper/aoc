package main

import (
	"bufio";
	"fmt";
	"os";
	"sort";
	"strconv";
)

func main() {
	scanner := bufio.NewScanner(os.Stdin)
	calories := []int{}
	acc := 0
	for scanner.Scan() {
		str := scanner.Text()
		if str == "" {
			calories = append(calories, acc)
			acc = 0
		} else {
			i, _ := strconv.Atoi(str)
			acc += i
		}
	}
	sort.Ints(calories)
	l := len(calories)
	fmt.Println(calories[l-1] + calories[l-2] + calories[l-3])
}
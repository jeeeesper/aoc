package main

import (
	"bufio";
	"fmt";
	"os";
	"strconv";
)

func main() {
	scanner := bufio.NewScanner(os.Stdin)
	acc := 0
	max := 0
	for scanner.Scan() {
		str := scanner.Text()
		if str == "" {
			if acc > max {
				max = acc
			}
			acc = 0
		} else {
			i, _ := strconv.Atoi(str)
			acc += i
		}
	}
	fmt.Println(max)
}

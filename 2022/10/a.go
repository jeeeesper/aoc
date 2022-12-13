package main

import (
	"bufio"
	"fmt"
	"os"
	"strconv"
	"strings"
)

func main() {
	scanner := bufio.NewScanner(os.Stdin)
	x := 1
	xs := []int{}
	for scanner.Scan() {
		line := strings.Split(scanner.Text(), " ")
		switch line[0] {
		case "noop":
			xs = append(xs, x)
		case "addx":
			xs = append(xs, x, x)
			dx, _ := strconv.Atoi(line[1])
			x += dx
		}
	}
	acc := 0
	for _, i := range []int{20, 60, 100, 140, 180, 220} {
		acc += i * xs[i-1]
	}
	fmt.Println(acc)
}

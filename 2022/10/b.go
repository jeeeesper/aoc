package main

import (
	"bufio"
	"fmt"
	"math"
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
	for i, n := range xs {
		var c rune
		if math.Abs(float64(n-(i%40))) <= 1 {
			c = '█'
		} else {
			c = '░'
		}
		fmt.Print(string(c))
		if (i+1)%40 == 0 {
			fmt.Println()
		}
	}
}

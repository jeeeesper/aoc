package main

import (
	"bufio"
	"fmt"
	"math"
	"os"
	"strconv"
	"strings"
)

type coordinate struct {
	x int
	y int
}

func (c *coordinate) move(d rune) {
	switch d {
	case 'R':
		c.x++
	case 'U':
		c.y--
	case 'L':
		c.x--
	case 'D':
		c.y++
	}
}

func sgn(a int) int {
	if a > 0 {
		return 1
	} else if a < 0 {
		return -1
	} else {
		return 0
	}
}

func main() {
	scanner := bufio.NewScanner(os.Stdin)
	moves := []rune{}
	for scanner.Scan() {
		ins := strings.Split(scanner.Text(), " ")
		n, _ := strconv.Atoi(ins[1])
		for i := 0; i < n; i++ {
			moves = append(moves, rune(ins[0][0]))
		}
	}
	visited := map[coordinate]bool{}
	head := coordinate{0, 0}
	tail := coordinate{0, 0}
	for _, ins := range moves {
		head.move(ins)
		if math.Abs(float64(head.x-tail.x)) > 1 || math.Abs(float64(head.y-tail.y)) > 1 {
			tail.x += sgn(head.x - tail.x)
			tail.y += sgn(head.y - tail.y)
		}
		visited[tail] = true
	}
	fmt.Println(len(visited))
}

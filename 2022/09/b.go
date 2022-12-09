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
	rope := make([]coordinate, 10)
	for _, ins := range moves {
		rope[0].move(ins)
		for i := 1; i < len(rope); i++ {
			if math.Abs(float64(rope[i-1].x-rope[i].x)) > 1 || math.Abs(float64(rope[i-1].y-rope[i].y)) > 1 {
				rope[i].x += sgn(rope[i-1].x - rope[i].x)
				rope[i].y += sgn(rope[i-1].y - rope[i].y)
			}
		}
		visited[rope[len(rope)-1]] = true
	}
	fmt.Println(len(visited))
}

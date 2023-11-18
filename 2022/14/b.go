package main

import (
	"bufio"
	"fmt"
	"os"
	"strconv"
	"strings"
)

type point struct{ x, y int }

type matter int

const (
	STONE matter = iota
	SAND
)

func main() {
	scanner := bufio.NewScanner(os.Stdin)
	cave := make(map[point]matter)
	var maxY int
	for scanner.Scan() {
		points := strings.Split(scanner.Text(), " -> ")
		for i := range points[:len(points)-1] {
			from := strings.Split(points[i], ",")
			fromX, _ := strconv.Atoi(from[0])
			fromY, _ := strconv.Atoi(from[1])
			to := strings.Split(points[i+1], ",")
			toX, _ := strconv.Atoi(to[0])
			toY, _ := strconv.Atoi(to[1])
			cave[point{fromX, fromY}] = STONE
			cave[point{toX, toY}] = STONE

			for fromX != toX || fromY != toY {
				if fromY > maxY {
					maxY = fromY
				}
				cave[point{fromX, fromY}] = STONE
				switch {
				case fromX < toX:
					fromX++
				case fromX > toX:
					fromX--
				case fromY < toY:
					fromY++
				case fromY > toY:
					fromY--
				}
				if fromY > maxY {
					maxY = fromY
				}
			}
			if toY > maxY {
				maxY = toY
			}
		}
	}

	void := false
	counter := 0
	for !void {
		fallingSand := point{500, 0}
		if _, ok := cave[fallingSand]; ok {
			break
		}
		for {
			if fallingSand.y == maxY+1 {
				cave[fallingSand] = SAND
				counter++
				break
			}
			if _, ok := cave[point{fallingSand.x, fallingSand.y + 1}]; !ok {
				fallingSand.y++
			} else if _, ok := cave[point{fallingSand.x - 1, fallingSand.y + 1}]; !ok {
				fallingSand.y++
				fallingSand.x--
			} else if _, ok := cave[point{fallingSand.x + 1, fallingSand.y + 1}]; !ok {
				fallingSand.y++
				fallingSand.x++
			} else {
				cave[fallingSand] = SAND
				counter++
				break
			}
		}
	}
	fmt.Println(counter)
}

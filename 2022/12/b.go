package main

import (
	"bufio"
	"fmt"
	"os"
)

type coords struct {
	x, y int
}

func main() {
	scanner := bufio.NewScanner(os.Stdin)
	dist := map[coords]int{}
	queue := []coords{}
	var t coords
	h := map[coords]rune{}
	for x := 0; scanner.Scan(); x++ {
		line := scanner.Text()
		for y, c := range line {
			p := coords{x, y}
			if c == 'a' {
				h[p] = 'a'
				dist[p] = 0
				queue = append(queue, p)
			} else if c == 'E' {
				h[p] = 'z'
				t = p
			} else {
				h[p] = c
			}
		}
	}

	for len(queue) > 0 {
		p := queue[0]
		queue = queue[1:]

		dp := dist[p]
		for _, d := range []coords{{0, 1}, {1, 0}, {0, -1}, {-1, 0}} {
			q := coords{p.x + d.x, p.y + d.y}
			dq, visited := dist[q]
			_, exists := h[q]

			if exists && (!visited || dq > dp+1) && h[p] >= h[q]-1 {
				dist[q] = dp + 1
				queue = append(queue, q)
			}
		}
	}

	fmt.Println(dist[t])
}
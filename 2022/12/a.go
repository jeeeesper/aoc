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
	var s, t coords
	h := map[coords]rune{}
	for x := 0; scanner.Scan(); x++ {
		line := scanner.Text()
		for y, c := range line {
			p := coords{x, y}
			h[p] = c
			if c == 'S' {
				s = p
			} else if c == 'E' {
				t = p
			}
		}
	}
	h[s], h[t] = 'a', 'z'

	dist := map[coords]int{s: 0}
	queue := []coords{s}

	for len(queue) > 0 {
		p := queue[0]
		queue = queue[1:]

		for _, d := range []coords{{0, 1}, {1, 0}, {0, -1}, {-1, 0}} {
			q := coords{p.x + d.x, p.y + d.y}
			_, visited := dist[q]
			_, exists := h[q]

			if exists && !visited && h[p] >= h[q]-1 {
				dist[q] = dist[p] + 1
				queue = append(queue, q)
			}
		}
	}

	fmt.Println(dist[t])
}
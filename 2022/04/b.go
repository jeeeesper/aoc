package main

import (
	"bufio"
	"fmt"
	"os"
	"strconv"
	"strings"
)

type interval struct {
	lb int
	ub int
}

type intersection struct {
	first  interval
	second interval
}

func main() {
	scanner := bufio.NewScanner(os.Stdin)
	intersections := []intersection{}
	for scanner.Scan() {
		elves := strings.Split(scanner.Text(), ",")
		first := strings.Split(elves[0], "-")
		firstlb, _ := strconv.Atoi(first[0])
		firstub, _ := strconv.Atoi(first[1])
		second := strings.Split(elves[1], "-")
		secondlb, _ := strconv.Atoi(second[0])
		secondub, _ := strconv.Atoi(second[1])
		intersections = append(intersections, intersection{
			interval{lb: firstlb, ub: firstub},
			interval{lb: secondlb, ub: secondub},
		})
	}
	acc := 0
	for _, i := range intersections {
		if i.first.lb <= i.second.ub && i.first.ub >= i.second.lb {
			acc += 1
		}
	}
	fmt.Println(acc)
}

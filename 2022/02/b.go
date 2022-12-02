package main

import (
	"bufio"
	"fmt"
	"os"
	"strings"
)

func win_score(t, o string) int {
	switch o {
	case "X":
		switch t {
		case "A":
			return 3
		case "B":
			return 1
		case "C":
			return 2
		}
	case "Y":
		switch t {
		case "A":
			return 1 + 3
		case "B":
			return 2 + 3
		case "C":
			return 3 + 3
		}
	case "Z":
		switch t {
		case "A":
			return 2 + 6
		case "B":
			return 3 + 6
		case "C":
			return 1 + 6
		}
	}
	return -1
}

func main() {
	scanner := bufio.NewScanner(os.Stdin)
	acc := 0
	for scanner.Scan() {
		strs := strings.Split(scanner.Text(), " ")
		theirmove := strs[0]
		outcome := strs[1]
		acc += win_score(theirmove, outcome)
	}
	fmt.Println(acc)
}

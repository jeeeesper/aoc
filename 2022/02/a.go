package main

import (
	"bufio"
	"fmt"
	"os"
	"strings"
)

func symbol_score(s string) int {
	switch s {
	case "X":
		return 1
	case "Y":
		return 2
	case "Z":
		return 3
	default:
		return -1
	}
}

func win_score(t, m string) int {
	switch m {
	case "X":
		switch t {
		case "A":
			return 3
		case "B":
			return 0
		case "C":
			return 6
		}
	case "Y":
		switch t {
		case "A":
			return 6
		case "B":
			return 3
		case "C":
			return 0
		}
	case "Z":
		switch t {
		case "A":
			return 0
		case "B":
			return 6
		case "C":
			return 3
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
		mymove := strs[1]
		acc += symbol_score(mymove) + win_score(theirmove, mymove)
	}
	fmt.Println(acc)
}

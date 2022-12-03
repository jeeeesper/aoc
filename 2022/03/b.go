package main

import (
	"bufio"
	"fmt"
	"os"
	"unicode"
)

func find_common_letter(a, b, c string) rune {
	// n^3 go brrr
	for _, ca := range a {
		for _, cb := range b {
			for _, cc := range c {
				if ca == cb && cb == cc {
					return ca
				}
			}
		}
	}
	return rune(0)
}

func get_letter_score(c rune) int {
	if unicode.IsUpper(c) {
		return int(c-'A') + 27
	} else {
		return int(c-'a') + 1
	}
}

func main() {
	scanner := bufio.NewScanner(os.Stdin)
	lines := []string{}
	for scanner.Scan() {
		lines = append(lines, scanner.Text())
	}
	acc := 0
	for i := 0; i < len(lines)/3; i++ {
		l1 := lines[3*i]
		l2 := lines[3*i+1]
		l3 := lines[3*i+2]
		letter := find_common_letter(l1, l2, l3)
		acc += get_letter_score(letter)
	}
	fmt.Println(acc)
}

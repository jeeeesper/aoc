package main

import (
	"bufio"
	"fmt"
	"os"
	"unicode"
)

func find_common_letter(a, b string) rune {
	for _, ca := range a {
		for _, cb := range b {
			if ca == cb {
				return ca
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
	acc := 0
	for scanner.Scan() {
		strs := scanner.Text()
		firstCompartment := strs[:len(strs)/2]
		secondCompartment := strs[len(strs)/2:]
		letter := find_common_letter(firstCompartment, secondCompartment)
		acc += get_letter_score(letter)
	}
	fmt.Println(acc)
}

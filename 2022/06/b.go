package main

import (
	"bufio"
	"fmt"
	"os"
)

func main() {
	scanner := bufio.NewScanner(os.Stdin)
	scanner.Scan()
	str := scanner.Text()
	for i := 14; i <= len(str); i++ {
		letters := map[rune]bool{}
		for _, letter := range str[i-14 : i] {
			letters[letter] = true
		}
		if len(letters) == 14 {
			fmt.Println(i)
			return
		}
	}
}

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
	for i := 4; i <= len(str); i++ {
		letters := map[rune]bool{}
		for _, letter := range str[i-4 : i] {
			letters[letter] = true
		}
		if len(letters) == 4 {
			fmt.Println(i)
			return
		}
	}
}

package main

import (
	"bufio"
	"encoding/json"
	"fmt"
	"os"
)

type pkgpair struct {
	left, right any
}

func (pair pkgpair) cmp() int {
	lefts, leftIsList := pair.left.([]any)
	rights, rightIsList := pair.right.([]any)

	if !leftIsList && !rightIsList {
		return int(pair.left.(float64) - pair.right.(float64))
	} else if !leftIsList {
		lefts = []any{pair.left}
		pair.left = lefts
	} else if !rightIsList {
		rights = []any{pair.right}
		pair.right = rights
	}

	for i := 0; i < len(lefts) && i < len(rights); i++ {
		c := pkgpair{lefts[i], rights[i]}.cmp()
		if c != 0 {
			return c
		}
	}

	return len(lefts) - len(rights)
}

func main() {
	scanner := bufio.NewScanner(os.Stdin)
	pair := pkgpair{}
	acc := 0
	for i := 0; scanner.Scan(); i++ {
		line := scanner.Text()
		switch i % 3 {
		case 0:
			json.Unmarshal([]byte(line), &pair.left)
		case 1:
			json.Unmarshal([]byte(line), &pair.right)
		case 2:
			c := pair.cmp()
			if c <= 0 {
				acc += (i / 3) + 1
			}
		}
	}

	fmt.Println(acc)
}

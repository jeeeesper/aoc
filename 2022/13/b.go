package main

import (
	"bufio"
	"encoding/json"
	"fmt"
	"os"
	"sort"
)

type pkg any
type pkglist []pkg

func (l pkglist) Len() int           { return len(l) }
func (l pkglist) Swap(i, j int)      { l[i], l[j] = l[j], l[i] }
func (l pkglist) Less(i, j int) bool { return cmp(l[i], l[j]) < 0 }

func cmp(left, right pkg) int {
	lefts, leftIsList := left.([]any)
	rights, rightIsList := right.([]any)

	if !leftIsList && !rightIsList {
		return int(left.(float64) - right.(float64))
	} else if !leftIsList {
		lefts = []any{left}
		left = lefts
	} else if !rightIsList {
		rights = []any{right}
		right = rights
	}

	for i := 0; i < len(lefts) && i < len(rights); i++ {
		c := cmp(lefts[i], rights[i])
		if c != 0 {
			return c
		}
	}

	return len(lefts) - len(rights)
}

func main() {
	scanner := bufio.NewScanner(os.Stdin)
	lines := []string{"[[2]]", "[[6]]"}
	for scanner.Scan() {
		line := scanner.Text()
		if line != "" {
			lines = append(lines, line)
		}
	}

	pkgs := pkglist{}
	for _, pkgstr := range lines {
		var tmp pkg
		json.Unmarshal([]byte(pkgstr), &tmp)
		pkgs = append(pkgs, tmp)
	}

	sort.Sort(pkgs)

	acc := 1
	for i, pkg := range pkgs {
		if fmt.Sprint(pkg) == "[[2]]" || fmt.Sprint(pkg) == "[[6]]" {
			acc *= i + 1
		}
	}
	fmt.Println(acc)
}

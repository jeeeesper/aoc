package main

import (
	"bufio"
	"fmt"
	"os"
	"strconv"
	"strings"
)

func main() {
	scanner := bufio.NewScanner(os.Stdin)
	lines := []string{}
	var nStacks int
	for scanner.Scan() {
		line := scanner.Text()
		if rune(line[0]) == ' ' && rune(line[1]) == '1' {
			nStacks = (len(line) + 1) / 4
			break
		}
		lines = append(lines, line)
	}
	stacks := make([][]rune, nStacks)
	for line := len(lines) - 1; line >= 0; line-- {
		for i := 0; i < nStacks; i++ {
			if len(lines[line]) > i*4+1 && lines[line][i*4+1] != ' ' {
				stacks[i] = append(stacks[i], rune(lines[line][i*4+1]))
			}
		}
	}
	scanner.Scan()
	for scanner.Scan() {
		ins := strings.Split(scanner.Text(), " ")
		n, _ := strconv.Atoi(ins[1])
		s, _ := strconv.Atoi(ins[3])
		s--
		t, _ := strconv.Atoi(ins[5])
		t--
		for i := 0; i < n; i++ {
			e := stacks[s][len(stacks[s])-1]
			stacks[s] = stacks[s][:len(stacks[s])-1]
			stacks[t] = append(stacks[t], e)
		}
	}
	for _, stack := range stacks {
		fmt.Print(string(stack[len(stack)-1]))
	}
	fmt.Println()
}

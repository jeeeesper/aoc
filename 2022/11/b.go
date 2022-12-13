package main

import (
	"fmt"
	"io/ioutil"
	"os"
	"sort"
	"strconv"
	"strings"
)

type monkey struct {
	items []int
	op    func(int) int
	div   int
	test  func(int) bool
	throw func(bool) int
}

func parseInput() []monkey {
	input, _ := ioutil.ReadAll(os.Stdin)
	defs := strings.Split(string(input), "\n\n")
	monkeys := []monkey{}
	for i, def := range defs {
		lines := strings.Split(def, "\n")
		monkeys = append(monkeys, monkey{
			make([]int, 0),
			nil,
			0,
			nil,
			nil,
		})

		// items
		items := strings.Split(strings.Split(lines[1], ": ")[1], ", ")
		for _, nstring := range items {
			n, _ := strconv.Atoi(nstring)
			monkeys[i].items = append(monkeys[i].items, n)
		}

		// operation
		_, opstring, _ := strings.Cut(lines[2], "new = old ")
		var opfn func(int, int) int
		if opstring[0] == '+' {
			opfn = func(n, m int) int {
				return n + m
			}
		} else if opstring[0] == '*' {
			opfn = func(n, m int) int {
				return n * m
			}
		}
		operandstring := opstring[2:]
		if operandstring == "old" {
			monkeys[i].op = func(n int) int {
				return opfn(n, n)
			}
		} else {
			operand, _ := strconv.Atoi(operandstring)
			monkeys[i].op = func(n int) int {
				return opfn(n, operand)
			}
		}

		// test
		divisor := getLastNumFromLine(lines[3])
		monkeys[i].div = divisor
		monkeys[i].test = func(n int) bool {
			return n%divisor == 0
		}

		// throw
		trueix := getLastNumFromLine(lines[4])
		falseix := getLastNumFromLine(lines[5])
		monkeys[i].throw = func(pred bool) int {
			if pred {
				return trueix
			} else {
				return falseix
			}
		}
	}

	return monkeys
}

func getLastNumFromLine(str string) int {
	split := strings.Split(str, " ")
	n, _ := strconv.Atoi(split[len(split)-1])
	return n
}

func turn(monkeys *[]monkey, ix int, modulo int) {
	activemonkey := &(*monkeys)[ix]
	for _, item := range activemonkey.items {
		item = activemonkey.op(item)
		item %= modulo
		cond := activemonkey.test(item)
		catcherix := activemonkey.throw(cond)
		catcher := &(*monkeys)[catcherix]
		catcher.items = append(catcher.items, item)
	}
	activemonkey.items = make([]int, 0)
}

func main() {
	monkeys := parseInput()
	modulo := 1
	for _, m := range monkeys {
		modulo *= m.div
	}
	nturns := make([]int, len(monkeys))
	for i := 0; i < 10000; i++ {
		for i, m := range monkeys {
			nturns[i] += len(m.items)
			turn(&monkeys, i, modulo)
		}
	}
	sort.Sort(sort.Reverse(sort.IntSlice(nturns)))
	fmt.Println(nturns[0] * nturns[1])
}

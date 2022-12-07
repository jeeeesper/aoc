package main

import (
	"bufio"
	"fmt"
	"os"
	"strconv"
	"strings"
)

type file struct {
	parent *directory
	name   string
	size   int
}

type directory struct {
	parent  *directory
	name    string
	subdirs map[string]*directory
	files   map[string]file
}

func dir_size(dir directory) int {
	size := 0
	for _, f := range dir.files {
		size += f.size
	}
	for _, d := range dir.subdirs {
		size += dir_size(*d)
	}
	return size
}

func solve_a(dir directory) int {
	this := dir_size(dir)
	recurse := 0
	for _, d := range dir.subdirs {
		recurse += solve_a(*d)
	}
	if this > 100000 {
		return recurse
	}
	return this + recurse
}

func main() {
	scanner := bufio.NewScanner(os.Stdin)
	var lines []string
	for scanner.Scan() {
		lines = append(lines, scanner.Text())
	}
	root := directory{
		name:    "/",
		files:   map[string]file{},
		subdirs: map[string]*directory{},
	}
	var wd *directory
	for i := 0; i < len(lines); {
		line := lines[i]
		argv := strings.Split(line[2:], " ")
		switch argv[0] {
		case "cd":
			switch argv[1] {
			case "/":
				wd = &root
			case "..":
				wd = wd.parent
			default:
				wd = wd.subdirs[argv[1]]
			}
			i++
		case "ls":
			i++
			for i < len(lines) {
				if lines[i][:1] == "$" {
					break
				}
				res := strings.Split(lines[i], " ")
				switch res[0] {
				case "dir":
					wd.subdirs[res[1]] = &directory{
						parent:  wd,
						name:    res[1],
						files:   map[string]file{},
						subdirs: map[string]*directory{},
					}
				default:
					fs, _ := strconv.Atoi(res[0])
					wd.files[res[1]] = file{
						parent: wd,
						name:   res[1],
						size:   fs,
					}
				}
				i++
			}
		}
	}
	fmt.Println(solve_a(root))
}

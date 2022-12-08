package main

import (
	"bufio"
	"fmt"
	"os"
)

func main() {
	scanner := bufio.NewScanner(os.Stdin)
	forest := [][]byte{}
	for scanner.Scan() {
		line := scanner.Text()
		forest = append(forest, []byte{})
		for _, c := range line {
			forest[len(forest)-1] = append(forest[len(forest)-1], byte(c-'0'))
		}
	}
	nRows := len(forest)
	nCols := len(forest[0])
	nVisible := 0
	for r := 0; r < nRows; r++ {
		for c := 0; c < nCols; c++ {
			visible := false
			height := forest[r][c]

			visibleFromRight := true
			for dc := 1; dc < nCols-c; dc++ {
				if forest[r][c+dc] >= height {
					visibleFromRight = false
					break
				}
			}
			visible = visible || visibleFromRight

			visibleFromLeft := true
			for dc := -1; dc > -(c+1) && !visible; dc-- {
				if forest[r][c+dc] >= height {
					visibleFromLeft = false
					break
				}
			}
			visible = visible || visibleFromLeft

			visibleFromBottom := true
			for dr := 1; dr < nRows-r && !visible; dr++ {
				if forest[r+dr][c] >= height {
					visibleFromBottom = false
					break
				}
			}
			visible = visible || visibleFromBottom

			visibleFromTop := true
			for dr := -1; dr > -(r+1) && !visible; dr-- {
				if forest[r+dr][c] >= height {
					visibleFromTop = false
					break
				}
			}
			visible = visible || visibleFromTop

			if visible {
				nVisible++
			}
		}
	}
	fmt.Println(nVisible)
}

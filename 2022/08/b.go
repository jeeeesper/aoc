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
	maxScore := 0
	for r := 0; r < nRows; r++ {
		for c := 0; c < nCols; c++ {
			height := forest[r][c]

			vr := 0
			for dc := 1; dc < nCols-c; dc++ {
				vr++
				if forest[r][c+dc] >= height {
					break
				}
			}

			vl := 0
			for dc := -1; dc > -(c + 1); dc-- {
				vl++
				if forest[r][c+dc] >= height {
					break
				}
			}

			vb := 0
			for dr := 1; dr < nRows-r; dr++ {
				vb++
				if forest[r+dr][c] >= height {
					break
				}
			}

			vt := 0
			for dr := -1; dr > -(r + 1); dr-- {
				vt++
				if forest[r+dr][c] >= height {
					break
				}
			}

			scenicScore := vr * vl * vb * vt
			if scenicScore > maxScore {
				maxScore = scenicScore
			}
		}
	}
	fmt.Println(maxScore)
}

package main

import (
	"errors"
	"io/ioutil"
	"strings"
)

type Node struct {
	Val     string
	X       int
	Y       int
	Steps   int
	Visited bool
}

type Grid struct {
	Nodes [][]*Node
}

func parse(filename string) *Grid {
	bytes, _ := ioutil.ReadFile(filename)
	lines := strings.Split(strings.TrimSpace(string(bytes)), "\n")

	grid := &Grid{make([][]*Node, len(lines))}

	for y, line := range lines {
		for x, char := range line {
			grid.Nodes[y] = append(grid.Nodes[y], &Node{string(char), x, y, -1, false})
		}
	}

	return grid
}

func (g *Grid) findStart() (*Node, error) {
	for _, row := range g.Nodes {
		for _, node := range row {
			if node.Val == "S" {
				return node, nil
			}
		}
	}

	return &Node{}, errors.New("No start found")
}

func (g *Grid) getNeighbors(node *Node) []*Node {
	neighbors := make([]*Node, 0)

	if node.X > 0 && g.Nodes[node.Y][node.X-1].Val != "#" {
		neighbors = append(neighbors, g.Nodes[node.Y][node.X-1])
	}

	if node.X < len(g.Nodes[node.Y])-1 && g.Nodes[node.Y][node.X+1].Val != "#" {
		neighbors = append(neighbors, g.Nodes[node.Y][node.X+1])
	}

	if node.Y > 0 && g.Nodes[node.Y-1][node.X].Val != "#" {
		neighbors = append(neighbors, g.Nodes[node.Y-1][node.X])
	}

	if node.Y < len(g.Nodes)-1 && g.Nodes[node.Y+1][node.X].Val != "#" {
		neighbors = append(neighbors, g.Nodes[node.Y+1][node.X])
	}

	return neighbors
}

func (g *Grid) print() {
	for _, row := range g.Nodes {
		for _, node := range row {
			print(node.Val)
		}

		println()
	}
}

func (g *Grid) getPlotCount() int {
	count := 0

	for _, row := range g.Nodes {
		for _, node := range row {
			if node.Val == "O" {
				count++
			}
		}
	}

	return count
}

func bfs(grid *Grid, maxSteps int) int {
	start, _ := grid.findStart()
	start.Steps = 1
	queue := []*Node{start}

	processed := 0

	for len(queue) > 0 {
		node := queue[0]
		queue = queue[1:]

		processed++

		if node.Steps > maxSteps {
			continue
		}

		if node.Visited {
			continue
		}

		node.Visited = true

		for _, neighbor := range grid.getNeighbors(node) {
			neighbor.Steps = node.Steps + 1
			queue = append(queue, neighbor)

			if neighbor.Steps%2 != 0 {
				neighbor.Val = "O"
			}
		}
	}

	println(processed)

	return -1
}

func main() {
	grid := parse("day21/data.txt")
	bfs(grid, 64)

	grid.print()
	total := grid.getPlotCount()

	println(total)
}

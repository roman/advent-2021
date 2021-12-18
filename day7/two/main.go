package main

import (
	"fmt"
	"bufio"
	"math"
	"strconv"
	"strings"
	"os"
)

func getNeedFuel(n int, numbers []int) int {
	acc := 0
	for _, v := range numbers {
		res := n - v
		if res < 0 {
			res = res * -1
		}
		res = (res * (res + 1)) / 2
		// fmt.Printf("%d to %d (%d): %d (diff: %d, acc: %d)\n", n, i, v, res, n - v, acc)
		acc += res
	}
	return acc
}

func main() {
	in := bufio.NewScanner(os.Stdin)
	in.Scan()
	line := in.Text()

	numberStrs := strings.Split(line, ",")
	numbers := make([]int, len(numberStrs))

	maxN := math.MinInt
	for i, nStr := range numberStrs {
		n0, err := strconv.ParseInt(nStr, 10, 64)
		if err != nil {
			panic(err.Error())
		}
		n := int(n0)
		if n > maxN {
			maxN = n
		}
		numbers[i] = n
	}

	minFuel := math.MaxInt
	for i := 0; i <= maxN; i++ {
		fuel := getNeedFuel(i, numbers)
		if minFuel > fuel {
			minFuel = fuel
		}
	}

	fmt.Printf("%v\n", minFuel)
}

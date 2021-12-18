package main

import (
	"fmt"
	"bufio"
	"math"
	"strconv"
	"strings"
	"sort"
	"os"
)

func getNeedFuel(n int, numbers []int) int {
	acc := 0
	for _, v := range numbers {
		res := n - v 
		if res < 0 {
			res = res * -1
		}
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

	for i, nStr := range numberStrs {
		n, err := strconv.ParseInt(nStr, 10, 64)
		if err != nil {
			panic(err.Error())
		}
		numbers[i] = int(n)
	}

	sort.Ints(numbers)

	minFuel := math.MaxInt
	for i := 0; i < len(numbers); i++ {
		fuel := getNeedFuel(numbers[i], numbers)
		if minFuel > fuel {
			minFuel = fuel
		}
	}

	fmt.Printf("%v\n", minFuel)
}

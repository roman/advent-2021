package main

import (
	"fmt"
	"bufio"
	"strconv"
	"os"
)

func main() {
	in := bufio.NewScanner(os.Stdin)
	numbers := make([]int64, 0, 1024)
	for {
		in.Scan()
		text := in.Text()
		if len(text) == 0 {
			break
		}
		number, err := strconv.ParseInt(text, 10, 64)
		if err != nil {
			fmt.Printf("FATAL: invalid number %v: %v\n", text, err)
			return
		}
		numbers = append(numbers, number)
	}

	acc := 0
	sums := make([]int64, 0, 1024)
	for i := 2; i < len(numbers); i++ {
		sums = append(sums, numbers[i - 2] + numbers[i - 1] + numbers[i])
	}

	fmt.Printf("%v\n", sums)

	for i := 1; i < len(sums); i++ {
		if sums[i - 1] < sums[i] {
			acc++
		}
	}

	fmt.Printf("RESULT: %v\n", acc)
}

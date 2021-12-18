def get_surroundings(lines, i, j)
  # Left/upper corner
  if i == 0 && j == 0
    right = [i, j + 1]
    down = [i + 1, j]
    return [right, down]

  end

  # Left/bottom corner
  if i == lines.size-1 && j == 0
    right = [i, j + 1]
    up = [i - 1, j]
    return [right, up]
  end

  # Right/upper corner
  if i == 0 && j == lines[i].size-1
    left = [i, j-1]
    down = [i+1, j]
    return [left, down]
  end

  # Right/bottom corner
  if i == lines.size-1 && j == lines[i].size-1
    left = [i, j-1]
    up = [i-1, j]
    return [left, up]
  end

  # Top edge
  if i == 0
    # puts "top edge"
    right = [i, j + 1]
    left = [i, j-1]
    down = [i+1, j]
    return [right, left, down]
  end

  # Bottom edge
  if i == lines.size-1
    # puts "bottom edge"
    right = [i, j + 1]
    left = [i, j-1]
    up = [i-1, j]
    return [right, left, up]
  end

  # Left edge
  if j == 0
    # puts "left edge"
    up = [i-1, j]
    right = [i, j + 1]
    down = [i+1, j]
    return [up, right, down]
  end

  # Right edge
  if j == lines[i].size-1
    # puts "right edge"
    up = [i-1, j]
    left = [i, j-1]
    down = [i+1, j]
    return [up, left, down]
  end

  down = [i+1, j]
  right = [i, j + 1]
  left = [i, j-1]
  up = [i-1, j]

  return [up, right, down, left]
end

def main
  lines = []
  while true
    n = gets
    if n.nil?
      break
    end
    lines << n.chomp.split('').map(&:to_i)
  end

  # initialize a visit matrix where all 9s are already visited
  visited = Array.new(lines.size) { |i| Array.new(lines[0].size) { |j| lines[i][j] == 9 } }

  # puts lines.inspect
  # puts visited.inspect

  result = []
  queue = []
  for i in (0...lines.size)
    for j in (0...lines[i].size)
      if visited[i][j]
        next
      end

      acc = 0
      queue.unshift [i, j]
      while !queue.empty? do
        current = queue.pop
        nodes = get_surroundings(lines, current[0], current[1]).select { |(i, j)| !visited[i][j] }
        # when all surroundings have been visited, break until the next visited
        if nodes.empty?
           next
        end
        nodes.each do |(i, j)|
          # puts "visiting [#{i}, #{j}]"
          acc += 1
          visited[i][j] = true
          queue.unshift [i, j]
        end
      end

      result << acc
    end
  end

  puts result.inspect
  product = result.sort_by { |n| n * -1 }.take(3).reduce(1) { |acc, n| acc * n }

  puts "Result: #{product}"
end


main

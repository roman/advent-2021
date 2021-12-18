def get_surroundings(lines, i, j)
  # Left/upper corner
  if i == 0 && j == 0
    right = lines[i][j + 1]
    down = lines[i + 1][j]
    return [right, down]

  end

  # Left/bottom corner
  if i == lines.size-1 && j == 0
    right = lines[i][j + 1]
    up = lines[i - 1][j]
    return [right, up]
  end

  # Right/upper corner
  if i == 0 && j == lines[i].size-1
    left = lines[i][j-1]
    down = lines[i+1][j]
    return [left, down]
  end

  # Right/bottom corner
  if i == lines.size-1 && j == lines[i].size-1
    left = lines[i][j-1]
    up = lines[i-1][j]
    return [left, up]
  end

  # Top edge
  if i == 0
    # puts "top edge"
    right = lines[i][j + 1]
    left = lines[i][j-1]
    down = lines[i+1][j]
    return [right, left, down]
  end

  # Bottom edge
  if i == lines.size-1
    # puts "bottom edge"
    right = lines[i][j + 1]
    left = lines[i][j-1]
    up = lines[i-1][j]
    return [right, left, up]
  end

  # Left edge
  if j == 0
    # puts "left edge"
    up = lines[i-1][j]
    right = lines[i][j + 1]
    down = lines[i+1][j]
    return [up, right, down]
  end

  # Right edge
  if j == lines[i].size-1
    # puts "right edge"
    up = lines[i-1][j]
    left = lines[i][j-1]
    down = lines[i+1][j]
    return [up, left, down]
  end

  down = lines[i+1][j]
  right = lines[i][j + 1]
  left = lines[i][j-1]
  up = lines[i-1][j]

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

  acc = []
  for i in (0...lines.size)
    for j in (0...lines[i].size)
      current = lines[i][j]
      if get_surroundings(lines, i, j).all? { |n| n > current }
        acc << current
      end
    end
  end
  puts acc.map { |n| n + 1 }.sum
end

main

///| Day2 of adventofcode
fn day2!() -> Int {
  let path = "day2/input"
  @fs.read_file_to_string!(path~) |> toIntInt |> isSafeCount
}

test "run day2" {
  println("result")
  println(day2!())
}

///| Split string by delimiter into array of strings
fn split_by(s : String, delim : String) -> Array[String] {
  let result = Array::new()
  let iter = s.split(delim)
  iter.each(fn(x) { result.push(x) })
  result
}

///| Convert string to integer, return 0 if parse fails
fn parse_int_safe(s : String) -> Int {
  try {
    @strconv.parse_int!(s)
  } catch {
    _ => 0
  }
}

///| Parse a single line like "1 2 3 4" into Array[Int]
fn parse_line(line : String) -> Array[Int] {
  let nums = Array::new()
  let parts = split_by(line, " ")
  parts.each(fn(part) { nums.push(parse_int_safe(part.trim_space())) })
  nums
}

///| Main function to convert string input to Array[Array[Int]]
fn toIntInt(input : String) -> Array[Array[Int]] {
  let result = Array::new()
  let lines = split_by(input, "\n")
  lines.each(fn(line) { result.push(parse_line(line.trim_space())) })
  result
}

test "toInts" {
  let input = "1 2 3 4 \n 2 3 4 5"
  let result = toIntInt(input)
  inspect!(result.length(), content="2")
  inspect!(result.get(0).unwrap().length(), content="4")
  inspect!(result.get(1).unwrap().length(), content="4")
  let first = result.get(0).unwrap()
  let second = result.get(1).unwrap()
  inspect!(first.get(0).unwrap(), content="1")
  inspect!(first.get(3).unwrap(), content="4")
  inspect!(second.get(0).unwrap(), content="2")
  inspect!(second.get(3).unwrap(), content="5")
}

///|
fn isSafeCount(matrix : Array[Array[Int]]) -> Int {
  matrix.filter(isCrazySafe).length()
}

///|
fn isSafe(row : Array[Int]) -> Bool {
  let mut count = 0
  for idx, v in row {
    if idx == 0 {
      continue
    }
    if v > row[idx - 1] && v - row[idx - 1] > 0 && v - row[idx - 1] <= 3 {
      count = count + 1
    } else {
      break
    }
  }
  if count == row.length() - 1 {
    return true
  }
  count = 0
  for idx, v in row {
    if idx == 0 {
      continue
    }
    if v < row[idx - 1] && row[idx - 1] - v > 0 && row[idx - 1] - v <= 3 {
      count = count + 1
    } else {
      break
    }
  }
  if count == row.length() - 1 {
    return true
  }
  false
}

///|
fn isCrazySafe(row : Array[Int]) -> Bool {
  if isSafe(row) {
    return true
  }

  for idx, _ in row {
    let r0 = row.copy()
    r0.remove(idx) |> ignore


    if isSafe(r0) {
      return true
    }
  }
  false
}

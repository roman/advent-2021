use std::io::{self, BufRead};

fn main() -> Result<(), io::Error> {
    let buff = io::BufReader::new(io::stdin());

    let parse_digit = |d: char| {
        d.to_digit(10).
            ok_or(io::Error::from(io::ErrorKind::InvalidData))
    };

    let parse_line = |line: Result<String, io::Error>| -> Result<Vec<u32>, io::Error> {
        let line = line?;
        line.chars().map(parse_digit).collect()
    };

    let lines = buff.lines().map(parse_line).collect::<Result<Vec<Vec<u32>>, io::Error>>()?;
    println!("{:?}", lines);
    Ok(())
}

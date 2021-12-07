use std::io::{self, BufRead};

// https://www.hackertouch.com/matrix-transposition-in-rust.html
fn matrix_transpose<A: Copy>(m: Vec<Vec<A>>) -> Vec<Vec<A>> {
    let mut t = vec![Vec::with_capacity(m.len()); m[0].len()];
    for r in m {
        for i in 0..r.len() {
            t[i].push(r[i]);
        }
    }
    t
}

fn main() -> Result<(), io::Error> {
    let buff = io::BufReader::new(io::stdin());

    let parse_digit = |d: char| {
        d.to_digit(10).
            ok_or(io::Error::from(io::ErrorKind::InvalidData))
    };

    let parse_line = |line: String| -> Result<Vec<u32>, io::Error> {
        line.chars().map(parse_digit).collect()
    };

    let lines = buff.lines().collect::<Result<Vec<String>, io::Error>>()?;
    let matrix = lines.into_iter().map(parse_line).collect::<Result<Vec<Vec<u32>>, io::Error>>()?;
    let matrix = matrix_transpose(matrix);

    let mut gamma_rate = Vec::new();
    let mut epsilon_rate = Vec::new();

    for bits in matrix {
        let mut zero_accum = 0;
        let mut one_accum = 0;
        for bit in bits {
            if bit == 0 {
                zero_accum += 1;
            }
            if bit == 1 {
                one_accum += 1;
            }
        }
        if zero_accum > one_accum {
            gamma_rate.push(0);
            epsilon_rate.push(1)
        } else if one_accum > zero_accum {
            gamma_rate.push(1);
            epsilon_rate.push(0);
        }
    }

    let base: i32 = 2;
    let mut gamma_number: i32 = 0;
    let mut epsilon_number: i32 = 0;

    let n = gamma_rate.len() - 1;
    for (i, _d) in gamma_rate.iter().enumerate() {
        gamma_number += gamma_rate[n - i] * base.pow(i.try_into().unwrap());
        epsilon_number += epsilon_rate[n - i] * base.pow(i.try_into().unwrap())
    }


    println!("gamma: {:?}\nepsilon: {:?}", gamma_rate, epsilon_rate);
    println!("gamma: {}; epsilon: {}", gamma_number, epsilon_number);
    println!("result: {}", gamma_number * epsilon_number);

    Ok(())
}

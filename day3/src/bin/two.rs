use std::io::{self, BufRead};

fn to_dec(input: Vec<u32>) -> u32 {
    let base: u32 = 2;
    let mut out: u32 = 0;
    let n = input.len() - 1;
    for (i, _d) in input.iter().enumerate() {
        out += input[n - i] * base.pow(i.try_into().unwrap());
    }
    out
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
    let mut oxygen = lines.into_iter().map(parse_line).collect::<Result<Vec<Vec<u32>>, io::Error>>()?;
    let mut co2 = oxygen.clone();

    let mut k = 0;
    loop {
        if oxygen.len() == 1 {
            break
        }

        let mut zero_accum = 0;
        let mut one_accum = 0;
        for bits in oxygen.iter() {
            let bit = bits[k];
            if bit == 0 {
                zero_accum += 1;
            }
            if bit == 1 {
                one_accum += 1;
            }
        }

        let mut acc = Vec::new();
        for bits in oxygen.into_iter() {
            let bit = bits[k];
            if (zero_accum == one_accum && bit == 1) ||
                (zero_accum > one_accum && bit == 0) ||
                (one_accum > zero_accum && bit == 1) {
                acc.push(bits);
            }
        }

        k += 1;
        oxygen = acc;
    }

    k = 0;
    loop {
        if co2.len() == 1 {
            break
        }

        let mut zero_accum = 0;
        let mut one_accum = 0;
        for bits in co2.iter() {
            let bit = bits[k];
            if bit == 0 {
                zero_accum += 1;
            }
            if bit == 1 {
                one_accum += 1;
            }
        }

        let mut acc = Vec::new();
        for bits in co2.into_iter() {
            let bit = bits[k];
            if (zero_accum == one_accum && bit == 0) ||
                (zero_accum > one_accum && bit == 1) ||
                (one_accum > zero_accum && bit == 0) {
                    acc.push(bits);
                }
        }

        k += 1;
        co2 = acc;
    }

    let output = move || -> Option<_> {
        let oxygen = oxygen.pop()?;
        let co2 = co2.pop()?;
        Some(to_dec(oxygen) * to_dec(co2))
    }();


    println!("{:?}", output);
    Ok(())
}

//
//  Wordify.swift
//  ReleaseNumberToWords
//
//  Created by Volare on 09/12/2017.
//  Copyright © 2017 Volare. All rights reserved.
//

import Foundation

let digitNames = ["","one","two","three","four","five","six","seven","eight","nine"]
let tensDigitNames = ["","","twenty","thirty","forty","fifty","sixty","seventy","eighty","ninety"]
let tenToNineteen = ["ten","eleven","twelve","thirteen","fourteen","fifteen","sixteen","seventeen","eighteen","nineteen"]
let ths = ["", "thousand","million","billion","trillion","quadrillion","quintillion","sextillion","septillion", "octillion", "nonillion", "decillion","undecillion",
           "duodecillion", "tredecillion", "quattuordecillion", "quindecillion", "sexdecillion", "septendecillion", "octodecillion", "novemdecillion", "vigintillion" ]

extension String {
    var isNumber: Bool {
        get {
            return !self.isEmpty && self.rangeOfCharacter(from: NSCharacterSet.decimalDigits.inverted) == nil
        }
    }
}

/// Converts numbers into equivalent words
///
/// - Parameter number: input Int
/// - Returns: a String representing converted output

func wordifyNum(number:Int)->String? {
    var num = number
    var output = ""
    var numAsStr:String = "\(num)"
    var strlen = numAsStr.lengthOfBytes(using: .ascii)
    var (posfwd, poshun, pos) = (0,0,strlen)
    
    func lastDigitIsZero(_ n: Int)->Bool {
        return n % 10 == 0
    }
    
    // -- for spacing only
    var wasTenOdds = false
    
    while num > 0 {
        var th = ""
        if posfwd % 3 == 0 {
            th = ths[posfwd / 3]
            poshun = 0
            numAsStr = "\(num)"
            strlen = numAsStr.lengthOfBytes(using: .ascii)
        }
        
        if num / 10 % 10 == 1 && pos == strlen  {
            let nnx = 10 + (num % 10)
            output = tenToNineteen[nnx % 10] + " " + th + (lastDigitIsZero(num) ? "":" ") + output
            wasTenOdds = true
        } else {
            if pos == strlen - 1 {
                output = tensDigitNames[num % 10] + (lastDigitIsZero(num) || wasTenOdds ? "" : "-") + output
            } else {
                var oo = digitNames[num % 10] + (lastDigitIsZero(num) ? "": " ")
                //                if num % 10 == 1 && poshun == 2 {
                //                    oo = "a "
                //                }
                oo += poshun == 2 && (!lastDigitIsZero(num)) ? "hundred and" : ""
                output = oo + th + (lastDigitIsZero(num) ? "":" ") + output
            }
            wasTenOdds = false
        }
        
        posfwd += 1
        poshun += 1
        pos -= 1
        num /= 10
    }
    // TODO: not very charming, but gets the job done...for now :)
    return output.trimmingCharacters(in: .whitespacesAndNewlines)
}

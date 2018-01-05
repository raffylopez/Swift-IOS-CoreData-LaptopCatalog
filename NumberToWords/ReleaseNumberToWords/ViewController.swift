//
//  ViewController.swift
//  ReleaseNumberToWords
//
//  Created by Volare on 09/12/2017.
//  Copyright © 2017 Volare. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var btn: UIButton!
    
    @IBOutlet weak var lbl: UILabel!
    @IBOutlet weak var tf: UITextField!
    @IBAction func btnClick(_ sender: UIButton) {
        guard let input = tf.text else { return }
        let res2 = input.trimmingCharacters(in: .whitespacesAndNewlines)
        guard res2.isNumber else { return }
        if let res3 = res2 == "" ? 0 : Int(res2) {
        let res4 = max(min(res3,0),Int.max)
        let res0 = wordifyNum(number: res3)
        lbl.text = res0
            lbl.sizeToFit()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        btn.layer.cornerRadius = 10
        btn.layer.borderColor = UIColor.blue.cgColor
        btn.layer.borderWidth = 1
        btn.clipsToBounds = true
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}


//
//  ViewController.swift
//  BinartSwiftCaptchaInput
//
//  Created by fallending on 07/28/2020.
//  Copyright (c) 2020 fallending. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        _ = test("", b: "", c: "")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func test(_ a: String, b: String, c: String = "") -> Bool {
        return true
    }

}


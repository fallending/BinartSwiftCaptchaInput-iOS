//
//  ViewController.swift
//  BinartSwiftCaptchaInput
//
//  Created by fallending on 07/28/2020.
//  Copyright (c) 2020 fallending. All rights reserved.
//

import UIKit
import BinartSwiftCaptchaInput

class ViewController: UIViewController, BACaptchaInputDelegate {
    
    @IBOutlet weak var captchaInput: BACaptchaInput!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - BACaptchaInputDelegate
    
    func onCaptchaInputComplete(captchaInput: BACaptchaInput, didFinishInput captchaCode: String) {
        print(captchaCode)
    }
    
    // MARK: - Action Handler
    
    @IBAction func onCaptchaError() {
        captchaInput.feedback()
    }
}


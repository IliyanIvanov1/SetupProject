//
//  ViewController123.swift
//  SetupProject
//
//  Created by Iliyan Ivanov on 14.11.20.
//  Copyright © 2020 Upnetix. All rights reserved.
//

import UIKit
import SFBaseKit

class ViewController123: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ViewController123: StoryboardInstantiatable {
    static var storyboardName: String {
        return "NewStoryboard"
    }
}

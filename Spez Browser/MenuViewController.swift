//
//  MenuViewController.swift
//  Spez Browser
//
//  Created by Sarp Ertoksöz on 19.05.2019.
//  Copyright © 2019 Spez Inc. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {

    @IBOutlet weak var Menu: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Rounded Corners - UIView "Menu".
        Menu.layer.cornerRadius = 12
        Menu.layer.masksToBounds = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func dismiss(_ sender: Any) {
        // Dismiss Menu
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func share(_ sender: Any) {
        // Share Dialog
        self.dismiss(animated: true, completion: nil)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "share"), object: nil)
    }
    
    @IBAction func read(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "read"), object: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

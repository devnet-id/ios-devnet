//
//  NewPostViewController.swift
//  Devnet
//
//  Created by Zulwiyoza Putra on 3/2/17.
//  Copyright © 2017 Kibar. All rights reserved.
//

import UIKit

class NewPostViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let _ = self.navigationController?.navigationBar.frame.size.height
        let inset: CGFloat = 16.0
        textView.textContainerInset = UIEdgeInsetsMake(inset, 16.0, inset, 16.0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

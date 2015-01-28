//
//  EditNoteViewController.swift
//  TouchIDDemoSwift
//
//  Created by KEEVIN MITCHELL on 1/27/15.
//  Copyright (c) 2015 Beyond 2021. All rights reserved.
//

import UIKit

class EditNoteViewController: UIViewController {
    
    @IBOutlet weak var txtNoteTitle: UITextField!
    
    @IBOutlet weak var tvNoteBody: UITextView!


    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Edit Note"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

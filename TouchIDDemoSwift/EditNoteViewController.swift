//
//  EditNoteViewController.swift
//  TouchIDDemoSwift
//
//  Created by KEEVIN MITCHELL on 1/27/15.
//  Copyright (c) 2015 Beyond 2021. All rights reserved.
//

import UIKit

class EditNoteViewController: UIViewController, UITextFieldDelegate {
    
    
    
    
    @IBOutlet weak var txtNoteTitle: UITextField!
    
    @IBOutlet weak var tvNoteBody: UITextView!
    
    let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate //declaring and instantiating at the same time an application delegate constant.

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Edit Note"
        txtNoteTitle.delegate = self
        self.txtNoteTitle.becomeFirstResponder() //It would be really nice if the keyboard would appear once this view controller is pushed to the navigation stack. That way, it would be much easier for our (hypothetic) users to start writing their notes.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    // MARK: - Textfield delegate methods
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool {
        //make the textview the first responder when the return key of the textfield keyboard gets tapped.
        
        // Resign the textfield from first responder.
        textField.resignFirstResponder()
        
        // Make the textview the first responder.
        tvNoteBody.becomeFirstResponder()
        
        return true
    }
}

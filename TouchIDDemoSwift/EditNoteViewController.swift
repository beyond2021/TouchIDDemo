//
//  EditNoteViewController.swift
//  TouchIDDemoSwift
//
//  Created by KEEVIN MITCHELL on 1/27/15.
//  Copyright (c) 2015 Beyond 2021. All rights reserved.
//

import UIKit

class EditNoteViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var saveNote: UIBarButtonItem!
    
    
    @IBOutlet weak var txtNoteTitle: UITextField!
    
    @IBOutlet weak var tvNoteBody: UITextView!
    
    let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate //declaring and instantiating at the same time an application delegate constant.
    
    
    
    @IBAction func saveNote(sender: AnyObject) {
        if self.txtNoteTitle.text.isEmpty {
            println("No title for the note was typed.")
            return
        }
           /*
            The logic that we’ll follow next is this:
            
            At first, we’ll set to a Dictionary object (Swift dictionary) the title and the note body values.
            Next, we’ll declare a mutable array (NSMutableArray).
            If the notes data file already exists, then we’ll initialize the above array with its contents, and then we’ll append the new dictionary to that array.
            If the notes data doesn’t exist, we’ll simply initialize the array by adding the dictionary to the init method.
            We’ll store the file back to disk.
            We’ll pop the view controller from the navigation controller stack.
*/
            
            // Create a dictionary with the note data.
            var noteDict = ["title": self.txtNoteTitle.text, "body": self.tvNoteBody.text]
            
            // Declare a NSMutableArray object.
            var dataArray: NSMutableArray
            
            // If the notes data file exists then load its contents and add the new note data too, otherwise
            // just initialize the dataArray array and add the new note data.
            if appDelegate.checkIfDataFileExists() {
                // Load any existing notes.
                dataArray = NSMutableArray(contentsOfFile: appDelegate.getPathOfDataFile())!
                
                // Add the dictionary to the array.
                dataArray.addObject(noteDict)
            }
            else{
                // Create a new mutable array and add the noteDict object to it.
                dataArray = NSMutableArray(object: noteDict)
            }
            
            // Save the array contents to file.
            dataArray.writeToFile(appDelegate.getPathOfDataFile(), atomically: true)
            
            // Pop the view controller
            self.navigationController!.popViewControllerAnimated(true)
            
            
            
            
        }
        
        
  

   
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

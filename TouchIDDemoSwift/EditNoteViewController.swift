//
//  EditNoteViewController.swift
//  TouchIDDemoSwift
//
//  Created by KEEVIN MITCHELL on 1/27/15.
//  Copyright (c) 2015 Beyond 2021. All rights reserved.
//
/*
There are now two important tasks we need to perform: The first one, is to update the saveNote IBAction method, so when a note is saved the noteWasSaved delegate method to be called. The second is to implement this method in the ViewController class, so every time it receives a message to load the data and update the tableview.
*/



import UIKit

// This is to tell any class whats happening in here.
protocol EditNoteViewControllerDelegate{
    func noteWasSaved()
    //In here, we’ll declare just one method that will be called every time a note gets saved:
}

class EditNoteViewController: UIViewController, UITextFieldDelegate {
    
    
   
    
    
    var indexOfEditedNote : Int! //we have to create a similar property in this  class, and then assign to it the value of the noteIndexToEdit in the viewController class property.
    
    var delegate : EditNoteViewControllerDelegate? // Next, we must declare a delegate property (variable). Note the question mark at the end of the above command. The delegate property must be an optional value, because it’s possible no object to be assigned to it (if, for example, we don’t set any delegate class), so it will remain nil.
    
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
                
                
                
                
                
                // Check if is editing a note or not.
                if indexOfEditedNote == nil {
                    // Add the dictionary to the array.
                    dataArray.addObject(noteDict)
                }
                else{
                    // Replace the existing dictionary to the array.
                    dataArray.replaceObjectAtIndex(indexOfEditedNote, withObject: noteDict)
                }
            }
            
            
            
            else{
                // Create a new mutable array and add the noteDict object to it.
                dataArray = NSMutableArray(object: noteDict)
            }
            
            // Save the array contents to file.
            dataArray.writeToFile(appDelegate.getPathOfDataFile(), atomically: true)
        
        
        // Notify the delegate class that the note has been saved. Protocol Method
        delegate?.noteWasSaved()
        
        
            // Pop the view controller
            self.navigationController!.popViewControllerAnimated(true)
        
        }
    
    
    func editNote() {
        //At first we load all the notes from the disk, then we assign to a dictionary object the one matching to the note we want to edit, and finally we set the textfield and textview texts so we can modify them.
        //By having this method prepared, we must find the proper place to call it. It’s important to select the correct point to do that, because it’s possible both the textfield and the textview not to have been initialised by the time we call that method. For example, if we call this method in the viewDidLoad method, then our app will probably crash, because the textfield and the textview will be still nil.
        
       // The best place in which we know that our subviews have been initialised, is after the view has appeared, so we just have to override and implement the viewDidAppear method.
        // Load all notes.
        var notesArray: NSArray = NSArray(contentsOfFile: appDelegate.getPathOfDataFile())!
        
        // Get the dictionary at the specified index.
        let noteDict : Dictionary = notesArray.objectAtIndex(indexOfEditedNote) as Dictionary<String, String>
        
        // Set the textfield text.
        txtNoteTitle.text = noteDict["title"]
        
        // Set the textview text.
        tvNoteBody.text = noteDict["body"]
    }
        
  

   
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Edit Note"
        txtNoteTitle.delegate = self
        self.txtNoteTitle.becomeFirstResponder() //It would be really nice if the keyboard would appear once this view controller is pushed to the navigation stack. That way, it would be much easier for our (hypothetic) users to start writing their notes.
        
    }
    
    override func viewDidAppear(animated: Bool) {
        //Note that before we call our method, we check if the indexOfEditedNote has actually a value and it’s not nil.
        if (indexOfEditedNote != nil) {
            editNote()
        }
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

//
//  ViewController.swift
//  TouchIDDemoSwift
//
//  Created by KEEVIN MITCHELL on 1/26/15.
//  Copyright (c) 2015 Beyond 2021. All rights reserved.
//

import UIKit
import LocalAuthentication
import iAd

class ViewController: UIViewController, UIAlertViewDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tblNotes: UITableView!
    
    let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate ////declaring and instantiating at the same time an application delegate constant.
    
    
    var dataArray: NSMutableArray! //we need an array (a NSMutableArray) that will be used as a data container. If you’re wondering why a mutable array and not an immutable one, then I must say because later we’ll implement another feature for deleting notes, and we’ll need to modify the array’s contents.
    //Note that the array has been declared as an optional, because if no data file exists, the array will remain nil.
    
    
    func loadData(){
        if appDelegate.checkIfDataFileExists() {
            
            // If the data file exists, then we load its contents to the array and we reload the tableview, otherwise we just display a message to the console.
            
            self.dataArray = NSMutableArray(contentsOfFile: appDelegate.getPathOfDataFile())
            self.tblNotes.reloadData()
        }
        else{
            println("File does not exist")
        }
        //By having the above method ready, we can go and call it wherever it’s needed. Let’s begin by going to the authenticateUser method, in the completion handler block and in the successful authentication case. Also, let’s call it when the correct password is typed in the alert view:
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.canDisplayBannerAds = true
        
        
        tblNotes.delegate = self
        tblNotes.dataSource = self
        
        
        authenticateUser()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //In here we will write the needed code for integrating the TouchID authentication. As you see, I set no return type to the method, as it’s a void one. Also, it doesn’t accept any parameters at all.
    
    func authenticateUser() {
        // Get the local authentication context.
        let context : LAContext = LAContext() // or let context = LAContext()
        
        // Declare a NSError variable. Notice that the error variable is declared as an optional, because if there’s no error it will be nil. nil in Swift is different from the nil in Objective-C, and it means that there’s no value at all.
        var error: NSError?
        
        // Set the reason string that will appear on the authentication alert.
        var reasonString = "Authentication is needed to access your notes."
        
        //The next step is to ask the framework if the TouchID authentication can be applied to the specific device, by calling a special function named canEvaluatePolicy. It accepts two parameters, the policy we want to evaluate and an error object. Here’s how it’s used:
        // Check if the device can evaluate the policy.
        if context.canEvaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics, error: &error) {
            
            
            //The DeviceOwnerAuthenticationWithBiometrics is a property of the LAPolicy class. Note that the error variable is passed by reference. If this condition is true, then the device supports the TouchID authentication, the TouchID mechanism has been enabled in the device’s Settings, a passcode has been also set, and of course, one finger at least has been enrolled. That means that the specific authentication policy can be applied, and the TouchID authentication dialog to appear:
            
            [context .evaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics, localizedReason: reasonString, reply: { (success: Bool, evalPolicyError: NSError?) -> Void in
                
                if success {
                    //here we call the l;oaddata method
                    NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                        self.loadData()
                    })
                }                else{
                    // If authentication failed then show a message to the console with a short description.
                    // In case that the error is a user fallback, then show the password alert view.
                    println(evalPolicyError?.localizedDescription)
                    
                    switch evalPolicyError!.code {
                        
                    case LAError.SystemCancel.rawValue:
                        println("Authentication was cancelled by the system")
                        
                    case LAError.UserCancel.rawValue:
                        println("Authentication was cancelled by the user")
                        
                    case LAError.UserFallback.rawValue:
                        println("User selected to enter custom password")
                        NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                            self.showPasswordAlert()
                        })
                        
                    default:
                        println("Authentication failed")
                        NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                            self.showPasswordAlert()
                        })
                    }
                }
                
                
                
            })]
            
        }else{
            // If the security policy cannot be evaluated then show a short message depending on the error.
            switch error!.code{
                
            case LAError.TouchIDNotEnrolled.rawValue:
                println("TouchID is not enrolled")
                
            case LAError.PasscodeNotSet.rawValue:
                println("A passcode has not been set")
                
            default:
                // The LAError.TouchIDNotAvailable case.
                println("TouchID not available")
            }
            
            // Optionally the error description can be displayed on the console.
            println(error?.localizedDescription)
            
            // Show the custom alert view to allow users to enter the password.
            self.showPasswordAlert()
        }
    }
    
    
    func showPasswordAlert() {
        var passwordAlert : UIAlertView = UIAlertView(title: "TouchIDDemo", message: "Please type your password", delegate: self, cancelButtonTitle: "Cancel", otherButtonTitles: "Okay")
        passwordAlert.alertViewStyle = UIAlertViewStyle.SecureTextInput
        passwordAlert.show()
    }
    
    func alertView(alertView: UIAlertView!, clickedButtonAtIndex buttonIndex: Int) {
        if buttonIndex == 1 {
            if !alertView.textFieldAtIndex(0)!.text.isEmpty {
                if alertView.textFieldAtIndex(0)!.text == "appcoda" {
                    
                    loadData()
                    
                }
                else{
                    showPasswordAlert()
                }
            }
            else{
                showPasswordAlert()
            }
        }
    }
   
    
    // MARK: - Saving to the documents Directory
    
    /*
     the note data is going to be stored to the disk, in the documents directory of the app specifically. Programmatically speaking, that means that we must develop the necessary methods to get the path of the notes file to the documents directory, and to check if that file exists.
    These two functionalities are needed in two places: In the ViewController, this class for checking if the file exists and for loading the data, and in the EditNoteViewController class, for loading any existing data and appending the new one, and of course for saving the edited note. Because we need to do almost the same thing in two different classes, we’ll implement the two methods in the AppDelegate class and then by instantiating an application delegate object, we’ll access them directly. The first method is going to return the full path of the notes file
    */
    
    
   // MARK: - TableView Datasource Methods
    
    func numberOfSectionsInTableView(tableView: UITableView!) -> Int {
        //At first, we must specify the number of sections in the tableview:
        
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let array = dataArray {
            //we must return the proper number of rows. Remember at this point that if the notes data file doesn’t exist, the dataArray mutable array we declared earlier won’t get initialised and it will remain nil. So, we must be sure first that the array is not nil and return the proper number of rows, otherwise we must return 0.
            //As you see, if the dataArray actually exists, we unwrap it to the array constant and we return the total number of its objects
            
            
            return array.count
        }
        else{
            return 0
        }
    }
    
    //Alternate numberOfRows
    /*func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return dataArray.count
    
    … as long as you don’t declare the dataArray as an optional, but you initialize it upon its declaration so it will never be nil. So, instead of writing this…
    1
    
    var dataArray: NSMutableArray!
    
    … you just need to write this:
    1
    
    var dataArray: NSMutableArray = NSMutableArray()
    
    However, this approach would make the dataArray to be initialised once again with the contents of the file in the loadData method, but furthermore, our initial implementation consists of a nice chance to work with optionals!
    */
    
    
    
    //Our next step is to return a cell:
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        //After having dequeued the cell, we assign the dictionary with each note data to the currentNote constant. Next, we just get the each note’s title and we set it as the text to the cell’s label.
        
        var cell = tableView.dequeueReusableCellWithIdentifier("idCell") as UITableViewCell
        
        let currentNote = self.dataArray.objectAtIndex(indexPath.row) as Dictionary<String, String>
        cell.textLabel.text = currentNote["title"]
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60.0
    }
    
    
    
    
    
}





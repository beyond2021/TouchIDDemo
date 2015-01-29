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

class ViewController: UIViewController, UIAlertViewDelegate {
    
    @IBOutlet weak var tblNotes: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.canDisplayBannerAds = true
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
                    
                }
                else{
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
    
    

}


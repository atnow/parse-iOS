//
//  RequestFormViewController.swift
//  now
//
//  Created by Ben Ribovich on 10/29/15.
//  Copyright © 2015 Ben Ribovich. All rights reserved.
//

import UIKit



class RequestFormViewController: UIViewController {
    
    
    
    @IBOutlet weak var descriptionTextField: UITextField!
    
    @IBOutlet weak var priceTextField: UITextField!

    @IBOutlet weak var locationTextField: UITextField!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var instructionsView: UITextView!
    
    
    @IBAction func submitPressed(sender: AnyObject) {
        
//        let newTask = Task()
//        newTask.title = descriptionTextField.text
//        newTask.price = NSNumber(integer: Int(priceTextField.text!)!)
//        newTask.taskLocation = locationTextField.text
//        newTask.descriptionProperty = instructionsView.text
//        newTask.timeRequested = NSNumber(integer: Int(datePicker.date.timeIntervalSince1970))
//        insertTaskToBackend(newTask)
        
    }
    
    func insertTaskToBackend(newTask: Task){
        
//        let query = GTLQueryAtnow.queryForTasksInsertWithObject(newTask) as GTLQueryAtnow
//        
//        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
//        service.executeQuery(query) { (ticket, response, error) -> Void in
//            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
//            if error != nil{
//                self._showErrorDialog(error!)
//                return
//            }
//            let returnedTask = response as! GTLAtnowTask
//            newTask.taskId = returnedTask.taskId
//            
//        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        instructionsView.layer.borderWidth = 1
        instructionsView.layer.borderColor = UIColor.lightGrayColor().CGColor
        // Do any additional setup after loading the view.
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
    
    //MARK: - Private helper methods
    
//    func _showErrorDialog(error: NSError){
//        let alertController = UIAlertController(title: "Endpoints Error", message: error.localizedDescription, preferredStyle: UIAlertControllerStyle.Alert)
//        let defaultAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
//        alertController.addAction(defaultAction)
//        presentViewController(alertController, animated: true, completion: nil)
//    }


}

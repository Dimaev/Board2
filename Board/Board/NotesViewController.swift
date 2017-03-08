//
//  NotesViewController.swift
//  Board
//
//  Created by Dmitry on 24.02.17.
//  Copyright © 2017 Creator. All rights reserved.
//

import UIKit

//the protocol (or delegate) pattern, so we can update the table view's selected item

protocol NoteViewDelegate {
    //the name of the function that will be implemented
    func didUpdateNoteWithTitle(newTitle : String, andBody newBody :
        String) }

class NotesViewController: UIViewController, UITextViewDelegate {
    
    //a variable to hold the delegate (so we can update the table view)
    
    var delegate : NoteViewDelegate?
    
    @IBOutlet var txtBody: UITextView!
    
    //a string variable to hold the body text
    var strBodyText : String!
    
    
    @IBOutlet weak var btnDoneEditing: UIBarButtonItem!
    
    @IBAction func doneEditingBody() {
        //hides the keyboard
        self.txtBody.resignFirstResponder()
        
        
        self.btnDoneEditing.tintColor = UIColor(red: 0, green:122.0/255.0, blue: 1, alpha: 1)
        
        
        //but only if the delegate is NOT nil
        if self.delegate != nil {
            self.delegate!.didUpdateNoteWithTitle(newTitle: self.navigationItem.title!, andBody: self.txtBody.text)
        }
        
    }
    
    private func textViewDidBeginEditing(textView: UITextView) {
     
        //it's not a pre-defined value like clearColor, so we give it the exact RGB values
        
        self.btnDoneEditing.tintColor = UIColor.clear //(red: 0, green:
            //122.0/255.0, blue: 1, alpha: 1)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        //set the body's text to the intermitent string
        self.txtBody.text = self.strBodyText
        
        //makes the keyboard appear immediately
        self.txtBody.becomeFirstResponder()
        
        //allows UITextView methods to be called (so we know when they begin editing again)
        
        self.txtBody.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //tell the main view controller that we're going to update the selected item
        
        //but only if the delegate is NOT nil
        if self.delegate != nil {
            self.delegate!.didUpdateNoteWithTitle(newTitle: self.navigationItem.title!, andBody: self.txtBody.text)
        }
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

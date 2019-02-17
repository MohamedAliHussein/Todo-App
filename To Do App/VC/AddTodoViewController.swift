//
//  AddTodoViewController.swift
//  To Do App
//
//  Created by Mohamed Ali on 2/2/19.
//  Copyright © 2019 mohamed ali. All rights reserved.
//

import UIKit
import CoreData


class AddTodoViewController: UIViewController {
    
    
    var managedContext: NSManagedObjectContext!
    var todo : Todo!

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var bottomConstraint : NSLayoutConstraint!
    
    var appDelegate: AppDelegate?
    let coreDataStack = CoreDataStack()

    
    override func viewDidLoad() {
        super.viewDidLoad()

      self.managedContext = coreDataStack.managecontext
        
        // Do any additional setup after loading the view.
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(with:)), name: .UIKeyboardWillShow, object: nil)
        textView.becomeFirstResponder()
        if let todo = todo {
            textView.text = todo.title

            segmentedControl.selectedSegmentIndex = Int(todo.priority)
        }
        
        
        
    }

    
  
    // MARK : Actions
    
    @objc func keyboardWillShow(with notification : Notification){
        _ = "UIKeyboardFrameEndUserInfokey"
        guard let keyboardFrame = notification.userInfo?["key"] as? NSValue else { return }
        
        let keyboardHeight = keyboardFrame.cgRectValue.height
        bottomConstraint.constant = keyboardHeight + 16
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
   
    @IBAction func cancel(_ sender: UIButton) {
        
        dismiss(animated: true)
        textView.resignFirstResponder()
       
    }
    @IBAction func done(_ sender: UIButton) {
        
        guard let title = textView.text , !title.isEmpty else {
            return
        }
        if let todo = self.todo {
            todo.title = title
            todo.priority = Int16(segmentedControl.selectedSegmentIndex)
        } else {
//        let todo = Todo(context: managedContext)
       let entity = NSEntityDescription.entity(forEntityName: "Todo", in: self.managedContext)
        let todo = Todo(entity: entity!, insertInto: self.managedContext)
        todo.title = title
        todo.priority = Int16(segmentedControl.selectedSegmentIndex)
        todo.date = Date()
        }
        do {
            try managedContext.save()
            dismiss(animated: true)
             textView.resignFirstResponder()
        } catch(let error) {
            print("Error saving todo \(error.localizedDescription)")
        }
    }
}

extension AddTodoViewController:UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if doneButton.isHidden {
            textView.text.removeAll()
            textView.textColor = .white
            
            doneButton.isHidden = false
            
            UIView.animate(withDuration: 0.3 , animations : {
                self.view.layoutIfNeeded()
            })
        }
    }
 }
// extension TodoTableViewController: NSFetchRequestDelegate {}








//
//  CollectionViewControllerDemo.swift
//  Board
//
//  Created by Dmitry on 23.02.17.
//  Copyright © 2017 Creator. All rights reserved.
//

import UIKit



class CollectionViewController: UICollectionViewController, NoteViewDelegate {
    
  
    @IBOutlet weak var calendarButton: UIBarButtonItem!
    
    
    fileprivate var activeCell : TextCellView!
    var arrNotes:[String] = []
    var selectedIndex = -1
    

    func saveNotesArray() {
        UserDefaults.standard.set(arrNotes, forKey: "notes")
        UserDefaults.standard.synchronize()
    }
    
    
    func didUpdateNoteWithTitle(newTitle: String, andBody newBody:
        String) {
        //update the respective values
        self.arrNotes[self.selectedIndex] = newBody
        self.collectionView?.reloadData()
        
        saveNotesArray()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //this is known as downcasting
        if let newNotes = UserDefaults.standard.array(forKey: "notes") as? [String] {
            //set the instance variable to the newNotes variable
            arrNotes = newNotes
        }
        
        // Добавляем строку, регистрируем xib
        self.collectionView?.register(UINib(nibName: "TextCellView", bundle: nil), forCellWithReuseIdentifier: "CELL")
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupView()
        
    }
    
    
    func setupView(){
        // Setting up swipe gesture recognizers
        let swipeRight : UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(CollectionViewController.userDidSwipeRight))
        swipeRight.direction = .right
        
        view.addGestureRecognizer(swipeRight)
        
        let swipeLeft : UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(CollectionViewController.userDidSwipeLeft))
        swipeLeft.direction = .left
        
        view.addGestureRecognizer(swipeLeft)
    }
    
    
    func getCellAtPoint(_ point: CGPoint) -> TextCellView? {
        // Function for getting item at point. Note optionals as it could be nil
        let indexPath = collectionView?.indexPathForItem(at: point)
        var cell : TextCellView?
        
        if indexPath != nil {
            cell = collectionView?.cellForItem(at: indexPath!) as? TextCellView
        } else {
            cell = nil
        }
        
        return cell
    }
    
    func userDidSwipeRight(_ gesture : UISwipeGestureRecognizer){
        let point = gesture.location(in: collectionView)
        let duration = animationDuration()
        
        if(activeCell == nil){
            activeCell = getCellAtPoint(point)
            
            UIView.animate(withDuration: duration, animations: {
                self.activeCell?.transform = CGAffineTransform(translationX: 0, y: -self.activeCell.frame.height)
            });
        } else {
            // Getting the cell at the point
            let cell = getCellAtPoint(point)
            
            // If the cell is the previously swiped cell, or nothing assume its the previously one.
            if cell == nil || cell == activeCell {
              
                    
                    let indexPath = collectionView?.indexPath(for: activeCell)
                    arrNotes.remove(at: indexPath!.row)
                    collectionView?.deleteItems(at: [indexPath!])
                    saveNotesArray()
                
                // If another cell is swiped
            } else if activeCell != cell {
                // It's not the same cell that is swiped, so the previously selected cell will get unswiped and the new swiped.
                UIView.animate(withDuration: duration, animations: {
                    self.activeCell.transform = CGAffineTransform.identity
                    cell!.transform = CGAffineTransform(translationX: 0, y: -cell!.frame.height)
                }, completion: {
                    (Void) in
                    self.activeCell = cell
                })
                
            }
        }
        
        
    }
    
    
    func userDidSwipeLeft(){
        // Revert back
        if(activeCell != nil){
            let duration = animationDuration()
            
            UIView.animate(withDuration: duration, animations: {
                self.activeCell.transform = CGAffineTransform.identity
            }, completion: {
                (Void) in
                self.activeCell = nil
            })
        }
    }
    
    func animationDuration() -> Double {
        return 0.5
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        return arrNotes.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath,to destinationIndexPath: IndexPath) {
        
        let temp = arrNotes[sourceIndexPath.row]
        arrNotes[sourceIndexPath.row] = arrNotes[destinationIndexPath.row]
        arrNotes[destinationIndexPath.row] = temp
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
         self.selectedIndex = indexPath.row
        
         performSegue(withIdentifier: "showEditorSegue", sender: nil)
        
        let cell = collectionView.cellForItem(at: indexPath)
        if activeCell != nil && activeCell != cell {
            userDidSwipeLeft()
        }
   
    }
    
        
    override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CELL",
                                                      for: indexPath) as! TextCellView
        
        cell.labelText.text = arrNotes[indexPath.row]
        
        return cell
        
    }
    

    @IBAction func newNote() {
        
        var newArr:String = ""
        
        arrNotes.insert(newArr, at: 0)
        
        self.collectionView?.reloadData()
        
        //set the selected index to the most recently added item
        self.selectedIndex = 0
        
        saveNotesArray()
        
        performSegue(withIdentifier:"showEditorSegue", sender: nil)
        

    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender:
        Any?) {
        
      if segue.identifier == "showEditorSegue" {
        
        //grab the view controller we're gong to transition to
        let notesEditorVC = segue.destination as!
        NotesViewController
        
        //set the title of the navigation bar to the selectedIndex's title
        notesEditorVC.navigationItem.title =
            arrNotes[self.selectedIndex]
        
        //set the body of the view controller to the selectedIndex's body
        
        notesEditorVC.strBodyText =
            arrNotes[self.selectedIndex]//["body"]
        
        //set the delegate to "self", so the method gets called here
        notesEditorVC.delegate = self
        
        
      }
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

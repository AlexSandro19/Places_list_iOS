//
//  ViewController.swift
//  Mandatory_1
//
//  Created by Veniamin Shandrovskiy on 07.04.2021.
//

import UIKit
import Firebase

let firebaseService = FirebaseService()//will be visible across all classes (it global - so its singleton)

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, Updatable {
    func updateImage(obj: NSObject?) {
        
    }
    

    private var db = Firestore.firestore()
    
    @IBOutlet weak var tableView: UITableView!
    
    private var currentEditIndex = -1 // initialized as invalid value
    
    var parent_view_controller:ViewController? = nil
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        firebaseService.parent = self
        firebaseService.startListener()
        tableView.dataSource = self
        tableView.delegate = self
        parent_view_controller = self
    }
    

    @IBAction func createNote(_ sender: UIButton) {
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        firebaseService.notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) //we get a non-Optional cell
        //cell.textLabel?.text = String(firebaseService.notes[indexPath.row].text.prefix(15))
        cell.textLabel?.text = String(firebaseService.notes[indexPath.row].text)
        return cell
    }
    
    func update() {
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print("You clicked \(indexPath.row)")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? DetailViewController{
            //print("Checked dest")
            let currentIndex = tableView.indexPathForSelectedRow?.row ?? -1
            dest.currentIndex = currentIndex
            var currentText = ""
            var currentImgId = ""
            if currentIndex == -1 {
            //currentText = ""
            //currentImage = nil
            //currentImgId = ""
            }else{
                currentText = firebaseService.notes[currentIndex].text
                currentImgId = firebaseService.notes[currentIndex].imageId
            }
            
            dest.currentText = currentText
            dest.currentImgId = currentImgId
            dest.parent_view_controller = self
            
            
        }
        //print("prepare is called \(segue.destination.description)")
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        print("Edit called \(indexPath.row)")
        firebaseService.deleteNote(index: indexPath.row )
        tableView.deleteRows(at: [indexPath], with: .fade)// this requires, that the underlying datasourse ALSO gets updated
    }
}


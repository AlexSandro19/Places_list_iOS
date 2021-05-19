//
//  FirebaseService.swift
//  Mandatory_1
//
//  Created by Veniamin Shandrovskiy on 07.04.2021.
//

import Foundation
import Firebase
import FirebaseStorage

class FirebaseService{
    
    private var db = Firestore.firestore()
    var storage = Storage.storage()
    var storageRef:StorageReference?
    var notes = [Note]()
    private var notesCol = "notes"

    var parent:Updatable?
   

    func startListener(){ // will keep listening
        db.collection(notesCol).addSnapshotListener { (snap, error) in
            if let e = error {
                print("error fetching data \(e)")
            }else {
                if let s = snap {
                    self.notes.removeAll()
                    for doc in s.documents {
                        if let txt = doc.data()["text"] as? String, let imageId =  doc.data()["imageId"] as? String{
                            //print(txt)
                            //print(imageId)
                            //print(doc.documentID)
                            let note = Note.init(id: doc.documentID, text: txt, imageId: imageId)
                            self.notes.append(note)
                        }else if let txt = doc.data()["text"] as? String{
                                //print(txt)
                                //print(doc.documentID)
                                let note = Note.init(id: doc.documentID, text: txt, imageId: "")
                                self.notes.append(note)
                        }
                    }
                    self.parent?.update()
                }
            }
        }
    }
    
    func addNote(text:String, imageId:String) {
        print("addNote called with \(text)")
        if text.count > 0 {
            let doc = db.collection(notesCol).document()//will create a new document
            var data = [String:String]()//create a new empty map/dictionary
            data["text"] = text
            if imageId.count > 0 {
                data["imageId"] = imageId
            }
            doc.setData(data)//will save to Firebase
            self.parent?.update()
        }
     
    }
    
    func deleteNote(index:Int) {
        if index < notes.count{
            let docID = notes[index].id
            let imageId = notes[index].imageId
            db.collection(notesCol).document(docID).delete(){
                //the code after delete() is a callback function(it is optional and can be added as last parameter to delete(). If err will have a value, then message will be displayed)
                err in
                if let e = err{
                    print("error deleting \(docID) \(e)")
                }else{
                    print("ok deleting \(docID)")
                }
            }
            notes.remove(at: index)//so we delete data both from Firestore and the array. The note will also be deleted graphically in the ViewController
            
            //!!!Also delete image from Storage
            let imageRef = storageRef?.child(imageId)
             imageRef!.delete { error in
                  if let e = error {
                    print("error deleting image \(e)")
                  } else {
                    print("ok deleting image \(imageId)")
                  }
            }
        }
    }
    
    func updateNote(index: Int, text:String, imageId:String) {
        
        if text.count > 0 {
            let doc = db.collection(notesCol).document(notes[index].id)//will create a new document
            var data = [String:String]()//create a new empty map/dictionary
            data["text"] = text

            
            if imageId.count > 0 {
                data["imageId"] = imageId
            }
            doc.setData(data)//will save to Firebase
                        
        }
        
        self.parent?.update()
    }
    
    func uploadImage(image:UIImage, imageId:String) {
        print("Inside upladImage")
        if let data = image.jpegData(compressionQuality: 1.0){
            self.storageRef = storage.reference()
            print("uplading Image compressed")
            if let imageRef = storageRef?.child(imageId){
                print("uplading Image called")
                imageRef.putData(data, metadata: nil){
                   (metadata, error) in
                    if let e = error {
                       print("error uploading image \(e)")
                    }else{
                        print("OK uploading image")
                    }
                }
            }
            
        
        }
    }
    
    func deleteImage(imageId:String) {
        if imageId.count < 0{
            let imageRef = storageRef?.child(imageId)
            imageRef!.delete { error in
                  if let e = error {
                    print("error deleting image \(e)")
                  } else {
                    print("ok deleting image \(imageId)")
                  }
            }
        }
    }
    
    /*func fetchImage(imageId:String) -> UIImage? {
        
        let imageRef = storageRef?.child(imageId)
        var image:UIImage? = nil
        imageRef?.getData(maxSize:10 * 1024 * 1024, completion: { (data, error) in
            if let e = error{
                print("Error getting data from Storage: \(e.localizedDescription)")
            }
            if let data = data {
                image = UIImage(data: data)
                print("Picture retrieved")
            }
            
        })
        
        if let img = image{
            return img
        }else{
            return nil
        }
        
    }*/
    
}

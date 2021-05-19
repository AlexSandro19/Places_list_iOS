//
//  DetailViewController.swift
//  Mandatory_1
//
//  Created by Veniamin Shandrovskiy on 07.04.2021.
//

import UIKit



class DetailViewController: UIViewController, UITextViewDelegate, UpdatableImage{

    let group = DispatchGroup()
    
    var currentIndex = -1
    var currentText = ""
    var currentImage:UIImage? = nil
    var currentImgId = ""
    
    var imageUpdated = false
    
    var parent_view_controller:ViewController? = nil
    
    
    
    @IBOutlet weak var noteTextView: UITextView!
    
    var imagePicker = ImagePicker()
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        noteTextView.delegate = self
        noteTextView.text = currentText
        imagePicker.parentDVC = self
        fetchImage(imageId: currentImgId)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        print("Current Image \(currentImgId)")
        print("Image Updated \(imageUpdated)")
        var imageId = currentImgId
        
        if imageUpdated{
            imageId = generateImageId()
        }
                    
        print(imageId)
        if currentIndex == -1{
            
            firebaseService.addNote(text: noteTextView.text, imageId: imageId)
        }else{
            firebaseService.updateNote(index: currentIndex, text: noteTextView.text, imageId: imageId)
        }
        
    }
    
    func generateImageId() -> String{
        if let img = imageView.image{
            print("Calling generateImageId \(img)")
            let imageId = UUID().uuidString
            firebaseService.uploadImage(image: img, imageId: imageId)
            print("Calling generateImageId with received id \(imageId)")
            return imageId
        }else{
            return ""
        }
        
    }
    
    @IBAction func addPicturePressed(_ sender: UIButton) {
        //print("Add Picture Pressed")
        imagePicker.sourceType = .photoLibrary// we want the library, not camera
        present(imagePicker, animated: true, completion: nil)
    }
    
    
    func updateImage(obj: NSObject?) {
        if let img = obj as? UIImage{
            imageView.image = img
            imageUpdated = true
            firebaseService.deleteImage(imageId: currentImgId
            )
        }
    }
    
    @IBAction func takePicturePressed(_ sender: UIButton) {
        //print("Take Picture Pressed")
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
    }
    @IBAction func savePicturePressed(_ sender: UIButton) {
        if let img = imageView.image{
            UIImageWriteToSavedPhotosAlbum(img, nil, nil, nil)
        }
        
    }
    
    
    func fetchImage(imageId:String) {
        print("Start fetch")
        if imageId.count > 0 {
            let storageRef = firebaseService.storageRef
            let imageRef = storageRef?.child(imageId)
            var image:UIImage? = nil
            imageRef?.getData(maxSize:10 * 1024 * 1024, completion: { (data, error) in
                if let e = error{
                    print("Error getting data from Storage: \(e.localizedDescription)")
                }
                if let data = data {
                    self.imageView.image = UIImage(data: data)
                    image = self.imageView.image
                    print("Picture retrieved")
                }
                
            })
            
            currentImage = image
            
            print("End fetch")
            
        }else{
            self.imageView.image = nil
        }
    
        
    }
    
    
}


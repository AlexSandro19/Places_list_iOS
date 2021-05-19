//
//  ImagePicker.swift
//  Mandatory_1
//
//  Created by Veniamin Shandrovskiy on 08.04.2021.
//

import UIKit

class ImagePicker: UIImagePickerController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var parentDVC:UpdatableImage? //parentDetailViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        super.delegate = self
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print("back with image \(info.description)")
        if let img = info[.originalImage] as? UIImage{
            parentDVC?.updateImage(obj: img)//if parentDVC has a value, then it will call update method. It will never throw nullpointer exception
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    

}

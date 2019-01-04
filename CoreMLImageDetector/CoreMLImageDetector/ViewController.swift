//
//  ViewController.swift
//  CoreMLImageDetector
//
//  Created by Jonathan Cochran on 1/3/19.
//  Copyright © 2019 Jonathan Cochran. All rights reserved.
//

import UIKit
import CoreML

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var imagePicker:UIImagePickerController!
    @IBOutlet weak var imageViewObject: UIImageView!
    @IBOutlet weak var descImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func btnTakeImage(_ sender: Any) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageViewObject.image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        imagePicker.dismiss(animated: true, completion: nil)
        pictureIdentifyML(image: (info[UIImagePickerController.InfoKey.originalImage] as? UIImage!)!)
    }
    
    func pictureIdentifyML(image:UIImage){
        
        guard let model = try? VNCoreMLModel(for:Resnet50().model) else {
            fatalError(" can not see Model")
        }
        
        let request = VNCoreMLRequest(model:model) {
           [weak self] request, error in
            
            guard let results = request.results as? [VNClassificationObserveration],
                let firstResult = results.first else {
                    fatalError("can not get result")
            }
        }
    }
    
}


//
//  ViewController.swift
//  CoreMLImage
//
//  Created by Jonathan Cochran on 1/4/19.
//  Copyright © 2019 Jonathan Cochran. All rights reserved.
//

import UIKit
import CoreML
import Vision
import AVFoundation

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageViewObject: UIImageView!
    
    @IBOutlet weak var imageDesc: UITextView!
    
    var imagePicker:UIImagePickerController!
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        
    }
    
    @IBAction func btnTakenImage(_ sender: Any) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        imageViewObject.image=info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        imagePicker.dismiss(animated: true, completion: nil)
        pictureIdentifyML(image: (info[UIImagePickerController.InfoKey.originalImage] as? UIImage)!)
    }
    
    func pictureIdentifyML(image:UIImage){
        guard let model = try? VNCoreMLModel(for: Resnet50().model) else {
            fatalError("CAN NOT LOAD ML MODEL")
        }
        
        let request = VNCoreMLRequest(model: model){
            [weak self] request, error in
            
            guard let results = request.results as? [VNClassificationObservation],
                let firstResult =  results.first else {
                    fatalError("cannot ger result")
            }
            
            DispatchQueue.main.async {
                self?.imageDesc.text = "confidence = \(Int(firstResult.confidence * 100))% \n identifire \(firstResult.identifier)"
                let text2Speech = AVSpeechUtterance(string: (self?.imageDesc.text)!)
                text2Speech.voice = AVSpeechSynthesisVoice(language: "en-gb")
                let synthesizer = AVSpeechSynthesizer()
                synthesizer.speak(text2Speech)
            }
        }
        
        guard let ciImage = CIImage(image: image) else {
            fatalError("Can not load picture")
        }
        let imageHandler = VNImageRequestHandler(ciImage: ciImage)
        
        DispatchQueue.global(qos: .userInteractive).async {
            do{
                try imageHandler.perform([request])
            }catch{
                print("Error \(error)")
            }
        }
    }
    
}




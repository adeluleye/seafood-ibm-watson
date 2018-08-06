//
//  ViewController.swift
//  SeeFood-IBM
//
//  Created by ADELU ABIDEEN ADELEYE on 8/6/18.
//  Copyright © 2018 Spantom Technologies Ltd. All rights reserved.
//

import UIKit
import VisualRecognitionV3
import SVProgressHUD
import Social

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let apiKey = "gR8heAbOJuJyyJoSadz_vrSPmUqTKFu1VvI2MljuAL3P"
    let version = "2018-08-06"
    

    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    
    @IBOutlet weak var share: UIButton!
    
    let imagePicker = UIImagePickerController()
    
    var classificationResults : [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        share.isHidden = true
        
        imagePicker.delegate = self
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        cameraButton.isEnabled = false
        SVProgressHUD.show(withStatus: "Analyzing your image...")
        
        if let userPickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            imageView.image = userPickedImage
            
            imagePicker.dismiss(animated: true, completion: nil)
            
            let visualRecognition = VisualRecognition(version: version, apiKey: apiKey)
            
            //let imageData = UIImageJPEGRepresentation(userPickedImage, 0.01)
            
            //let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            
            //let fileURL = documentsURL.appendingPathComponent("tempImage.jpg")
            
            //try? imageData?.write(to: fileURL, options: [])
            let failure = { (error: Error) in print(error) }
            visualRecognition.classify(image: userPickedImage, failure: failure) { (classifiedImages) in
                
                let classes = classifiedImages.images.first!.classifiers.first!.classes
                
                self.classificationResults = []
                
                for index in 0..<classes.count {
                    
                    self.classificationResults.append(classes[index].className)
                }
                
                print(self.classificationResults)
                
                DispatchQueue.main.async {
                    self.cameraButton.isEnabled = true
                    SVProgressHUD.dismiss()
                    self.share.isHidden = false
                }
                
                //let result = self.classificationResults.contains("hotdog") ? "Hotdog" : "Not Hot dog!"
                
                if self.classificationResults.contains("hotdog") {
                    DispatchQueue.main.async {
                        SVProgressHUD.showSuccess(withStatus: "Hotdog")
                        self.navigationItem.title = "Hotdog!"
                        self.navigationController?.navigationBar.barTintColor = UIColor.green
                        self.navigationController?.navigationBar.isTranslucent = false
                    }
                } else {
                    DispatchQueue.main.async {
                        SVProgressHUD.showError(withStatus: "Not Hotdog")
                        self.navigationItem.title = "Not Hotdog!"
                        self.navigationController?.navigationBar.barTintColor = UIColor.red
                        self.navigationController?.navigationBar.isTranslucent = false
                    }
                }
                
            }
            
        } else {
            print("Error while picking an image")
        }
        
    }

    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
        
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = false
        
        present(imagePicker, animated: true, completion: nil)
        
        
    }
    
    @IBAction func shareButtonTapped(_ sender: UIButton) {
        
        //SLServiceTypeTwitter has been deprecated
        
//        if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeTwitter) {
//
//            //let vc = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
//            //vc?.setInitialText("My Food is \(navigationItem.title)")
//            //present(vc!, animated: true, completion: nil)
//        } else {
//            self.navigationItem.title = "Please log in to twitter"
//        }
    }
}


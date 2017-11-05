//
//  CreateChallengeViewController.swift
//  NewBuckitApp
//
//  Created by Zhongwu Shi on 08/10/2017.
//  Copyright © 2017 Zhongwu Shi. All rights reserved.
//

import UIKit
import Alamofire
import Cloudinary
import RandomKit

class CreateChallengeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet var imageView: UIImageView!
    @IBOutlet var descriptionText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.layer.borderColor = UIColor.gray.cgColor
        imageView.layer.borderWidth = 1
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(addTapped))
        // Do any additional setup after loading the view.
    }
    
    @objc func addTapped() {
        let config = CLDConfiguration(cloudName: "sem", apiKey: "445234287149499")
        let cloudinary = CLDCloudinary(configuration: config)
        if let img = self.imageView.image {
            let data = UIImageJPEGRepresentation(img, 0.1)! as Data
            let params = CLDUploadRequestParams()
            let imageName = String.random(ofLength: 20, in: "A"..."Z", using: &Xoroshiro.default)
            params.setPublicId(imageName)
            cloudinary.createUploader().upload(data: data, uploadPreset: "snumwks7", params: params, progress: nil, completionHandler: {(response, error) in
                if error == nil {
                    let ownerChallengeImageLink : String = "https://cloudinary.com/console/media_library#dialog/image/upload/\(imageName).jpg"
                    let  challengeDescription : String = self.descriptionText.text!
                    let  challengeName =  challengeDescription
                    let  challengeCreatedDate = "2017-09-10"
                    let  challengeType = "funny"
                    let userId = "59fc0074a85b31a9be4c6cfe"
                    let params: Parameters = [
                            "ownerChallengeImageLink":ownerChallengeImageLink,
                            "challengeDescription":challengeDescription,
                            "challengeType":challengeType,
                            "challengeCreatedDate":challengeCreatedDate,
                            "challengeName":challengeName
                        ]
                    
                    Alamofire.request("http://10.0.0.192:8080/api/users/\(userId)/challenges",method: .post, parameters: params,encoding: JSONEncoding.default) .responseString { response in // 1
                        if (response.result.isSuccess) {
                        } else {
                            print("upload failed!")
                        }
                    }
                } else {
                    print(error)
                }
            })
        }
        //print(urlpath)
        //cloudinary.createUploader().upload(file: fileUrl)
        
        //uploader.upload(forUpload, options: ["public_id":"testo"])
    }
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @IBAction func choosePhoto(_ sender: Any) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        
        let actionSheet = UIAlertController(title: "Photo Source", message: "Choose a source", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: {(action:UIAlertAction) in
            imagePickerController.sourceType = .camera
            self.present(imagePickerController, animated: true, completion: nil)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: {(action:UIAlertAction) in
            imagePickerController.sourceType = .photoLibrary
            self.present(imagePickerController, animated: true, completion: nil)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        
        self.present(actionSheet, animated: true, completion: nil)
        
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        imageView.image = image
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func donePickingImage(_ sender: Any) {
        performSegue(withIdentifier: "segue2", sender: nil)
    }
    
    /*@IBAction func nextClicked(_ sender: Any) {
        //performSegue(withIdentifier: "segue2", sender: nil)
        let config = CLDConfiguration(cloudName: "sem", apiKey: "445234287149499")
        let cloudinary = CLDCloudinary(configuration: config)
        print("started")
        if let filePath = Bundle.main.path(forResource: "card_concert", ofType: "png") {
            print(filePath)
        }
        //cloudinary.createUploader().upload
        
    }*/
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

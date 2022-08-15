//
//  UploadViewController.swift
//  instaclone
//
//  Created by Yigit Ozdamar on 13.08.2022.
//

import UIKit
import FirebaseStorage
import FirebaseFirestore
import FirebaseAuth

class UploadViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var commentText: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Hide Keyboard
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(gestureRecognizer)
        
        //Select Image Click
        imageView.isUserInteractionEnabled = true
        let imageRecognizer = UITapGestureRecognizer(target: self, action: #selector(selectImage))
        imageView.addGestureRecognizer(imageRecognizer)
    }
    
    @objc func hideKeyboard(){
        view.endEditing(true)
    }
    
    //IMAGE İŞLERİ
    @objc func selectImage(){
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
          showPhotoMenu()
        } else {
          choosePhotoFromLibrary()
        }
    }
    
    func choosePhotoFromLibrary() {
      let imagePicker = UIImagePickerController()
      imagePicker.sourceType = .photoLibrary
      imagePicker.delegate = self
      imagePicker.allowsEditing = true
      present(imagePicker, animated: true, completion: nil)
    }
    
    func takePhotoWithCamera() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .camera
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
      }

    func showPhotoMenu() {
      let alert = UIAlertController(
        title: nil,
        message: nil,
        preferredStyle: .actionSheet)

      let actCancel = UIAlertAction(
        title: "Cancel",
        style: .cancel,
        handler: nil)
      alert.addAction(actCancel)

        let actPhoto = UIAlertAction(
          title: "Take Photo",
          style: .default) { _ in
            self.takePhotoWithCamera()
          }
      alert.addAction(actPhoto)

        let actLibrary = UIAlertAction(
          title: "Choose From Library",
          style: .default) { _ in
            self.choosePhotoFromLibrary()
          }

      alert.addAction(actLibrary)
      present(alert, animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true)
    }
    
    //SAVE BUTTON
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let mediaFolder = storageRef.child("media")
        
        if let data = imageView.image?.jpegData(compressionQuality: 0.5){
            let uuid = UUID().uuidString
            let imageReference = mediaFolder.child("\(uuid).jpg")
            imageReference.putData(data, metadata: nil) { metadata, error in
                if error != nil{
                    self.makeAlert(title: "Error", alertMessage: error?.localizedDescription ?? "error!")
                }else{
                    imageReference.downloadURL { url, error in
                        if error == nil{
                            let imageUrl = url?.absoluteString
                            
                            //DATABASE
                            let db = Firestore.firestore()
                            
                            var fireStoreReference : DocumentReference? = nil
                            
                            let fireStorePost = ["imageUrl": imageUrl!, "postedBy": Auth.auth().currentUser!.email!,"postComment":self.commentText.text!,"date":FieldValue.serverTimestamp(),"likes":0 ] as [String : Any]
                            
                            fireStoreReference = db.collection("Posts").addDocument(data: fireStorePost, completion: { error in
                                if error != nil{
                                    self.makeAlert(title: "error", alertMessage: error?.localizedDescription ?? "error")
                                }else{
                                    self.imageView.image = UIImage(named: "select.png")
                                    self.commentText.text = ""
                                    self.tabBarController?.selectedIndex = 0
                                }
                            })
                            
                        }
                    }
                }
            }
            
        }
        
    }
    
    func makeAlert(title:String,alertMessage:String){
        let alert = UIAlertController(title: title, message: alertMessage, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true)
    }
    

}

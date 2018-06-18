//
//  ViewController.swift
//  MemeMe
//
//  Created by Phillip Valdez on 4/12/18.
//  Copyright © 2018 Phillip Valdez. All rights reserved.
//
import UIKit

class MemeEditorVC: UIViewController, UIImagePickerControllerDelegate,
UINavigationControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var imagePicker: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var bottomText: UITextField!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var navBar: UINavigationBar!
    //The meme
    var memedImage: UIImage!
    
    //Meme Text Attributes
    let memeTextAttributes:[String: Any] = [NSAttributedStringKey.strokeColor.rawValue: UIColor.black, NSAttributedStringKey.foregroundColor.rawValue: UIColor.white, NSAttributedStringKey.font.rawValue: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!, NSAttributedStringKey.strokeWidth.rawValue: -6]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        shareButton.isEnabled = false
         //Checking to see if camera is enabled
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        setupTextField(textField: topText, text: "TOP")
        setupTextField(textField: bottomText, text: "BOTTOM")

        //Blank image
        imagePicker.image = UIImage(named: "Blank.png")
        
    }
    
    //over ride functions
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
        
    }
   
    //setting up text field with a UITextField and text for it
    func setupTextField(textField: UITextField, text: String) {
    
        textField.delegate = self
        textField.text = text
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = .center
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController,
                                        didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imagePicker.image = image
            dismiss(animated: true, completion: nil)
        }
    }

    //picking an image from the album
    @IBAction func pickImageAlbum(_ sender: Any) {
        pickImage(sourceType: .photoLibrary)

    }
    
    //picking an image from the camera
    @IBAction func pickImageCamera(_ sender: Any) {
        pickImage(sourceType: .camera)
    }
    
    func pickImage(sourceType: UIImagePickerControllerSourceType ) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = sourceType
        present(imagePicker, animated: true, completion: nil)
        shareButton.isEnabled = true
    }
    
    //function to hide nav bar or tool bar
    func hideBar(hideNav: Bool, hideTool: Bool) {
        navBar.isHidden = hideNav
        toolBar.isHidden = hideTool
        
    }

    //genrating meme image
    func generateMemedImage() -> UIImage {
        // TODO: Hide toolbar and navbar
        hideBar(hideNav: true, hideTool: true)
    
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        // TODO: Show toolbar and navbar
        hideBar(hideNav: false, hideTool: false)
        
        return memedImage
    }
    
    //saving meme
    func save(memedImage: UIImage) {
        // Create the meme
        let meme = Meme(topText: topText.text!, bottomText: bottomText.text!, originalImage: imagePicker.image!, memedImage: memedImage)
        
        // Add it to the memes array in the Application Delegate
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
    }
    
    
    //sharing meme:
    @IBAction func shareMeme(_ sender: Any) {
        //generate a memed image
        let theMeme = generateMemedImage()
        
        //define an instance of the ActivityViewController
        //pass the ActivityViewController a memedImage as an activity item
        let viewController = UIActivityViewController(activityItems: [theMeme], applicationActivities: [])
        
        //present the ActivityViewController
        present(viewController, animated: true, completion: nil)
        viewController.completionWithItemsHandler = { (activity, success, items, error) in
            if (success) {
                self.save(memedImage: theMeme)
                self.dismiss(animated: true, completion: nil)

            }
        }
    }
    
    //When a user presses cancel, it resends them to the sent meme's page
    @IBAction func cancelMeme(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
    }
    
    //when the user presses return on the keyboard, it returns to the picture with the text
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
    
    //setting a blank string when a user clicks on the text filed
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
        
    }
    
    //Hiding and showing keyboard with subscribeToKeyboard
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification:Notification) {
        if bottomText.isFirstResponder == true {
            view.frame.origin.y = -getKeyboardHeight(notification)
        }
    }
    
    @objc func keyboardWillHide(_ notification:Notification) {
        if bottomText.isFirstResponder == true {
            view.frame.origin.y = 0
        }
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }

}


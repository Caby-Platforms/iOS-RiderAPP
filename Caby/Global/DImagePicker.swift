//
//  DImagePicker.swift
//  ImagePickerDemo
//
//  Created by  on 8/10/17.
//  Copyright © 2017    . All rights reserved.
//

import UIKit

// Return Image Protocol
@objc protocol DImageViewReturnDelegate
{
    func imagePickUpFinish(image: UIImage,imageView:DSquareImageView)
}

class DSquareImageView: UIImageView , UIImagePickerControllerDelegate , UINavigationControllerDelegate {
    
    var imagePicker = UIImagePickerController()
    var delegate : DImageViewReturnDelegate?
    
    var isEditMode : Bool = true
    
    //MARK:- ImageView Configure Method
    
    override func awakeFromNib()
    {
        if isEditMode
        {
            self.isUserInteractionEnabled = true
        }
        else
        {
            self.isUserInteractionEnabled = false
        }
        self.contentMode = .scaleAspectFill
        self.clipsToBounds = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.imgTapHandle(_:)))
        self.addGestureRecognizer(gesture)
        imagePicker.delegate = self
    }
    
    //----------------------------------------------------------------------------------------------------------------
    
    //MARK:- ImagePickerController Delegate Method
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        imagePicker.dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.editedImage]! as? UIImage{
            self.image = image
            
            // if need a return image delegate call
            if delegate != nil
            {
                delegate?.imagePickUpFinish(image: image, imageView: self)
            }
            
        } else{
            print("Error")
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    //----------------------------------------------------------------------------------------------------------------
    
    
    //MARK:- ImageView TapGesture Handle Method
    
    @objc func imgTapHandle(_ sender: UITapGestureRecognizer)
    {
        if let vc = UIApplication.shared.keyWindow?.rootViewController
        {
            imgPickerOpen(this: vc, imagePicker: imagePicker, sourceControl: self)
        }
        
        
    }
    @IBAction func imagePick(_ sender: Any)
    {
        if let vc = UIApplication.shared.keyWindow?.rootViewController
        {
            imgPickerOpen(this: vc, imagePicker: imagePicker, sourceControl: self)
        }
    }
    
    //----------------------------------------------------------------------------------------------------------------
    
    
    //MARK:- ActionSheet Method
    
    func imgPickerOpen(this: UIViewController,imagePicker: UIImagePickerController, sourceControl:
        UIView)
    {
        
        this.view.endEditing(true)
        
        imagePicker.allowsEditing = true
        
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (UIAlertAction) in
            
//            if TARGET_OS_SIMULATOR == 1
//            {
//                if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
//                    imagePicker.sourceType = .photoLibrary
//                    OperationQueue.main.addOperation({() -> Void in
//
//                        this.present(imagePicker, animated: true, completion: nil)
//                    })
//                }
//
//                return
//            }
            
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                imagePicker.sourceType = .camera
                OperationQueue.main.addOperation({() -> Void in
                    
                    this.present(imagePicker, animated: true, completion: nil)
                })
                
            }
            else {
                GFunction.shared.showSnackBar(kNoCamera)
            }
            
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { (UIAlertAction) in
            
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                imagePicker.sourceType = .photoLibrary
                OperationQueue.main.addOperation({() -> Void in
                    
                    this.present(imagePicker, animated: true, completion: nil)
                })
            }
            else {
                GFunction.shared.showSnackBar(kNoGallery)
            }
        }))
        
        actionSheet.addAction(UIAlertAction(title: "CANCEL", style: .cancel, handler: { (UIAlertAction) in
            
        }))
        
        
        if ( UIDevice.current.userInterfaceIdiom == .pad )
        {
            actionSheet.popoverPresentationController?.sourceView = sourceControl
            actionSheet.popoverPresentationController?.sourceRect = sourceControl.bounds
        }
        
        this.present(actionSheet, animated: true, completion: nil)
        
    }
    
    
    //----------------------------------------------------------------------------------------------------------------
    
    
    
    
    
    
}

//
//  ParentVC.swift
//  Alsoooq
//
//  Created by Ayushi on 5/11/17.
//  Copyright © 2017 hyperlink. All rights reserved.
//

import UIKit
import Foundation

class ParentVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate {

    //------------------------------------------------------
    //MARK:- Outlet

    //------------------------------------------------------
    //MARK:- Class variable
    var MyImagePickerController             : UIImagePickerController?
    var iv                                  : UIImageView?
    
    
    
    //------------------------------------------------------
    //MARK:- WS Methods

    //------------------------------------------------------
    //MARK:- Memory Management Method
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    //------------------------------------------------------
    //MARK:- Custom Methods
    
    func addImagePicker(_ iv : UIImageView) {
        self.iv                     = UIImageView()
        self.iv                     = iv
        let tapGestureRecognizer    = UITapGestureRecognizer(target: self, action: #selector(tapOnImage(_:)))
        iv.isUserInteractionEnabled = true
        iv.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func tapOnImage( _ sender : AnyObject) {
        
        MyImagePickerController                     = UIImagePickerController()
        MyImagePickerController!.delegate           = self
        MyImagePickerController!.allowsEditing      = true
        
        let imageActionSheet: UIAlertController = UIAlertController(title: "Choose option", message: nil , preferredStyle:.actionSheet)
        
        let cancelActionButton: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel)
        { action -> Void in
        }
        imageActionSheet.addAction(cancelActionButton)
        
        let cameraActionButton: UIAlertAction = UIAlertAction(title: "Camera", style: .default)
        { action -> Void in
            self.OptionCamera()
        }
        imageActionSheet.addAction(cameraActionButton)
        
        let galleryActionButton: UIAlertAction = UIAlertAction(title: "Gallery", style: .default)
        { action -> Void in
            self.OptionGallary()
        }
        
        imageActionSheet.view.tintColor = UIColor.ColorLightBlue
        
        imageActionSheet.addAction(galleryActionButton)
        
        if GFunction.shared.isiPad()
        {
            imageActionSheet.popoverPresentationController?.sourceView = sender.view
            imageActionSheet.popoverPresentationController?.sourceRect = sender.bounds
        }
        
        present(imageActionSheet, animated: true, completion: nil)
    }
    
    func OptionCamera()
    {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera)
        {
            MyImagePickerController!.sourceType = TARGET_OS_SIMULATOR == 1 ? .photoLibrary : .camera
            self.present(MyImagePickerController!, animated: true, completion: nil)
        }
    }
    
    func OptionGallary()
    {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary)
        {
            self.MyImagePickerController!.sourceType = .photoLibrary
            self.present(self.MyImagePickerController!, animated: true, completion: nil)
        }
    }
    
   //------------------------------------------------------
    
    //MARK:- Action Methods
    
    //------------------------------------------------------
    
    //MARK: -  UIImagePickerController Delegate Method -
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let MyPickedPorfileImage    = info[.editedImage] as? UIImage
        self.iv!.image              = MyPickedPorfileImage
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    //------------------------------------------------------
    
    //MARK:- UI View Life Cycle Method
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

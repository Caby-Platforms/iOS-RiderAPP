//
//  ImageUpload.swift
//  YOLO
//
//  Created by hyperlink on 16/01/18.
//  Copyright © 2018 Hyperlink. All rights reserved.
//

import UIKit
import AWSS3

enum ImageType : String {
    case UserProfile
    case UserBgProfile
    case UserDoc
    case UserPerson
}
class ImageUpload: NSObject {
    
    static let shared : ImageUpload = ImageUpload()
    
    func uploadImage(_ showLoader : Bool = true,_ image : UIImage , _ mimeType : String, _ imageType : ImageType, withBlock completion :((String? , String?) -> Void)?) {
        if showLoader {
            GFunction.shared.addLoader("")
        }
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        //S3 bucket setup
        
        let credentialsProvider : AWSStaticCredentialsProvider = AWSStaticCredentialsProvider(accessKey: kAWSBucketAccessKeyID, secretKey: kAWSBucketSecretKey)
        let configuration : AWSServiceConfiguration = AWSServiceConfiguration(region: AWSRegionType.EUWest1, credentialsProvider: credentialsProvider)
        AWSServiceManager.default().defaultServiceConfiguration = configuration
        
        var bodyURL : URL?
        if let url : URL = self.storeDataInDirectory(image) {
            bodyURL = url
        }
        else {
            return
        }
        
        let transferManager : AWSS3TransferManager = AWSS3TransferManager.default()
        let uploadRequest : AWSS3TransferManagerUploadRequest = AWSS3TransferManagerUploadRequest()
        uploadRequest.bucket = kAWSBucket
        
        switch imageType {
        case ImageType.UserProfile:
            uploadRequest.key = kAWSUserPath
            break
        case ImageType.UserBgProfile:
            uploadRequest.key = kAWSUserBgPath
            break
        case .UserDoc:
            uploadRequest.key = kAWSUserDoc
            break
        case .UserPerson:
            uploadRequest.key = kAWSUserPerson
            break
        }
        
        
        uploadRequest.key = uploadRequest.key! + bodyURL!.lastPathComponent
        
        uploadRequest.body          = bodyURL!
        uploadRequest.contentType   = mimeType
        uploadRequest.acl           = .publicRead
        
        transferManager.upload(uploadRequest).continueWith { (task : AWSTask) -> Any? in
            if showLoader {
                DispatchQueue.main.async {
                    GFunction.shared.removeLoader()
                    //UIApplication.shared.isNetworkActivityIndicatorVisible = false
                }
            }
            
            if task.error == nil {
                debugPrint("Complete task")
                print("Image has been Uploaded on bucket")
                debugPrint(task.result ?? "")
                completion!(kAWSBucketPath + kAWSBucket + "/" + uploadRequest.key! , bodyURL!.lastPathComponent)
            }
            else {
                
                debugPrint(task.result)
                debugPrint(task.error?.localizedDescription)
                
                debugPrint("//--------------------------------------------------------------------//")
                debugPrint(task.error!.localizedDescription)
                debugPrint("//--------------------------------------------------------------------//")
                completion!(nil,nil)
            }
            return nil
        }
        
    }
    //    1111  1111
    func storeDataInDirectory(_ data : UIImage) -> URL? {
        
        let imgData : Data = data.jpegData(compressionQuality: 0.7)!//UIImageJPEGRepresentation(data, 0.7)!
        
        // *** Get documents directory path *** //
        let paths1 = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory1 = paths1[0] as String
        
        // *** Append video file name *** //
        let datapathT = documentsDirectory1.appending("/\(self.getRandomString()).jpeg")
        
        let tempURl : URL = URL(fileURLWithPath: datapathT)
        
        //        let urlT = tempURl.absoluteURL
        
        let urlT = tempURl
        // *** Remove video file data to path *** //
        let fileManager = FileManager.default
        
        do {
            try fileManager.removeItem(at: urlT)
        }
        catch {
            
            print("No Duplicate video")
        }
        
        // *** Write image file data to path *** //
        var strPathForFile = ""
        do {
            try imgData.write(to: urlT)
            return urlT
            
        } catch  {
            print("some error in preview image: ")
            return nil
        }
    }
    
    func getSizeOfData(data : Data) -> String {
        let byteCount = data.count//512_000 // replace with data.count
        let bcf = ByteCountFormatter()
        bcf.allowedUnits = [.useMB] // optional: restricts the units to MB only
        bcf.countStyle = .file
        let string = bcf.string(fromByteCount: Int64(byteCount))
        print(string)
        if byteCount == 0 {
            return "0"
        }
        return string
    }
    
    func getTimeStampFromDate() -> (double : Double,string : String) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date1 : String = dateFormatter.string(from: Date())
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date2 : Date = dateFormatter1.date(from: date1)!
        let timeStamp = date2.timeIntervalSince1970
        
        return (timeStamp,String(format: "%f", timeStamp))
    }
    
    //------------------------------------------------------
    
    func getRandomString() -> String {
        let timeStamp = self.getTimeStampFromDate()
        return "\(String(format: "%0.0f", timeStamp.double))"
        
    } 
}

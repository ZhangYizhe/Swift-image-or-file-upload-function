//
//  ViewController.swift
//  yizheImageUpload
//
//  Created by 张艺哲 on 2017/9/8.
//  Copyright © 2017年 张艺哲. All rights reserved.
//

import UIKit
import SwiftyTimer

class ViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBAction func imageBtnTap(_ sender: UIButton) {
        
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else//判断是否有权限
        {
            print("相册不可用")
            return
        }
        
        
        
        let picker = UIImagePickerController()
        picker.allowsEditing = false
        
        picker.sourceType = .photoLibrary
        picker.delegate = self//将相册代理设置为本身
        
        self.present(picker, animated: true, completion: nil)
        
        
    }
    
    //进度条
    @IBOutlet weak var progressView: UIProgressView!
    
    
    
    @IBOutlet weak var smallimage: UIImageView!
    //相册选择后返回数据
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        //      imageView.image = info[UIImagePickerControllerEditedImage] as? UIImage
        
        
        imageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        //        print(info[UIImagePickerControllerEditedImage])
        
        dismiss(animated: true, completion: nil)
        
        var test : String = ""
        
        if let imageData = UIImageJPEGRepresentation(imageView.image!, 0.7){
            
            test = imageData.base64EncodedString()
            let data = NSData(base64Encoded: test, options: NSData.Base64DecodingOptions.ignoreUnknownCharacters)
            smallimage.image = UIImage(data: data! as Data)
            
            
            FileUpload(File: imageData,FileName: "test.jpeg")
            
            
            
            
            
            
            
            
            //print(data)
        }
        
        //        let str =  NSString(data: imageData!, encoding: String.Encoding.utf8.rawValue)
        //
        //        print(String(describing: str))
        
    }
    
    
    
    
    
    
    
    func FileUpload(File: Data,FileName: String) {
        
        print("文件大小为：\(Double(File.count)/1000000.0) MB")
        
        
        var uploadTask : URLSessionUploadTask!
        //进度
        let timer = Timer.new(every: 0.01.second) {
            
            let x:CGFloat = (CGFloat)(uploadTask.countOfBytesSent)
            let y:CGFloat = (CGFloat)(uploadTask.countOfBytesExpectedToSend)
            
            self.progressView.progress = Float(x/y)
        }
        
        
        
        
        //上传地址
        let url = URL(string: "https://Url/upload.php?fileName=\(FileName)")
        //请求
        var request = URLRequest(url: url!, cachePolicy: .reloadIgnoringCacheData)
        request.httpMethod = "POST"
        
        let session = URLSession.shared
        
        
        uploadTask = session.uploadTask(with: request, from: File) {
            (data:Data?, response:URLResponse?, error:Error?) -> Void in
            //上传完毕后
            if error != nil{
                print(error!)
            }else{
                
                let str = String(data: data!, encoding: String.Encoding.utf8)
                print("上传完毕：\(str!)")
                timer.invalidate()
                
            }
        }
        
        //使用resume方法启动任务
        uploadTask.resume()
        
        timer.start()
        
        
    }


}


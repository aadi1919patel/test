//
//  WebServices.swift
//  APIStructure
//
//  Created by Adi Patel on 28/02/21.
//

import UIKit
import Alamofire
import SwiftyJSON
import SVProgressHUD

enum HttpResponseStatusCode : Int {
    case ok = 200
    case badRequest = 400
    case noAuthorization = 401
}

let reachability = Reachability()!

class WebServices: NSObject {

    var operationQueue = OperationQueue()
    
    func CallGlobalAPIForm(url:String, headers:NSDictionary, parameters:String, httpMethod:String, progressView:Bool, uiView:UIView, networkAlert:Bool, responseDict:@escaping (_ jsonResponce:Any?, _ strErrorMessage:String) -> Void) {
        
        print("URL: \(url)")
        print("Headers: \n\(headers)")
        print("Parameters: \n\(parameters)")
        
        if progressView == true {
            self.ProgressViewShow(uiView:uiView)
        }
        let operation = BlockOperation.init {
            DispatchQueue.global(qos: .background).async {
                if self.internetChecker(reachability: Reachability()!) {
                    if (httpMethod == "POST") {
                        var req = URLRequest(url: try! url.asURL())
                        req.httpMethod = "POST"
                        req.allHTTPHeaderFields = headers as? [String:String]
                        req.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "content-type")
                        req.httpBody = parameters.data(using: .utf8)
                        req.timeoutInterval = 30
                        AF.request(req).responseJSON { response in
                            switch (response.result)
                            {
                            case .success:
                                if((response.value) != nil) {
                                    let jsonResponce = response.data
                                        //JSON(response.value!)
                                    //print("Responce: \n\(jsonResponce)")
                                 //   print("Responce: \n\(JSON(response.value!))")
                                    DispatchQueue.main.async {
                                        self.ProgressViewHide(uiView: uiView)
                                        responseDict(jsonResponce,"")
                                    }
                                }
                                break
                            case .failure(let error):
                                let message : String
                                if let httpStatusCode = response.response?.statusCode {
                                    switch(httpStatusCode) {
                                    case 400:
                                        self.ProgressViewHide(uiView: uiView)
                                        message = "Something Went Wrong..Try Again"
                                    case 401:
                                        self.ProgressViewHide(uiView: uiView)
                                        message = "Something Went Wrong..Try Again"
                                        DispatchQueue.main.async {
                                            self.ProgressViewHide(uiView: uiView)
                                            responseDict([:],message)
                                        }
                                    default:
                                        
                                        if let data = response.data, let utf8Text = String(data: data, encoding: .utf8)
                                        {
                                            print("error utf8 : ",utf8Text)
                                        }
                                        
                                        print("error",error.localizedDescription)
                                        
                                        self.ProgressViewHide(uiView: uiView)
                                        
                                        break
                                    }
                                } else {
                                    message = error.localizedDescription
                                   // let jsonError = JSON(response.error!)
                                    DispatchQueue.main.async {
                                        self.ProgressViewHide(uiView: uiView)
                                        //responseDict(jsonError,"")
                                        responseDict([:],message)
                                    }
                                }
                                break
                            }
                        }
                    }
                    else if (httpMethod == "GET") {
                        var req = URLRequest(url: try! url.asURL())
                        req.httpMethod = "GET"
                        req.allHTTPHeaderFields = headers as? [String:String]
                        req.setValue("application/json", forHTTPHeaderField: "content-type")
                        req.timeoutInterval = 30
                        AF.request(req).responseJSON { response in
                            switch (response.result)
                            {
                            case .success:
                                if((response.value) != nil) {
                                   // let jsonResponce = response.data
                                    let jsonResponce = response.data
                                   // let jsonResponce = JSON(response.value!)
                                    DispatchQueue.main.async {
                                        self.ProgressViewHide(uiView: uiView)
                                        responseDict(jsonResponce,"")
                                    }
                                }
                                break
                            case .failure(let error):
                                let message : String
                                if let httpStatusCode = response.response?.statusCode {
                                    switch(httpStatusCode) {
                                    case 400:
                                        message = "Something Went Wrong..Try Again"
                                    case 401:
                                        message = "Something Went Wrong..Try Again"
                                        DispatchQueue.main.async {
                                            self.ProgressViewHide(uiView: uiView)
                                            responseDict([:],message)
                                        }
                                    default: break
                                    }
                                } else {
                                    message = error.localizedDescription
                                    let jsonError = JSON(response.error!)
                                    DispatchQueue.main.async {
                                        self.ProgressViewHide(uiView: uiView)
                                        responseDict(jsonError,"")
                                    }
                                }
                                break
                            }
                        }
                    }
                }
                else {
                    self.ProgressViewHide(uiView: uiView)
                    if networkAlert == true {
                        DispatchQueue.main.async {
                           // Utils.showNYAlertViewWithTitle(title: "Error!", detail: Constant.noInternet)
                        }
                    }
                }
            }
        }
        operation.queuePriority = .normal
        operationQueue.addOperation(operation)
    }
    
    func randomString(length: Int) -> String {
        
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)
        var randomString = ""
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        return randomString
    }
    
    func internetChecker(reachability: Reachability) -> Bool {
        var check:Bool = false
        if reachability.connection == .wifi {
            check = true
        }
        else if reachability.connection == .cellular {
            check = true
        }
        else {
            check = false
        }
        return check
    }
    
    func ProgressViewShow(uiView:UIView) {
        DispatchQueue.main.async {
           // SVProgressHUD.show()
            SVProgressHUD.show()
        }
    }
    
    func ProgressViewHide(uiView:UIView) {
        DispatchQueue.main.async {
           // SVProgressHUD.dismiss()
            SVProgressHUD.dismiss()
        }
    }
}

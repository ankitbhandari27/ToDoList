//
//  JsonParser.swift
//  TODOLIST
//
//  Created by Ankit Bhandari on 11/02/20.
//  Copyright © 2020 Ankit Bhandari. All rights reserved.
//

import Foundation
import UIKit
import SystemConfiguration
//import Security

class Response: NSObject {
    
    var isSuccess:Bool = false
    var data:Data?
    var dictData:Any?
    var arrData:[AnyObject] = []
    var strMessage:String?
    
}

class JSONParser : NSObject, URLSessionDelegate {
    
    static let share : JSONParser = JSONParser()
    
    
    // MARK:- Create responce object
    fileprivate func genrateResponceModel(_ jsonResult: Any?,_ data:Data?,_ message:String,_ completionHandler: @escaping (_ response: Response) -> Void) {
        let responce = Response()
        responce.isSuccess = true
        responce.strMessage = "No data found"
        responce.data = data
        responce.dictData = jsonResult
        completionHandler(responce)
    }
    
    // MARK:- Call Api
    
    func parseWithURL(_ endPointUrl : String, requestPrm: [String : Any], completionHandler: @escaping (_ response: Response) -> Void){
        
        if isConnectedToNetwork() {
            
            let config = URLSessionConfiguration.default
            let session = URLSession(configuration: config)
            let url = baseUrl + endPointUrl
            let task = session.dataTask(with: URL(string: url)!) { data, response, error in
                
                if let data = data {
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: [])
                        print(json)
                        self.genrateResponceModel(json,data,"Data Found",completionHandler)
                    } catch {
                        print(error)
                        self.genrateResponceModel(nil,nil,"No data found",completionHandler)
                    }
                } else {
                    
                    self.genrateResponceModel(nil,nil,"No data found",completionHandler)
                }
                
            }
            
            task.resume()
            
        }  else {
            self.genrateResponceModel(nil,nil,"Internet connection error",completionHandler)
        }
    }
    
    // MARK:- Check NetWork Function
    func isConnectedToNetwork() -> Bool {
        
        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
        if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
            return false
        }
        
        // Working for Cellular and WIFI
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        let ret = (isReachable && !needsConnection)
        
        return ret
        
    }
    
}

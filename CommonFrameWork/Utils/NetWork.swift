//
//  NetWork.swift
//  CommonFrameWork
//
//  Created by sayi on 2018/05/21.
//  Copyright © 2018年 sayi. All rights reserved.
//

import Foundation
import Alamofire
class Connectivity {
    class var isConnectedToInternet:Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}

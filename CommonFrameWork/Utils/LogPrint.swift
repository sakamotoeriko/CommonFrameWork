//
//  LogPrint.swift
//  CommonFrameWork
//
//  Created by sayi on 2018/05/20.
//  Copyright © 2018年 sayi. All rights reserved.
//

import Foundation

class LogPrint{
    func whLog<T>(_ message : T, file : String = #file, funcName : String = #function, lineNum : Int = #line) {
        #if DEBUG
        let fileName = (file as NSString).lastPathComponent
        print("\n>>> \(Date())  \(fileName) (line: \(lineNum)): \(message)\n")
        #endif
    }
}

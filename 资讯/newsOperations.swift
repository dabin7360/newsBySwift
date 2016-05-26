//
//  newsOperations.swift
//  资讯
//
//  Created by jdcsh-fe on 16/5/18.
//  Copyright © 2016年 dabin. All rights reserved.
//

import Foundation

class newsOperations{
    //追踪进行中和等待中的下载操作
    lazy var downloadsInProgress = [NSIndexPath : NSOperation]()
    //图片下载列队
    lazy var downloadQueue:NSOperationQueue = {
        var queue = NSOperationQueue()
        queue.name = "Download queue"
        queue.maxConcurrentOperationCount = 1
        return queue
    }()
}
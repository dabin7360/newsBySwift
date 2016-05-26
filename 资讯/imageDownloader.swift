//
//  imageDownloader.swift
//  资讯
//
//  Created by jdcsh-fe on 16/5/18.
//  Copyright © 2016年 dabin. All rights reserved.
//

import UIKit

//图片下载操作任务
class ImageDownloader : NSOperation{
    //新闻条目对象
    let newssRecord : newsRecord
    init(newssRecord : newsRecord){
        self.newssRecord = newssRecord
    }
    
    override func main() {
        if self.cancelled{
            return
        }
        //下载图片
        let imageData = NSData(contentsOfURL: self.newssRecord.url)
        
        if self.cancelled{
            return
        }
        
        if imageData?.length > 0 {
            self.newssRecord.image = UIImage(data: imageData!)
            self.newssRecord.state = .Downloaded
        }else{
            self.newssRecord.state = .Failed
            self.newssRecord.image = UIImage(named: "c")
        }
        
    }
    
    
    
    
    
}

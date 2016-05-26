//
//  newsRecord.swift
//  资讯
//
//  Created by jdcsh-fe on 16/5/18.
//  Copyright © 2016年 dabin. All rights reserved.
//

import UIKit

//所有图片的状态
enum NewsRecordState {
    case New, Downloaded, Failed
}

//新闻条目类
class newsRecord {
    let name:String
    let url:NSURL
    let id:String
    let date:String
    var state = NewsRecordState.New
    //默认初始化图片
    var image = UIImage(named: "logo")
    
    init(name:String,url:NSURL,id:String,date:String){
        self.name = name
        self.url = url
        self.id = id
        self.date = date
    }
    
}



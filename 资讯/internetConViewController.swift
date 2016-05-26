//
//  internetConViewController.swift
//  资讯
//
//  Created by jdcsh-fe on 16/5/16.
//  Copyright © 2016年 dabin. All rights reserved.
//

import UIKit
import Foundation
class internetConViewController: UIViewController{
    
    var newsTitleData : String = ""
    var newsId:String = ""
    //var contData : NSString = ""
    var newsContData : String = "S"
    
    @IBOutlet weak var newsCont: UIWebView!
    @IBOutlet weak var loadingAni: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadingAni.startAnimating()
        //self.view.frame = CGRectMake(0, 0 , self.view.frame.size.width, self.view.frame.size.height);
        
        //contData = NSString(data: newsContData, encoding:NSISOLatin1StringEncoding)!
        self.requestUrl("http://www.tngou.net/api/top/show?id="+newsId)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //将请求到的数据转为json
    func nsdataToJSON(data: NSData) -> AnyObject? {
        do {
            return try NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers)
        } catch let myJSONError {
            print(myJSONError)
        }
        return nil
    }
    
    //异步请求数据
    func requestUrl(urlString:String){
        let url : NSURL = NSURL(string: urlString)!
        let request : NSURLRequest = NSURLRequest(URL : url)
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler:{ (response,data,error) -> Void in
            if ((error) != nil) {
                print("没有请求到数据")
            }else{
                let myjson = self.nsdataToJSON(data!)!
                let addImgCss:String = "<style>img{max-width:100%;};</style>"
                let titleHtml:String = "<h2>"+self.newsTitleData+"</h2>"
                let pubdateHtml:String = "<span>"+self.timeStampToString(myjson["time"]!!.description)+" </span>"
                let newsFromHtml:String = "<span> "+(myjson["fromname"] as! String)+"</span>"
                let newsContHtml = addImgCss + titleHtml + pubdateHtml + newsFromHtml + (myjson["message"] as! String)
                self.newsContData = newsContHtml
                //print(self.newsContData)
                self.newsCont.loadHTMLString(self.newsContData, baseURL: nil)
            }
            self.loadingAni.stopAnimating()
        })
        
    }
    
    //将时间戳转为日期
    func timeStampToString(timeStamp:String)->String {
        let string = NSString(string: timeStamp)
        let timeSta:NSTimeInterval = string.doubleValue/1000
        let dfmatter = NSDateFormatter()
        dfmatter.dateFormat="MM-dd HH:mm"
        let date = NSDate(timeIntervalSince1970: timeSta)
        //print(dfmatter.stringFromDate(date))
        return dfmatter.stringFromDate(date)
    }

    
    



}
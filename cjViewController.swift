//
//  cjViewController.swift
//  资讯
//
//  Created by jdcsh-fe on 16/6/2.
//  Copyright © 2016年 dabin. All rights reserved.
//

import UIKit
import Foundation

class cjViewController: UIViewController, UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate {
    
    var url = "http://www.tngou.net/api/top/list?id=3&rows=15"
    var newsArr = [newsRecord]()
    let newssOperations = newsOperations()
    var refreshControl = UIRefreshControl()
    var page = 1
    
    @IBOutlet weak var cjTable: UITableView!
    @IBOutlet weak var loadingListAni: UIActivityIndicatorView!
    @IBOutlet weak var tableFooterView: UIView!
    @IBOutlet weak var loadingAni: UIActivityIndicatorView!
    
    @IBAction func loadMoreBrn(sender: AnyObject) {
        self.loadingAni.startAnimating()
        self.page++
        let curUrl = self.url + "&page=" + String(self.page)
        requestMoreData(curUrl)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = true
        self.newsArr = []
        self.loadingListAni.startAnimating()
        requestUrl(url)
        // Do any additional setup after loading the view, typically from a nib.
        refreshControl.addTarget(self, action: "refreshData", forControlEvents: UIControlEvents.ValueChanged)
        refreshControl.attributedTitle = NSAttributedString(string: "大宾正在帮您加载，不客气")
        cjTable.addSubview(refreshControl)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func refreshData(){
        requestUrl(url)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return newsArr.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("celldeid3")
        
        let tin = newsArr[indexPath.row]
        let newsTile = tin.name
        var newsImg = tin.image
        
        //let newsImgUrl = tin.url
        cell!.textLabel!.text = newsTile
        cell!.detailTextLabel?.text = tin.date
        //cell?.detailTextLabel.
        //cell?.detailTextLabel?.text = "sdgdsfdf"
        
        let sizeChange = CGSize(width: 88,height: 70)
        UIGraphicsBeginImageContextWithOptions(sizeChange, false, 0.0)
        
        // 修改图片长和宽
        newsImg?.drawInRect(CGRect(origin: CGPointZero, size: sizeChange))
        
        // 生成新图片
        newsImg = UIGraphicsGetImageFromCurrentImageContext()
        
        // 关闭图片编辑模式
        UIGraphicsEndImageContext()
        
        //let img = UIImage(data: nsd!);
        //let vImg = UIImageView(image: img);
        //cell!.imageView?.addSubview(vImg)
        
        cell?.imageView?.image = newsImg
        switch (tin.state){
        case .Failed:
            //indicator.stopAnimating()
            cell?.textLabel?.text = "Failed to load"
        case .New:
            //indicator.startAnimating()
            startDownloadForRecord(tin, indexPath: indexPath)
        default:
            print("")
        }
        
        return cell!
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toCjCon"{
            let toContView = segue.destinationViewController as! internetConViewController
            toContView.newsTitleData = (sender?.textLabel!!.text)!
            
            let curIndex = self.cjTable.indexPathForCell(sender as! UITableViewCell)!
            let curId = newsArr[curIndex.row].id
            
            //print(curIndex)
            toContView.newsId = curId
            
            //curContArr.description
        }
    }
    
    func nsdataToJSON(data: NSData) -> AnyObject? {
        do {
            return try NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers)
        } catch let myJSONError {
            print(myJSONError)
        }
        return nil
    }
    
    
    func requestUrl(urlString:String){
        let url = NSURL(string: urlString)!
        //let request : NSURLRequest = NSURLRequest(URL : url)
        let request : NSURLRequest = NSURLRequest(URL : url,cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringCacheData, timeoutInterval: 10)
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler:{ (response,data,error) -> Void in
            if ((error) != nil) {
                print("没有请求到数据")
            }else{
                let myjson = self.nsdataToJSON(data!)!
                let dataArr = myjson.valueForKey("tngou")! as! NSArray
                self.newsArr = []
                for v in dataArr{
                    let newsName = v.valueForKey("title") as! String
                    let newsImgUrl = NSURL(string: "http://tnfs.tngou.net/image" + (v.valueForKey("img") as! String))!
                    let newsId = v.valueForKey("id")!.description
                    let newsDate = self.timeStampToString(v.valueForKey("time")!.description)
                    let newssRecord = newsRecord(name: newsName, url: newsImgUrl,id: newsId,date: newsDate)
                    self.newsArr.append(newssRecord)
                }
                //print(self.newsArr[0].name)
                self.cjTable.reloadData()
                self.tableFooterView.hidden = false;
                self.loadingListAni.stopAnimating()
                self.refreshControl.endRefreshing()
                
            }
            
        })
    }
    
    func requestMoreData(urlString:String){
        let url = NSURL(string: urlString)!
        let request : NSURLRequest = NSURLRequest(URL : url,cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringCacheData, timeoutInterval: 10)
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler:{ (response,data,error) -> Void in
            if ((error) != nil) {
                print("没有请求到数据")
            }else{
                let myjson = self.nsdataToJSON(data!)!
                let dataArr = myjson.valueForKey("tngou")! as! NSArray
                
                for v in dataArr{
                    let newsName = v.valueForKey("title") as! String
                    let newsImgUrl = NSURL(string: "http://tnfs.tngou.net/image" + (v.valueForKey("img") as! String))!
                    let newsId = v.valueForKey("id")!.description
                    let newsDate = self.timeStampToString(v.valueForKey("time")!.description)
                    let newssRecord = newsRecord(name: newsName, url: newsImgUrl,id: newsId,date: newsDate)
                    self.newsArr.append(newssRecord)
                    
                }
            }
            self.cjTable.reloadData()
            self.loadingAni.stopAnimating()
        })
        
    }
    
    
    //执行下载任务
    func startDownloadForRecord(newssRecord: newsRecord, indexPath: NSIndexPath){
        if let _=newssOperations.downloadsInProgress[indexPath]{
            return
        }
        
        //创建一个下载任务
        let downloader = ImageDownloader(newssRecord: newssRecord)
        
        //任务完成后重新加载对应的单元格
        downloader.completionBlock = {
            if downloader.cancelled{
                return
            }
            dispatch_async(dispatch_get_main_queue(), {
                self.newssOperations.downloadsInProgress.removeValueForKey(indexPath)
                self.cjTable.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            })
        }
        //记录当前下载的任务
        newssOperations.downloadsInProgress[indexPath] = downloader
        //将任务添加到列队中
        newssOperations.downloadQueue.addOperation(downloader)
        
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


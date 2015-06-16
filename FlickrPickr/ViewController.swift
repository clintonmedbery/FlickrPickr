//
//  ViewController.swift
//  FlickrPickr
//
//  Created by Clinton Medbery on 6/14/15.
//  Copyright (c) 2015 Programadores Sans Frontieres. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var searchTextField: UITextField!
    
    let FLICKR_API_KEY:String = "your_api_key_here"
    let FLICKR_URL:String = "https://api.flickr.com/services/rest/"
    let SEARCH_METHOD:String = "flickr.photos.search"
    let FORMAT_TYPE:String = "json"
    let JSON_CALLBACK:Int = 1
    let PRIVACY_FILTER:Int = 1
    
    var imageString:String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchTextField.delegate = self
    
    }
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }

    @IBAction func searchClick(sender: AnyObject) {
        displayImage()
    }
    
    func displayImage(){
        
        let random = Int(arc4random_uniform(UInt32(100))) as Int
        println("RANDOM:")
        println(random)
        
        Alamofire.request(.GET, FLICKR_URL, parameters: ["method": SEARCH_METHOD, "api_key": FLICKR_API_KEY, "tags":searchTextField.text,"privacy_filter":PRIVACY_FILTER, "format":FORMAT_TYPE, "nojsoncallback": JSON_CALLBACK])
            .responseJSON { (request, response, data, error) in
                println(request)
                
                if(data != nil){
                    
                    var json:JSON = JSON(data!)
                    var innerJson:JSON = JSON(data!)
                    
                    var farm:String = innerJson["photos"]["photo"][random]["farm"].stringValue
                    var server:String = innerJson["photos"]["photo"][random]["server"].stringValue
                    var photoID:String = innerJson["photos"]["photo"][random]["id"].stringValue
                    
                    var secret:String = innerJson["photos"]["photo"][random]["secret"].stringValue
                    
                    var imageString:String = "http://farm\(farm).staticflickr.com/\(server)/\(photoID)_\(secret)_n.jpg/"
                    println(imageString)
                    self.urlToImageView(imageString)
                    
                    
                }
        }

    }
    
    func urlToImageView(imageString: String){
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            dispatch_async(dispatch_get_main_queue(), {
                let url = NSURL(string: imageString)
                let imageData = NSData(contentsOfURL: url!)
                if(imageData != nil){
                    self.imageView.image = UIImage(data: imageData!)
                    
                } else {
                    self.urlToImageView(imageString)
                }
                
            });
        });

    }
}


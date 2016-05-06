//
//  IMDBSearchVC.swift
//  086-FavMovies
//
//  Created by Meagan McDonald on 5/5/16.
//  Copyright © 2016 Skyla157. All rights reserved.
//

import UIKit
import WebKit

class IMDBSearchVC: UIViewController, UINavigationControllerDelegate {

    @IBOutlet weak var container: UIView!
    var webView: WKWebView!
    var movieTitle: String!
    var imdbURLString: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        webView = WKWebView()
        container.addSubview(webView)
        
        loadRequest(movieTitle)
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.toolbarHidden = false
    }

    override func viewDidAppear(animated: Bool) {
        let frame = CGRectMake(0, 0, container.bounds.width, container.bounds.height)
        webView.frame = frame
    }

    func loadRequest(title: String) {
        //Remember to add "NSAppTransportSecurity" in plist and the bool
        var url: NSURL!
        
        if title == "" {
            url = NSURL(string: "http://www.imdb.com/find")!
        } else {
            if title.hasPrefix("http://www.imdb.com/title/tt") {
                url = NSURL(string: title)
            } else {
                let newTitle = title.stringByReplacingOccurrencesOfString(" ", withString: "+")
                url = NSURL(string: "http://www.imdb.com/find?ref_=nv_sr_fn&q=\(newTitle)&s=all")!
            }
        }
        let request = NSURLRequest(URL: url)
        webView.loadRequest(request)
    }
    
    @IBAction func onDoneBtnPress(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func onCopyBtnPress(sender: AnyObject) {
        imdbURLString = (webView.URL?.absoluteString)!
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let destination = segue.destinationViewController as? AddVC {
            destination.urlTxt.text = imdbURLString
        }
    }
    

}

//
//  ViewControllerWebviewDelegate.swift
//  SimpleApp
//
//  Created by Chris on 7/4/15.
//  Copyright (c) 2015 OxbowSoft. All rights reserved.
//

extension ViewController {
    
    func loadAddressURL(urlString: String){
        self.title = urlString
        let requestURL = NSURL(string: URLPath)
        let request = NSURLRequest(URL: requestURL!)
        webView.loadRequest(request)
    }
    
    // MARK: Webview Delegate
    func webViewDidStartLoad(webView: UIWebView) {
        var currentUrlString = (self.webView.request?.URL?.absoluteString)!
        //var calledUrlString = (webView.request!.mainDocumentURL.absoluteString)!


        NSLog("starturl"+currentUrlString)
        //self.title = currentUrlString;
        self.title = "Debt Payoff Planner"
        
        SVProgressHUD.show()
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        NSLog("Webview finished load")
        let currentUrlString = (webView.request?.URL!.absoluteString)!
        NSLog("finishurl"+currentUrlString)
        
        //DISPLAY THE INTERSTITIAL IN START LOAD TO PREVENT FLICKER
        if (self.interstitial?.isReady != nil && currentUrlString.rangeOfString("images.google.com") == nil && self.first_time==false) {
            NSLog("Interstital is to be created and loaded")
            self.interstitial.presentFromRootViewController(self)
            self.interstitial=createAndLoadInterstitial()
            self.first_time == false
        } else if (self.interstitial?.isReady != nil && currentUrlString.rangeOfString("images.google.com") != nil) {
            NSLog("This is the images so don't display an interstitial")
        } else if (self.first_time==true) {
            //FROM NOW ON SHOW THE AD
            self.first_time=false
            
        } else {
            NSLog("Interstitial was not ready")
            self.first_time=false
            
            let alertNoConnection = UIAlertController(title: "Interstitial not ready", message: "Somethings up.", preferredStyle: .Alert)
            let callAction = UIAlertAction(title: "I don't know", style: .Default, handler: {
                action in
                NSLog("Interstitial was not ready")
                }
            )
            
            let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertNoConnection.addAction(defaultAction)
            presentViewController(alertNoConnection, animated: true, completion: nil)
        }
        
        //CONTROL DISPLAY OF NAVIGATION BAR
        if currentUrlString.rangeOfString("google.com") != nil {
            NSLog("Going to hide the navigation bar! "+currentUrlString)
            //THIS IS WHERETHE NAVIGATION BAR WILL BE HIDDEN
            self.navigationController?.setNavigationBarHidden(true, animated: true)
            self.navigationController!.navigationBar.translucent = false
        } else {
            NSLog("Going to show the navigation bar! "+currentUrlString)
            self.navigationController?.setNavigationBarHidden(false, animated: true)
            //THIS IS WHERE IS NEED THE NAVIGATION BAR TO BE SHOWN
        }
        
        SVProgressHUD.dismiss()
    }
    
    func webView(webView: UIWebView, didFailLoadWithError error: NSError) {
        SVProgressHUD.dismiss()
    }
    
}

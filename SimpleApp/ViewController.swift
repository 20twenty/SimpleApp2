//
//  ViewController.swift
//  SimpleApp
//
//  Created by Chris on 7/10/15.
//  Copyright (c) 2015 OxbowSoft. All rights reserved.
//

import UIKit
import GoogleMobileAds
import IJReachability

class ViewController: UIViewController, GADInterstitialDelegate {

    @IBOutlet weak var webView: UIWebView!

    //@IBOutlet weak var bannerView: GADBannerView!
    var googleBannerView: GADBannerView!
    
    let URLPath = "http://www.google.com"
    
    var myCustomBackButtonItem: UIBarButtonItem?
    
    var interstitial: GADInterstitial!
    var first_time: Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        loadAddressURL(URLPath)
        addBackButton()
        //self.automaticallyAdjustsScrollViewInsets = false
        self.interstitial = createAndLoadInterstitial()
        self.first_time=true
        

    }
    
    // MARK: Actions
    func addBackButton() {
        var myBackButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        myBackButton.addTarget(self, action: "backHistory:", forControlEvents: UIControlEvents.TouchUpInside)
        myBackButton.setTitle("Back", forState: UIControlState.Normal)
        myBackButton.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
        myBackButton.sizeToFit()
        myCustomBackButtonItem = UIBarButtonItem(customView: myBackButton)
        self.navigationItem.leftBarButtonItem  = myCustomBackButtonItem
    }
    
    @IBAction func homeButtonAction(sender: AnyObject) {
        loadAddressURL(URLPath)
    }
    
    func backHistory(sender: UIButton) {
        if webView.canGoBack {
            webView.goBack()
        }
    }
    
    func createAndLoadInterstitial()->GADInterstitial {
        var interstitial = GADInterstitial(adUnitID: "ca-app-pub-2652694585370731/3178921602")
        //interstitial.delegate=self
        var request = GADRequest()

        request.testDevices = [ kGADSimulatorID, "cf5848b91f45150868cb35da83b1dd8e9eef4344", "f0913eac2112017cf7b97d2aeec27fb91c4dd2f6" ]
        
        interstitial.loadRequest(request)
        return interstitial
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        //CHECK ON INTERNET CONNECTION
        if IJReachability.isConnectedToNetwork() {
            
            NSLog("I'm connected to the network")
            
            //SUPPORT FOR GOOGLE ADS DYNAMICALLY CREATE THE CONTAINER
            googleBannerView = GADBannerView(adSize: kGADAdSizeSmartBannerPortrait)
            self.googleBannerView.adUnitID = "ca-app-pub-2652694585370731/3178921602"
            self.googleBannerView.rootViewController = self
            
            var request: GADRequest = GADRequest()
            request.testDevices = [ kGADSimulatorID, "cf5848b91f45150868cb35da83b1dd8e9eef4344", "f0913eac2112017cf7b97d2aeec27fb91c4dd2f6" ]
            googleBannerView.loadRequest(request)
            googleBannerView.frame = CGRectMake(0, view.bounds.height-googleBannerView.frame.size.height, googleBannerView.frame.size.width, googleBannerView.frame.size.height)
            
            self.view.addSubview(googleBannerView!)

            
        } else {
            NSLog("I'm not connected")
            
            let alertNoConnection = UIAlertController(title: "No Internet Connection", message: "Ensure you are within range of a network, networking is turned on, and your device is not in Airplane Mode.", preferredStyle: .Alert)
            let callAction = UIAlertAction(title: "I don't know", style: .Default, handler: {
                action in
                NSLog("I'm connected")
                }
            )
            
            let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertNoConnection.addAction(defaultAction)
            presentViewController(alertNoConnection, animated: true, completion: nil)
            
        }
    }
    
}


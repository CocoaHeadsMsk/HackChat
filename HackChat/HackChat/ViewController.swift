//
//  ViewController.swift
//  HackChat
//
//  Created by Danila Shikulin on 28/6/14.
//  Copyright (c) 2014 CHM. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class ViewController: UIViewController, MCBrowserViewControllerDelegate {
    var mpcHandler:MPCHandler?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mpcHandler = (UIApplication.sharedApplication().delegate as AppDelegate).mpcHandler
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(animated: Bool)  {
        super.viewDidAppear(animated)
        
    }
    
    @IBAction func searchPlayers(sender:AnyObject!) {
        if let handler = mpcHandler {
            handler.setupPeerWithDisplayName(UIDevice.currentDevice().name)
            handler.setupSession()
            handler.advertiseSelf(true)
            
            if let session = handler.session {
                handler.setupBrowser()
                handler.browser!.delegate = self
                
                self.presentModalViewController(handler.browser, animated: true)
            }
        }
    }

    func browserViewControllerDidFinish(browserViewController: MCBrowserViewController!) {
        mpcHandler?.browser?.dismissModalViewControllerAnimated(true)
        
    }
    
    func browserViewControllerWasCancelled(browserViewController: MCBrowserViewController!)  {
        mpcHandler?.browser?.dismissModalViewControllerAnimated(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


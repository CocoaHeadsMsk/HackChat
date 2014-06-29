//
//  MPCHandler.swift
//  HackChat
//
//  Created by Danila Shikulin on 28/6/14.
//  Copyright (c) 2014 CHM. All rights reserved.
//

import Foundation
import MultipeerConnectivity

class MPCHandler : NSObject, MCSessionDelegate {
    var peerID:MCPeerID?
    var session:MCSession?
    var browser:MCBrowserViewController?
    var advertiser:MCAdvertiserAssistant?

    func setupPeerWithDisplayName(name: String) {
        peerID = MCPeerID(displayName: name)
    }
    func setupSession() {
        session = MCSession(peer: peerID)
        session!.delegate = self;
    }
    func setupBrowser() {
        browser = MCBrowserViewController(serviceType:"my-game", session: session)
    }
    func advertiseSelf(advertise:Bool) {
        if advertise {
            advertiser = MCAdvertiserAssistant(serviceType:"my-game", discoveryInfo: nil, session: session)
            advertiser?.start()
        } else {
            advertiser?.stop()
            advertiser = nil
        }

    }
    
    func session(session: MCSession!, peer peerID: MCPeerID!, didChangeState state: MCSessionState) {
//        var userInfo:Dictionary<String, MCPeerID> = ["peerID": peerID, "state":state]
//        var userInfo:NSDictionary = NSDictionary(objects: [peerID, state], forKeys: ["peerID", "state"])
        var userInfo = ["userInfoTuple": (peerID, state)]
        
        dispatch_async(dispatch_get_main_queue(), {
            NSNotificationCenter.defaultCenter().postNotificationName("MPCDemo_DidChangeStateNotification", object: nil, userInfo: userInfo)
            })
    }
    
    func session(session: MCSession!, didReceiveData data: NSData!, fromPeer peerID: MCPeerID!) {
        
        var userInfo:Dictionary<String, Any> = ["data": data, "peerID":peerID]
        
        dispatch_async(dispatch_get_main_queue(), {
            NSNotificationCenter.defaultCenter().postNotificationName("MPCDemo_DidReceiveDataNotification", object: nil, userInfo: userInfo)
            })
        
    }
    
    func session(session: MCSession!, didFinishReceivingResourceWithName resourceName: String!, fromPeer peerID: MCPeerID!, atURL localURL: NSURL!, withError error: NSError!) {
        
    }
    func session(session: MCSession!, didReceiveStream stream: NSInputStream!, withName streamName: String!, fromPeer peerID: MCPeerID!) {
        
    }
    func session(session: MCSession!, didStartReceivingResourceWithName resourceName: String!, fromPeer peerID: MCPeerID!, withProgress progress: NSProgress!) {
        
    }
}
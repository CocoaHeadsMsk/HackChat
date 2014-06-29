//
//  ViewController.swift
//  HackChat100500
//
//  Created by Евгений Заболотний on 29/06/14.
//  Copyright (c) 2014 ZEG. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class ViewController: UIViewController, MCBrowserViewControllerDelegate, MCSessionDelegate, UITextViewDelegate, UITextFieldDelegate {
    
    var myPeerID: MCPeerID? //= MCPeerID()
    var mySession: MCSession? //= MCSession()
    var advertiser: MCAdvertiserAssistant?// = MCAdvertiserAssistant()
    var browserVC: MCBrowserViewController?// = MCBrowserViewController()
    
    @IBOutlet var browserButton : UIButton
    @IBOutlet var textBox : UITextView
    @IBOutlet var chatBox : UITextField
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setUpMultipeer()
    }

    func setUpMultipeer() {
        myPeerID = MCPeerID(displayName: UIDevice.currentDevice().name)
        mySession = MCSession(peer: myPeerID)
        mySession!.delegate = self
        browserVC = MCBrowserViewController(serviceType:"chat1", session:mySession)
        browserVC!.delegate = self
        advertiser = MCAdvertiserAssistant(serviceType:"chat1", discoveryInfo:nil, session:mySession)
        advertiser!.start()
    }
    
    func sendText() {
        println("sendText")
        let text = chatBox.text
        chatBox.text = ""
        let data = text.dataUsingEncoding(NSUTF8StringEncoding)
        mySession!.sendData(data, toPeers:mySession!.connectedPeers, withMode: MCSessionSendDataMode.Reliable, error:nil)
        receiveMessage(text, peer: myPeerID!)
    }
    
    func receiveMessage(message: String, peer: MCPeerID) {
        var finalText: String
        if peer == myPeerID {
            finalText = "\n\nme: \(message)"
        }
        else {
            finalText = "\n\n\(peer.displayName): \(message)"
        }
        textBox.text = textBox.text + finalText
    }
    
    func textFieldShouldReturn(textField: UITextField) {
        textField.resignFirstResponder()
        sendText()
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        textView.resignFirstResponder()
        sendText()
    }
    
    func dismissBrowserVC() {
        browserVC!.dismissViewControllerAnimated(true, completion:nil)
    }
    
    @IBAction func showBrowserVC() {
        presentViewController(browserVC, animated:true, completion:nil)
    }
    
    // Notifies the delegate, when the user taps the done button
    func browserViewControllerDidFinish(browserViewController: MCBrowserViewController!) {
        dismissBrowserVC()
    }
    
    // Notifies delegate that the user taps the cancel button.
    func browserViewControllerWasCancelled(browserViewController: MCBrowserViewController!) {
        dismissBrowserVC()
    }
    
    // Remote peer changed state
    func session(session: MCSession!, peer peerID: MCPeerID!, didChangeState state: MCSessionState) {
        
    }
    
    // Received data from remote peer
    func session(session: MCSession!, didReceiveData data: NSData!, fromPeer peerID: MCPeerID!) {
        println("didReceiveData")
        var message = NSString(data: data, encoding: NSUTF8StringEncoding)
        //  append message to text box:
        dispatch_async(dispatch_get_main_queue(), { self.receiveMessage(message, peer:peerID) })
    }
    
    // Received a byte stream from remote peer
    func session(session: MCSession!, didReceiveStream stream: NSInputStream!, withName streamName: String!, fromPeer peerID: MCPeerID!) {
    }
    
    // Start receiving a resource from remote peer
    func session(session: MCSession!, didStartReceivingResourceWithName resourceName: String!, fromPeer peerID: MCPeerID!, withProgress progress: NSProgress!) {
    }
    
    // Finished receiving a resource from remote peer and saved the content in a temporary location - the app is responsible for moving the file to a permanent location within its sandbox
    func session(session: MCSession!, didFinishReceivingResourceWithName resourceName: String!, fromPeer peerID: MCPeerID!, atURL localURL: NSURL!, withError error: NSError!) {
    }

}


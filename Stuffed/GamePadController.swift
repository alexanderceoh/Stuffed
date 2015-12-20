//
//  GamePadController.swift
//  Stuffed
//
//  Created by alex oh on 10/27/15.
//  Copyright © 2015 Alex Oh. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class GamePadController: UIViewController, MCNearbyServiceAdvertiserDelegate, MCSessionDelegate {

    var session: MCSession!
    var advertiser: MCNearbyServiceAdvertiser!
    var myPeerID: MCPeerID = MCPeerID(displayName: "DeezNuts")
    
    var boardID: MCPeerID?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        session = MCSession(peer: myPeerID)
        session.delegate = self
        advertiser = MCNearbyServiceAdvertiser(peer: myPeerID, discoveryInfo: ["color": "white"], serviceType: "stuffed")
        
        advertiser.delegate = self
        
        advertiser.startAdvertisingPeer()

    }
    
    /////
    ///// ADVERTISER
    /////

    func advertiser(advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: NSData?, invitationHandler: (Bool, MCSession) -> Void) {
        
        print("Inviting Peer \(peerID.displayName)")
        
        if peerID.displayName == "Board" {
            
            boardID = peerID
            
            print(peerID)
            
            print("Accept Invite")
//            advertiser.stopAdvertisingPeer()
            invitationHandler(true,session)
        } else {
            print("Decline Invite")
            invitationHandler(false,session)
        }
        
    }
    
    
    /////
    ///// SESSION
    /////

    
    func session(session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, atURL localURL: NSURL, withError error: NSError?) {
        // if started receiving file
    }
    
    func session(session: MCSession, didReceiveData data: NSData, fromPeer peerID: MCPeerID) {
        // if data is received
    }
    
    func session(session: MCSession, didReceiveStream stream: NSInputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        // if streaming data is received
    }
    
    func session(session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, withProgress progress: NSProgress) {
        // if started receiving file
    }
    
    func session(session: MCSession, peer peerID: MCPeerID, didChangeState state: MCSessionState) {
        
        let states = ["Not Connected","Connecting","Connected"]
        
        let stateName = states[state.rawValue]
        
        print(peerID)
        
        print("\(peerID.displayName) " + stateName)
        
        print(session.connectedPeers)
    }
    
    /////
    ///// BUTTONS
    /////

    
    @IBAction func jump(sender: AnyObject) {
     
        let info = [
            
            "action" : "jump",
            
            
        ]
        
        sendInfo(info)
    }
    
    @IBAction func fire(sender: AnyObject) {
        
        let info = [
            
            "action" : "fire",

            
        ]
        
        sendInfo(info)
        
        
    }

    @IBAction func left(sender: AnyObject) {
        
        let info = [
            
            "action" : "move",
            "direction" : "left"
            
        ]
        
        sendInfo(info)
        
    }
    
    @IBAction func right(sender: AnyObject) {
        
        let info = [
        
            "action" : "move",
            "direction" : "right"
        
        ]
        
        sendInfo(info)
        
    }
    
    func sendInfo(info:[String:String]) {
        
        if let data = try? NSJSONSerialization.dataWithJSONObject(info, options: .PrettyPrinted) {
            
            if let bID = boardID {
                
                do {
                    
                    try session.sendData(data, toPeers: [bID], withMode: .Reliable)
                    
                } catch {
                    
                    print(error)
                    
                }
                
                
            }

            
        }
        
        
    }
    
}
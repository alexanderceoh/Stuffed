//
//  ViewController.swift
//  Stuffed
//
//  Created by alex oh on 10/27/15.
//  Copyright © 2015 Alex Oh. All rights reserved.
//

import UIKit
import MultipeerConnectivity
import SpriteKit

typealias PeerInfo = [DisplayName: [String:String]?]

class GameBoardController: UIViewController, MCNearbyServiceBrowserDelegate, MCSessionDelegate{

    var session: MCSession!
    var browser: MCNearbyServiceBrowser!
    // peers are devices
    var myPeerID: MCPeerID = MCPeerID(displayName: "Board")
    
    let scene = GameBoardScene(fileNamed: "GameBoard")

    var peerInfo: PeerInfo = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let skView = view as? SKView {
            
            skView.presentScene(scene)
            skView.ignoresSiblingOrder = true
            skView.asynchronous = false
            
        }
        
        session = MCSession(peer: myPeerID)
        session.delegate = self
        
        browser = MCNearbyServiceBrowser(peer: myPeerID, serviceType: "stuffed")
        browser.delegate = self
        browser.startBrowsingForPeers()
    }
    
    /////
    ///// BROWSER
    /////
    
    var waitingPeers: [MCPeerID] = []
    var sendingInvite: Bool = false
    
    func sendInvite() {
        
        if let peerID = waitingPeers.first {
            
            sendingInvite = true
            waitingPeers.removeFirst()
            browser.invitePeer(peerID, toSession: session, withContext: nil, timeout: 10)
            
            
        }
        

        
    }
    
    func browser(browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        
        if session.connectedPeers.contains(peerID) {return}
        
        print("Found Peer \(peerID.displayName)")
//        print("Found peer Info \(info)")
        
        peerInfo[peerID.displayName] = info
        
        // the return below stops the whole function if the contains part is true
        if waitingPeers.contains(peerID) { return }
        
        waitingPeers.append(peerID)
        
        if !sendingInvite { sendInvite() }

    }

    func browser(browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        print("Lost Peer \(peerID.displayName)")
    }

    /////
    ///// SESSION
    /////
    
    func session(session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, atURL localURL: NSURL, withError error: NSError?) {
        // if started receiving file
    }
    
    func session(session: MCSession, didReceiveData data: NSData, fromPeer peerID: MCPeerID) {
        // if data is received
        
        print(data)
        
        if let info = try? NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers) as? [String:String] {
            
            if let action = info?["action"] where action == "move", let direction = info?["direction"] {
                    
                    scene?.movePixel(peerID.displayName, direction: direction)
                
            }
            
        
        
            if let action = info?["action"] where action == "jump" {
                
                scene?.jumpPixel(peerID.displayName)
                
            }
            
            if let action = info?["action"] where action == "fire" {
                
                scene?.firePixel(peerID.displayName)
                
            }

        }
        
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
        
        print("\(peerID.displayName)" + stateName)
        
        if state != .Connecting {
            
            sendingInvite = false
            sendInvite()
            
        }
        
        if state == .Connected {
            
            print(stateName)
            
            if let color = peerInfo[peerID.displayName]??["color"] {
                
                scene?.addPixel(peerID.displayName, colorName: color)
                
            }
            scene?.addPixel(peerID.displayName)
            
        }
        
        if state == .NotConnected {
            
            // remove pixel with name
            scene?.removePixel(peerID.displayName)

        }
    }
    
    func session(session: MCSession, didReceiveCertificate certificate: [AnyObject]?, fromPeer peerID: MCPeerID, certificateHandler: (Bool) -> Void) {
        
        certificateHandler(true)
        
    }
}


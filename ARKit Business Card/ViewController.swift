//
//  ViewController.swift
//  Talent Garden
//
//  Created by Alessandro on 01/08/2018.
//  Copyright © 2018 Alessandro Fan. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {
    
    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene(named: "art.scnassets/mainScene.scn")!
        
        // Set the scene to the view
        sceneView.scene = scene
    }
    
    
    //: Todo: Make the status bar style light
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARImageTrackingConfiguration()
        
        configuration.maximumNumberOfTrackedImages = 1
        
        guard let referenceImage = ARReferenceImage.referenceImages(inGroupNamed: "cards", bundle: nil) else {
            fatalError("There was a problem with finding the group image check again")
        }
        
        configuration.trackingImages = referenceImage
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    // MARK: - ARSCNViewDelegate
    
    // TODO: Renderer function with the position of rendered stuff
    
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        
        let node = SCNNode()
        
        if let imageAnchor = anchor as? ARImageAnchor{
            let referenceImage = imageAnchor.referenceImage
            
            let plane = SCNPlane(width: referenceImage.physicalSize.width/4, height: referenceImage.physicalSize.height/4)
            let plane1 = SCNPlane(width: referenceImage.physicalSize.width/4, height: referenceImage.physicalSize.height/4)
            
            let plane2 = SCNPlane(width: referenceImage.physicalSize.width/4, height: referenceImage.physicalSize.height/4)
            
            let plane3 = SCNPlane(width: referenceImage.physicalSize.width/4, height: referenceImage.physicalSize.height/4)
            
            
            let planeNode = SCNNode(geometry: plane)
            
            planeNode.opacity = 0.5
            planeNode.eulerAngles.x = -.pi/2
            
            //            planeNode.runAction(self.imageHighlightAction)
            
            //            //MARK: - Stack Overflow Answer
            //            let testPlane = SCNPlane(width: referenceImage.physicalSize.width, height: referenceImage.physicalSize.width/2)
            //            testPlane.cornerRadius = testPlane.width / 8
            //
            //
            //
            //            let stuff = SKScene(size: CGSize(width: 900, height: 900))
            //            stuff.backgroundColor = UIColor.white
            //
            //            let str = SKLabelNode(text: "This is just a test")
            //            str.color = UIColor.black
            //            str.fontColor = UIColor.black
            //            str.fontSize = 45.5
            //
            //            str.position = CGPoint(x: stuff.size.width / 2,
            //                                     y: stuff.size.height / 2)
            //            stuff.addChild(str)
            //
            //            testPlane.firstMaterial?.diffuse.contents = stuff
            //            testPlane.firstMaterial?.isDoubleSided = true
            //            testPlane.firstMaterial?.diffuse.contentsTransform = SCNMatrix4Translate(SCNMatrix4MakeScale(1, -1, 1), 0, 1, 0)
            //
            //            let testNode = SCNNode(geometry: testPlane)
            //
            //
            //            testNode.eulerAngles.x = -.pi / 2
            //            testNode.position = SCNVector3Make(0.0,0.0,0.0)
            
            
            
            
            //MARK: - Text plane for name and stuff
            
            let namePlane = SCNPlane(width: referenceImage.physicalSize.width, height: referenceImage.physicalSize.width/2)
            namePlane.cornerRadius = namePlane.width / 8
            
            let nameSpriteKit = SKScene(fileNamed: "NameInfo")
            if let label = nameSpriteKit?.childNode(withName: "Name") as? SKLabelNode{
                
                label.text = String((referenceImage.name?.split(separator: " ")[0])!).uppercased()
                
            }
            if let label2 = nameSpriteKit?.childNode(withName: "Last") as? SKLabelNode {
                label2.text = String((referenceImage.name?.split(separator: " ")[1])!).uppercased()
                
            }
            
            namePlane.firstMaterial?.diffuse.contents = nameSpriteKit
            namePlane.firstMaterial?.isDoubleSided = true
            namePlane.firstMaterial?.diffuse.contentsTransform = SCNMatrix4Translate(SCNMatrix4MakeScale(1, -1, 1), 0, 1, 0)
            
            let namePlaneNode = SCNNode(geometry: namePlane)
            
            
            namePlaneNode.eulerAngles.x = -.pi / 2
            namePlaneNode.position = SCNVector3Make(Float(referenceImage.physicalSize.width + 0.04), 0.0, (-Float(referenceImage.physicalSize.height/2 - namePlane.height/2)))
            
            
            
            //MARK: - Stuff fo the profile picture an stuff
            let profilePlane = SCNPlane(width: referenceImage.physicalSize.width/2, height: referenceImage.physicalSize.width/2)
            profilePlane.cornerRadius = profilePlane.width / 8
            
            let profileSpriteKit = SKScene(fileNamed: "ProfilePicture")
            let profilePictureMaterial = SCNMaterial()
            profilePictureMaterial.isDoubleSided = true
            profilePictureMaterial.diffuse.contents = "alessandro fan"
            profilePlane.materials = [profilePictureMaterial]
            
            
            let profilePlaneNode = SCNNode(geometry: profilePlane)
            
            profilePlaneNode.eulerAngles.x = -.pi / 2
            profilePlaneNode.position = SCNVector3Make(Float(referenceImage.physicalSize.width), 0.0, (-Float(referenceImage.physicalSize.height/2 - profilePlane.height/2)))
            
            
            
            //MARK: - Stuff fo the pphone icon and stuff
            let tempView = UIView.init(frame: CGRect(x: 0, y: 0, width: 900, height: 900))
            tempView.layer.bounds = CGRect(x: -450, y: -450, width: tempView.frame.size.width, height: tempView.frame.size.height)
            let newMaterial = SCNMaterial()
            newMaterial.isDoubleSided = true
            newMaterial.diffuse.contents = "phone"
            plane.materials = [newMaterial]
            let phoneNode = SCNNode(geometry: plane)
            phoneNode.eulerAngles.x = -.pi / 2
            phoneNode.position = SCNVector3Make(Float(referenceImage.physicalSize.width), 0.0, Float(referenceImage.physicalSize.height/2 - plane.height/2))
            
            
            //MARK: - Stuff fo the mmail icon and stuff
            let tempView1 = UIView.init(frame: CGRect(x: 0, y: 0, width: 900, height: 900))
            tempView1.layer.bounds = CGRect(x: -450, y: -450, width: tempView1.frame.size.width, height: tempView1.frame.size.height)
            let newMaterial1 = SCNMaterial()
            newMaterial1.isDoubleSided = true
            newMaterial1.diffuse.contents = "mail"
            plane1.materials = [newMaterial1]
            let mailNode = SCNNode(geometry: plane1)
            mailNode.eulerAngles.x = -.pi / 2
            mailNode.position = SCNVector3Make(Float(referenceImage.physicalSize.width + 0.02), 0.0, Float(referenceImage.physicalSize.height/2 - plane.height/2))
            
            
            //MARK: - Stuff fo the iinstagram icon and stuff
            let tempView2 = UIView.init(frame: CGRect(x: 0, y: 0, width: 900, height: 900))
            tempView2.layer.bounds = CGRect(x: -450, y: -450, width: tempView2.frame.size.width, height: tempView.frame.size.height)
            let newMaterial2 = SCNMaterial()
            newMaterial2.isDoubleSided = true
            newMaterial2.diffuse.contents = "instagram"
            plane2.materials = [newMaterial2]
            let instagramNode = SCNNode(geometry: plane2)
            instagramNode.eulerAngles.x = -.pi / 2
            instagramNode.position = SCNVector3Make(Float(referenceImage.physicalSize.width + 0.04), 0.0, Float(referenceImage.physicalSize.height/2 - plane.height/2))
            
            
            //MARK: - Stuff fo the ttwitter icon and stuff
            let tempView3 = UIView.init(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
            tempView3.layer.bounds = CGRect(x: -450, y: -450, width: tempView3.frame.size.width, height: tempView3.frame.size.height)
            let newMaterial3 = SCNMaterial()
            newMaterial3.isDoubleSided = true
            newMaterial3.diffuse.contents = "twitter"
            plane3.materials = [newMaterial3]
            let twitterNode = SCNNode(geometry: plane3)
            twitterNode.eulerAngles.x = -.pi / 2
            twitterNode.position = SCNVector3Make(Float(referenceImage.physicalSize.width + 0.06), 0.0, Float(referenceImage.physicalSize.height/2 - plane.height/2))
            
            
            //MARK: - Adding child nodes and stuff
            node.addChildNode(profilePlaneNode)
            node.addChildNode(namePlaneNode)
            node.addChildNode(phoneNode)
            node.addChildNode(mailNode)
            node.addChildNode(instagramNode)
            node.addChildNode(twitterNode)
            
            
        }
        return node
    }
    
    
    // TODO: Define touchesBegan actions blabla
    
    
    
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}

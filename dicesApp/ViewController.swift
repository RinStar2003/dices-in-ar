//
//  ViewController.swift
//  dicesApp
//
//  Created by мас on 27.11.2022.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    var isTableAdded = false
    
    var diceArray = [SCNNode]()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        self.sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        
        sceneView.autoenablesDefaultLighting = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        configuration.planeDetection = .horizontal
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        print("Tapped")

        if let touch = touches.first {
            let touchLocation = touch.location(in: sceneView)
            
            let results = sceneView.hitTest(touchLocation, types: .existingPlaneUsingExtent)
            
            if let hitResults = results.first {
                
                // Create a new scene
                let diceScene = SCNScene(named: "art.scnassets/diceCollada.scn")!
                
                if let diceNode = diceScene.rootNode.childNode(withName: "Dice", recursively: true) {
                    
                    diceNode.position = SCNVector3(
                        x: hitResults.worldTransform.columns.3.x,
                        y: hitResults.worldTransform.columns.3.y,
                        z: hitResults.worldTransform.columns.3.z)
                    
                    diceArray.append(diceNode)
                    
                    sceneView.scene.rootNode.addChildNode(diceNode)
                }
            }
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        print("plane detected")

        if isTableAdded == false {
            let planeAnchor = anchor
            // let planeNode = SCNNode()
            let x = planeAnchor.transform.columns.3.x
            let y = planeAnchor.transform.columns.3.y
            let z = planeAnchor.transform.columns.3.z
            //planeNode!.position = SCNVector3(x: x, y: y, z: z)
            
            let idleScene = SCNScene(named: "art.scnassets/Table.scn")!
            let node = SCNNode()
            for child in idleScene.rootNode.childNodes{
                node.addChildNode(child)
            }
            node.position = SCNVector3(x,y,z)
            node.scale = SCNVector3(0.001,0.001,0.001)
            
            sceneView.scene.rootNode.addChildNode(node)
            
            isTableAdded = true
        }
        print("Model placed")
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
        print("plane updated")
    }
}

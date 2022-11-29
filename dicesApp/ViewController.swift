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

    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        print("plane detected")

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
        
        print("Model placed")
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
        
        print("plane updated")
    }
}

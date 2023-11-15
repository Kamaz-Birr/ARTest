//
//  ViewController.swift
//  ARTest
//
//  Created by Haldox on 13/11/2023.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Show the process oof detecting the plane
        self.sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a cube
//        let cube = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0.01)
        
        // Create a sphere
//        let sphere = SCNSphere(radius: 0.2)
//        
//        let material = SCNMaterial()
//        material.diffuse.contents = UIImage(named: "art.scnassets/8k_moon.jpg") // Add a texture
//        
//        sphere.materials = [material]
//        
//        // create a scene node (a point in 3d space)
//        let node = SCNNode()
//        node.position = SCNVector3(x: 0, y: 0.1, z: -0.5)
//        
//        // Give the node a geometry
//        node.geometry = sphere
//        
//        // Put the node into the scene
//        sceneView.scene.rootNode.addChildNode(node)
        
        // Add lights
        sceneView.autoenablesDefaultLighting = true
        
        // Create a new scene
//        let diceScene = SCNScene(named: "art.scnassets/diceCollada.scn")!
//        
//        if let diceNode = diceScene.rootNode.childNode(withName: "Dice", recursively: true) {
//            diceNode.position = SCNVector3(x: 0, y: 0, z: -1)
//            
//            // Set the scene to the view
//            sceneView.scene.rootNode.addChildNode(diceNode)
//        }
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
        if let touch = touches.first {
            let touchLocation = touch.location(in: sceneView)
            
            if let query = sceneView.raycastQuery(from: touchLocation, allowing: .existingPlaneGeometry, alignment: .any) {
                let results = sceneView.session.raycast(query)
                if let hitResult = results.first {
                    let diceScene = SCNScene(named: "art.scnassets/diceCollada.scn")!
                    if let diceNode = diceScene.rootNode.childNode(withName: "Dice", recursively: true) {
                        diceNode.position = SCNVector3(
                            x: hitResult.worldTransform.columns.3.x,
                            y: hitResult.worldTransform.columns.3.y + diceNode.boundingSphere.radius,
                            z: hitResult.worldTransform.columns.3.z
                        )
                        sceneView.scene.rootNode.addChildNode(diceNode)
                    }
                }
            }
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        if anchor is ARPlaneAnchor {
            let planeAnchor = anchor as! ARPlaneAnchor
            let plane = SCNPlane(width: CGFloat(planeAnchor.planeExtent.width), height: CGFloat(planeAnchor.planeExtent.height))
            let planeNode = SCNNode()
            planeNode.position = SCNVector3(x: planeAnchor.center.x, y: 0, z: planeAnchor.center.z)
            
            // By default, the SCNPlane is vertical. Transform to horizontal
            planeNode.transform = SCNMatrix4MakeRotation(-Float.pi / 2, 1, 0, 0)
            
            let gridMaterial = SCNMaterial()
            gridMaterial.diffuse.contents = UIImage(named: "art.scnassets/grid.png")
            
            plane.materials = [gridMaterial]
            
            planeNode.geometry = plane
            
            node.addChildNode(planeNode)
        } else {
            return
        }
    }

    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
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

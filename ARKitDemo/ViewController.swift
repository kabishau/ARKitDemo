//
//  ViewController.swift
//  ARKitDemo
//
//  Created by Aleksey Kabishau on 1113..17.
//  Copyright © 2017 Aleksey Kabishau. All rights reserved.
//

import UIKit
import ARKit

class ViewController: UIViewController {

    @IBOutlet weak var sceneView: ARSCNView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addBox()
        addTapGestureToSceneView()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let configuration = ARWorldTrackingConfiguration()
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
    
    // adding parameters to the initial function with default values
    func addBox(x: Float = 0, y: Float = 0, z: Float = 0.2) {
        
        // creating box shape; 1 float = 1 meter
        let box = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0)
        
        //node represent position and coordinates of an object in 3D space; by itself is not visible
        let boxNode = SCNNode()
        // make the node visible by giving it a shape of box
        boxNode.geometry = box
        // positioning relatively to the camera; negative z = forward
        boxNode.position = SCNVector3(x, y, z)
        
        // creating SceneKit scene to be displaying in the view
        // root node in a scene defines the coordinates of the real world rendering by SceneKit
        sceneView.scene.rootNode.addChildNode(boxNode)
    }
    
    func addTapGestureToSceneView() {
        // initializing tapGestureRecognizer with targer set ViewController with the action selector set  to callback function
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.didTap(withGestureRecognizer:)))
        
        // adding gesture recognizer to ARSceneView
        sceneView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func didTap(withGestureRecognizer recognizer: UIGestureRecognizer) {
        
        // retrieving the user's tap location relative to sceneView, then hit test to see if user tapped onto any node(s)
        let tapLocation = recognizer.location(in: sceneView)
        let hitTestResults = sceneView.hitTest(tapLocation)
        
        // unwraping the first node from hitTestResults
        guard let node = hitTestResults.first?.node else {
            // perform hit test with type featurePoint
            let hitTestResultsWithFeaturePoints = sceneView.hitTest(tapLocation, types: .featurePoint)
            // unwraping first hit test result
            if let hitTestResultWithFeaturePoints = hitTestResultsWithFeaturePoints.first {
                //
                let translation = hitTestResultWithFeaturePoints.worldTransform.translation
                addBox(x: translation.x, y: translation.y, z: translation.z)
            }

            return
        }
        // if result contains at least a node - removing it from its parent node
        node.removeFromParentNode()
    }

}

// extenstion transform a matrix into float3, it gives us x, y, and z from the matrix
extension float4x4 {
    var translation: float3 {
        let translation = self.columns.3
        return float3(translation.x, translation.y, translation.z)
    }
}


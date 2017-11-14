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
    
    func addBox() {
        
        // creating box shape; 1 float = 1 meter
        let box = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0)
        
        //node represent position and coordinates of an object in 3D space; by itself is not visible
        let boxNode = SCNNode()
        // make the node visible by giving it a shape of box
        boxNode.geometry = box
        // positioning relatively to the camera; negative z = forward
        boxNode.position = SCNVector3(0, 0, -0.2)
        
        // creating SceneKit scene to be displaying in the view
        let scene = SCNScene()
        // root node in a scene defines the coordinates of the real world rendering by SceneKit
        scene.rootNode.addChildNode(boxNode)
        // adding just created "scene" as a scene for ARcSeneView
        sceneView.scene = scene
        
        
        /* can be refactored
         sceneView.scene.rootNode.addChildNode(boxNode)
        */
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
        guard let node = hitTestResults.first?.node else { return }
        // if result contains at least a node - removing it from its parent node
        node.removeFromParentNode()
    }

}


//
//  ARGuideViewController.swift
//  Guide
//
//  Created by Michael Vilabrera on 1/3/23.
//

import UIKit
import ARKit
import SceneKit

import ARCore

class ARGuideViewController: UIViewController {
    lazy var sceneView: ARSCNView = {
        let asv = ARSCNView(frame: .zero)
        asv.translatesAutoresizingMaskIntoConstraints = false
        return asv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        // 1
        sceneView.delegate = self
        sceneView.showsStatistics = true
        
        setupNode()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 2
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    private func setupViews() {
        self.view.addSubview(sceneView)
        sceneView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        sceneView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        sceneView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        sceneView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
    }
    
    private func setupNode() {
        let scene = SCNScene()
        
        sceneView.scene = scene
        let pyramid = SCNPyramid(width: 0.2, height: 0.2, length: 0.2)
        pyramid.firstMaterial?.diffuse.contents = UIColor.green
        let pyramidNode = SCNNode(geometry: pyramid)
        pyramidNode.position.z = -0.8
        sceneView.scene.rootNode.addChildNode(pyramidNode)
    }
}

extension ARGuideViewController: ARSCNViewDelegate {
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

extension ARGuideViewController: ARSessionDelegate {
    
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        //
    }
    
    func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
        //
    }
    
    func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
        //
    }
    
    func session(_ session: ARSession, didRemove anchors: [ARAnchor]) {
        //
    }
}

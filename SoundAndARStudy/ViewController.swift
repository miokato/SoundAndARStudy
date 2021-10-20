//
//  ViewController.swift
//  SoundAndARStudy
//
//  Created by mio kato on 2021/10/17.
//

import UIKit
import RealityKit
import ARKit

class ViewController: UIViewController {
    
    @IBOutlet var scnView: ARSCNView!
    var rootNode: SCNNode {
        scnView.scene.rootNode
    }

    var timer: Timer?
    var frameRate: Float = 60.0;
    var deltaTime: TimeInterval {
        return TimeInterval(1.0 / frameRate)
    }
    
    // 世界ノード
    let worldNode = SCNNode()
    // アニメーションするノード
    let animateNode = SCNNode()
    // タップして出したボール
    var ballNodes: [AnimateSphereNode] = .init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // ノード構築
        setupNode()
        
        // gesture
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(gesture:)))
        scnView.addGestureRecognizer(tapGesture)
    }
    
    func setupNode() {
        worldNode.addChildNode(animateNode)
        rootNode.addChildNode(worldNode)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let configuration = ARWorldTrackingConfiguration()
        configuration.sceneReconstruction = .mesh
        configuration.planeDetection = .horizontal
        scnView.session.run(configuration, options: [.removeExistingAnchors, .resetTracking])
        
        startTimer()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        stopTimer()
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: deltaTime, repeats: true, block: { t in
            for childNode in self.animateNode.childNodes {
                if let ballNode = childNode as? AnimateSphereNode {
                    ballNode.update()
                }
            }
        })
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    @objc func handleTap(gesture: UITapGestureRecognizer) {
        let location = gesture.location(in: scnView)
        guard let query = scnView.raycastQuery(from: location, allowing: .existingPlaneGeometry, alignment: .horizontal) else { return }
        let hitResults = scnView.session.raycast(query)
        guard let hitResult = hitResults.first else { return }
        let worldPos = hitResult.worldTransform.position
        
        let ballNode = AnimateSphereNode()
        ballNode.simdWorldPosition = worldPos
        animateNode.addChildNode(ballNode)
    }
}

extension simd_float4x4  {
    var position: SIMD3<Float> {
        return SIMD3<Float>(columns.3.x, columns.3.y, columns.3.z)
    }
}

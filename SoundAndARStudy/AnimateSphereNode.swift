//
//  AnimateSphereNode.swift
//  SoundAndARStudy
//
//  Created by mio kato on 2021/10/20.
//

import SceneKit

class AnimateSphereNode: SCNNode {
    
    var time: Float = 0.0

    override init() {
        super.init()
        
        setup()
    }
    
    private func setup() {
        geometry = SCNSphere(radius: 0.05)
//        geometry = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0)
        
        let program = SCNProgram()
        program.vertexFunctionName = "vertexShader"
        program.fragmentFunctionName = "fragmentShader"
        geometry?.firstMaterial?.program = program
    }
    
    public func update() {
        time = Float(Date().timeIntervalSinceNow)
        let timeData = Data(bytes: &time, count: MemoryLayout<Float>.size)
        geometry?.firstMaterial?.setValue(timeData, forKey: "timeData")
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

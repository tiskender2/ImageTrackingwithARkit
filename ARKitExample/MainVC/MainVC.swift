//
//  MainVC.swift
//  ARKitExample
//
//  Created by Tolga İskender on 15.07.2020.
//  Copyright © 2020 Tolga İskender. All rights reserved.
//

import UIKit
import ARKit
import WebKit

class MainVC: UIViewController {
    
    @IBOutlet weak var arView: ARSCNView!
    private var configuration = ARImageTrackingConfiguration()
    private var options : ARSession.RunOptions = [.resetTracking,.removeExistingAnchors]
    lazy var webView: WKWebView = {
        let webConfiguration = WKWebViewConfiguration()
        let webView = WKWebView(frame: .zero, configuration: webConfiguration)
       // webView.uiDelegate = self
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        resetTrackingConfiguration()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        arView.session.pause()
    }
    
    fileprivate func setupUI(){
        title = "ARKit"
        arView.delegate = self
      
    }
    fileprivate func loadWebView(){
        self.view.addSubview(webView)
        
        NSLayoutConstraint.activate([
            webView.topAnchor
                .constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            webView.leftAnchor
                .constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor),
            webView.bottomAnchor
                .constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            webView.rightAnchor
                .constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor)
        ])
        
        let url = URL(string: "https://github.com/tiskender2")!
        webView.load(URLRequest(url: url))
    }
    
    func resetTrackingConfiguration() {
        guard let referenceImages = ARReferenceImage.referenceImages(inGroupNamed: "AR Resources", bundle: nil) else { return }
        configuration.trackingImages = referenceImages
        configuration.maximumNumberOfTrackedImages = 1
        arView.session.run(configuration, options: options)
    }
}
extension MainVC : ARSCNViewDelegate {
    
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
       
            if let imageAnchor = anchor as? ARImageAnchor {
                let plane = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width, height: imageAnchor.referenceImage.physicalSize.height)
                let planeNode = SCNNode(geometry: plane)
                planeNode.eulerAngles.x = .pi / 2
                planeNode.opacity = 0.70
                addLabel(text: "Loading...", node: planeNode,created:"Created by @tiskender2")
                node.addChildNode(planeNode)
                DispatchQueue.main.asyncAfter(deadline: .now()+2, execute: {
                    self.loadWebView()
                })
                
            }
            
        return node
    }
    func addLabel(text: String,node:SCNNode,created:String){
        let sk = SKScene(size: CGSize(width: 3000, height: 2000))
        sk.backgroundColor = UIColor.clear
        
        let rectangle = SKShapeNode(rect: CGRect(x: 0, y: 0, width: 3000, height: 2000), cornerRadius: 10)
        rectangle.fillColor = UIColor.black
        rectangle.strokeColor = UIColor.white
        rectangle.lineWidth = 5
        rectangle.alpha = 0.5
        
        let lbl = SKLabelNode(text: text)
        lbl.fontSize = 160
        lbl.numberOfLines = 0
        lbl.fontColor = UIColor.white
        lbl.fontName = "Helvetica-Bold"
        lbl.position = CGPoint(x:1500,y:1000)
        lbl.preferredMaxLayoutWidth = 2900
        lbl.horizontalAlignmentMode = .center
        lbl.verticalAlignmentMode = .center
        
        let lbl2 = SKLabelNode(text: created)
        lbl2.fontSize = 160
        lbl2.numberOfLines = 0
        lbl2.fontColor = UIColor.white
        lbl2.fontName = "Helvetica-Bold"
        lbl2.position = CGPoint(x:1500,y:(sk.frame.size.height - 180)) // font size 160 that's why i set it 180 to give 20px top space
        lbl2.preferredMaxLayoutWidth = 2900
        lbl2.horizontalAlignmentMode = .center
        lbl2.verticalAlignmentMode = .bottom
       // lbl.zRotation = .pi
        
        sk.addChild(rectangle)
        sk.addChild(lbl)
        sk.addChild(lbl2)
        let material = SCNMaterial()
        material.isDoubleSided = true
        material.diffuse.contents = sk
        node.geometry?.materials = [material]
        node.geometry?.firstMaterial?.diffuse.contentsTransform = SCNMatrix4MakeScale(Float(1), Float(1), 1)
        node.geometry?.firstMaterial?.diffuse.wrapS = .repeat
        node.geometry?.firstMaterial?.diffuse.wrapS = .repeat
    }
}



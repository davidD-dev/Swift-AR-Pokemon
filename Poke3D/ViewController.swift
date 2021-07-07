//
//  ViewController.swift
//  Poke3D
//
//  Created by David Deschamps on 06/07/2021.
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
        
        sceneView.autoenablesDefaultLighting = true
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARImageTrackingConfiguration()
        
        if let imagesToTrack = ARReferenceImage.referenceImages(inGroupNamed: "Pokemon-cards", bundle: Bundle.main) {
            
        
            configuration.trackingImages = imagesToTrack
            
            configuration.maximumNumberOfTrackedImages = 2
            
            print("Images ajoutés")
        }

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    // MARK: - ARSCNViewDelegate
    
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
        
        if let imageAnchor = anchor as? ARImageAnchor {
            // On crée un plan en fonction de la carte qui à été détecté
            let plane = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width, height: imageAnchor.referenceImage.physicalSize.height)
            
                    
            // On rend le plan à moitié transparent
            plane.firstMaterial?.diffuse.contents = UIColor(white: 1.0, alpha: 0.5)
            
            let planeNode = SCNNode(geometry: plane)
            
            // On rotate le plan de 90° pour que celui ci soit à l'horizontal de la carte
            planeNode.eulerAngles.x = -.pi / 2
            
            let pokeName = imageAnchor.referenceImage.name!
            
            
            if let pokeNode = addPokeScene(pokemonName: pokeName) {
                planeNode.addChildNode(pokeNode)
            }
            
            node.addChildNode(planeNode)
            
        }
        
        return node
    }
    
    //MARK:- OUTILS
    
    private func addPokeScene(pokemonName name: String) -> SCNNode? {
        
        if let pokeScene = SCNScene(named: "art.scnassets/\(name)-model.scn") {
            if let pokeNode = pokeScene.rootNode.childNodes.first {
                pokeNode.eulerAngles.x = .pi / 2
                return pokeNode
            }
        }
        
        return nil
    }
    
}

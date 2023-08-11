//
//  GameViewController.swift
//  RainCat
//
//  Created by Roman Lantsov on 11.08.2023.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let scene = GameScene(size: view.frame.size)

        if let view = self.view as! SKView? {
          view.presentScene(scene)
          view.ignoresSiblingOrder = true
          view.showsPhysics = true
          view.showsFPS = true
          view.showsNodeCount = true
        }
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscape
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}

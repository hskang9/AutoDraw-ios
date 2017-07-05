//
//  ViewController.swift
//  drawView
//
//  Created by hyungsukkang on 7/5/17.
//  Copyright © 2017 hyungsukkang. All rights reserved.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController {
    
    let model = MobileNet()
    
    @IBAction func guessTapped(_ sender: Any) {
        guard let visionModel = try? VNCoreMLModel(for: model.model) else {
            fatalError("Error")
        }
        let request = VNCoreMLRequest(model: visionModel) { request, error in
            if let observations = request.results as? [VNClassificationObservation] {
                let top5 = observations.prefix(through: 4)
                    .map { ($0.identifier, Double($0.confidence)) }
                print(top5)
                // handle top 5 prediction results
                self.object.text = top5[0].0
            }
        }
        let handler = VNImageRequestHandler(cgImage: (imgCanvas.image?.cgImage!)!)
        try? handler.perform([request])
    }
    
    
    @IBAction func clearTapped(_ sender: Any) {
        imgCanvas.image = nil
        self.object.text = ""
    }
    
    
    @IBOutlet var object: UILabel!
    
    
    @IBOutlet var imgCanvas: UIImageView!
    
    var lastTouch = CGPoint.zero
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let firstTouch = touches.first {
            lastTouch = firstTouch.location(in: view)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let firstTouch = touches.first {
            let touchLocation = firstTouch.location(in: view)
            
            drawLine(from: lastTouch, to: touchLocation)
            
            lastTouch = touchLocation
        }
    }
    
    func drawLine(from: CGPoint, to: CGPoint) {
        UIGraphicsBeginImageContext(imgCanvas.frame.size)
        
        let context = UIGraphicsGetCurrentContext()
        
        context?.move(to: from)
        context?.addLine(to: to)
        
        context?.setLineCap(.round)
        context?.setLineWidth(10)
        
        let red: CGFloat = CGFloat(arc4random_uniform(256)) / 255
        let green: CGFloat = CGFloat(arc4random_uniform(256)) / 255
        let blue: CGFloat = CGFloat(arc4random_uniform(256)) / 255
        
        context?.setStrokeColor(red: red, green: green, blue: blue, alpha: 1)
        
        context?.strokePath()
        
        imgCanvas.image?.draw(in: imgCanvas.frame)
        imgCanvas.image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}



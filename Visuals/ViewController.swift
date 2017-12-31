//
//  ViewController.swift
//  Visuals
//
//  Created by Marcos Polanco on 12/19/17.
//  Copyright © 2017 Visor Labs. All rights reserved.
//

import UIKit
import CoreML
import Vision
import SwiftyCam


class PhotoViewController: SwiftyCamViewController {
    
    @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var shootButton: SwiftyCamButton!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.cameraDelegate = self
        shootButton.delegate = self

        //label.backgroundColor = UIColor.
    }
    
    func predict(_ image: UIImage)  {
        guard let model = try? VNCoreMLModel(for: MobileNet().model) else {return}
        
        let request = VNCoreMLRequest(model: model) {[weak self] request, error in
            guard let guess = request.results?.first as? VNClassificationObservation else {return}
            self?.label.text = "\(guess.confidence) \(guess.identifier)"

        }
        let handler = VNImageRequestHandler(cgImage: image.cgImage!, options: [:])
        
        do {
            try handler.perform([request])
        } catch {
            debugPrint(error)
        }
    }
}

extension PhotoViewController: SwiftyCamViewControllerDelegate {
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didTake photo: UIImage) {
        self.predict(photo)
    }
}

extension UILabel {
    func contrast() {
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 3.0
    }
}

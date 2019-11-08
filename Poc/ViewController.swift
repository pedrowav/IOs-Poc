//
//  ViewController.swift
//  Poc
//
//  Created by Pedro Eduardo Waquim on 11/7/19.
//  Copyright © 2019 Pedro Eduardo Waquim. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, URLSessionDelegate {
    
    var imagePicker: UIImagePickerController!
    var image: UIImage!
    
    @IBOutlet weak var imageView: UIImageView!
    
    private lazy var urlSession: URLSession = {
        let config = URLSessionConfiguration.background(withIdentifier: "MySession")
        config.isDiscretionary = true
        config.sessionSendsLaunchEvents = true
        return URLSession(configuration: config, delegate: self, delegateQueue: nil)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Controller")
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func takePhoto(_ sender: Any) {
        if (UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)) {
            imagePicker =  UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            
            present(imagePicker, animated: true, completion: nil)
        } else {
            imageView.image = UIImage(named: "zelda_image")
            uploadImage(image: imageView.image!)
            // Just for proof that download work
            /*fetch {
                updateUI()
            }*/
        }
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func downloadImage(from url: URL) {
        print("Download Started")
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            DispatchQueue.main.async() {
                self.image = UIImage(data: data)
                self.updateUI()
            }
        }
    }
    
    func fetch(_ completion: () -> Void) {
        //This is call from the background
        print("fetch")
        downloadImage(from: URL(string: "https://i.blogs.es/7a04ff/analisis-legend-zelda-breath-wild/450_1000.jpg")!)
        completion()
    }
    
    func updateUI() {
        print("update")
        self.imageView.image = image
    }
    
    
    // old method, not ended
    func uploadImage(image: UIImage) {
        /*let urlRequest = URLRequest(url: <#T##URL#>)
        let data = UIImagePNGRepresentation(image)
        urlSession.uploadTask(with: urlRequest, from: data!)
         */
    }

    /*
    Method to open the camera. I need update Xcode for use it.
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        imagePicker.dismiss(animated: true, completion: nil)
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.image = image
            uploadImage(image: imageView.image!)
        }
    }*/
}


//
//  TodayViewController.swift
//  TestTodayExtension
//
//  Created by Aleksandar Atanackovic on 11/15/16.
//  Copyright © 2016 Aleksandar Atanackovic. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
        
    @IBOutlet weak var labelSubtitle: UILabel!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    var hasContent = false
    
    private let testUrlString = "https://api.myjson.com/bins/36vps"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchData(urlString: testUrlString) { (data) in
            guard let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]  else {
                return
            }
            self.updateUI(simpleData: DummyData(jsonResponse: jsonResponse))
        }

        // Do any additional setup after loading the view from its nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        
        fetchData(urlString: testUrlString) { (data) in
            guard let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]  else {
                return
            }
            self.updateUI(simpleData: DummyData(jsonResponse: jsonResponse))
            completionHandler(NCUpdateResult.newData)
        }
    }

    
    func updateUI(simpleData:DummyData) {
        DispatchQueue.main.async {
            self.labelTitle.text = simpleData.title
            self.labelSubtitle.text = simpleData.subTitle
            self.view.layoutIfNeeded()
        }
        fetchData(urlString: simpleData.imageUrl) { (data) in
            DispatchQueue.main.async {
                self.imageView.image = UIImage(data: data)
            }
        }
        
    }
    
}

extension TodayViewController {
    
    func fetchData(urlString: String, completion: @escaping (_ data: Data) -> ()) {
        guard let url = URL(string: urlString) else {
            return
        }
        let session = URLSession.shared
        session.dataTask(with: url) { (data, response, error) in
            if let data = data {
                completion(data)
            }else {
                print(error?.localizedDescription ?? "error with no description")
            }

        }.resume()
        
    }
    
}

struct DummyData {
    
    var title:String
    var subTitle:String
    var imageUrl:String
    
    init(jsonResponse:[String: Any] ) {
        title = jsonResponse["title"] as? String ?? "No title"
        subTitle = jsonResponse["subTitle"] as? String ?? "No subtitle"
        imageUrl = jsonResponse["imageUrl"] as? String ?? ""
    }
}


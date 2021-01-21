//
//  WebViewController.swift
//  Weather
//
//  Created by kartheek.p on 21/01/21.
//  Copyright © 2021 Reshma.M. All rights reserved.
//

import UIKit
import WebKit
class WebViewController: UIViewController {
    @IBOutlet weak var webView: WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.webView.navigationDelegate = self
        if let url = Bundle.main.url(forResource: "help", withExtension: "html") {
            webView.load(URLRequest(url: url))
            showActivityView()
        }
        // Do any additional setup after loading the view.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
extension WebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        hideActivityView()
    }
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        hideActivityView()
    }
}
extension WebViewController {
    func showActivityView() {
        self.view.activityStartAnimating(activityColor: UIColor.white, backgroundColor: UIColor.black.withAlphaComponent(0.5))
        
    }
    func hideActivityView() {
        DispatchQueue.main.async {
            self.view.activityStopAnimating()
        }
    }
}

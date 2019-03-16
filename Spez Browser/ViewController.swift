//
//  ViewController.swift
//  Spez Browser
//
//  Created by Konuk Kullanıcı on 14.03.2019.
//  Copyright © 2019 Spez Inc. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UISearchBarDelegate, UIWebViewDelegate {

    @IBOutlet weak var SearchBar: UISearchBar!
    @IBOutlet weak var WebView: UIWebView!
    
    @IBAction func back(_ sender: Any) {
        if WebView.canGoBack
        {
            WebView.goBack()
        }
    }
    
    @IBAction func refresh(_ sender: Any) {
        WebView.reload()
    }
    
    @IBAction func next(_ sender: Any) {
        if WebView.canGoForward
        {
            WebView.goForward()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        SearchBar.resignFirstResponder()
        
        if let url = URL(string: SearchBar.text!)
        {
            if (SearchBar.text?.contains("http"))!
            {
                WebView.loadRequest(URLRequest(url: url))
            }
            else
            {
                WebView.loadRequest(URLRequest(url: URL(string: "https://" + SearchBar.text!)!))
            }
        }
        else
        {
            print("Error when loading a page.")
        }
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        
        if let currentURL = webView.request?.url?.absoluteString{
            print(currentURL + "loaded.")
            SearchBar.text = currentURL
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        WebView.loadRequest(URLRequest(url: URL(string: "https://spezcomputer.weebly.com/")!))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


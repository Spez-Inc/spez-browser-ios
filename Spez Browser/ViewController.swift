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
    
    var err = "None"
    var errurl = "None"
    
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
        
        if ((SearchBar.text?.contains("."))! || (SearchBar.text?.contains(","))! || (SearchBar.text?.contains(":"))!)
        {
            if let url = URL(string: SearchBar.text!.lowercased())
            {
                if ((SearchBar.text?.contains("http://"))! || (SearchBar.text?.contains("https://"))! || (SearchBar.text?.contains("file://"))!)
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
                print("This is not a page.")
            }
            
        }
        else
        {
            let search = SearchBar.text
            let searchstr = search?.replacingOccurrences(of: " ", with: "+", options: .literal, range: nil)
            WebView.loadRequest(URLRequest(url: URL(string: "https://duckduckgo.com/?q=" + searchstr!)!))
        }
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        
        if let currentURL = WebView.request?.url?.absoluteString{
            print(currentURL + "loaded.")
            SearchBar.text = currentURL
        }
        
        if (SearchBar.text?.contains(".app/new-tab.html"))!
        {
            SearchBar.text = ""
        }
        
        if (SearchBar.text?.contains(".app/site-error.html"))!
        {
            WebView.stringByEvaluatingJavaScript(from: "setdet('" + err + "');")
        }
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        errurl = (WebView.request?.url?.absoluteString)!
        print("webview did fail load with error.")
        WebView.loadRequest(URLRequest(url: URL(fileURLWithPath: Bundle.main.path(forResource: "site-error", ofType: "html")!) as URL))
        err = error.localizedDescription
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        let searchBarStyle = SearchBar.value(forKey: "searchField") as? UITextField
        searchBarStyle?.clearButtonMode = .always
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        let searchBarStyle = SearchBar.value(forKey: "searchField") as? UITextField
        searchBarStyle?.clearButtonMode = .never

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        registerSettingsBundle()
        
        let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
        if launchedBefore  {
            print("Not first launch.")
        }
        else {
            print("First launch, setting NSUserDefault.")
            UserDefaults.standard.set(true, forKey: "launchedBefore")
            UserDefaults.standard.set("default", forKey: "homepage")
        }
        
                if (UserDefaults.standard.string(forKey: "homepage") == "default")
                {
                    self.WebView.loadRequest(URLRequest(url: URL(fileURLWithPath: Bundle.main.path(forResource: "new-tab", ofType: "html")!) as URL))
                }
                else
                {
                    let homepage = UserDefaults.standard.string(forKey: "homepage")
                    if ((self.SearchBar.text?.contains("http://"))! || (self.SearchBar.text?.contains("https://"))! || (self.SearchBar.text?.contains("file://"))!)
                    {
                        self.WebView.loadRequest(URLRequest(url: URL(string: homepage!)!))
                    }
                    else
                    {
                        self.WebView.loadRequest(URLRequest(url: URL(string: "https://" + homepage!)!))
                    }
                }
        
        self.navigationController?.navigationBar.topItem?.titleView = SearchBar
        let searchBarStyle = SearchBar.value(forKey: "searchField") as? UITextField
        searchBarStyle?.clearButtonMode = .never
        
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.defaultsChanged), name: UserDefaults.didChangeNotification, object: nil)
        defaultsChanged()
    }
    
    func registerSettingsBundle(){
        let appDefaults = [String:AnyObject]()
        UserDefaults.standard.register(defaults: appDefaults)
    }
    
    func defaultsChanged(){
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


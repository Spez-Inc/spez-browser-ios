//
//  ViewController.swift
//  Spez Browser
//
//  Created by Sarp Ertoksöz on 14.03.2019.
//  Copyright © 2019 Spez Inc. All rights reserved.
//

import UIKit
import SafariServices

class ViewController: UIViewController, UISearchBarDelegate, UIWebViewDelegate {

    // Initlaize UI elements
    @IBOutlet weak var SearchBar: UISearchBar!
    @IBOutlet weak var WebView: UIWebView!
    @IBOutlet weak var progbar: UIProgressView!
    
    var actionlatest = "None"
    var err = "None"
    var errurl = "None"
    
    @IBAction func goback(_ sender: Any) {
        // GO BACK
        if WebView.canGoBack {
            WebView.goBack()
        }
    }
    
    @IBAction func reload(_ sender: Any) {
        // REFRESH
        WebView.reload()
    }
    
    @IBAction func gonext(_ sender: Any) {
        // GO FORWARD
        if WebView.canGoForward {
            WebView.goForward()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        SearchBar.resignFirstResponder()
        
        // Detect is url or search string
        if ((SearchBar.text?.contains("."))! || (SearchBar.text?.contains(","))! || (SearchBar.text?.contains(":"))!)
        {
            // It is url
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
            // It is NOT url -- SEARCH
            let search = SearchBar.text?.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
            let searchstr = search?.replacingOccurrences(of: " ", with: "+", options: .literal, range: nil)
            WebView.loadRequest(URLRequest(url: URL(string: "https://duckduckgo.com/?q=" + searchstr!)!))
        }
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        // Start Load
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        progbar.setProgress(0.1, animated: false)
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        // Finish Load
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        progbar.setProgress(1.0, animated: true)
        
        
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
        // Load Fail
        errurl = (WebView.request?.url?.absoluteString)!
        print("webview did fail load with error.")
        WebView.loadRequest(URLRequest(url: URL(fileURLWithPath: Bundle.main.path(forResource: "site-error", ofType: "html")!) as URL))
        err = error.localizedDescription
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        // Show clean button
        let searchBarStyle = SearchBar.value(forKey: "searchField") as? UITextField
        searchBarStyle?.clearButtonMode = .always
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        // Hide clean button
        let searchBarStyle = SearchBar.value(forKey: "searchField") as? UITextField
        searchBarStyle?.clearButtonMode = .never

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // Register Settings Bundle
        registerSettingsBundle()
        
        // First launch settings
        let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
        if launchedBefore  {
            // Not first launch.
            print("Not first launch.")
        }
        else {
            // First launch, apply default settings.
            print("First launch, setting NSUserDefault.")
            UserDefaults.standard.set(true, forKey: "launchedBefore")
            UserDefaults.standard.set("default", forKey: "homepage")
        }
        
        // Homepage Load
                if (UserDefaults.standard.string(forKey: "homepage") == "default")
                {
                    // Default Homepage
                    self.WebView.loadRequest(URLRequest(url: URL(fileURLWithPath: Bundle.main.path(forResource: "new-tab", ofType: "html")!) as URL))
                }
                else
                {
                    // Custom Homepage
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
        
        // Navigation bar with Search Bar.
        self.navigationController?.navigationBar.topItem?.titleView = SearchBar
        // No clear button -- SearchBar.
        let searchBarStyle = SearchBar.value(forKey: "searchField") as? UITextField
        searchBarStyle?.clearButtonMode = .never
        
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.defaultsChanged), name: UserDefaults.didChangeNotification, object: nil)
        defaultsChanged()
        NotificationCenter.default.addObserver(self, selector: #selector(share), name: NSNotification.Name(rawValue: "share"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(read), name: NSNotification.Name(rawValue: "read"), object: nil)
    }
    
    func registerSettingsBundle(){
        let appDefaults = [String:AnyObject]()
        UserDefaults.standard.register(defaults: appDefaults)
    }
    
    func defaultsChanged(){
        
    }
    
    func share(){
        // Share Dialog
        let url: String = (self.WebView.request?.url?.absoluteString)!
        let shareVC = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        shareVC.popoverPresentationController?.sourceView = self.view
        self.present(shareVC, animated: true, completion: nil)
    }
    
    func read(){
        let urlString = (self.WebView.request?.url?.absoluteString)!
        let url = URL(string: urlString)
        let safariVC = SFSafariViewController(url: url!, entersReaderIfAvailable: true)
        present(safariVC, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


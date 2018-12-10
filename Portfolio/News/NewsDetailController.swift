//
//  NewsDetailController.swift
//  Portfolio
//
//  Created by 안정은 on 10/12/2018.
//  Copyright © 2018 portfolio. All rights reserved.
//

import UIKit
import WebKit

class NewsDetailController: UIViewController {
    //데이터를 받을 변수 생성
    var data : String?
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //데이터가 있을 때
        if let siteaddr = data{
            //url이 정상적으로 만들어졌을 때
            if let url = URL(string: siteaddr){
                //웹뷰가 로딩
                let request = URLRequest(url: url)
                
                /*
                 //웹뷰 설정
                 let preferences = WKPreferences()
                 preferences.javaScriptEnabled = true
                 let configuration = WKWebViewConfiguration()
                 configuration.preferences = preferences
                 configuration.userContentController = WKUserContentController()
                 configuration.userContentController.add(self, name: "AppModel")
                 
                 let webView = WKWebView(frame: self.view.frame, configuration: configuration)
                 
                 self.view.addSubview(webView)
                 */
                webView.load(request)
                //로딩중일 때만 보이는 indicator을 위해서 필요한 코드
                webView.uiDelegate = self
                webView.navigationDelegate = self
            }
                //url이 정상적으로 만들어지지 않았을 때
            else{
                let alert = UIAlertController(title: "잘못된 url입니다.", message: "", preferredStyle: .alert)
                let ok = UIAlertAction.init(title: "확인", style: .cancel)
                //alert 버튼 적용
                alert.addAction(ok)
                //alert를 화면에 적용
                self.present(alert, animated: true)
            }
        }
            //데이터가 없을 때
        else{
            let alert = UIAlertController(title: "url이 없습니다.", message: "", preferredStyle: .alert)
            let ok = UIAlertAction.init(title: "확인", style: .cancel)
            //alert 버튼 적용
            alert.addAction(ok)
            //alert를 화면에 적용
            self.present(alert, animated: true)
        }
    }
}
extension NewsDetailController : WKUIDelegate, WKNavigationDelegate{
    
    //웹뷰가 로딩을 시작했을 때 호출되는 메소드
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        self.indicator.startAnimating()
        
        
    }
    //웹뷰가 로딩을 끝냈을 때 호출되는 메소드
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.indicator.stopAnimating()
        
        
    }
    //웹뷰가 로딩에 실패했을 때 호출되는 메소드
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        self.indicator.stopAnimating()
        
        
        
        let alert = UIAlertController(title: "페이지 로딩에 실패했습니다.", message: "", preferredStyle: .alert)
        let ok = UIAlertAction.init(title: "확인", style: .cancel)
        //alert 버튼 적용
        alert.addAction(ok)
        //alert를 화면에 적용
        self.present(alert, animated: true)
    }
}

extension NewsDetailController{
    
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        let alert = UIAlertController(title: nil , message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default, handler: {action in completionHandler()})
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: {(action) in completionHandler(false)})
        let okAction = UIAlertAction(title: "확인", style: .default, handler: {action in completionHandler(true)})
        
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Void) {
        
    }
    
}

//
//  NewsController.swift
//  Portfolio
//
//  Created by 안정은 on 10/12/2018.
//  Copyright © 2018 portfolio. All rights reserved.
//

import UIKit
class News{
    var title : String!
    var link : String!
    var content : String!
    var pubdate : String!
}
class NewsController: UITableViewController {
    //데이터를 담을 list
    lazy var list : [News] = {
        var newsList = [News]()
        return newsList
    }()
    
    func download(){
        //URL을 생성해서 다운로드 받기
        //다운로드 받을 URL 만들기
        let url = "http://192.168.2.3:8080/portfolio/mobile/mfdsnews"
        let newsURI : URL! = URL(string: url)
        //REST API를 호출
        let data = try! Data(contentsOf: newsURI)
        
        //데이터 전송 결과를 로그로 출력
        let log = NSString(data: data, encoding: String.Encoding.utf8.rawValue) as String?
        //print("API Result=\( log! )")
        
        //예외처리
        do{
            //전체 데이터를 디셔너리로 만들기
            let newsDict =
                try JSONSerialization.jsonObject(with: data, options: []) as! NSDictionary
            //response 키의 값을 디셔너리로 가져오기
            let arrayData = newsDict["data"] as! NSArray
            //배열을 순회
            for row in arrayData{
                //하나하나 가져오는 걸 딕셔너리로 풀어줌
                let imsi = row as! NSDictionary
                
                let news = News()
                news.title = imsi["title"] as? String
                news.pubdate = imsi["pubdate"] as? String
                news.content = imsi["content"] as? String
                news.link = imsi["link"] as? String
                
                self.list.append(news)
            }
            //print(self.list)
            //데이터 뷰 재출력
            self.tableView.reloadData()
        }catch{
            print("파싱 예외 발생")
        }
    }
    
    //refreshControl 이 화면에 보여질 때 호출될 메소드
    @objc func hadleRequest(_ refreshControl:UIRefreshControl){
        self.download()
        //refreshControl 애니메이션 중지
        refreshControl.endRefreshing()
    }
    
    override func viewDidLoad() {
        self.download()
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem.init(title: "기사목록", style: .done, target: nil, action: nil)
        super.viewDidLoad()
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.addTarget(self, action: #selector(NewsController.hadleRequest(_:)), for: .valueChanged)
        self.refreshControl?.tintColor = UIColor.red
    }

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return list.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell", for: indexPath) as? NewsCell
        //행번호에 해당하는 데이터 가져오기
        let rowData = self.list[indexPath.row]
        cell?.titleLbl.text = rowData.title
        cell?.dateLbl.text = rowData.pubdate
        cell?.contentLbl.text = rowData.content
        return cell!
    }
    
    //셀의 높이를 설정하는 메소드
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 122
    }
    //셀이 선택되었을 때 호출되는 메소드
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        //하위 뷰 객체 만들기
        let newsDetailController = self.storyboard?.instantiateViewController(withIdentifier: "NewsDetailController") as? NewsDetailController
        //선택된 셀의 데이터 가져오기
        let rowData = self.list[indexPath.row]
        
        //데이터 넘기기
        newsDetailController?.data = rowData.link
        //네비게이션으로 페이지 이동
        self.navigationController?.pushViewController(newsDetailController!, animated: true)
    }
}

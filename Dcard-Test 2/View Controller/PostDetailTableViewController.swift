//
//  TableViewController.swift
//  Dcard-Test 2
//
//  Created by Ryan Chang on 2021/6/9.
//

import UIKit

class PostDetailTableViewController: UITableViewController {
    
    @IBOutlet var contentVV: ContentViewV!
    
    var post: Posts!
    var postDetail : PostDetail?
    var comments = [Comments]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        contentVV.titleLabel.text = ""
        fetchPostData()
        fetchComments()
        
        //設定navigationController
        let nc = navigationController
        nc?.hidesBarsOnSwipe = false //上滑時會隱藏navigationBar
        
        
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    
    
    func fetchPostData() {
        print(post.id)
        print("fetchPostData")
        let urlStr = "https://www.dcard.tw/service/api/v2/posts/\(post.id)"
        if let url = URL(string: urlStr) {
            URLSession.shared.dataTask(with: url) { data, response, error in
                let decoder = JSONDecoder()
                let dateFormatter = ISO8601DateFormatter()
                dateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
                decoder.dateDecodingStrategy = .custom({ (decoder) -> Date in
                    let container = try decoder.singleValueContainer()
                    let dateString = try container.decode(String.self)
                    if let date = dateFormatter.date(from: dateString) {
                        print("data = data")
                        return date
                    } else {
                        throw DecodingError.dataCorruptedError(in: container, debugDescription: "")
                    }
                })
                if let data = data, let postDetails = try? decoder.decode(PostDetail.self, from: data) {
                    self.postDetail = postDetails
                    print("postdetails")
                    print(postDetails)
                    //將內文以 \n 拆開，並存入 array
                    let contentSplit = self.postDetail?.content.split(separator: "\n").map(String.init)
                    let mutableAttributedString = NSMutableAttributedString()
                    contentSplit?.forEach({ row in
                        if row.contains("https") {
                            mutableAttributedString.append(imageSource: row, labelText: self.contentVV.commentLabel)
                        } else {
                            mutableAttributedString.append(string: row)
                        }
                    })
                    DispatchQueue.main.async { [self] in
                        let formatter = DateFormatter()
                        formatter.dateFormat = "yyyy/mm/dd hh:mm"
                        let timeText = formatter.string(from: postDetails.createdAt)
                        self.contentVV.dateLabel.text = timeText
                        self.contentVV.commentLabel.attributedText = mutableAttributedString
                        
                        if let likecount = postDetail?.likeCount,
                           let commentCount = postDetail?.commentCount,
                           let school = post.school {
                            contentVV.likeCountLabel.text = String(likecount)
                            contentVV.commentCountLabel.text = String(commentCount)
                            contentVV.schoolLabel.text = school
                        }else {
                            contentVV.likeCountLabel.text = "0"
                            contentVV.commentCountLabel.text = "0"
                            contentVV.schoolLabel.text = "匿名"
                        }
                        contentVV.titleLabel.text = post.title
                        contentVV.forumsNameLabel.text = post.forumName
                        self.tableView.reloadData()
                    }
                }
            }.resume()
        }
    }
    
    
    func fetchComments() {
        
        let urlStr = "https://www.dcard.tw/service/api/v2/posts/\(post.id)/comments"
        if let url = URL(string: urlStr) {
            URLSession.shared.dataTask(with: url) { data, response, error in
                let decoder = JSONDecoder()
                let dateFormatter = ISO8601DateFormatter()
                dateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
                decoder.dateDecodingStrategy = .custom({ (decoder) -> Date in
                    let container = try decoder.singleValueContainer()
                    let dateString = try container.decode(String.self)
                    if let date = dateFormatter.date(from: dateString) {
                        return date
                    } else {
                        throw DecodingError.dataCorruptedError(in: container, debugDescription: "")
                    }
                })
                if let data = data, let comment = try? decoder.decode([Comments].self, from: data) {
                    self.comments = comment
                    print(comment)
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }.resume()
        }
    }
    
    
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return contentVV
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return comments.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PostDetailTableViewCell", for: indexPath) as? PostDetailTableViewCell else { return PostDetailTableViewCell()}
        
        let item = comments[indexPath.row]
        cell.commentsLabel.text = item.content
        cell.floorLabel.text =  String("B\(item.floor)。")
        
        if item.school == "" || item.school == nil {
            cell.schoolLabel.text = "匿名"
        }else {
            cell.schoolLabel.text = item.school
        }
        
        if item.gender == "M" {
            cell.genderImageView.image = UIImage(named: "M")
        }else {
            cell.genderImageView.image = UIImage(named: "F")
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd hh:mm:ss"
        cell.createdAtLabel.text = formatter.string(from: item.createdAt)
        
        return cell
    }
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    
    //未完成的loding view
    let loadIndicatorView:UIActivityIndicatorView = {
        let loading = UIActivityIndicatorView()
        loading.center = CGPoint(x: UIScreen.main.bounds.height , y: UIScreen.main.bounds.width)
        loading.color = .white
        loading.style = .large
        
        return loading
    }()
    
    let glass:UIView = {
        let blurEffect = UIBlurEffect(style: .systemMaterialDark)
        let glassView = UIVisualEffectView(effect: blurEffect)
        glassView.frame = CGRect(x:0, y:0, width: UIScreen.main.bounds.width , height: (UIScreen.screens.first?.bounds.height)!)
        glassView.layer.cornerRadius = 15
        glassView.clipsToBounds = true
        return glassView
    }()
    
    func loading(){
        glass.alpha = 0
        self.view.addSubview(glass)
        self.view.addSubview(loadIndicatorView)
        loadIndicatorView.startAnimating()
        let animate = UIViewPropertyAnimator(duration: 3, curve: .easeIn) {
            self.navigationController?.navigationBar.isHidden = true
            self.glass.alpha = 1
        }
        animate.startAnimation()
    }
    
    func stopLoading(){
        let animate = UIViewPropertyAnimator(duration: 3, curve: .easeIn) {
            self.glass.alpha = 0
            self.navigationController?.navigationBar.isHidden = false
            self.glass.removeFromSuperview()
            self.loadIndicatorView.removeFromSuperview()
        }
        animate.startAnimation()
    }
    
    
}

//
//  DcardCollectionViewController.swift
//  Dcard-Test 2
//
//  Created by Ryan Chang on 2021/6/4.
//

import UIKit

private let reuseIdentifier = "\(Dcard_mainCollectionViewCell.self)"

class DcardCollectionViewController: UICollectionViewController {
    
    var post = [Posts]()
    var getAlias: String = ""
    var getName: String = ""
    
    @IBOutlet weak var loadingView: UIActivityIndicatorView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("DcardPosts:\(getAlias)")
        fetchData()
        refreshControl()
        
        // 設定navigation樣式
        
        navigationItem.title = getName
        let barButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        navigationItem.backBarButtonItem = barButtonItem
        let image = UIImage(systemName: "arrow.backward")
        let barAppearance = UINavigationBarAppearance()
        barAppearance.setBackIndicatorImage(image, transitionMaskImage: image)
        navigationController?.navigationBar.standardAppearance = barAppearance
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        // Do any additional setup after loading the view.
    }
    
    // 下拉更新cell
    func refreshControl() {
        let refreshcontroller = UIRefreshControl()
        let attributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        refreshcontroller.attributedTitle = NSAttributedString(string: "更新看看",attributes: attributes)
        refreshcontroller.tintColor = UIColor.white
        refreshcontroller.backgroundColor = UIColor.gray
        refreshcontroller.addTarget(self, action: #selector(fetchData), for: .valueChanged)
//        collectionView.addSubview(refreshcontroller)  //與下面相同
        collectionView.refreshControl = refreshcontroller
        
    }

    
    @objc func fetchData(){
        loadingView.startAnimating()
        let urlstr = "https://www.dcard.tw/service/api/v2/forums/\(getAlias)/posts"
        if let url = URL(string: urlstr){
            URLSession.shared.dataTask(with: url) { data, response, error in
                let decoder = JSONDecoder()
                if let data = data {
                    do {
                        let posts = try decoder.decode([Posts].self, from: data)
                        self.post = posts
                        DispatchQueue.main.async { [self] in
                            collectionView.reloadData()
                            collectionView.refreshControl?.endRefreshing() //如果沒有加上此段，下拉更新的視窗不會消失．．．
                            loadingView.stopAnimating()
                            loadingView.hidesWhenStopped = true
                        }
                    } catch  {
                        print("error")
                    }
                }
            }.resume()
        }
    }
    

    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using [segue destinationViewController].
     // Pass the selected object to the new view controller.
     }
     */
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return post.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Dcard-mainCollectionViewCell", for: indexPath) as? Dcard_mainCollectionViewCell else {return UICollectionViewCell()}
        
        //設定cell的內容
        
        let item = post[indexPath.item]
        cell.titleLabel.text = item.title
        cell.likeCountLabel.text = String(item.likeCount)
        cell.commentCountLabel.text = String(item.commentCount)
        
        if item.school != nil {
            cell.schoolLabel.text = item.school
        }else {
            cell.schoolLabel.text = "匿名"
        }
        cell.backgroundColor = UIColor.white
//        cell.layer.borderWidth = 5
        cell.layer.cornerRadius = 10
        cell.clipsToBounds = true
        
        return cell
    }
    
    //使用prepare 點擊進入下一頁
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let item = collectionView.indexPathsForSelectedItems?.first?.item,
           let controller = segue.destination as? PostDetailTableViewController {
            let post = post[item]
            controller.post = post
        }
    }
    
    // MARK: UICollectionViewDelegate
    
    /*
     // Uncomment this method to specify if the specified item should be highlighted during tracking
     override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment this method to specify if the specified item should be selected
     override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
     override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
     return false
     }
     
     override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
     return false
     }
     
     override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
     
     }
     */
    
}

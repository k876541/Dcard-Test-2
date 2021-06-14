//
//  ForumsCollectionViewController.swift
//  Dcard-Test 2
//
//  Created by Ryan Chang on 2021/6/7.
//

import UIKit

private let reuseIdentifier = "Cell"

class ForumsCollectionViewController: UICollectionViewController {
    
    var forum = [Forums]()
    
    @IBOutlet weak var loadingView: UIActivityIndicatorView!
    
    let searchController = UISearchController(searchResultsController: nil) //宣告來使用searchController
    var filterLsit = [Forums]() //這裡的用來存取過濾後的看板資料(searchBar 使用)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchData()
        configureSearchController() //呼叫使用searchBar 以及 navation controller 定義
        
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        // Do any additional setup after loading the view.
    }
    
    //獲取資料
    @objc func fetchData(){
        loadingView.startAnimating()
        print("fetchData")
        let urlstr = "https://www.dcard.tw/service/api/v2/forums"
        if let url = URL(string: urlstr){
            URLSession.shared.dataTask(with: url) { data, response, error in
                let decoder = JSONDecoder()
                if let data = data {
                    do {
                        let forums = try decoder.decode([Forums].self, from: data)
                        self.forum = forums
                        DispatchQueue.main.async { [self] in
                            filterLsit = forum //獲取完資料後把資料型別同時也存進去過濾資料的filterLsit
                            collectionView.reloadData()
                            loadingView.stopAnimating()
                            loadingView.hidesWhenStopped = true
                        }
                    } catch  {
                        print(error)
                    }
                }
            }.resume()
        }
    }
    
    
    
    //下拉更新 (原本有做,但是發現看板資料不太需要更新)
    //    func refreshControl() {
    //
    //        let refreshcontroller = UIRefreshControl()
    //        let attributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
    //
    //        refreshcontroller.attributedTitle = NSAttributedString(string: "更新看看",attributes: attributes)
    //        refreshcontroller.tintColor = UIColor.white
    //        refreshcontroller.backgroundColor = UIColor.gray
    //        refreshcontroller.addTarget(self, action: #selector(fetchData), for: .valueChanged)
    //        collectionView.addSubview(refreshcontroller)
    //    }
    //
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     */
    
    // MARK: UICollectionViewDataSource
    
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    //因為search Controller會改變cell的數量,所以只要searchController啟動,就會改變
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.searchController.isActive {
            return filterLsit.count
        }else {
            return forum.count
        }
        // #warning Incomplete implementation, return the number of items
    }
    
    //
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ForumsCollectionViewCell" , for: indexPath) as? ForumsCollectionViewCell else {return UICollectionViewCell()}
        
        let searchResult = filterLsit[indexPath.item]
        cell.forumsNameLabel.text = searchResult.name
        //預覽文章照片
        if searchResult.logo != nil  {
            let imageUrl = searchResult.logo?.url
            URLSession.shared.dataTask(with: imageUrl!) { data, response, error in
                if let data = data {
                    DispatchQueue.main.async {
                        cell.logoImageView.image = UIImage(data: data)
                    }
                }
            }.resume()
        }else {
            cell.logoImageView.image = UIImage(named: "dcard")
        }
        
        // 改變cell的外型讓他變成圓弧狀
        cell.backgroundColor = UIColor.white
        //cell.layer.borderColor = UIColor.gray.cgColor
        //cell.layer.borderWidth = 5
        cell.layer.cornerRadius = 10
        cell.clipsToBounds = true
        
        return cell
    }
    
    
    //使用prepare 點擊後跳下一頁
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("prepare")
        
        if let item = collectionView.indexPathsForSelectedItems?.first?.item,
           let controller = segue.destination as? DcardCollectionViewController {
            let gets = filterLsit[item].alias
            let names = filterLsit[item].name
            print("gets:\(gets), names:\(names)")
            controller.getAlias = gets
            controller.getName = names
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


//把UISearchResultsUpdating 和 UISearchBarDelegate都放在這裡
extension ForumsCollectionViewController: UISearchResultsUpdating, UISearchBarDelegate{
    
    //讀取搜尋的文字(但有個小問題就是：如果沒有任何文字時，應該要全部的cell都出現，只是因為還是啟動searchController的狀態下，所以不會出現任何cell
    func updateSearchResults(for searchController: UISearchController) {
        if self.searchController.searchBar.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).count == 0{
            return
        }
        self.filterDataSource() //textField有超過一個字就會跳進來
    }
    
    //過濾搜尋的文字
    func filterDataSource() {
        filterLsit = forum.filter({ (forums) -> Bool in
            let searchText = searchController.searchBar.text!
            print("filterlist:\(searchText)")
            return forums.name.lowercased().contains(self.searchController.searchBar.text!)
        })
        collectionView.reloadData()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        //因有遵守UISearchResultsUpdating協議的話，則輸入文字的當下即會觸發updateSearchResults,可依個人需求決定，也不一定要跟法蘭克一樣選擇不實作)
    }
    
    // 點擊searchBar上的取消按鈕，因為沒有輸入文字時還是啟動searchController，所以這邊增加點擊“取消”鈕來重置cell
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchController.isActive = false
        fetchData()
        filterLsit = forum
    }
    
    // 點擊searchBar的搜尋按鈕時
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // 在「輸入文字時」即會觸發 updateSearchResults 的 delegate 做查詢的動作
        // 關閉瑩幕小鍵盤
        self.searchController.searchBar.resignFirstResponder()
    }
    
    
    func configureSearchController() {
        // 將 delegate 設為 self，之後會使用 UISearchResultsUpdater 的方法
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "尋找看板"
        searchController.searchBar.tintColor = .black
        searchController.searchBar.barTintColor = .black
        searchController.searchBar.searchBarStyle = .default
        searchController.searchBar.sizeToFit()
        
        // 搜尋時是否隱藏 NavigationBar
        searchController.hidesNavigationBarDuringPresentation = false
        // 將navigationItem.searchController 設置為我們的 searchController
        navigationItem.searchController = searchController
        navigationItem.title = "熱門看板"
        navigationController?.navigationBar.backgroundColor = UIColor.white
        navigationController?.hidesBarsOnSwipe = false
    }
    
    
}

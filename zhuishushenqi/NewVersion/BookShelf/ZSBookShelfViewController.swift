//
//  ZSBookShelfViewController.swift
//  Alamofire
//
//  Created by caony on 2019/6/17.
//

import UIKit
import SnapKit
import SafariServices

enum ShelfNav:Int {
    case gift = 0
    case search
    case history
    case more
    
    // community
    case mine
    case notification
    
    var image:UIImage? {
        switch self {
        case .gift:
            return UIImage(named: "bookshelf_icon_gift_34_34")
        case .search:
            return UIImage(named: "bookshelf_icon_seach_34_34")
        case .history:
            return UIImage(named: "bookshelf_icon_history_34_34")
        case .more:
            return UIImage(named: "bookshelf_icon_more_34_34")
        case .mine:
            return UIImage(named: "bbs_icon_personal_34_34_34x34_")
        case .notification:
            return UIImage(named: "bbs_icon_message_34_34_34x34_")
        }
    }
    
    var needLogin:Bool {
        switch self {
        case .gift:
            return true
        case .search:
            return false
        case .history:
            return false
        case .more:
            return false
        case .mine:
            return true
        case .notification:
            return true
        }
    }
}

class ZSBookShelfViewController: BaseViewController, NavigationBarDelegate, ZSBookShelfHeaderDelegate,ZSShelfTableViewCellDelegate,ZSShelfOperatingViewDelegate {
    lazy var navImages:[ShelfNav] = {
        var images:[ShelfNav] = []
        let gifNav = ShelfNav(rawValue: 0)
        let searchNav = ShelfNav(rawValue: 1)
        let historyNav = ShelfNav(rawValue: 2)
        let moreNav = ShelfNav(rawValue: 3)

        if let _ = gifNav?.image {
            images.append(gifNav!)
        }
        if let _ = searchNav?.image {
            images.append(searchNav!)
        }
        if let _ = historyNav?.image {
            images.append(historyNav!)
        }
        if let _ = moreNav?.image {
            images.append(moreNav!)
        }
        return images
    }()
    
    lazy var navView:NavigationBar = {
        let navView = NavigationBar(navImages: self.navImages, delegate: self)
        return navView
    }()
    lazy var tableView:UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.sectionHeaderHeight = 0.01
        tableView.sectionFooterHeight = 0.01
        if #available(iOS 11, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        }
        tableView.register(ZSShelfTableViewCell.self, forCellReuseIdentifier: "\(ZSShelfTableViewCell.self)")
        tableView.qs_registerHeaderFooterClass(ZSBookShelfHeaderView.self)
        let blurEffect = UIBlurEffect(style: .extraLight)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        tableView.backgroundView = blurEffectView
        return tableView
    }()
    
    var shelfViewModel:ZSBookShelfViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        observe()
        setupSubviews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
        automaticallyAdjustsScrollViewInsets = false
        self.tableView.reloadData()
        ZSShelfManager.share.refresh()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    @objc
    func refreshAction() {
        shelfViewModel?.requestMsg()
    }
    
    func stopRefresh() {
        tableView.mj_header.endRefreshing()
    }
    
    func setupSubviews() {
        view.addSubview(navView)
        view.addSubview(tableView)
        navView.snp.makeConstraints { (make) in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(kNavgationBarHeight)
        }
        tableView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(self.navView.snp.bottom)
            make.bottom.equalToSuperview().offset(-kTabbarBlankHeight - 49)
        }
        let mj_header = ZSRefreshTextHeader(refreshingTarget: self, refreshingAction: #selector(refreshAction))
        mj_header?.endRefreshingCompletionBlock = { [weak mj_header] in
            mj_header?.changeText()
        }
        tableView.mj_header = mj_header
        mj_header?.beginRefreshing()
    }
    
    func observe() {
        shelfViewModel = ZSBookShelfViewModel()
        shelfViewModel?.reloadBlock = { [weak self] in
            DispatchQueue.main.async {
                self?.stopRefresh()
                self?.tableView.reloadData()
            }
        }
        NotificationCenter.default.addObserver(self, selector: #selector(localChangeNoti(noti:)), name: NSNotification.Name.ShelfChanged, object: nil)
    }
    
    func jumpCheck(type:ShelfNav, next:@escaping ()->Void) {
        if type.needLogin {
            if !ZSLogin.share.hasLogin() {
                login { (success) in
                    success ? next():nil
                }
            } else {
                next()
            }
        } else {
            next()
        }
    }
    
    func jump(type:ShelfNav) {
//        https://h5.zhuishushenqi.com/v2/taskCenter.html?platform=ios&special=51&specialTasks=video&token=ob8lW49OQcetLaIyca394642ed0c48d0f87002693d0015cafeffd2ba2ea7e151bde405328e202a428ac3920683328908d400567735a62aab55750a2f65c58035e0e43ed270454a06fb54753b21b8434494c192e3d330af0c&timestamp=1561889416.124459&gender=female&version=14&packageName=com.ifmoc.ZhuiShuShenQi
        switch type {
        case .gift:
            let timeInterval = Date().timeIntervalSince1970
            let webVC = ZSWebViewController()
            webVC.url = "https://h5.zhuishushenqi.com/v2/taskCenter.html?platform=ios&special=51&specialTasks=video&token=\(ZSLogin.share.token)&timestamp=\(timeInterval)&gender=female&version=\(14)&packageName=com.ifmoc.ZhuiShuShenQi"
            webVC.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(webVC, animated: true)
            break
        case .search:
            let searchVC = ZSSearchBookViewController()
            searchVC.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(searchVC, animated: true)
            break
        case .history:
            alert(with: "提示", message: "该功能待上线,请更新版本后再次尝试!", okTitle: "确定")
            break
        case .more:
            let localVC = ZSBookLocalShelfViewController()
            localVC.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(localVC, animated: true)
            break
        default:
            break
        }
    }
    
    func messageHandle() {
        // 存在三种可能,post,link,booklist
        if let message = shelfViewModel?.shelfMsg {
            let title = message.postMessage()
            let type = title.2
            if type == .link {
                if let url = URL(string: title.0) {
                    let safariVC = SFSafariViewController(url: url)
                    self.present(safariVC, animated: true, completion: nil)
                }
            } else if type == .post {
                let id = title.0
                let comment = BookComment()
                comment._id = id
                let commentVC = ZSBookCommentViewController(style: .grouped)
                commentVC.hidesBottomBarWhenPushed = true
                commentVC.viewModel.model = comment
                navigationController?.pushViewController(commentVC, animated: true)
            } else if type == .booklist {
                let topicVC = QSTopicDetailRouter.createModule(id: title.0)
                topicVC.hidesBottomBarWhenPushed = true
                navigationController?.pushViewController(topicVC, animated: true)
            }
        }
    }
    
    //MARK: - local handler
    @objc
    private func localChangeNoti(noti:Notification) {
        tableView.reloadData()
    }
    
    //MARK: - changeIndex
    private func move(from:IndexPath, to:IndexPath) {
        ZSShelfManager.share.change(from: from.row, to: to.row)
        tableView.reloadData()
    }
    
    //MARK: - NavigationBarDelegate
    func navView(navView: NavigationBar, didSelect at: Int) {
        if let nav = ShelfNav(rawValue: at) {
            jumpCheck(type: nav) { [weak self] in
                self?.jump(type: nav)
            }
        }
    }
    
    //MARK: - ZSBookShelfHeaderDelegate
    func headerView(headerView: ZSBookShelfHeaderView, didClickLoginButton: UIButton) {
        let loginVC = ZSLoginViewController()
        present(loginVC, animated: true, completion: nil)
    }
    
    func headerView(headerView: ZSBookShelfHeaderView, didClickMsgButton: UIButton) {
        messageHandle()
    }
    
    //MARK: - ZSShelfTableViewCellDelegate
    func shelfCell(cell: ZSShelfTableViewCell, clickMore: UIButton) {
        if let indexPath = tableView.indexPath(for: cell) {
            let book = ZSShelfManager.share.books[indexPath.row]
            if book.bookType == .online {
                ZSShelfManager.share.aikan(book) { [weak self] (result) in
                    guard let aikan = result else { return }
                    let opView = ZSShelfOperatingView(frame: UIScreen.main.bounds)
                    opView.delegate = self
                    opView.configure(book: aikan)
                    opView.indexPath = indexPath
                    opView.show(inView: self?.view.window ?? self!.view)
                }
            } else {
                let opView = ZSShelfOperatingView(frame: UIScreen.main.bounds)
                opView.delegate = self
                opView.isLocalBook = true
                opView.bookUrl = book.bookUrl
                opView.indexPath = indexPath
                opView.show(inView: view.window ?? view)
            }
        }
    }
    
    //MARK: - ZSShelfOperatingViewDelegate
    func opView(opView: ZSShelfOperatingView, clickTop: UIButton) {
        guard let book = opView.book else { return }
        if book.bookType == .local {
            return
        }
        ZSBookCache.share.remove(book.bookName)
        ZSShelfManager.share.removeHistory(bookUrl: book.bookUrl)
        Toast.show(tip: "删除成功", .success, 1)
    }
    
    func opView(opView: ZSShelfOperatingView, clickDetail: UIButton) {
        let book = opView.book
        if book?.bookType == .local {
            return
        }
        let infoVC = ZSSearchInfoViewController()
        infoVC.model = book
        infoVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(infoVC, animated: true)
    }
    
    func opView(opView: ZSShelfOperatingView, clickDelete: UIButton) {
        if let book = opView.book {
            if ZSShelfManager.share.remove(book.bookUrl) {
                ZSShelfManager.share.remove(book.bookUrl)
                ZSShelfManager.share.removeAikan(bookUrl: book.bookUrl)
                ZSBookCache.share.remove(book.bookName)
                tableView.reloadData()
                Toast.show(tip: "删除成功", .success, 1)
            }
        } else if opView.isLocalBook {
            ZSShelfManager.share.removeLocalBook(bookUrl: opView.bookUrl)
            tableView.reloadData()
        }
    }
    
    func opView(opView: ZSShelfOperatingView, clickSource: UIButton) {
        let book = opView.book
        if book?.bookType == .local {
            return
        }
        if let source = ZSSourceManager.share.source(book?.host ?? "") {
            let addVC = ZSAddSourceViewController()
            addVC.source = source
            addVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(addVC, animated: true)
        }
    }
    
    func opView(opView: ZSShelfOperatingView, clickDownload: UIButton) {
        guard let book = opView.book else { return }
        guard let indexPath = opView.indexPath else { return }
        if book.bookType == .local {
            return
        }
        ZSReaderDownloader.share.download(book: book, start: 0) { [weak self] (index) in
            let cell = self?.tableView.cellForRow(at: indexPath) as? ZSShelfTableViewCell
            cell?.progress(value: CGFloat(index ?? 0), max: CGFloat(book.chaptersModel.count))
            if index == book.chaptersModel.count - 1 {
                cell?.finish()
                Toast.show(tip: "下载完成", .success, 1)
            }
        }
    }
}

extension ZSBookShelfViewController: UITableViewDataSource, UITableViewDelegate {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ZSShelfManager.share.books.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if let _ = shelfViewModel?.shelfMsg?.postMessage().1 {
            
            return ZSLogin.share.hasLogin() ? 90:134
        }
        return ZSLogin.share.hasLogin() ? 0.01:90
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.qs_dequeueReusableHeaderFooterView(ZSBookShelfHeaderView.self)
        headerView?.delegate = self
        headerView?.bind(msg: shelfViewModel?.shelfMsg)
        return headerView
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.qs_dequeueReusableCell(ZSShelfTableViewCell.self)
        cell?.selectionStyle = .none
        let book = ZSShelfManager.share.books[indexPath.row]
        cell?.configure(model: book)
        cell?.delegate = self
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let book = ZSShelfManager.share.books[indexPath.row]
        if book.bookType == .local {
            Toast.showProgress(tip: "加载中", onView: view)
            ZSShelfManager.share.aikan(book) { [weak self] (result) in
                if let aikan = result {
                    self?.jumpReader(book: aikan, indexPath: indexPath)
                } else if let shelf = QSReaderParse.parse(shelf: book) {
                    ZSShelfManager.share.addAikan(shelf)
                    self?.jumpReader(book: shelf, indexPath: indexPath)
                }
                Toast.hiden()
            }
        } else {
            ZSShelfManager.share.aikan(book) { [weak self] (result) in
                guard let aikan = result else { return }
                if aikan.chaptersModel.count > 0 {
                    let readerVC = ZSReaderController(chapter: nil, aikan)
                    readerVC.hidesBottomBarWhenPushed = true
                    self?.navigationController?.pushViewController(readerVC, animated: true)
                    self?.move(from: indexPath, to: IndexPath(row: 0, section: 0))
                    aikan.update = false
                    ZSShelfManager.share.modifyAikan(aikan)
                    self?.tableView.reloadData()
                } else {
                    self?.alert(with: "提示", message: "找不到该书籍", okTitle: "确定")
                }
            }
        }
    }
    
    private func jumpReader(book:ZSAikanParserModel, indexPath:IndexPath) {
        let readerVC = ZSReaderController(chapter: nil, book, bookType: book.bookType)
        readerVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(readerVC, animated: true)
        move(from: indexPath, to: IndexPath(row: 0, section: 0))
    }
}

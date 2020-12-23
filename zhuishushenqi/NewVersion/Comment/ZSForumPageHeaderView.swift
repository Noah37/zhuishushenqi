//
//  ZSForumPageHeaderView.swift
//  zhuishushenqi
//
//  Created by yung on 2019/8/6.
//  Copyright © 2019 QS. All rights reserved.
//

import UIKit

class ZSForumPageHeaderView: UITableViewHeaderFooterView, ZSForumToolBarDelegate {
    
    
    private lazy var iconView:UIImageView = {
        let view = UIImageView(frame: .zero)
        return view
    }()
    
    private lazy var nicknameLabel:UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = UIColor(red: 0.63, green: 0.53, blue: 0.48, alpha: 1.0)
        label.setContentHuggingPriority(UILayoutPriority.required, for: .horizontal)
        return label
    }()
    
    private lazy var tagView:UIImageView = {
        let imageView = UIImageView(image: UIImage(named: ""))
        return imageView
    }()
    
    private lazy var levelLabel:UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 9)
        label.textAlignment = .center
        label.textColor = UIColor(red: 0.63, green: 0.53, blue: 0.48, alpha: 1.0)
        label.layer.cornerRadius = 6.5
        label.layer.masksToBounds = true
        label.layer.borderColor = UIColor(red: 0.63, green: 0.53, blue: 0.48, alpha: 1.0).cgColor
        label.layer.borderWidth = 1
        return label
    }()
    
    private lazy var timeLabel:UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 9)
        label.textColor = UIColor.gray
        return label
    }()
    
    private lazy var titleLabel:UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = UIColor.black
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var displayView:ZSDisplayView = {
        let diplayView = ZSDisplayView(frame: .zero)
        return diplayView
    }()
    
    private lazy var toolBar:ZSForumToolBar = {
        let toolBar = ZSForumToolBar(frame: .zero)
        toolBar.delegate = self
        return toolBar
    }()

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = UIColor.white
        addSubview(iconView)
        addSubview(nicknameLabel)
        addSubview(tagView)
        addSubview(levelLabel)
        addSubview(timeLabel)
        addSubview(titleLabel)
        addSubview(displayView)
        addSubview(toolBar)
        
        iconView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            make.top.equalToSuperview().offset(20)
            make.width.equalTo(40)
            make.height.equalTo(40)
        }
        
        nicknameLabel.snp.makeConstraints { [unowned self] (make) in
            make.left.equalTo(self.iconView.snp_right).offset(10)
            make.top.equalTo(20)
            make.height.equalTo(20)
        }
        
        tagView.snp.makeConstraints { [unowned self](make) in
            make.left.equalTo(self.nicknameLabel.snp_right).offset(5)
            make.top.equalTo(24)
            make.width.equalTo(0)
            make.height.equalTo(12)
        }
        
        timeLabel.snp.makeConstraints { [unowned self](make) in
            make.left.equalTo(self.iconView.snp_right).offset(10)
            make.top.equalTo(self.nicknameLabel.snp_bottom)
            make.height.equalTo(20)
        }
        
        levelLabel.snp.makeConstraints { [unowned self](make) in
            make.left.equalTo(self.tagView.snp_right).offset(5)
            make.top.equalTo(23.5)
            make.width.equalTo(30)
            make.height.equalTo(13)
        }
        
        titleLabel.snp.makeConstraints { [unowned self](make) in
            make.left.equalTo(20)
            make.top.equalTo(self.iconView.snp_bottom).offset(10)
            make.right.equalToSuperview().offset(-20)
        }
        
        displayView.snp.makeConstraints { [unowned self](make) in
            make.left.equalToSuperview().offset(20)
            make.top.equalTo(self.titleLabel.snp_bottom).offset(10)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(0)
        }
        toolBar.snp.makeConstraints { [unowned self](make) in
            make.width.equalTo(250)
            make.height.equalTo(52)
            make.top.equalTo(self.displayView.snp_bottom).offset(20)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-20)
        }
        
    }
    
    func configure(review:ZSPostReview?) {
        guard let postReview = review else { return }
        iconView.qs_setAvatarWithURLString(urlString: postReview.author.avatar)
        nicknameLabel.text = postReview.author.nickname
        levelLabel.text = "lv.\(postReview.author.lv)"
        timeLabel.qs_setCreateTime(createTime: postReview.created, append: "")
        titleLabel.text = postReview.title
        let parser = MarkupParser()
        parser.parseContent(postReview.content, settings: CTSettings.shared)
        displayView.snp.updateConstraints { (make) in
            make.height.equalTo(parser.coreData?.height ?? 0)
        }
        displayView.buildContent(attr: parser.attrString, andImages: parser.coreData?.images ?? [], settings: CTSettings.shared)
        tagView.image = postReview.author.type.image
        if let _ = tagView.image {
            tagView.snp.updateConstraints { (make) in
                make.width.equalTo(12)
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    //MARK: - ZSForumToolBarDelegate
    func toolBar(toolBar: ZSForumToolBar, clickLikeButton: UIButton) {
        
    }
    
    func toolBar(toolBar: ZSForumToolBar, clickShareButton: UIButton) {
        
    }
    
    func toolBar(toolBar: ZSForumToolBar, clickMoreButton: UIButton) {
        
    }
    
}


//let str = "(-@y@) [扶眼镜]转眼间，2019已过半，年初制定的旅行计划都如期进行了吗？如果你错过了上半年的春风与花海，那一定要抓住夏日的阳光明媚和碧海蓝天，可以去凉爽的地方避暑，或是去炎热的地方酣畅淋漓。那么，你心目中最理想的夏日旅行城市是哪里，一起来互相安利吧~\n{{type:image,url:http%3A%2F%2Fstatics.zhuishushenqi.com%2Fpost%2F156289728628679,size:200-200}}\n◇活动时间：\n即日起~7月14日（周日）23:59截止\n（活动奖励在活动结束后七个工作日内发放）\n\n◇参与方式①：\n❀活动期间，在『社区』-『综合讨论区』发贴：\n标题中需含有：#旅行#+______（你的自定义标题）\n帖子中内容需符合主题~\n\nA.一等奖：追书券5000点（2人）\n要求：综合排名+官方管理员判定\nB.二等奖：追书券2000点（10人）\n要求：帖子点赞数+评论数-最多的前10位\nC.原创参与奖1——追书券1200点\n要求：只要参加+帖子原创内容正文（去水）至少300字\nD.原创参与奖2——追书券800点\n要求：只要参加+帖子原创内容正文（去水）至少100字\n\n◆敲黑板：原创哦~非原创是木有奖励的哦~被举报了会记上小本本的哦~\n◆在某一个评判要求获得数相同情况下，会根据综合因素进行官方判定。\n◆内容健康积极向上，不发布恶意调侃、引战、偏激等内容。\n\n◇参与方式②：直接回复本帖完成填空\n#旅行#+_________（和本帖话题相关内容）\n◆活动结束后，随机抽选奖励666追书\n【本栏目介绍】#7日挑战#\n——每周三，会从【近期版权书单】/【近期搜索较热】中挑选男女频各8~10本小说（记得加入书架）\n以周二23:59为截止点，收集大家的挑战结果！\n@追书白小妹会在每周四公布优秀挑战结果者的书评！挑战奖励会在每周四18点前发，名单奖励见我们家小妹的帖子！（参与活动的小伙伴记得收藏本帖）\nㄟ( ▔, ▔ )ㄏ\n【挑战难度 】★★★☆☆\n男频12本，女频12本，共计24本\n【参与方式】\n《挑战结果可含》\n☑ 7天内读了哪几本小说\n☑ 【必须】 用读后感证明自己读了该小说（并说明阅读进度，比如读了第22章后就……）\n☑ 可尽情吐槽/打分觉得该本小说是毒草、粮草还是仙草~\n☑ 以上挑战结果可直接在『社区』-『综合讨论区』发布tag标题#7日挑战#的话题\n（评论不算哦）\n==========\n【男频】\n[[book:5cefa8ed56c75f15e0b9ca03 《阴媒》【连载】作者：秋刀]]\n[[book:5ae6f10def182f2278eb8ca3 《踏天神王》【连载】作者：圆脸猫]]\n[[book:5b9245105d31bf29abaeeb66 《贴身军医》【连载】作者：山不转]]\n[[book:5b92451170b03a2a67179db6 《龙武九天》【连载】作者：绿柠茶]]\n[[book:5abcba073ee22f2527a102bc 《我是神界监狱长》【连载】作者：玄武]]\n[[book:5b49a237169b24797649e187 《剑道之神》【连载】作者：一道惊鸿]]\n[[book:5b92450b68d76629b04b7f25 《我在异界当神壕》【连载】作者：芝士就是力量]]\n[[book:5b00da54ca29bda54d84872f 《霸道大帝》【连载】作者：王者荣耀]]\n[[book:5be29290ff992d28351a3f77 《我的高冷女总裁》【连载】作者：疯狂的豆芽]]\n[[book:5be29291f5215e27fb234f85 《我有一双透视神瞳》【连载】作者：霸王说唱]]\n[[book:54181ca6e8b62bce29f70457 《无限异能：超禁忌游戏》【完结】作者：宁航一]]\n[[book:598c25aa9b72d5774b20be30 《长安十二时辰全集》【完结】作者：马伯庸]]\n\n---------------\n【女频】\n[[book:56225938a27063ef471e4d6f 《何所冬暖，何所夏凉》【完结】作者：顾西爵]]\n[[book:521b20186adaee123f01d36d 《一路繁花相送》【完结】作者：青衫落拓]]\n[[book:5c3db9457235b95cac24ba93 《豪门嗜宠：霆少的小甜妻》【完结】作者：落眠]]\n[[book:5c3db9457235b95cac24ba94 《快穿之职业打脸玩家》【完结】作者：尧小台]]\n[[book:5c3db928baab695c3f744a7c 《狼性总裁不可以》【完结】作者：棠溪]]\n[[book:5be29291ff992d28351a3f83 《邪肆太子妃》【连载】作者：梅果子]]\n[[book:5be2928e9074f627c600dab5 《契约首席：沈少宠上瘾》【连载】作者：香蕉雪糕]]\n[[book:5be2928d34d3702800b1de45 《迷人娇妻》【连载】作者：十夜]]\n[[book:5b9245070d939f2a2d21cd25 《说散就散》【连载】作者：多士喵]]\n[[book:55f361ca08d07d3220e1dd5f 《盛世狂妃：傻女惊华》【连载】作者：安懒]]\n[[book:582d31f60e607e2973999768 《绝色兽妃：冷狂嫡女逆天下》【连载】作者：流间月]]\n[[book:5be29292f5215e27fb2351a8 《妖孽来袭：逆天小凰妻》【连载】作者：水鱼摇]]\n\n---------------\n【范围】\n仅限 以上红字书籍传送门的小说\n\n【奖励】\n01.符合发帖要求参与（去水）至少100字，获得1000追书券\n02.符合发帖要求参与，在每周四官方V@追书白小妹公布的优秀挑战结果者，获得3000追书券\n记得标题前缀加#7日挑战#\n03.发布在综合区的试读结果会根据试读总情况进行综合判定为1个结果\n04.试读内容同步书评可获得额外奖励，按书评内容质量获得随机额度的书券（单期可累积）\n（评论不算哦）\n\n=======\n《评论奖励》\n本帖回复#追书#+_____（书名）推荐一本人物角色名字好玩的的小说，谢谢~\n\n* 活动结束后随机抽选奖励100书券\n* 本帖互动问题会从新版书荒互助区摘选[[post:5aa887f2fbf8675f7b9f3329 【点击红字了解详情】]]\n\n---------------\n❤觉得不错的小说记得加入书架和评分哦！\n❤看到不错的书评可以点【有用】鼓励下哦！\n-----看完后欢迎留下亲你的书评(✪ω✪)\n-----爱试读喜欢写书评的小伙伴，请加QQ群《497136897》"
//let parser = MarkupParser()
////            parser.parseMarkup(text)
//parser.parseContent(str)
//ctView = ZSDisplayView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height))
//scrollView.addSubview(ctView)
//ctView.buildContent(attr: parser.attrString, andImages: parser.coreData!.images)
//scrollView.contentSize = CGSize(width: self.view.bounds.width, height: parser.coreData!.height)

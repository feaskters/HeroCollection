//
//  GameViewController.swift
//  PurificationMonsters
//
//  Created by iOS123 on 2019/3/13.
//  Copyright © 2019年 iOS123. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {
    
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var selectView1: UIView!
    
    @IBOutlet weak var selectView2: UIView!
    
    @IBOutlet weak var gameView: UIView!
    
    @IBOutlet weak var score: UILabel!
    
    private var blocksArray : Array<Array<HeroView>> = Array<Array<HeroView>>.init()
    private var blocksSynchronizated : Array<HeroView> = Array<HeroView>.init() //已被选中的方块
    private var x = 10;
    private var y = 10;
    private var is_random = false;
    
    lazy var lockView : UIImageView = {
        let imageView = UIImageView.init(frame: CGRect.init(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2, width: 300, height: 300))
        imageView.image = UIImage.init(named: "lock")
        imageView.transform = CGAffineTransform.init(scaleX: 2, y: 2)
        self.gameView.addSubview(imageView)
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if self.x > 10 {
            for item in self.gameView.constraints{
                if item.identifier == "gvWidth"{
                    item.constant = 500
                    break
                }
            }
        }
        
        initBlocks()
        
//        UIView.animate(withDuration: 1) {
//            self.lockView.frame = self.blocksSynchronizated[0].frame
//        }
    }
    
    //初始化方块
    func initBlocks() {
        let gvHeight : CGFloat = 380
        let gvWidth : CGFloat = self.x < 10 ? 380 : 500
        let characterSquare : CGFloat = 47
        let spaceX = (gvWidth - characterSquare * CGFloat(x)) / CGFloat(x + 1)
        let spaceY = (gvHeight - characterSquare * CGFloat(y)) / CGFloat(y + 1)
        for i in 0...y - 1{
            self.blocksArray.append([])
            for j in 0...x - 1{
                let x = spaceX + CGFloat(j) * (characterSquare + spaceX)
                let y = spaceY + CGFloat(i) * (characterSquare + spaceY)
                let cv = HeroView.init(frame: CGRect.init(x: x, y: y, width: characterSquare, height: characterSquare))
                //获取type
                let type = Int(arc4random() % 6)
                self.gameView.addSubview(cv)
                cv.setType(type: type)
                cv.setPosition(x: i, y: j)
                self.blocksArray[i].append(cv)
            }
        }
        
        //判断是否随机
        if self.is_random{
            let y = Int(arc4random() % UInt32(self.blocksArray.count))
            let x = Int(arc4random() % UInt32(self.blocksArray[y].count))
            self.blocksArray[x][y].setFlag(flag: 1)
            self.blocksSynchronizated.append(self.blocksArray[x][y])
        }else{
            self.blocksArray[0][0].setFlag(flag: 1)
            self.blocksSynchronizated.append(self.blocksArray[0][0])
        }
    }
    
    @IBAction func back(_ sender: Any) {
        Music.shared().musicPlayEffective()
        UIView.animate(withDuration: 1, animations: {
            self.containerView.alpha = 0
            EffectiveClass.moveRightOutScreen(view: self.containerView)
        }) { (Bool) in
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    func setConfig(x:Int,y:Int,is_random:Bool) {
        self.x = x
        self.y = y
        self.is_random = is_random
    }
    
    @IBAction func changeHero(_ sender: UIButton) {
        Music.shared().musicPlayMergeEffective()
        
        //改变英雄并进行同化
        for item in self.blocksSynchronizated{
            item.setType(type: sender.tag)
            self.synchronizeBlocksAround(block: item)
        }
        
        for item in self.selectView1.subviews{
            (item as! UIButton).isEnabled = false
        }
        
        for item in self.selectView2.subviews{
            (item as! UIButton).isEnabled = false
        }
        //延时一秒后允许点击
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + TimeInterval(1)) {
            for item in self.selectView1.subviews{
                (item as! UIButton).isEnabled = true
            }
            for item in self.selectView2.subviews{
                (item as! UIButton).isEnabled = true
            }
            //判断是否结束游戏
            
        }
    }
    
    //同化周围的英雄
    func synchronizeBlocksAround(block:HeroView) {
        let position = block.getPosition()
        let x = position["x"]!
        let y = position["y"]!
        var flag = false //是否有可以同化的方块
        //左边方块
        if x > 0 && self.blocksArray[x - 1][y].getType() == block.getType() && self.blocksArray[x - 1][y].getFlag() == 0{
            self.blocksArray[x - 1][y].setFlag(flag: 1)
            self.blocksSynchronizated.append(self.blocksArray[x - 1][y])
            self.synchronizeBlocksAround(block: self.blocksArray[x - 1][y])
            flag = true
        }
        //右边方块
        if x < self.x - 1 && self.blocksArray[x + 1][y].getType() == block.getType() && self.blocksArray[x + 1][y].getFlag() == 0{
            self.blocksArray[x + 1][y].setFlag(flag: 1)
            self.blocksSynchronizated.append(self.blocksArray[x + 1][y])
            self.synchronizeBlocksAround(block: self.blocksArray[x + 1][y])
            flag = true
        }
        //上边方块
        if y > 0 && self.blocksArray[x][y - 1].getType() == block.getType() && self.blocksArray[x][y - 1].getFlag() == 0{
            self.blocksArray[x][y - 1].setFlag(flag: 1)
            self.blocksSynchronizated.append(self.blocksArray[x][y - 1])
            self.synchronizeBlocksAround(block: self.blocksArray[x][y - 1])
            flag = true
        }
        //下边方块
        if y < self.y - 1 && self.blocksArray[x][y + 1].getType() == block.getType() && self.blocksArray[x][y + 1].getFlag() == 0{
            self.blocksArray[x][y + 1].setFlag(flag: 1)
            self.blocksSynchronizated.append(self.blocksArray[x][y + 1])
            self.synchronizeBlocksAround(block: self.blocksArray[x][y + 1])
            flag = true
        }
        if !flag {
            return
        }
    }
    
}

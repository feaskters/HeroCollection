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
    
    private var herosArray : Array<Array<HeroView>> = Array<Array<HeroView>>.init()
    private var herosCollected : Array<HeroView> = Array<HeroView>.init() //已被选中的方块
    private var x = 10;
    private var y = 10;
    private var is_random = false;
    private var can_touch = false;
    private var score_num = 0;
    private var eat_count = 0;//分数翻倍
    private var addScoreTimer : Timer?
    
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
        
        UIView.animate(withDuration: 1) {
            self.lockView.frame = self.herosCollected[0].frame
            self.lockView.frame = CGRect.init(x: self.lockView.frame.origin.x + 10, y: self.lockView.frame.origin.y + 10, width: self.lockView.frame.width - 20, height: self.lockView.frame.height - 20)
        }
    }
    
    //初始化方块
    func initBlocks() {
        let gvHeight : CGFloat = 380
        let gvWidth : CGFloat = self.x < 10 ? 380 : 500
        let characterSquare : CGFloat = 47
        let spaceX = (gvWidth - characterSquare * CGFloat(x)) / CGFloat(x + 1)
        let spaceY = (gvHeight - characterSquare * CGFloat(y)) / CGFloat(y + 1)
        for i in 0...y - 1{
            self.herosArray.append([])
            for j in 0...x - 1{
                let x = spaceX + CGFloat(j) * (characterSquare + spaceX)
                let y = spaceY + CGFloat(i) * (characterSquare + spaceY)
                let cv = HeroView.init(frame: CGRect.init(x: x, y: y, width: characterSquare, height: characterSquare))
                //获取type
                let type = Int(arc4random() % 6)
                self.gameView.addSubview(cv)
                cv.setType(type: type)
                cv.setPosition(x: i, y: j)
                self.herosArray[i].append(cv)
            }
        }
        
        //判断是否随机
        if self.is_random{
            let y = Int(arc4random() % UInt32(self.herosArray.count))
            let x = Int(arc4random() % UInt32(self.herosArray[y].count))
            self.herosArray[y][x].setFlag(flag: 1)
            self.herosCollected.append(self.herosArray[y][x])
        }else{
            self.herosArray[0][0].setFlag(flag: 1)
            self.herosCollected.append(self.herosArray[0][0])
        }
        
        
        self.collectedHeroAround(hero: self.herosCollected[0])
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
        self.eat_count = 0;
        //改变英雄并进行同化
        for item in self.herosCollected{
            item.setType(type: sender.tag)
            self.collectedHeroAround(hero: item)
        }
        
        for item in self.selectView1.subviews{
            (item as! UIButton).isEnabled = false
        }
        
        for item in self.selectView2.subviews{
            (item as! UIButton).isEnabled = false
        }
        //加分
        self.changeScore()
        //延时一秒后允许点击
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + TimeInterval(1)) {
            for item in self.selectView1.subviews{
                (item as! UIButton).isEnabled = true
            }
            for item in self.selectView2.subviews{
                (item as! UIButton).isEnabled = true
            }
            //判断是否结束游戏
            self.judgeEnd()
        }
    }
    
    //修改分数
    func changeScore() {
        self.addScoreTimer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { (Timer) in
            if Int(self.score.text!)! < self.score_num{
                self.score.text = String(Int(self.score.text!)! + 1)
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.addScoreTimer?.invalidate()
        
    }
    
    //加分机制
    func addScore() {
        eat_count += 1
        self.score_num += 10 * eat_count
    }
    
    //判断结束
    func judgeEnd() {
        if self.herosCollected.count == self.x * self.y {
            self.gameOver()
        }
    }
    
    //弹出结算页面
    func gameOver() {
        let gov = GameOverView.init(frame: CGRect.init(x: 0, y: -400, width: self.gameView.frame.width + 200, height: self.gameView.frame.height - 50))
        let result = ["score" : String(self.score_num)]
        gov.setResult(result: result)
        self.containerView.addSubview(gov)
        UIView.animate(withDuration: 0.2) {
            gov.frame = CGRect.init(x: self.gameView.frame.origin.x - 100, y: self.gameView.frame.origin.y + 25, width: self.gameView.frame.width + 200, height: self.gameView.frame.height - 50)
        }
        self.can_touch = true
    }
    
    
    //同化周围的英雄
    func collectedHeroAround(hero:HeroView) {
        let position = hero.getPosition()
        let y = position["x"]!
        let x = position["y"]!
        var flag = false //是否有可以同化的方块
        //左边方块
        if x > 0 && self.herosArray[y][x - 1].getType() == hero.getType() && self.herosArray[y][x - 1].getFlag() == 0{
            self.addScore()
            self.herosArray[y][x - 1].setFlag(flag: 1)
            self.herosCollected.append(self.herosArray[y][x - 1])
            self.collectedHeroAround(hero: self.herosArray[y][x - 1])
            flag = true
        }
        //右边方块
        if x < self.x - 1 && self.herosArray[y][x + 1].getType() == hero.getType() && self.herosArray[y][x + 1].getFlag() == 0{
            self.addScore()
            self.herosArray[y][x + 1].setFlag(flag: 1)
            self.herosCollected.append(self.herosArray[y][x + 1])
            self.collectedHeroAround(hero: self.herosArray[y][x + 1])
            flag = true
        }
        //上边方块
        if y > 0 && self.herosArray[y - 1][x].getType() == hero.getType() && self.herosArray[y - 1][x].getFlag() == 0{
            self.addScore()
            self.herosArray[y - 1][x].setFlag(flag: 1)
            self.herosCollected.append(self.herosArray[y - 1][x])
            self.collectedHeroAround(hero: self.herosArray[y - 1][x])
            flag = true
        }
        //下边方块
        if y < self.y - 1 && self.herosArray[y + 1][x].getType() == hero.getType() && self.herosArray[y + 1][x].getFlag() == 0{
            self.addScore()
            self.herosArray[y + 1][x].setFlag(flag: 1)
            self.herosCollected.append(self.herosArray[y + 1][x])
            self.collectedHeroAround(hero: self.herosArray[y + 1][x])
            flag = true
        }
        if !flag {
            return
        }
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if self.can_touch{
            Music.shared().musicPlayEffective()
            self.back(UIButton.init())
        }
    }
    
}

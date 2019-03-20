import UIKit

class HeroView: UIView {
    
    //type == 0-5 -> differentHero
    private var type : Int = 0
    private var position : Dictionary<String,Int>?
    //flag == 0 -> not in array
    //flag == 1 -> in array
    private var flag : Int = 0
    
    private let hero = UIImageView.init(image: UIImage.init(named: "1"))
    private let background = UIImageView.init(image: UIImage.init(named: "herobackground"))
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.hero.frame = CGRect.init(x: 4, y: 4, width: self.frame.width - 12, height: self.frame.height - 12)
        self.background.frame = CGRect.init(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        self.addSubview(background)
        self.addSubview(hero)
    }

    //更新图片状态
    func updateImage() {
        EffectiveClass.reverse(view: self)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + TimeInterval(0.3)) {
            self.hero.image = UIImage.init(named: String(self.type))
        }
    }
    
    //设置类型
    func setType(type:Int){
        self.type = type
        updateImage()
    }
    
    //获取类型
    func getType() -> Int{
        return self.type
    }
    
    //设置位置
    func setPosition(x:Int,y:Int) {
        let dic : Dictionary<String,Int> = ["x" : x,
                                            "y" : y]
        self.position = dic
    }
    
    //获取位置
    func getPosition() -> Dictionary<String,Int> {
        return self.position!
    }
    
    //设置flag
    func setFlag(flag:Int) {
        self.flag = flag
    }
    
    //获取flag
    func getFlag() -> Int {
        return self.flag
    }
    
}

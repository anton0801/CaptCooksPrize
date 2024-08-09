import SwiftUI
import SpriteKit

class LeprekonSlotsView: SKScene {
    
    var slot: Slot
    
    var baraban1: OneSlotBarabanView!
    var baraban2: SlotMachineBaraban!
    var baraban3: OneSlotBarabanView!
    
    private var menuButton: SKSpriteNode {
        get {
            let node = SKSpriteNode(imageNamed: "menu_bttn")
            node.position = CGPoint(x: 150, y: size.height - 100)
            node.size = CGSize(width: 250, height: 160)
            node.name = "menu_btn"
            return node
        }
    }
    
    var soundsInApp = UserDefaults.standard.bool(forKey: "sounds_app")
    
    private var balance = UserDefaults.standard.integer(forKey: "money") {
        didSet {
            UserDefaults.standard.set(balance, forKey: "money")
            balanceLabel.text = "\(balance)"
        }
    }
    private var balanceLabel: SKLabelNode = SKLabelNode(text: "0")
    
    private var currentWin = 0 {
        didSet {
            currentWinLabel.text = "\(currentWin)"
        }
    }
    
    private var currentWinLabel: SKLabelNode = SKLabelNode(text: "0")
    
    private var currentBet = 500 {
        didSet {
            currentBetLabel.text = "\(currentBet)"
        }
    }
    private var currentBetLabel = NumberLabelNode(text: "500")
    
    private var increaseBetBtn = SKSpriteNode(imageNamed: "arrow_up")
    private var decreaseBetBtn = SKSpriteNode(imageNamed: "arrow_down")
    
    private var spinBtn: SKSpriteNode = SKSpriteNode(imageNamed: "spin_bttn")

    init(slot: Slot) {
        self.slot = slot
        super.init(size: CGSize(width: 1800, height: 1000))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        let slotsGameBackground = SKSpriteNode(imageNamed: "\(slot.symbol)_bg")
        slotsGameBackground.size = size
        slotsGameBackground.position = CGPoint(x: size.width / 2, y: size.height / 2)
        addChild(slotsGameBackground)
        
        if soundsInApp {
            let musicNode = SKAudioNode(fileNamed: "music.mp3")
            addChild(musicNode)
        }
        
        baraban1 = OneSlotBarabanView(slotSymbols: getSlotSymbols(), symbolBack: "\(slot.symbol)_symbol_bg", size: CGSize(width: 200, height: 240)) {
        }
        
        baraban2 = SlotMachineBaraban(slotSymbols: getSlotSymbols(), symbolBack: "\(slot.symbol)_symbol_bg", size: CGSize(width: 200, height: 730)) {
        }
        
        baraban3 = OneSlotBarabanView(slotSymbols: getSlotSymbols(), symbolBack: "\(slot.symbol)_symbol_bg", size: CGSize(width: 200, height: 250)) {
            self.checkWinning()
        }
        
        baraban1.position = CGPoint(x: size.width / 2 - 230, y: size.height / 2)
        baraban2.position = CGPoint(x: size.width / 2, y: size.height / 2)
        baraban3.position = CGPoint(x: size.width / 2 + 230, y: size.height / 2)
        addChild(baraban1)
        addChild(baraban2)
        addChild(baraban3)
        
        addChild(menuButton)
        
        createBalanceLabel()
        createCurrentWinLabel()
        createBets()
        
        spinBtn.position = CGPoint(x: size.width - 200, y: 120)
        spinBtn.name = "spin_btn"
        addChild(spinBtn)
        
        let lines = "\(slot.symbol)_lines"
        let linesNode = SKSpriteNode(imageNamed: "\(lines)")
        linesNode.size = CGSize(width: 600, height: 730)
        linesNode.position = CGPoint(x: size.width / 2, y: size.height / 2)
        addChild(linesNode)
        
        let actionFadeIn = SKAction.fadeIn(withDuration: 0.3)
        let actionFadeOut = SKAction.fadeOut(withDuration: 0.3)
        let seq = SKAction.sequence([actionFadeIn, actionFadeOut])
        let actionRepeate3Times = SKAction.repeat(seq, count: 5)
        linesNode.run(actionRepeate3Times)
    }
    
    private func createBets() {
        let betBg = SKSpriteNode(imageNamed: "bet_background")
        betBg.position = CGPoint(x: size.width - 200, y: size.height / 2)
        betBg.size = CGSize(width: 350, height: 120)
        addChild(betBg)
        
        currentBetLabel.position = CGPoint(x: size.width - 200, y: size.height / 2 - 20)
        currentBetLabel.fontName = "K2D-ExtraBold"
        currentBetLabel.fontSize = 62
        currentBetLabel.fontColor = UIColor.init(red: 1, green: 182/255, blue: 71/255, alpha: 1)
        addChild(currentBetLabel)
        
        increaseBetBtn.position = CGPoint(x: size.width - 200, y: size.height / 2 + 170)
        increaseBetBtn.name = "increase_bet"
        decreaseBetBtn.position = CGPoint(x: size.width - 200, y: size.height / 2 - 170)
        decreaseBetBtn.name = "decrease_bet"
        
        addChild(increaseBetBtn)
        addChild(decreaseBetBtn)
    }
    
    private func createCurrentWinLabel() {
        let currentWinBackground = SKSpriteNode(imageNamed: "win")
        currentWinBackground.position = CGPoint(x: 250, y: 200)
        currentWinBackground.size = CGSize(width: 350, height: 250)
        addChild(currentWinBackground)
        
        currentWinLabel.position = CGPoint(x: 220, y: 105)
        currentWinLabel.fontName = "K2D-ExtraBold"
        currentWinLabel.fontSize = 42
        currentWinLabel.fontColor = UIColor.init(red: 1, green: 182/255, blue: 71/255, alpha: 1)
            
        addChild(currentWinLabel)
    }
    
    private func createBalanceLabel() {
        let balanceBackground = SKSpriteNode(imageNamed: "money_bg")
        balanceBackground.position = CGPoint(x: 250, y: size.height / 2 + 180)
        balanceBackground.size = CGSize(width: 350, height: 100)
        addChild(balanceBackground)
        
        balanceLabel = .init(text: "\(balance)")
        balanceLabel.fontName = "K2D-ExtraBold"
        balanceLabel.fontSize = 42
        balanceLabel.fontColor = UIColor.init(red: 1, green: 182/255, blue: 71/255, alpha: 1)
        balanceLabel.position = CGPoint(x: 200, y: size.height / 2 + 165)
        addChild(balanceLabel)
    }
    
    private func getSlotSymbols() -> [String] {
        var result = [String]()
        let slotId = slot.symbol.components(separatedBy: "_")[1]
        for i in 1...(slot.symbolsCount) {
            let nameSymbol = "slot_icon_\(slotId)_\(i)"
            result.append(nameSymbol)
        }
        return result
    }
    
    private func checkWinning() {
        let centerBarabanCenterItem = self.atPoint(CGPoint(x: self.size.width / 2, y: self.size.height / 2)).name ?? ""
        let leftBarabanCenterItem = self.atPoint(CGPoint(x: self.size.width / 2 - 230, y: self.size.height / 2)).name ?? ""
        let rightBarabanCenterItem = self.atPoint(CGPoint(x: self.size.width / 2 + 230, y: self.size.height / 2)).name ?? ""
        
        if centerBarabanCenterItem == leftBarabanCenterItem && centerBarabanCenterItem == rightBarabanCenterItem {
            currentWin = currentBet * 5
            if soundsInApp {
                run(SKAction.playSoundFileNamed("win_sound", waitForCompletion: false))
            }
        } else {
            
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if self.balance == 0 {
                self.showLoss()
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let loc = touch.location(in: self)
            let object = atPoint(loc)
            
            if object.name == "spin_btn" {
                if balance >= currentBet {
                    baraban1.startScrolling()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                        self.baraban2.startScrolling()
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        self.baraban3.startScrolling()
                    }
                    balance -= currentBet
                }
            
                if self.balance == 0 {
                    self.showLoss()
                }
                if soundsInApp {
                    run(SKAction.playSoundFileNamed("tap_sound", waitForCompletion: false))
                }
            }
            
            if object.name == "increase_bet" {
                let prev = currentBet
                currentBet += 100
                currentBetLabel.animate(from: prev, to: currentBet, duration: 0.3)
                if soundsInApp {
                    run(SKAction.playSoundFileNamed("plaer_set_bet_sound.mp3", waitForCompletion: false))
                }
            }
            
            if object.name == "decrease_bet" {
                if currentBet > 100 {
                    let prev = currentBet
                    currentBet -= 100
                    currentBetLabel.animate(from: prev, to: currentBet, duration: 0.3)
                }
                if soundsInApp {
                    run(SKAction.playSoundFileNamed("plaer_set_bet_sound.mp3", waitForCompletion: false))
                }
            }
            
            if object.name == "menu_btn" {
                if soundsInApp {
                    run(SKAction.playSoundFileNamed("tap_sound", waitForCompletion: false))
                }
                NotificationCenter.default.post(name: Notification.Name("to_menu"), object: nil, userInfo: ["balance": balance])
            }
            
        }
    }
    
    private var lossNode: SKSpriteNode!
    
    func showLoss() {
        lossNode = SKSpriteNode()
        let lossBg = SKSpriteNode(imageNamed: "loss_bg")
        lossBg.size = size
        lossBg.position = CGPoint(x: size.width / 2, y: size.height / 2)
        lossBg.alpha = 0.7
        lossNode.addChild(lossBg)
        
        let lossContent = SKSpriteNode(imageNamed: "loss")
        lossContent.position = CGPoint(x: size.width / 2, y: size.height / 2)
        lossContent.size = CGSize(width: 1000, height: 800)
        lossNode.addChild(lossContent)
        
        let toMenuBtn = SKSpriteNode(imageNamed: "menu_bttn")
        toMenuBtn.position = CGPoint(x: size.width / 2, y: 130)
        toMenuBtn.size = CGSize(width: 360, height: 200)
        toMenuBtn.name = "menu_btn"
        lossNode.addChild(toMenuBtn)
        addChild(lossNode)
        lossNode.run(SKAction.fadeIn(withDuration: 0.5))
    }
    
}

#Preview {
    VStack {
        SpriteView(scene: LeprekonSlotsView(slot: Slot(symbol: "slots_1", isPurchased: true, symbolsCount: 8)))
            .ignoresSafeArea()
    }
}

class SlotMachineBaraban: SKSpriteNode {
    
    var slotSymbols: [String]
    var symbolBack: String
    private let cropNode: SKCropNode
    private let contentNode: SKNode
    private var currentOffset: CGFloat = 0
    var endScroll: () -> Void
    
    var reverseScroll = false
    
    init(slotSymbols: [String], symbolBack: String, size: CGSize, endScroll: @escaping () -> Void) {
        self.slotSymbols = slotSymbols
        self.cropNode = SKCropNode()
        self.contentNode = SKNode()
        self.symbolBack = symbolBack
        self.endScroll = endScroll
        super.init(texture: nil, color: .clear, size: size)
        setUpSymbolsBackgrounds()
        addSymbols()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpSymbolsBackgrounds() {
        let symbol1Bg = SKSpriteNode(imageNamed: symbolBack)
        symbol1Bg.position = CGPoint(x: 0, y: 250)
        symbol1Bg.size = CGSize(width: 180, height: 190)
        symbol1Bg.zPosition = 0
        addChild(symbol1Bg)
        
        let symbol2Bg = SKSpriteNode(imageNamed: symbolBack)
        symbol2Bg.position = CGPoint(x: 0, y: 0)
        symbol2Bg.size = CGSize(width: 180, height: 190)
        symbol2Bg.zPosition = 0
        addChild(symbol2Bg)
        
        let symbol3Bg = SKSpriteNode(imageNamed: symbolBack)
        symbol3Bg.position = CGPoint(x: 0, y: -250)
        symbol3Bg.size = CGSize(width: 180, height: 190)
        symbol3Bg.zPosition = 0
        addChild(symbol3Bg)
    }
    
    func addSymbols() {
        cropNode.position = CGPoint(x: 0, y: 0)
                
        // Создаем маску обрезки
        let maskNode = SKSpriteNode(color: .black, size: size)
        maskNode.position = CGPoint(x: 0, y: 0)
        cropNode.maskNode = maskNode
        
        // Добавляем узел обрезки как дочерний
        addChild(cropNode)
        
        // Добавляем contentNode внутрь cropNode
        cropNode.addChild(contentNode)
        
        let shuffledSymbols = slotSymbols.shuffled()
        for i in 0..<slotSymbols.count * 8 {
            let symbolName = shuffledSymbols[i % 8]
            let symbol = SKSpriteNode(imageNamed: symbolName)
            symbol.size = CGSize(width: 150, height: 150)
            symbol.zPosition = 1
            symbol.name = symbolName
            symbol.position = CGPoint(x: 0, y: size.height - CGFloat(i) * 240.5)
            contentNode.addChild(symbol)
        }
        
        contentNode.run(SKAction.moveBy(x: 0, y: 250 * CGFloat(slotSymbols.count * 3), duration: 0.0))
    }
    
    func startScrolling() {
        if reverseScroll {
            reverseScroll = false
            let actionMove = SKAction.moveBy(x: 0, y: -(240 * CGFloat(Int.random(in: 4...6))), duration: 0.5)
            contentNode.run(actionMove) {
                self.endScroll()
            }
        } else {
            let actionMove = SKAction.moveBy(x: 0, y: 240 * CGFloat(Int.random(in: 4...6)), duration: 0.5)
            contentNode.run(actionMove) {
                self.endScroll()
            }
            reverseScroll = true
        }
    }
    
}

class OneSlotBarabanView: SKSpriteNode {
    
    var slotSymbols: [String]
    var symbolBack: String
    private let cropNode: SKCropNode
    private let contentNode: SKNode
    private var currentOffset: CGFloat = 0
    var endScroll: () -> Void
    
    var reverseScroll = false
    
    init(slotSymbols: [String], symbolBack: String, size: CGSize, endScroll: @escaping () -> Void) {
        self.slotSymbols = slotSymbols
        self.cropNode = SKCropNode()
        self.contentNode = SKNode()
        self.symbolBack = symbolBack
        self.endScroll = endScroll
        super.init(texture: nil, color: .clear, size: size)
        setUpSymbolsBackgrounds()
        addSymbols()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpSymbolsBackgrounds() {
        let symbol1Bg = SKSpriteNode(imageNamed: symbolBack)
        symbol1Bg.position = CGPoint(x: 0, y: 0)
        symbol1Bg.size = CGSize(width: 180, height: 190)
        symbol1Bg.zPosition = 0
        addChild(symbol1Bg)
    }
    
    func addSymbols() {
        cropNode.position = CGPoint(x: 0, y: 0)
                
        // Создаем маску обрезки
        let maskNode = SKSpriteNode(color: .black, size: size)
        maskNode.position = CGPoint(x: 0, y: 0)
        cropNode.maskNode = maskNode
        
        // Добавляем узел обрезки как дочерний
        addChild(cropNode)
        
        // Добавляем contentNode внутрь cropNode
        cropNode.addChild(contentNode)
        
        let shuffledSymbols = slotSymbols.shuffled()
        for i in 0..<slotSymbols.count * 6 {
            let symbolName = shuffledSymbols[i % 6]
            let symbol = SKSpriteNode(imageNamed: symbolName)
            symbol.size = CGSize(width: 150, height: 150)
            symbol.zPosition = 1
            symbol.name = symbolName
            symbol.position = CGPoint(x: 0, y: size.height - CGFloat(i) * 240.5)
            contentNode.addChild(symbol)
        }
        
        contentNode.run(SKAction.moveBy(x: 0, y: 250 * CGFloat(slotSymbols.count * 3), duration: 0.0))
    }
    
    func startScrolling() {
        if reverseScroll {
            reverseScroll = false
            let actionMove = SKAction.moveBy(x: 0, y: -(240 * CGFloat(Int.random(in: 4...5))), duration: 0.5)
            contentNode.run(actionMove) {
                self.endScroll()
            }
        } else {
            let actionMove = SKAction.moveBy(x: 0, y: 240 * CGFloat(Int.random(in: 4...8)), duration: 0.5)
            contentNode.run(actionMove) {
                self.endScroll()
            }
            reverseScroll = true
        }
    }
    
}


class NumberLabelNode: SKLabelNode {
    private var startValue: Int = 0
    private var endValue: Int = 0
    private var duration: TimeInterval = 0
    private var currentValue: Int = 0
    private var timer: Timer?
    
    func animate(from startValue: Int, to endValue: Int, duration: TimeInterval) {
        self.startValue = startValue
        self.endValue = endValue
        self.duration = duration
        self.currentValue = startValue
        self.text = "\(startValue)"
        
        let interval = 0.02
        let totalSteps = duration / interval
        let valueChange = (Double(endValue - startValue) / totalSteps)
        
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { [weak self] timer in
            guard let self = self else {
                timer.invalidate()
                return
            }
            
            if abs(self.currentValue - endValue) < abs(Int32(valueChange)) {
                self.currentValue = endValue
                self.text = "\(endValue)"
                timer.invalidate()
            } else {
                self.currentValue += Int(valueChange)
                self.text = "\(self.currentValue)"
            }
        }
    }
}

import SwiftUI
import SpriteKit

class EgyptSlotsScene: SKScene {
    
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
        let topCenterItem = self.atPoint(CGPoint(x: self.size.width / 2, y: self.size.height / 2 + 240)).name ?? ""
        
        var hasWin = false
        
        if leftBarabanCenterItem == topCenterItem && rightBarabanCenterItem == centerBarabanCenterItem {
            currentWin = currentBet * 5
            hasWin = true
        }
        
        if centerBarabanCenterItem == leftBarabanCenterItem && centerBarabanCenterItem == rightBarabanCenterItem {
            currentWin = currentBet * 5
            hasWin = true
        }
        
        if hasWin {
            if soundsInApp {
                run(SKAction.playSoundFileNamed("win_sound", waitForCompletion: false))
            }
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
        SpriteView(scene: EgyptSlotsScene(slot: Slot(symbol: "slots_3", isPurchased: true, symbolsCount: 9)))
            .ignoresSafeArea()
    }
}

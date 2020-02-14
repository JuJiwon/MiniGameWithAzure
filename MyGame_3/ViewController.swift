
import UIKit
import AVFoundation
import AZSClient

class ViewController: UIViewController, ViewDelegate_1, ViewDelegate_2 {
    
    let connStr = "DefaultEndpointsProtocol=https;AccountName=codingstr2;AccountKey=NQKaG+dQJEYXF1Guwd4q7gHRvZPuzEJzzDoEXO9XY5CyWcaotcR14xNuKQLC0IwLqnpKkYlsQKwLfq/ghtN8OQ==;EndpointSuffix=core.windows.net"
    
    var containerA: AZSCloudBlobContainer!
    var clientA: AZSCloudBlobClient!
    var blobA: AZSCloudBlockBlob!
    
    var width, height: CGFloat!
    var worldhighest: Int!
    var amount = 0
    var highest: Int!
    
    var sameColor: Bool = true
    var repeatedColor: Int = 0
    
    var arr: Array = [Objective_1]()
    
    let obj_2: Objective_2 = Objective_2()
    
    var timerA = Timer()
    var lbl: UILabel!
    var lblA: UILabel!
    var lblB: UILabel!
    var lblC: UILabel!
    var lblD: UILabel!
    var btnA: UIButton!
    
    var sucCt = 0
    var failCt = 0
    var bgmSound = AVAudioPlayer()
    
    //
    var count = 0
    var count_ = 0
    //
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            try highest = UserDefaults.standard.integer(forKey: "highest")
        } catch  {
            highest = 0
        }
        
        // Azure
        let stAccount: AZSCloudStorageAccount = try! AZSCloudStorageAccount(fromConnectionString: self.connStr)
        clientA = stAccount.getBlobClient()
        containerA = clientA.containerReference(fromName: "codingstr2")
        containerA.createContainerIfNotExists { (errA, isOK) in
            if errA != nil {
                print("Error in creating container.")
            }
        }
        self.blobA = containerA.blockBlobReference(fromName: "highest")
        
        self.width = self.view.bounds.width
        self.height = self.view.bounds.height
        self.amount = Int(self.height-(self.height.truncatingRemainder(dividingBy: 100)))/100
        
        btnA = UIButton(type: UIButton.ButtonType.system)
        btnA.setTitle("Try again!", for: .normal)
        btnA.frame = CGRect(x: 0, y: 0, width: 300, height: 100)
        btnA.center = CGPoint(x: width/2, y: height/5)
        btnA.titleLabel?.font = btnA.titleLabel?.font.withSize(60)
        btnA.addTarget(self, action: #selector(btnPressed(btn:)), for: UIControl.Event.touchUpInside)
        
        self.lbl = UILabel(frame: CGRect(x: width/12, y: height/3, width: 120, height: 150))
        self.lblA = UILabel(frame: CGRect(x: width-width/6, y: height/3, width: 120, height: 150))
        
        self.lblB = UILabel(frame: CGRect(x: 0, y: 0, width: 300, height: 100))
        self.lblB.center = CGPoint(x: width/2, y: height/5*2)
        self.lblB.textColor = UIColor.black
        self.lblC = UILabel(frame: CGRect(x: 0, y: 0, width: 300, height: 100))
        self.lblC.center = CGPoint(x: width/2, y: height/5*3)
        self.lblC.textColor = UIColor.black
        self.lblD = UILabel(frame: CGRect(x: 0, y: 0, width: 300, height: 100))
        self.lblD.center = CGPoint(x: width/2, y: height/5*4)
        self.lblD.textColor = UIColor.black
        
        lbl.font = lbl.font.withSize(60)
        lblA.font = lblA.font.withSize(60)
        lblB.font = lblB.font.withSize(50)
        lblC.font = lblC.font.withSize(50)
        lblD.font = lblD.font.withSize(50)
        lbl.textColor = UIColor.green
        lblA.textColor = UIColor.red
        startFunc()
    }
    
    func startFunc() {
        
        blobA.downloadToData { (errA, dataA) in
            if errA != nil {
                print("err down")
                print(errA!)
            } else {
                print("suc down")
                let downText = String(data: dataA!, encoding: String.Encoding.utf8)
                DispatchQueue.main.async {
                    self.worldhighest = Int(downText!)!
                }
            }
        }
        
        let bgm = Bundle.main.path(forResource: "TheFatRat - Unity", ofType: "mp3")
        do {
            bgmSound = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: bgm! ))
            
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.ambient)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print(error)
        }
        
        bgmSound.play()
        
        for _ in 0...amount-1 {
            arr.append(Objective_1())
        }
        
        timerA = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: Selector(("activeTimerA")), userInfo: nil, repeats: true)
        
        self.view.addSubview(lbl)
        self.view.addSubview(lblA)
        
        lbl.text = "\(sucCt)"
        lblA.text = "\(failCt)"
        
        obj_2.delegate = self
        obj_2.frame = CGRect(x: width/2-width/12, y: height-100, width: width/6, height: 20)
        obj_2.backgroundColor = UIColor.blue
        self.view.addSubview(obj_2)
        
    }
    
    @objc func btnPressed(btn:UIButton) {
        
        self.sucCt = 0
        self.failCt = 0
        self.count = 0
        self.count_ = 0
        obj_2.color_2 = true
        btnA.removeFromSuperview()
        lblB.removeFromSuperview()
        lblC.removeFromSuperview()
        lblD.removeFromSuperview()
        startFunc()
    }
    
    func myFunc() {
        
        if arr[count_].color_1 == obj_2.color_2 {
            sucCt += 1
            lbl.text = "\(sucCt)"
        } else {
            failCt += 1
            lblA.text = "\(failCt)"
        }
        
        if failCt >= 10 {
            if highest < sucCt {
                highest = sucCt
                UserDefaults.standard.set(highest, forKey: "highest")
                UserDefaults.standard.synchronize()
                if worldhighest != nil && highest > worldhighest {
                    blobA.upload(fromText: String(highest)) { (errA) in
                        if errA != nil {
                            print("err up")
                            print(errA!)
                        } else {
                            print("suc up")
                        }
                    }
                    self.view.addSubview(lblD)
                    lblD.text = "world     \(highest!)"
                }
            } else if worldhighest != nil && highest <= worldhighest {
                self.view.addSubview(lblD)
                lblD.text = "world     \(worldhighest!)"
            }
            
            bgmSound.stop()
            for i in 0...amount-1 {
                arr[i].timer.invalidate()
                arr[i].removeFromSuperview()
            }
            obj_2.removeFromSuperview()
            lbl.removeFromSuperview()
            lblA.removeFromSuperview()
            self.view.addSubview(btnA)
            self.view.addSubview(lblB)
            self.view.addSubview(lblC)
            lblB.text = "score        \(sucCt)"
            lblC.text = "highest    \(Int(highest))"
            if worldhighest == nil {
                self.view.addSubview(lblD)
                lblD.text = "you are offline"
            }
            self.arr.removeAll()
            return
        }
        
        if repeatedColor >= 3 {
            if sameColor == true {
                arr[count_].color_1 = false
                arr[count_].backgroundColor = UIColor.red
                repeatedColor = 0
                print("3x blue")
            } else {
                arr[count_].color_1 = true
                arr[count_].backgroundColor = UIColor.blue
                repeatedColor = 0
                print("3x red")
            }
        } else if Int(arc4random_uniform(UInt32(2))) == 1 {
            arr[count_].color_1 = true
            arr[count_].backgroundColor = UIColor.blue
            if sameColor == true {
                repeatedColor += 1
            } else {
                repeatedColor = 0
            }
            sameColor = true
        } else {
            arr[count_].color_1 = false
            arr[count_].backgroundColor = UIColor.red
            if sameColor == false {
                repeatedColor += 1
            } else {
                repeatedColor = 0
            }
            sameColor = false
        }
        
//        if Int(arc4random_uniform(UInt32(2))) == 1 {
//            arr[count_].color_1 = true
//            arr[count_].backgroundColor = UIColor.blue
//        } else {
//            arr[count_].color_1 = false
//            arr[count_].backgroundColor = UIColor.red
//        }
        
        if (sucCt + failCt) % 40 == 0 {
            for i in 0...amount-1 {
                arr[i].mmA += 0.013
            }
        }
        
        
        count_ += 1
        if count_ == amount {
            count_ = 0
        }
        
    }
    
    func myFunc_() {
        
        if obj_2.color_2 == true {
            obj_2.color_2 = false
            obj_2.backgroundColor = UIColor.red
        } else if obj_2.color_2 == false {
            obj_2.color_2 = true
            obj_2.backgroundColor = UIColor.blue
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if obj_2.color_2 == true {
            obj_2.color_2 = false
            obj_2.backgroundColor = UIColor.red
        } else if obj_2.color_2 == false {
            obj_2.color_2 = true
            obj_2.backgroundColor = UIColor.blue
        }
    }
    
    @objc func activeTimerA() {
        
        arr[count].delegate = self
        arr[count].width = self.width
        arr[count].height = self.height
        arr[count].frame = CGRect(x: 0, y: 0, width: 15, height: 15)
        arr[count].center = CGPoint(x: width/2, y: height/18)
        arr[count].backgroundColor = UIColor.blue
        self.view.insertSubview(arr[count], at: 0)
        count += 1
        if count == amount {
            timerA.invalidate()
        }
    }
    
}



/*
 알고리즘

 ViewDidLoad()
     저장소에서 최고점수를 끄집어온다. 없으면 0으로 저장.
     버튼/레이블 설정한다
     startFunc() 시작

 startFunc()
     Azure에서 세계 최고점수를 끄집어온다.
     bgm 재생
     obj1 만들고 activeTimerA() 시작
     점수레이블 2개 붙이고 텍스트
     obj2 만들고 붙임

 btnPressed()
     겜 재시작

 myFunc()
     색 같으면 +1 다르면 -1
     10번 넘으면 겜오버
         최고점수보다 높으면 최고점수 업뎃
         세계최고점수보다 높으면 업뎃하고 표시
     bgm 스탑
     겜오버화면 표시
     연속색 3개되면 다음색 다름
         색바꿈
     40 배수면 빨라짐
     한턴돌면 count_ 초기화

 myFunc_()
     obj2 색바꿈

 touchesBegan()
     obj2 색바꿈

 activeTimerA()
     obj1 위치바꿈
 */

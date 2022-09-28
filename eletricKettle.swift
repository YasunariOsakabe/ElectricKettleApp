import UIKit
import Foundation // Timerクラスを使用するために必要なモジュール
import PlaygroundSupport // Playground上でTimerクラスを機能させるために必要なモジュール

//電気ケトルロジック（ElectricKettle）
//仕様
//        ケトル容量(1L)
//        加熱スタートボタン
//        3段階の温度調整ができる(50度、80度、90度）
//        空焚き防止機能(水が入っていないと空焚きになるので沸かせない)
//        毎秒2度ずつ温度上昇していくよう、カウントアップ機能実装
//
//例外ケース
//        ケトルの上限温度になれば加熱停止　3種のモード選択（50度、80度、90度で上限設定）
//        入れた水量ごとにケトルの加熱停止時間
//        水が入っていない状態で沸かそうとすると、電源が落ちるようにする
//
//処理流れ
//ケトルに水を入れる→温めスタート→一定の温度になれば加熱停止
//ケトルの水が入っていない→空焚き防止機能が動作→加熱開始しないように
//
//3段階の温度調整 - 上限温度がそれぞれ変わるように（それぞれ50度、80度、90度で加熱が終わるように）

//ケトルの水量が1Lの状態と仮定して、実装
//ケトルの水量によって加熱時間が速くなったり、遅くなったりする処理も余裕があれば実装
//水量は引数として渡すように
//
class ElectricKettle {
    var kettleStrage = 1000 //ケトル容量1L(ml表記）
    var warterStrage = 0 //注水量ml
    var limitTemperature = 0 //ケトルの上限温度
    var timer: Timer?
    var temperature = 0 //現在の温度
    
    //3段階の温度調節
    enum TemperatureMode {
        case temperatureFifty
        case temperatureEighty
        case temperatureNinety
    }
    
    
    //スタートメソッド
    func start(type: TemperatureMode) {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(heatingStart), userInfo: nil, repeats: true)
        print("水量は\(warterStrage)mlです")
        switch type {
        case .temperatureFifty:
            print("設定温度:50度に設定しました")
            limitTemperature = 50
        case .temperatureEighty:
            print("設定温度:80度に設定しました")
            limitTemperature = 80
        case .temperatureNinety:
            print("設定温度:90度に設定しました")
            limitTemperature = 90
        }
        
        if warterStrage <= 0 {  //注水量が0だった場合は空焚き防止メソッドへ
            emptyFiring()//空焚き防止メソッドへ
        }
        
    }
    
    //加熱開始
    @objc func heatingStart() {
        temperature += 2 //2度ずつ温度上昇
        print("現在の温度は\(temperature)度です")
        if temperature >= limitTemperature {
            stop()
            return
        }
    }

    
    //加熱ストップメソッド
    func stop() {
        timer?.invalidate()
        print("カチッ！（\(temperature)度に到達。加熱をストップしました）")
    }
    
    //空焚き防止機能メソッド
    func emptyFiring() {
        timer?.invalidate()
        print("空焚き防止機能が動作しました")
    }
}


let electricKettle = ElectricKettle()
electricKettle.warterStrage = 1000 //注水量を入力 (0にすると空焚き防止が動作）
electricKettle.start(type: .temperatureFifty)

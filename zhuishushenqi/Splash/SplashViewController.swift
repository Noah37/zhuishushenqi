//
//  Copyright 2021 Google LLC
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      https://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import UIKit

class SplashViewController: UIViewController {
    /// Number of seconds remaining to show the app open ad.
    /// This simulates the time needed to load the app.
    var secondsRemaining: Int = 1
    /// The countdown timer.
    var countdownTimer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        BUAdManager.shared.completion = { [weak self] in
            self?.stopTimer()
            self?.startMainScreen()
        }
        BUAdManager.shared.success = { [weak self] in
            self?.stopTimer()
        }
        BUAdManager.shared.startBUAdSDK(viewController: self)
        startTimer()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @objc func decrementCounter() {
        secondsRemaining -= 1
        if secondsRemaining > 0 {
            
        } else {
            countdownTimer?.invalidate()
            startMainScreen()
        }
    }
    
    func startTimer() {
        countdownTimer = Timer.scheduledTimer(
            timeInterval: 1.0,
            target: self,
            selector: #selector(SplashViewController.decrementCounter),
            userInfo: nil,
            repeats: true)
    }
    
    func stopTimer() {
        countdownTimer?.invalidate()
        countdownTimer = nil
    }
    
    func startMainScreen() {
        let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        let mainViewController = mainStoryBoard.instantiateViewController(
            withIdentifier: "MainStoryBoard")
        // Find the keyWindow which is currently being displayed on the device,
        // and set its rootViewController to mainViewController.
        let keyWindow = UIApplication.shared.windows.first(where: { $0.isKeyWindow })
        keyWindow?.rootViewController = mainViewController
    }
    
    // MARK: AppOpenAdManagerDelegate
    func appOpenAdManagerAdDidComplete(_ appOpenAdManager: AppOpenAdManager) {
        startMainScreen()
    }
}

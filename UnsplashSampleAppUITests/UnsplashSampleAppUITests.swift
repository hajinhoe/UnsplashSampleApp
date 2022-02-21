//
//  UnsplashSampleAppUITests.swift
//  UnsplashSampleAppUITests
//
//  Created by jinho on 2022/02/18.
//

import XCTest

// iOS 13에서 UITests에서 app 터미네이트하면 아래와 같은 에러가 발생한다.
// UnsplashSampleAppUITests.testLaunchPerformance(): Failed to terminate jinho.UnsplashSampleApp:74034: Failed to terminate jinho.UnsplashSampleApp:0
// Failed to terminate jinho.UnsplashSampleApp:74034: Failed to terminate jinho.UnsplashSampleApp:0
// 종료 시의 문제이기 때문에 앱의 문제는 아닌 것으로 보임. (테스트 환경, M1 MacMini, iOS 13.7, iPhone 11 시뮬레이터, Xcode 13.2.1)
// 타겟을 일단 UITests에 대해서는 iOS 14로 변경함.

class UnsplashSampleAppUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 14.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}

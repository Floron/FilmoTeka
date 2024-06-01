//
//  FilmsAppUITests.swift
//  FilmsAppUITests
//
//  Created by Floron on 01.06.2024.
//

import XCTest

final class FilmsAppUITests: XCTestCase {

    func testCollectionView() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
        
        app.swipeUp()
        app.swipeDown()
        
        let collectionView = app.collectionViews["MyCollectionView"]
        let cells = collectionView.cells.matching(identifier: "MyCollectionViewCell")
        
        let cellLabelText = cells.staticTexts.element(boundBy: 3).label
        //XCTAssertEqual(cellLabelText, "Форест Гамп")
        
        
        // Нажимаем на ячейку 3 элемента массива (нумерация начинается с 0)
        cells.staticTexts.element(boundBy: 3).tap()
        XCTAssertEqual(app.staticTexts["MyDeteilViewFilmTitle"].label, cellLabelText)
        
        // Данные успешно были переданы на второй экран, тайтлы совпадают
        
    }
    
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

        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}

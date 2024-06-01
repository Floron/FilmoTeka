//
//  FilmsAppTests.swift
//  FilmsAppTests
//
//  Created by Floron on 01.06.2024.
//

import XCTest

final class FilmsAppTests: XCTestCase {

    var expectation: XCTestExpectation!
     
    let session = URLSession.shared
    
    func testAsynchronousURLConnection() {
        guard let url = URL(string: "https://kinopoiskapiunofficial.tech/api/v2.2/films/collections?type=TOP_250_MOVIES") else {
            XCTFail("URL не найден")
            return
        }
        XCTAssertNotNil(url, "Url не должны быть nil")
        
        expectation = expectation(description: "skillfactory")
        
        var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.setValue("b27890d4-28ce-4e20-8b65-c542733f350c", forHTTPHeaderField: "X-API-KEY")
    
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            XCTAssertNotNil(data, "Данные не должны быть nil")
            XCTAssertNil(error, "Ошибка должна быть nil")
    
            if let httpResponse = response as? HTTPURLResponse,
                let responseURL = httpResponse.url {
                XCTAssertEqual(responseURL.absoluteString, url.absoluteString, "URL-адрес HTTP — ответа должен быть равен исходному URL-адресу")
                XCTAssertEqual(httpResponse.statusCode, 200, "Код состояния ответа HTTP должен быть 200")
            } else {
                XCTFail("Response was not NSHTTPURLResponse")
            }
    
            self.expectation.fulfill()
        }
    
        task.resume()
    
//        waitForExpectations(timeout: task.originalRequest?.timeoutInterval ?? 10) { error in
//            if let error = error {
//                print("Error: \(error.localizedDescription)")
//            }
//            task.cancel()
//        }
    
        wait(for: [expectation], timeout: 10)
    }
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}

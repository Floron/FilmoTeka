//
//  TestModel.swift
//  6. Diplom_FilmsApp
//
//  Created by Floron on 25.03.2024.
//

import Foundation

class TestModel {
    var testPic: String?
    var testTitle: String?
    var testYear: String?
    var testRating: String?
    
    init(testPic: String?, testTitle: String?, testYear: String?, testRating: String?) {
        self.testPic = testPic
        self.testTitle = testTitle
        self.testYear = testYear
        self.testRating = testRating
    }
}

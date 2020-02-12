//
//  TODOLISTTests.swift
//  TODOLISTTests
//
//  Created by Ankit Bhandari on 11/02/20.
//  Copyright © 2020 Ankit Bhandari. All rights reserved.
//

import XCTest
@testable import TODOLIST

class TODOLISTTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testAPIRequest(){
        //Test api call
        if JSONParser.share.isConnectedToNetwork() {
            
            let endPointUrl = "karthikraj-duraisamy/todoendpoint/tasks"
            
            let config = URLSessionConfiguration.default
            let session = URLSession(configuration: config)
            let url = baseUrl + endPointUrl
            let task = session.dataTask(with: URL(string: url)!) { data, response, error in
                
                if response != nil {
                    var isDataValid = false
                    if let d = data {
                        if let value = String(data: d, encoding: String.Encoding.ascii) {
                            
                            if let jsonData = value.data(using: String.Encoding.utf8) {
                                do {
                                    if let _ = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any]{
                                        XCTAssertTrue(true)
                                        isDataValid = true
                                    }
                                } catch {
                                    XCTFail(error.localizedDescription)
                                }
                            }
                        }
                    }
                    
                    if !isDataValid{
                        XCTFail("No data to display")
                    }
                } else {
                    XCTFail("No data to display")
                }
            }
            task.resume()
            
        }  else {
            XCTFail("Internet connection error")
        }
        
    }
    
    func testViewDidLoad() {
        //test view did load
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let feedList = storyboard.instantiateViewController(withIdentifier: "TaskListVC") as? TaskListVC else {
            return
        }
        
        XCTAssertNotNil(feedList.refreshData(_:))
        XCTAssertNotNil(feedList.getFeedData())
    }


}

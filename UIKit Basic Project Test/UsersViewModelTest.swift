//
//  UIKit_Basic_Project_Test.swift
//  UIKit Basic Project Test
//
//  Created by Mustafa B'irat on 14/06/2020.
//  Copyright © 2020 Mustafa Birat. All rights reserved.
//

import XCTest
@testable import UIKit_Basic_Project_1

class UsersViewModelTest: XCTestCase {
    
    var viewModel: UsersViewModel!
    private var request =  MockRequest()
    
    override func setUp() {
        super.setUp()
        viewModel = UsersViewModel(usersRequest: request)
        XCTAssert(viewModel != nil, "ViewModel Present")
    }
    
    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }
    
    func testUsersArray() {
        request.data = getData()
        viewModel.fetchUsers { (response) in
            switch response {
            case .success(_):
                XCTAssert(self.viewModel.filteredUsers.count == 8, "Users Is Here")
            case .failure(_):
                return
            }
        }
    }
    
    func testUserArrayWithoutData() {
        request.data = nil
        viewModel.fetchUsers { response in
            switch response {
            case .failure(_):
                XCTAssert(true)
            case .success(_):
                XCTFail()
            }
        }
        
    }
    
    func testUserSearchWithInput() {
        request.data = getData()
        fetchUsers()
        viewModel.filterUsers(username: "s")
        XCTAssert(self.viewModel.filteredUsers.count == 1, "Search is working well")
    }
    
    func testUserSearchWithoutInput() {
        request.data = getData()
        fetchUsers()
        viewModel.filterUsers(username: nil)
        XCTAssert(self.viewModel.filteredUsers.count == 8, "Search is working well")
    }
    
    private func fetchUsers() {
        let ex =  expectation(description: "users")
        viewModel.fetchUsers {  response in
            ex.fulfill()
        }
        wait(for: [ex], timeout: 1)
    }
    
    private func getData() -> [User] {
        let user1 = User(id: 1, username: "Mustafa", name: "Mustafa B'irat", email: "mustafaadwi@gmail.com", website: "asdsadad", phone: "2343244324", company: Company(name: "asdsadsdad"), address: Address(geo: Geo(lat: "34", lng: "34"), city: "sss"))
        let user2 = User(id: 1, username: "Mohammed", name: "Mustafa B'irat", email: "mustafaadwi@gmail.com", website: "asdsadad", phone: "2343244324", company: Company(name: "asdsadsdad"), address: Address(geo: Geo(lat: "34", lng: "34"), city: "sss"))
        let user3 = User(id: 1, username: "Sari", name: "Mustafa B'irat", email: "mustafaadwi@gmail.com", website: "asdsadad", phone: "2343244324", company: Company(name: "asdsadsdad"), address: Address(geo: Geo(lat: "34", lng: "34"), city: "sss"))
        return Array.init(repeating: user1, count: 5) + Array.init(repeating: user2, count: 2) + Array.init(repeating: user3, count: 1)
    }
    
}

private class MockRequest: UsersRequest {
    
    var data: [User]?
    
    func fetchUsers(completion: @escaping (Result<[User], UserError>) -> Void) {
        if let users = data {
            completion(.success(users))
        } else {
            completion(.failure(.invalidRequest))
        }
    }
}

//
//  UsersViewModel.swift
//  UIKit Basic Project 1
//
//  Created by Asal Macbook 1 on 07/06/2020.
//  Copyright © 2020 Mustafa Birat. All rights reserved.
//

import Foundation

class UsersViewModel {
    
    var filteredUsers: [User]
    private var users: [User]
    private var usersRequest: UsersRequest
    
    init(usersRequest: UsersRequest) {
        self.usersRequest = usersRequest
        users = []
        filteredUsers = []
    }
    
    func fetchUsers(completion: @escaping (Result<[User], Error>) -> Void) {
        usersRequest.fetchUsers { [weak self] response in
            switch response {
            case .success(let users):
                self?.users = users
                self?.filteredUsers = users
                completion(.success(users))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func filterUsers(username: String?) {
        guard let username = username else {
            filteredUsers = users
            return
        }
        filteredUsers =  users.filter({$0.username.lowercased().hasPrefix(username.lowercased())})
    }
    
    
}

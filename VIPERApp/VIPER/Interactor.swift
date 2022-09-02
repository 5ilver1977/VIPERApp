//
//  Interactor.swift
//  VIPERApp
//
//  Created by usuario on 30/8/22.
//

import Foundation

// Object
// Protocol
// Ref to interactor, router, view

// https://jsonplaceholder.typicode.com/users

protocol AnyInteractor {
    var presenter: AnyPresenter? { get set }

    func getUsers()
}

class UserInteractor: AnyInteractor {
    var presenter: AnyPresenter?

    func getUsers() {
        print("Start fetching")
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/users") else { return }
        let task = URLSession.shared.dataTask(with: url) { [ weak self ] data, _, error in
            guard let data = data, error == nil else {
                self?.presenter?.interactorDidFetchUsers(with: .failure(FetchError.failed))
                return
            }

            do {
                let enteties = try JSONDecoder().decode([User].self, from: data)
                self?.presenter?.interactorDidFetchUsers(with: .success(enteties))
            }
            catch {
                self?.presenter?.interactorDidFetchUsers(with: .failure(error))
            }
        }
        task.resume()
    }
}


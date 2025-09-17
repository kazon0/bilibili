//
//  LoginViewModel.swift
//  BiliBili
//
//  Created by 郑金坝 on 2025/9/6.
//


import Foundation
import SwiftUI

class LoginViewModel: ObservableObject {
    @Published var username = ""
    @Published var password = ""
    @Published var token: String?
    @Published var errorMessage: String?
    @Published var isLoading = false

    @AppStorage("userToken") var userToken: String = ""  // 全局 token

    func login() {
        guard !username.isEmpty, !password.isEmpty else {
            errorMessage = "用户名或密码不能为空"
            return
        }

        isLoading = true
        ApiService.shared.login(username: username, password: password) { result in
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let token):
                    self.token = token
                    self.userToken = token   // 自动存储全局 token
                    self.errorMessage = nil
                    //print("登录成功，token:", token)
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                    print("登录失败:", error.localizedDescription)
                }
            }
        }
    }
}


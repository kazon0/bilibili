//
//  LoginView.swift
//  BiliBili
//
//  Created by 郑金坝 on 2025/9/6.
//


import SwiftUI

struct LoginView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var viewModel = LoginViewModel() 
    
    var body: some View {
        VStack(spacing: 20) {
            VStack(alignment: .leading, spacing: 20) {
                // 账号
                VStack(alignment: .leading, spacing: 0) {
                    HStack {
                        Text("账号")
                            .font(.title3)
                            .padding(.trailing)
                        TextField("请输入账号", text: $viewModel.username)
                            .padding(.vertical, 10)
                            .font(.title3)
                    }
                    Rectangle()
                        .frame(height: 0.8)
                        .foregroundColor(.gray.opacity(0.3))
                }
                
                // 密码
                VStack(alignment: .leading, spacing: 5) {
                    HStack{
                        Text("密码")
                            .font(.title3)
                            .padding(.trailing)
                        SecureField("请输入密码", text: $viewModel.password)
                            .padding(.vertical, 10)
                            .font(.title3)
                    }
                    Rectangle()
                        .frame(height: 0.8)
                        .foregroundColor(.gray.opacity(0.3))
                }
            }
            .padding(.horizontal)
            
            // 登录按钮
            Button(action: {
                viewModel.login()
            }) {
                if viewModel.isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                } else {
                    Text("登录")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.accentColor)
                        .foregroundColor(.white)
                        .cornerRadius(25)
                }
            }
            .padding(.horizontal)
            
            // 提示信息
            if !viewModel.userToken.isEmpty {
                Text("登录成功，token: \(viewModel.userToken)")
                    .foregroundColor(.green)
                    .padding()
                    .multilineTextAlignment(.center)
            }
            
            if let error = viewModel.errorMessage {
                Text("登录失败：\(error)")
                    .foregroundColor(.red)
                    .padding()
                    .multilineTextAlignment(.center)
            }
            
            Spacer()
        }
        .padding(.top, 30)
        .navigationBarTitleDisplayMode(.inline) // 保持导航栏小标题模式
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("账号密码登录")
                    .font(.system(size: 22, weight: .bold)) // 自定义字体大小
                    .foregroundColor(.black)
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: Button(action: {
            presentationMode.wrappedValue.dismiss()
        }) {
            Image(systemName: "chevron.left")
                .foregroundColor(.black)
        })
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView { // 包一层 NavigationView，这样导航栏也能显示
            LoginView()
        }
    }
}

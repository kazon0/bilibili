//
//  firstbili.swift
//  bilibili1
//
//  Created by 郑晗希 on 2025/3/26.
//



import SwiftUI


struct VideoPlayerView: View {
    //用环境变量控制导航
    @Environment(\.dismiss) private var dismiss
    @Binding var hideTabBar: Bool
    @Binding var video: Videos
    
    @ObservedObject var viewmodel: CollectionViewModel

    let choosetitle = ["简介", "评论"]
    @State var selectionTitle :String = "简介"
    // 定义单列布局
    let columns = [GridItem(.flexible())]  // 只有一列，宽度灵活填充
    @State private var offset = CGSize.zero
    @State var guesture :String = ""
    
    @StateObject private var playerWrapper = PlayerWrapper()
    @ObservedObject var viewModel: VideoViewModel
    
    var body: some View {

        ScrollView(.vertical, showsIndicators: false){
            
            VStack(alignment: .leading, spacing: 0) {
                // 视频封面/播放区域
                if guesture != "up"{
                    ZStack(alignment: .bottom){
                        
                        ZStack(alignment: .topLeading){

                            Group {
                                VStack {
                                    if let path = Bundle.main.path(forResource: "video1", ofType: "mp4") {
                                        let localUrl = URL(fileURLWithPath: path)
                                        SimpleVideoPlayerView(playerWrapper: playerWrapper, videoURL: localUrl)
                                            .frame(height: UIScreen.main.bounds.width * 9 / 16)
                                    } else {
                                        Text("本地视频未找到")
                                            .frame(height: UIScreen.main.bounds.width * 9 / 16)
                                            .background(Color.gray)
                                    }
                                }
                            }
                            // 返回按钮
                            Button(action: {
                                dismiss()
                            }) {
                                Image(systemName: "chevron.left")
                                    .foregroundColor(Color(#colorLiteral(red: 0.7345525622, green: 0.7345526218, blue: 0.7345525622, alpha: 1)))
                            }
                            .padding()
                            
                        }
                        ProgressbarView(playerWrapper: playerWrapper)
                        }
            }
           
                    LazyVGrid(columns: columns, pinnedViews: [.sectionHeaders]) {
                        Section(header : headerView) {
                            if selectionTitle == "评论"{
                                TotalCommentView()
                            }
                            else if selectionTitle == "简介"{
                                SimpleMesView(video: $video, viewModel: viewModel, viewmodel: viewmodel)
                            }
                        }
                    }
                    

                }
            }
        .overlay(
            Color.black
                .frame(height: safeAreaTop)
                .ignoresSafeArea(edges: .top),
            alignment: .top
        )
        .onAppear {
            hideTabBar = true // 进入时隐藏标签栏
        }
        .onDisappear {
            hideTabBar = false // 退出时恢复标签栏
        }
        .offset(offset)
        .simultaneousGesture(//避免被scrollview盖过
            DragGesture()
                .onChanged { gesture in
                    self.offset = CGSize(width: 0, height: gesture.translation.height)
                }
                .onEnded { gesture in
                    let swipeThreshold: CGFloat = 100
                    if gesture.translation.height > swipeThreshold {
                        // 向下滑动
                        guesture="down"
                    } else if gesture.translation.height < -swipeThreshold {
                        // 向上滑动
                        guesture="up"
                    }
                    self.offset = .zero
                }
        )
        .onAppear {
             hideTabBar = true // 进入时隐藏标签栏
         }
        .navigationBarHidden(true)
        
        
    }
    
    var headerView: some View {
        //导航栏
        VStack(spacing: 0){
            if guesture=="up"{
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.white)
                            .padding()
                    }
                    Spacer()
                    Text("继续播放")
                        .font(.title3)
                        .foregroundColor(.white)
                    Spacer()
                    Image(systemName: "ellipsis")
                        .rotationEffect(.degrees(90))// 旋转90度
                        .foregroundColor(.white)
                        .padding()
                }
                .padding(.vertical,10)
                .background(Color.black.opacity(0.8))
                .transition(.move(edge: .top))
                .zIndex(1)
            }
            HStack(spacing: nil) {
                ForEach(choosetitle, id: \.self){ title in
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.3)){selectionTitle = title}
                    }) {
                        if selectionTitle == title{
                            VStack(spacing:0){
                                Text(title)
                                    .font(.system(.headline, weight: .light))
                                    .foregroundColor(Color(#colorLiteral(red: 1, green: 0.3539066911, blue: 0.6795577407, alpha: 1)))
                                    .padding(.vertical,12)
                                    .overlay(//单独处理下划线动画
                                        Group {
                                if selectionTitle == title {
                                    Divider()
                                        .frame(width: 40, height: 2)
                                        .background(Color.pink)
                                        .transition(.opacity) //只使用淡入淡出
                                }},alignment: .bottom)}}
                        else{
                                Text(title)
                                    .font(.system(.headline, weight: .light))
                                    .foregroundColor(.gray)
            
                            
                        }
                    }
                    .padding(.horizontal,nil)
                 
                }
                Spacer()
                SplitCapsuleButton(
                    leftAction: {
                        print("Left tapped")
                        
                    },
                    rightAction: { print("Right tapped") },
                    leftText: "Left",
                    rightText: "Right"
                )
                
            }
            .padding(.horizontal,nil)
            .padding(.vertical,7)
            Divider()
                .offset(y: -8) // 向上移动8pt，与按钮文字padding一致
        }
        .background(Color.white)
    }
}

struct ConnectVideoView: View {
    let username: String
    let image: String
    let title: String
    let count1: String
    let count2: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack() {
                Image(image)
                    .resizable()
                    .frame(width: 150, height: 90)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                
                VStack(alignment: .leading, spacing: 8) {
                
                    Text(title)
                        .font(.system(.callout))
                        .foregroundColor(.black)
                    Spacer()
                    HStack(spacing: 8) {
                        Text(username)
                            .font(.system(.caption, weight: .light))
                            .foregroundColor(Color(#colorLiteral(red: 0.5174005032, green: 0.5174005032, blue: 0.5174005032, alpha: 1)))
                    }
                    HStack{
                        Text(count1)
                            .font(.system(.caption, weight: .light))
                            .foregroundColor(Color(#colorLiteral(red: 0.5174005032, green: 0.5174005032, blue: 0.5174005032, alpha: 1)))
                        Text(count2)
                            .font(.system(.caption, weight: .light))
                            .foregroundColor(Color(#colorLiteral(red: 0.5174005032, green: 0.5174005032, blue: 0.5174005032, alpha: 1)))
                        Spacer()
                        Button(action: {}) {
                            HStack(spacing: 4) {
                                Image(systemName: "ellipsis")
                                    .rotationEffect(.degrees(90))// 旋转90度
                                    .foregroundColor(.gray)
                                    .font(.system(size: 12))
                            }
                        }
                    }
               
                    }
                    .padding(.leading,3)
                }
            }

        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        Divider()
    }
}

struct CommentView: View {
    let username: String
    let avatar: String
    let content: String
    let time: String
    let likes: String
    @State var isLiked: Bool
    @State var isunLiked: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .top) {
                Image(avatar)
                    .resizable()
                    .frame(width: 30, height: 30)
                    .clipShape(Circle())
                
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Text(username)
                            .font(.system(.caption, weight: .light))
                            .foregroundColor(Color(#colorLiteral(red: 0.5174005032, green: 0.5174005032, blue: 0.5174005032, alpha: 1)))
                    }
                    Text(content)
                        .font(.system(size: 14))
                        .lineLimit(nil)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
            HStack(spacing: 16) {
                Button(action: {
                    isLiked.toggle()
                    isunLiked=false
                }) {
                    HStack(spacing: 4) {
                        Image(systemName: isLiked ? "hand.thumbsup.fill" : "hand.thumbsup")
                            .foregroundColor(isLiked ? Color(#colorLiteral(red: 1, green: 0.35, blue: 0.68, alpha: 1)) : .gray)
                            .font(.system(size: 12))
                        Text(likes)
                            .font(.system(size: 12))
                            .foregroundColor(.gray)
                    }
                }
                Button(action: {
                    isunLiked.toggle()
                    isLiked=false
                }) {
                    HStack(spacing: 4) {
                        Image(systemName: isunLiked ? "hand.thumbsdown.fill" : "hand.thumbsdown")
                            .foregroundColor(isunLiked ? Color(#colorLiteral(red: 1, green: 0.35, blue: 0.68, alpha: 1)) : .gray)
                            .font(.system(size: 12))
                    }
                }
                Button(action: {}) {
                    HStack(spacing: 4) {
                        Image(systemName: "square.and.arrow.up")
                            .foregroundColor(.gray)
                            .font(.system(size: 12))
                    }
                }
                Button(action: {}) {
                    HStack(spacing: 4) {
                        Image(systemName: "text.bubble")
                            .foregroundColor(.gray)
                            .font(.system(size: 12))
                        
                        Text("回复")
                            .font(.system(size: 12))
                            .foregroundColor(.gray)
                    }
                }
                Spacer()
                Button(action: {}) {
                    HStack(spacing: 4) {

                        Text(time)
                            .font(.system(size: 12))
                            .foregroundColor(.gray)
                        Image(systemName: "ellipsis")
                            .rotationEffect(.degrees(90))// 旋转90度
                            .foregroundColor(.gray)
                            .font(.system(size: 12))
                    }
                }
            }
            .padding(.leading, 40)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        Divider()
    }
}

struct SplitCapsuleButton: View {
    let leftAction: () -> Void
    let rightAction: () -> Void
    let leftText: String
    let rightText: String
    
    var body: some View {
        HStack(spacing: 0) {
            Button(action: leftAction) {
                Text("点我发弹幕")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(Color(#colorLiteral(red: 0.7345525622, green: 0.7345526218, blue: 0.7345525622, alpha: 1)))
                    .padding(.horizontal, 16)
                    .padding(.vertical, nil)
                    .background(Color(#colorLiteral(red: 0.9447798133, green: 0.9447798133, blue: 0.9447798133, alpha: 1)))
                    
            }
            Divider()
            Button(action: rightAction) {
                Text("弹")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.gray)
                    .padding(.horizontal, 12)
                    .padding(.vertical, nil)
                    .background(.white)
            }
        }
        .buttonStyle(.plain)
        .frame(height: 35)
        .background(Color.gray.opacity(0.2))
        .clipShape(Capsule())
    }
}



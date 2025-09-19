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
    @EnvironmentObject var tabBarManager: TabBarManager
    @Binding var video: Videos
    @Binding var showVideoView: Bool
    @EnvironmentObject var viewModel: CollectionViewModel

    let choosetitle = ["简介", "评论"]
    @State var selectionTitle :String = "简介"
    // 定义单列布局
    let columns = [GridItem(.flexible())]
    @State private var offset = CGSize.zero
    @State var guesture :String = ""
    @State private var showFolderSelection = false
    @State private var dragOffset = CGSize.zero
    @State private var showCancle = false
    
    @StateObject private var playerWrapper = PlayerWrapper()
    @EnvironmentObject var videoViewModel: VideoViewModel
    
    var body: some View {
        ZStack{
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
                                
                                
                            }
                           // ProgressbarView(playerWrapper: playerWrapper)
                        }}
                        LazyVGrid(columns: columns, pinnedViews: [.sectionHeaders]) {
                            Section(header : headerView) {
                                if selectionTitle == "评论"{
                                    TotalCommentView()
                                }
                                else if selectionTitle == "简介"{
                                    SimpleMesView(video: $video, showCancle: $showCancle, showFolderSelection: $showFolderSelection)
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
            .navigationBarHidden(true)
            // 自定义视图，模拟滑动关闭
            if showFolderSelection {
                    Rectangle()
                        .foregroundColor(.black)
                        .opacity(dragOffset.height > 0 ? 0 : 0.3)

                CollectionListSelectionView(showFolderSelection: $showFolderSelection, video: $video)
                        .offset(y:250)
                        .offset(y: dragOffset.height) // 根据拖动调整位置
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    // 更新拖动偏移
                                    if value.translation.height > 0{ // 向下滑动时
                                        dragOffset = value.translation
                                    }
                                }
                                .onEnded { value in
                                    // 如果滑动超过一定距离，则关闭视图
                                    if dragOffset.height > 10 {
                                        withAnimation {
                                            showFolderSelection = false
                                        }
                                    }
                                    // 重置偏移
                                    dragOffset = .zero
                                }
                        )
                        .animation(.easeOut, value: dragOffset) // 动画效果
            }
            if showCancle {
                    Text("取消收藏")
                        .foregroundColor(.white)
                        .padding(10)
                        .background(Color.black)
                        .cornerRadius(10)
            }
        }
        .onAppear{
            showVideoView = true
        }
        .animation(.easeInOut(duration: 0.3), value: showCancle)
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
                .offset(y: -8) 
        }
        .background(Color.white)
    }
}


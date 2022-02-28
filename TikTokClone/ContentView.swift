import SwiftUI
import AVKit

struct ContentView: View {
    @State var VideoList = [
       //TO DO: Create an arrow of Video objects and add the video into your resources!
        // e.g Video(id: 0, player: AVPlayer(url: URL(fileURLWithPath: Bundle.main.path(forResource: "Video1", ofType: "mov")!)), replay: false, username: "developer_rob", description: "Top 5 SwiftUI resources for Beginners", sound: "Original Sound - developer_rob", likes: 250, comments: 112, shares: 3),
    ]
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea(.all)
            VStack {
                
                VideoPlayerView(videos: VideoList)
                Spacer()
                BottomNavBar()
                    .padding(.init(top: 2, leading: 2, bottom: 2, trailing: 2))
            }
            VStack {
                HeaderText()
                Spacer()
            }
        }
    }
}

struct HeaderText: View {
    var body: some View {
        HStack {
            Button(action: {
                print("Live Button pressed")
            }) {
                Image(systemName: "play.tv")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .foregroundColor(.white)
            }
            
            Spacer()
            Button (action: {
                print("following button pressed")
            }) {
                Text("Following")
                    .foregroundColor(.gray)
            }
            
            Rectangle()
                .frame(width: 1, height: 15)
                .foregroundColor(.gray.opacity(0.2))
            
            Button(action: {
                print("For You Button pressed")
            }) {
                Text("For You")
                    .foregroundColor(.white)
                    .fontWeight(.bold)
            }
            
            Spacer()
            
            Button(action: {
                print("Live Button pressed")
            }) {
                Image(systemName: "magnifyingglass")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .foregroundColor(.white)
            }
            
            
        }
        .padding(.init(top: 15, leading: 15, bottom: 10, trailing: 15))
    }
}


struct Video : Hashable {
    var id: Int
    var player : AVPlayer
    var replay : Bool
    
    var username : String
    var description: String
    var sound : String
    
    var likes : Int
    var comments : Int
    var shares : Int
    
}

struct VideoPlayerView : View {
    @State var videos : [Video]
    
    var body: some View {
        ZStack {
            GeometryReader { proxy in
                TabView {
                    ForEach(0..<self.videos.count) { i in
                        //Player(player: self.data[i].player) // Your cell content
                        ZStack {
                            myPlayerView(data: self.videos[i])
                            HStack {
                                VStack {
                                    VideoDetails(video: self.videos[i])
                                }
                                Spacer()
                                VideoButtons(video: self.videos[i])
                                
                            }
                        }
                        
                    }
                    .rotationEffect(.degrees(-90)) // Rotate content
                    .frame(
                        width: proxy.size.width,
                        height: proxy.size.height
                    )
                }
                .frame(
                    width: proxy.size.height, // Height & width swap
                    height: proxy.size.width
                )
                .rotationEffect(.degrees(90), anchor: .topLeading) // Rotate TabView
                .offset(x: proxy.size.width) // Offset back into screens bounds
                .tabViewStyle(
                    PageTabViewStyle(indexDisplayMode: .never)
                )
            }
        }
    }
}

struct VideoButtons : View {
    let video : Video
    var body: some View {
        VStack(spacing: 15) {
            Spacer()
            Spacer()
            Button(action: {
                print("profile Image clicked")
            }) {
                Image("ProfileImage")
                    .resizable()
                    .frame(width:35, height: 35)
                    .clipShape(Circle())
            }
            VStack {
                Button(action: {
                    print("Like clicked")
                }) {
                    Image(systemName: "suit.heart.fill")
                        .resizable()
                        .frame(width:35, height: 30)
                        .foregroundColor(.white)
                }
                Text("\(video.likes)")
                    .foregroundColor(.white)
                    .font(.system(size: 14))
            }
            
            VStack {
                Button(action: {
                    print("Comment clicked")
                }) {
                    Image(systemName: "text.bubble.fill")
                        .resizable()
                        .frame(width:35, height: 30)
                        .foregroundColor(.white)
                }
                Text("\(video.comments)")
                    .foregroundColor(.white)
                    .font(.system(size: 14))
            }
            
            VStack {
                Button(action: {
                    print("Comment clicked")
                }) {
                    Image(systemName: "arrowshape.turn.up.forward.fill")
                        .resizable()
                        .frame(width:35, height: 30)
                        .foregroundColor(.white)
                }
                Text("\(video.shares)")
                    .foregroundColor(.white)
                    .font(.system(size: 14))
            }
            
            Spacer()
            
        }
        .offset(y: 50)
        .padding()
    }
}

struct Player : UIViewControllerRepresentable {
    
    var player : AVPlayer
    
    func makeUIViewController(context: Context) -> AVPlayerViewController{
        
        let view = AVPlayerViewController()
        view.player = player
        view.showsPlaybackControls = false
        view.videoGravity = .resizeAspectFill
        return view
    }
    
    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {
        
        
    }
}

struct myPlayerView : View {
    @State var data : Video
    
    var body : some View {
        
        Player(player: self.data.player)
            .onAppear {
                data.player.seek(to: .zero)
                data.player.play()
                
                NotificationCenter.default.addObserver(forName: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: data.player.currentItem, queue: .main) { (_) in
                    
                    // notification to identify at the end of the video...
                    
                    // enabling replay button....
                    self.data.replay = true
                }
                
                
            }
            .onDisappear {
                data.player.seek(to: .zero)
                data.player.pause()
            }
    }
}

struct VideoDetails : View {
    let video : Video
    var body : some View{
        VStack(alignment: .leading, spacing: 2) {
            Spacer()
            Text("@\(video.username)")
                .foregroundColor(.white)
                .fontWeight(.bold)
                .font(.system(size: 14))
            
            Text("\(video.description)")
                .multilineTextAlignment(.leading)
                .lineLimit(2)
                .font(.system(size: 12))
                .foregroundColor(.white)
            
            HStack(spacing: 5) {
                Image(systemName: "music.note")
                Text("\(video.sound)")
                    .font(.system(size: 12))
                    .lineLimit(1)
                
            }
            .foregroundColor(.white)
        }
        .padding()
    }
}


struct BottomNavBar: View {
    var body: some View {
        HStack {
            Button(action: {
                print("home button pressed")
            }) {
                VStack {
                    Image(systemName: "house.fill")
                        .resizable()
                        .frame(width:20    , height: 20)
                        .foregroundColor(.white)
                        .padding(.horizontal)
                    Text("Home")
                        .font(.system(size: 10))
                        .foregroundColor(.white)
                }
                
                
            }
            
            
            Button(action: {
                print("discover button pressed")
            }) {
                VStack {
                    Image(systemName: "safari")
                        .resizable()
                        .frame(width:20, height: 20)
                        .foregroundColor(.gray)
                        .padding(.horizontal)
                    Text("Discover")
                        .font(.system(size: 10))
                        .foregroundColor(.gray)
                }
                
            }
            
            Button(action: {
                print("create button pressed")
            }) {
                VStack {
                    Image(systemName: "plus.app.fill")
                        .resizable()
                        .frame(width:30, height: 25)
                        .padding(.horizontal)
                        .foregroundColor(.white)
                    Text("Create")
                        .font(.system(size: 10))
                        .foregroundColor(.gray)
                }
                
            }
            
            Button(action: {
                print("inbox button pressed")
            }) {
                VStack {
                    Image(systemName: "tray")
                        .resizable()
                        .frame(width:20, height: 20)
                        .foregroundColor(.gray)
                        .padding(.horizontal)
                    Text("Inbox")
                        .font(.system(size: 10))
                        .foregroundColor(.gray)
                }
                
            }
            
            Button(action: {
                print("profile button pressed")
            }) {
                VStack {
                    Image(systemName: "person")
                        .resizable()
                        .frame(width:20, height: 20)
                        .foregroundColor(.gray)
                        .padding(.horizontal)
                    Text("Profile")
                        .font(.system(size: 10))
                        .foregroundColor(.gray)
                }
            }
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

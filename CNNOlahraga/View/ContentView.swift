import SwiftUI
import SafariServices

struct ContentView: View {
    
    @StateObject private var newsVM = NewsVM()
    
    @State private var searchText = ""
    @State private var isLoading = true
    
    var searchTitle: [NewsArticle] {
        guard !searchText.isEmpty else {
            return newsVM.articles
        }
        return newsVM.articles.filter { $0.title.lowercased().contains(searchText.lowercased())
        }
    }
    
    //    var searchTitle: [NewsArticle] {
    //        guard !searchText.isEmpty else {
    //            return NewsVM.articles
    //        }
    //        return NewsVM.articles.title {
    //            $0.title?.lowercased().contains(searchText.lowercased())
    //        }
    //    }
    
    var body: some View {
        NavigationStack {
            List {
                ForEach (searchTitle) { article in
                    if newsVM.isLoading{
                        CardNews(article: article)
                            .redacted(reason: .placeholder)
                    } else {
                        CardNews(article: article)
                    }
                    
                }
            }
            .listStyle(.plain)
            .navigationTitle(Constant.newsTitle)
            .task {
                await newsVM.fetchNews()
//                isLoading = false
            }
            .refreshable {
//                isLoading = true
                await newsVM.fetchNews()
//                isLoading = false
            }
            .searchable(text: $searchText,
                        placement: .navigationBarDrawer(displayMode: .always),
                        prompt: "Search"
            )
            .overlay(newsVM.isLoading ? ProgressView() : nil)
            .overlay {
                if searchTitle.isEmpty, !newsVM.isLoading {
                    ContentUnavailableView.search(text: searchText)
                }
                if searchTitle.isEmpty, newsVM.isLoading {
                    waitingView()
                }
            }
        }
    }
}

#Preview {
    ContentView()
}

@ViewBuilder
func waitingView() -> some View {
    VStack(spacing : 20) {
        ProgressView()
            .progressViewStyle(.circular)
            .tint(.pink)
        
        //        Text("Fetch Image....")
    }
}

extension UIApplication {
    var firstKeyWindow: UIWindow? {
        return UIApplication.shared.connectedScenes
            .compactMap { scene in
                scene as? UIWindowScene
            }
            .filter { filter in
                filter.activationState == .foregroundActive
            }
            .first?.keyWindow
    }
}

struct CardNews: View {
    var article: NewsArticle
    var body: some View {
        HStack {
            AsyncImage(url: URL(string: article.image.small)) {
                image in
                image.resizable()
                    .frame(width: 100, height: 100)
                    .scaledToFill().clipShape(RoundedRectangle(cornerRadius: 10))
            } placeholder: {
                ProgressView()
            }
            
            VStack (alignment: .leading, spacing: 16) {
                Text(article.title)
                    .font(.headline)
                    .lineLimit(2, reservesSpace: false)
                
                HStack {
                    
                    Text(article.isoDate.relativeToCurrentDate())
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    
                    
                    Button {
                        let vc = SFSafariViewController(url: URL(string: article.link)!)
                        UIApplication.shared.firstKeyWindow?.rootViewController?.present(vc, animated: false)
                    } label: {
                        Text("| Selengkapnya")
                            .font(.subheadline)
                            .foregroundStyle(.blue)
                            .fontWeight(.bold)
                    }
                }
                
                
            }
            
        }
    }
}

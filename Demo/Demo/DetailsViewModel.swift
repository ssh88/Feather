import Foundation

extension DetailsView {
    final class ViewModel: ObservableObject {
        
        @Published private var user: User?
        private let apiClient: APIClientProvider
        
        var name: String { user?.name ?? "" }
        var username: String { user?.username ?? "" }
        var email: String { user?.email ?? ""}
        
        init(apiClient: APIClientProvider = APIClient()) {
            self.apiClient = apiClient
            fetchUser()
        }
        
        func fetchUser() {
            Task {
                do {
                    let user = try await apiClient.data(for: .user).decode(User.self)
                    await MainActor.run {
                        self.user = user
                    }
                } catch {
                    print("error fetching user: \(error)")
                }
            }
        }
    }
}

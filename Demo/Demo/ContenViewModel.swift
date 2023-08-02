import Foundation

extension ContentView {
    final class ViewModel: ObservableObject {
        
        @Published var users: [User] = []
        private let apiClient: APIClientProvider
        
        init(apiClient: APIClientProvider = APIClient()) {
            self.apiClient = apiClient
        }
        
        func fetchUsers() {
            Task {
                do {
                    let users = try await apiClient.data(for: .users).decode([User].self)
                    await MainActor.run {
                        self.users = users
                    }
                } catch {
                    print("error fetching users: \(error)")
                }
            }
        }
    }
}

import SwiftUI

struct ContentView: View {
    
    @StateObject var viewModel: ViewModel
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    VStack (alignment: .trailing) {
                        HStack {
                            Spacer()

                            Button {
                                viewModel.fetchUsers()
                            } label: {
                                Image(systemName: "arrow.triangle.2.circlepath")
                                    .frame(height: 44)
                                    .foregroundColor(.white)
                            }
                            .background(
                                Circle()
                                    .frame(width: 60)
                                    .foregroundColor(.blue)
                            )
                            .accessibilityIdentifier("refresh-button")
                        }
                        .padding(.trailing)
                    }
                    
                    Image("title-logo")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 200)
                    
                    VStack(alignment: .leading) {
                        Text("Select a user")
                            .font(.headline)
                            .padding(.bottom, 5)
                        
                        VStack(spacing: 10) {
                            ForEach(viewModel.users) { user in
                                NavigationLink {
                                    DetailsView(viewModel: .init())
                                } label: {
                                    userCard(for: user)
                                }
                            }
                        }
                        .padding()
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(.gray, lineWidth: 2)
                        )
                    }
                    Spacer()
                }
                .padding()
                .onAppear() {
                    viewModel.fetchUsers()
                }
            }
        }
    }
    
    @ViewBuilder
    private func userCard(for user: User) -> some View {
        HStack{
            Image(systemName: "person")
                .imageScale(.large)
                .foregroundColor(.accentColor)
                .frame(width: 40)
    
            Text(user.name)
                .accessibilityIdentifier("name")
            
            Spacer()
            
            Image(systemName: "chevron.right")
        }
        .padding(10)
        .background(
            RoundedRectangle(cornerRadius: 5)
                .foregroundColor(Color.gray.opacity(0.2))
            )
        .frame(maxWidth: .infinity)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: .init(apiClient: MockAPIClient()))
    }
}


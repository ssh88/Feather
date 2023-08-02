import SwiftUI

struct DetailsView: View {
    
    @StateObject var viewModel: ViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            VStack {
                card(icon: "person", value: viewModel.name)
                    .accessibilityIdentifier("name")
                card(icon: "number", value: viewModel.username)
                    .accessibilityIdentifier("username")
                card(icon: "envelope", value: viewModel.email)
                    .accessibilityIdentifier("email")
            }
            .background(
                RoundedRectangle(cornerRadius: 5).stroke(.gray, lineWidth: 2)
            )
            .frame(maxWidth: .infinity)
            .padding()
            
            Spacer()
        }
        .navigationTitle("Selected User")
    }
    
    @ViewBuilder
    private func card(icon: String, value: String) -> some View {
        HStack{
            Image(systemName: icon)
                .imageScale(.large)
                .foregroundColor(.accentColor)
                .frame(width: 40)
            Text(value)
                .accessibilityIdentifier("username")
            Spacer()
        }
        .padding(10)
    }
}

struct DetailsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            DetailsView(viewModel: .init(apiClient: MockAPIClient()))
        }
    }
}

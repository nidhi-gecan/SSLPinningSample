import SwiftUI

struct ContentView: View {
    
    @ObservedObject var viewModel: PinningListViewModel
    
    init(viewModel: PinningListViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        List(viewModel.items) { item in
            VStack(alignment: .leading) {
                Text(item.type.rawValue)
                    .font(.headline)
                Text(item.description)
                    .font(.subheadline)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: PinningListViewModel())
    }
}

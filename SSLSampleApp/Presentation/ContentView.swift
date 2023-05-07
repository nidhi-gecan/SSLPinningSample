import SwiftUI

struct ContentView: View {
    
    @ObservedObject var viewModel: PinningListViewModel
    
    init(viewModel: PinningListViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        switch viewModel.uiState {
            case .loading:
                ProgressView().progressViewStyle(.circular)
            case .loaded:
                List(viewModel.items) { item in
                    VStack(alignment: .leading) {
                        Text(item.type.rawValue)
                            .font(.headline)
                            .onTapGesture {
                                self.viewModel.didSelectPinningType(type: item.type)
                            }
                        Text(item.description)
                            .font(.subheadline)
                    }
                }
            case .error:  
                VStack {
                    Text("Pinning Failed").font(.headline)
                    HStack {
                        Button("Cancel") {
                            self.viewModel.cancelLoading()
                        }.padding(.all)
                        Button("Retry") {
                            self.viewModel.loadList()
                        }.padding(.all)
                    }
                    
                } 
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: PinningListViewModel())
    }
}

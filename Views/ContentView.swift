import SwiftUI

struct ContentView: View {
    @StateObject var sharedUser = AppState.shared
    
    var body: some View {
        VStack {
            switch sharedUser.appState {
            case .onboarding:
                IntroView()
            case .loggedin:
                switch sharedUser.user?.userType {
                case .doctor:
                    DoctorHomeView()
                        .transition(.opacity)
                case .patient:
                    PatientHomeView()
                        .transition(.opacity)
                case .none:
                    Text("None")
                }
            }
        }
        .animation(.easeInOut, value: sharedUser.appState)
        .animation(.easeInOut, value: sharedUser.user?.userType)
    }
}

#Preview {
    ContentView()
}

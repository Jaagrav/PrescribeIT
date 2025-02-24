import SwiftUI

struct ContentView: View {
    @ObservedObject var sharedUser = AppState.shared
    
    var body: some View {
        VStack {
            switch sharedUser.appLevel {
            case .onboarding:
                IntroView2()
            case .authorised:
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
        .animation(.easeInOut, value: sharedUser.user?.userType)
        .animation(.easeInOut, value: sharedUser.appLevel)
    }
}

#Preview {
    ContentView()
}

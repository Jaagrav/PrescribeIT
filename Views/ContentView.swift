import SwiftUI

struct ContentView: View {
    @ObservedObject var sharedUser = SharedUser()
    var body: some View {
        if sharedUser.user.userType == "doctor" {
            DoctorHomeView()
        }
    }
}

#Preview {
    ContentView()
}

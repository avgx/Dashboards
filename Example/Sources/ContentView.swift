import SwiftUI
import DashboardsCore
import DashboardsUI

@available(iOS 16.0, *)
@MainActor
struct ContentView: View {
    @StateObject var core = DashboardsCore.shared
    
    @AppStorage("user") var user: String = ""
    @AppStorage("pass") var pass: String = ""
    @AppStorage("api") var api: String = ""
    @AppStorage("token") var token: String = ""
    @State var isValidToken = false
    @State var errorString = ""
    
    var body: some View {
        NavigationStack {
            if isValidToken, let baseURL = URL(string: api), errorString.isEmpty {
                DashboardsUI()
                    .environmentObject(core)
                    .onAppear {
                        core.set(
                            api: baseURL,
                            token: token
                        )
                    }
                    .toolbar {
                        ToolbarItem(placement: .topBarLeading) {
                            Button(action: { isValidToken = false }, label: {
                                Text("Close")
                            })
                        }
                    }
            } else {
                loginForm
            }
        }
        .onAppear {
            checkToken()
        }
    }
    
    @ViewBuilder
    var loginForm: some View {
        List {
            Section {
                TextField("api", text: $api, prompt: Text("api"))
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                    .textContentType(.URL)
                    .keyboardType(.URL)
                    .submitLabel(.done)
            } header: {
                Text("Cloud")
            }
            
            Section {
                TextField("email", text: $user, prompt: Text("email"))
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                    .textContentType(.emailAddress)
                    .keyboardType(.default)
                    .submitLabel(.next)
                SecureField("password", text: $pass, prompt: Text("password"))
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                    .textContentType(.password)
                    .keyboardType(.default)
                    .submitLabel(.done)
            } header: {
                Text("Credentials")
            }
            
            loginButton
        }
    }
    
    @ViewBuilder
    var loginButton: some View {
        Section {
            Button(action: {
                login()
            }, label: {
                HStack {
                    Spacer()
                    Text("Login")
                    Spacer()
                }
                .compositingGroup()
                .padding(8)
            })
            .buttonStyle(.borderedProminent)
        } footer: {
            Text(errorString)
                .foregroundStyle(.red)
        }
        .listRowBackground(Color.clear)
        .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
        .listRowSeparator(.hidden)
    }
    
    func checkToken() {
        guard let url = URL(string: api) else {
            return
        }
        
        Task { @MainActor in
            do {
                self.isValidToken = false
                errorString = ""
                try await DashboardsCore.testToken(url: url, token: self.token)
                self.isValidToken = true
            } catch {
                print(error)
                errorString = error.localizedDescription
            }
        }
    }
    
    func login() {
        guard let url = URL(string: api), !user.isEmpty, !pass.isEmpty else {
            return
        }
        
        Task { @MainActor in
            do {
                self.isValidToken = false
                errorString = ""
                self.token = try await DashboardsCore.login(url: url, user: user, pass: pass)
                self.isValidToken = true
            } catch {
                print(error)
                errorString = error.localizedDescription
            }
        }
    }
}

#Preview {
    if #available(iOS 16.0, *) {
        ContentView()
    } else {
        // Fallback on earlier versions
        Text("need iOS 16+")
    }
}

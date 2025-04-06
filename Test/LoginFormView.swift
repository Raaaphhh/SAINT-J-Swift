import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseFirestore

struct LoginFormView: View {
    
    @Environment(\.dismiss) var dismiss

    @State private var login = ""
    @State private var password = ""
    @State private var message = ""
    @State private var showMenu = false
    @State private var showTransition = false
    @State private var scale: CGFloat = 1.0
    @State private var opacity: Double = 1.0

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            // transition de merde juste pour test
            if showTransition {
                Color.black
                    .ignoresSafeArea()
                    .overlay(
                        Text("SAINT - J")
                            .font(.system(size: 48, weight: .black))
                            .foregroundColor(.white)
                            .scaleEffect(scale)
                            .opacity(opacity)
                            .onAppear {
                                withAnimation(.easeInOut(duration: 1.2)) {
                                    scale = 20.0
                                    opacity = 0.0
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                                    showMenu = true
                                }
                            }
                    )
            } else {
                
                VStack(spacing: 20) {
                    
                    VStack(spacing: 20) {
                        
                        VStack(spacing: 10) {
                            Text("SAINT - J")
                                .font(.system(size: 36, weight: .black))
                                .foregroundColor(.white)

                            Text("CONNEXION")
                                .font(.headline)
                                .foregroundColor(.white)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(red: 40/255, green: 40/255, blue: 40/255))
                        
                        Spacer().frame(height: 50)
                    }


                    VStack(spacing: 20) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Login")
                                .foregroundColor(.white)
                                .fontWeight(.bold)
                                .textCase(.uppercase)

                            TextField("", text: $login)
                                .foregroundColor(.white)
                                .padding(.vertical, 8)
                                .overlay(Rectangle().frame(height: 1).foregroundColor(.white), alignment: .bottom)
                                .autocapitalization(.none)
                        }

                        VStack(alignment: .leading, spacing: 8) {
                            Text("MOT DE PASSE")
                                .foregroundColor(.white)
                                .fontWeight(.bold)
                                .textCase(.uppercase)

                            SecureField("", text: $password)
                                .foregroundColor(.white)
                                .padding(.vertical, 8)
                                .overlay(Rectangle().frame(height: 1).foregroundColor(.white), alignment: .bottom)
                        }

                        Button(action: {
                            loginUser()
                        }) {
                            Text("SE CONNECTER")
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.black)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 5)
                                        .stroke(Color.white, lineWidth: 2)
                                )
                        }

                        if !message.isEmpty {
                            Text(message)
                                .foregroundColor(.red)
                                .multilineTextAlignment(.center)
                        }

                        Text("HEUREUX DE VOUS REVOIR")
                            .foregroundColor(.white)
                            .font(.caption)
                            .fontWeight(.bold)
                            .padding(.top, 10)
                    }
                    .padding()
                    .background(Color(red: 30/255, green: 28/255, blue: 28/255))
                    .cornerRadius(12)
                    .padding(.horizontal)

                    Button(action: {
                        dismiss()
                    }) {
                        Text("RETOUR")
                            .foregroundColor(.white)
                            .fontWeight(.medium)
                            .underline()
                            .padding(.top, 10)
                    }

                    Spacer()
                }
            }

            if showMenu {
                MenuView()
                    .transition(.opacity)
            }
        }
    }

    func loginUser() {
        let db = Firestore.firestore()
        db.collection("users").whereField("login", isEqualTo: login).getDocuments { snapshot, error in
            if let error = error {
                message = "Erreur : \(error.localizedDescription)"
                return
            }

            if let document = snapshot?.documents.first,
               let email = document.data()["email"] as? String {
                Auth.auth().signIn(withEmail: email, password: password) { result, error in
                    if let error = error {
                        message = "Erreur : \(error.localizedDescription)"
                    } else {
                        message = ""
                        showTransition = true
                    }
                }
            } else {
                message = "Login non trouvé"
            }
        }
    }
}

#Preview {
    LoginFormView()
}


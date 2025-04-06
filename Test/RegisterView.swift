import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseAuth

struct RegisterView: View {
    @Environment(\.dismiss) var dismiss

    @State private var login = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var message = ""
    @State private var isRegistered = false

    var body: some View {
        NavigationView {
            ZStack {
                Color.black.ignoresSafeArea()

                VStack(spacing: 20) {
                    Text("INSCRIPTION")
                        .font(.largeTitle)
                        .foregroundColor(.white)
                        .padding(.bottom, 10)

                    TextField("Login", text: $login)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .autocapitalization(.none)
                        .foregroundColor(.black)

                    TextField("Email", text: $email)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .foregroundColor(.black)

                    SecureField("Mot de passe", text: $password)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .foregroundColor(.black)

                    SecureField("Confirmer mot de passe", text: $confirmPassword)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .foregroundColor(.black)

                    Button(action: {
                        registerUser()
                    }) {
                        Text("S'inscrire")
                            .foregroundColor(.black)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.white)
                            .cornerRadius(10)
                    }

                    Text(message)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)

                    Spacer()
                }
                .padding()
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("Retour") {
                            dismiss()
                        }
                        .foregroundColor(.white)
                    }
                }
            }
            .navigationBarBackButtonHidden(true)
        }
    }

    func registerUser() {
        guard password == confirmPassword else {
            message = "Les mots de passe ne correspondent pas"
            return
        }

        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                message = "Erreur : \(error.localizedDescription)"
                return
            }

            guard let uid = result?.user.uid else {
                message = "Erreur interne"
                return
            }

            let db = Firestore.firestore()
            db.collection("users").document(uid).setData([
                "login": login,
                "email": email,
                "score": 0
            ]) { err in
                if let err = err {
                    message = "Erreur Firestore : \(err.localizedDescription)"
                } else {
                    message = "Inscription réussie"
                    isRegistered = true
                    dismiss() // optionnel : on retourne au menu
                }
            }
        }
    }
}

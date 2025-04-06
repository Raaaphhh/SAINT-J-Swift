import SwiftUI
import FirebaseFirestore

struct Joueur: Identifiable {
    let id = UUID()
    let login: String
    let score: Int
}

struct ClassementView: View {
    @State private var joueurs: [Joueur] = []
    private let db = Firestore.firestore()

    var body: some View {
        VStack(spacing: 20) {
            Text("Classement")
                .font(.largeTitle)
                .foregroundColor(.white)

            List(joueurs.sorted(by: { $0.score > $1.score })) { joueur in
                HStack {
                    Text(joueur.login)
                    Spacer()
                    Text("\(joueur.score) pts")
                        .bold()
                }
                .foregroundColor(.white)
                .listRowBackground(Color.black)
            }
            .scrollContentBackground(.hidden)
        }
        .padding()
        .background(Color.black.ignoresSafeArea())
        .onAppear {
            fetchClassement()
        }
        .navigationBarBackButtonHidden(false)
    }

    private func fetchClassement() {
        db.collection("users").getDocuments { snapshot, error in
            guard let documents = snapshot?.documents else { return }
            self.joueurs = documents.compactMap { doc in
                let data = doc.data()
                let login = data["login"] as? String ?? "Inconnu"
                let score = data["score"] as? Int ?? 0
                return Joueur(login: login, score: score)
            }
        }
    }
}

#Preview {
    ClassementView()
}

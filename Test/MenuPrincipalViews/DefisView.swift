import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct Challenge: Identifiable {
    let id = UUID()
    let key: String
    let title: String
    let points: Int
    var isCompleted: Bool
}

enum Difficulty: String, CaseIterable {
    case facile = "Facile"
    case moyen = "Moyen"
    case difficile = "Difficile"
    case extreme = "Extrême"
}

struct DefisView: View {
    @State private var challengesByDifficulty: [Difficulty: [Challenge]] = [:]
    @State private var expandedSection: Difficulty?
    @State private var totalPoints = 0
    @State private var playerLogin = ""

    private let db = Firestore.firestore()
    private let uid = Auth.auth().currentUser?.uid ?? "unknown"

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Bienvenue, \(playerLogin)")
                    .font(.title2)
                    .foregroundColor(.white)

                Text("Score : \(totalPoints)")
                    .foregroundColor(.green)
                    .font(.title2)

                // SECTION FACILE : DisclosureGroup personnalisé
                DisclosureGroup(
                    isExpanded: Binding(
                        get: { expandedSection == .facile },
                        set: { expandedSection = $0 ? .facile : nil }
                    ),
                    content: {
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Prenez garde à ce que les défis que vous réalisez ne mettent en danger ni vous ni qui que ce soit")
                                .font(.caption)
                                .foregroundColor(.white)
                                .padding(.bottom)

                            ForEach(challengesByDifficulty[.facile] ?? []) { challenge in
                                HStack {
                                    Button(action: {
                                        toggleChallenge(difficulty: .facile, challenge: challenge)
                                    }) {
                                        Image(systemName: challenge.isCompleted ? "checkmark.square.fill" : "square")
                                            .resizable()
                                            .frame(width: 24, height: 24)
                                            .foregroundColor(.green)
                                    }

                                    Text(challenge.title)
                                        .foregroundColor(.white)
                                        .font(.body)

                                    Spacer()
                                }
                                .padding()
                                .background(Color(.sRGB, red: 0.1, green: 0.1, blue: 0.1, opacity: 1))
                                .cornerRadius(10)
                            }
                        }
                        .padding(.top)
                    },
                    label: {
                        HStack(spacing: 12) {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .foregroundColor(.green)
                                .font(.title2)

                            VStack(alignment: .leading, spacing: 2) {
                                Text("Liste des défs de niveau :")
                                    .foregroundColor(.white)
                                    .font(.subheadline)

                                Text("Facile")
                                    .foregroundColor(.green)
                                    .font(.headline)
                            }
                        }
                    }
                )
                .padding()
                .background(Color.black.opacity(0.8))
                .cornerRadius(12)
                
                
                // Defis Moyen
                DisclosureGroup(
                    isExpanded: Binding(
                        get: { expandedSection == .moyen },
                        set: { expandedSection = $0 ? .moyen : nil }
                    ),
                    content: {
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Prenez garde à ce que les défis que vous réalisez ne mettent en danger ni vous ni qui que ce soit")
                                .font(.caption)
                                .foregroundColor(.white)
                                .padding(.bottom)

                            ForEach(challengesByDifficulty[.moyen] ?? []) { challenge in
                                HStack {
                                    Button(action: {
                                        toggleChallenge(difficulty: .moyen, challenge: challenge)
                                    }) {
                                        Image(systemName: challenge.isCompleted ? "checkmark.square.fill" : "square")
                                            .resizable()
                                            .frame(width: 24, height: 24)
                                            .foregroundColor(.yellow)
                                    }

                                    Text(challenge.title)
                                        .foregroundColor(.white)
                                        .font(.body)

                                    Spacer()
                                }
                                .padding()
                                .background(Color(.sRGB, red: 0.1, green: 0.1, blue: 0.1, opacity: 1))
                                .cornerRadius(10)
                            }
                        }
                        .padding(.top)
                    },
                    label: {
                        HStack(spacing: 12) {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .foregroundColor(.yellow)
                                .font(.title2)

                            VStack(alignment: .leading, spacing: 2) {
                                Text("Liste des défis de niveau :")
                                    .foregroundColor(.white)
                                    .font(.subheadline)

                                Text("Moyen")
                                    .foregroundColor(.yellow)
                                    .font(.headline)
                            }
                        }
                    }
                )
                .padding()
                .background(Color.black.opacity(0.8))
                .cornerRadius(12)
                
                
                // Niveau Difficile
                DisclosureGroup(
                    isExpanded: Binding(
                        get: { expandedSection == .difficile },
                        set: { expandedSection = $0 ? .difficile : nil }
                    ),
                    content: {
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Prenez garde à ce que les défis que vous réalisez ne mettent en danger ni vous ni qui que ce soit")
                                .font(.caption)
                                .foregroundColor(.white)
                                .padding(.bottom)

                            ForEach(challengesByDifficulty[.difficile] ?? []) { challenge in
                                HStack {
                                    Button(action: {
                                        toggleChallenge(difficulty: .difficile, challenge: challenge)
                                    }) {
                                        Image(systemName: challenge.isCompleted ? "checkmark.square.fill" : "square")
                                            .resizable()
                                            .frame(width: 24, height: 24)
                                            .foregroundColor(.orange)
                                    }

                                    Text(challenge.title)
                                        .foregroundColor(.white)
                                        .font(.body)

                                    Spacer()
                                }
                                .padding()
                                .background(Color(.sRGB, red: 0.1, green: 0.1, blue: 0.1, opacity: 1))
                                .cornerRadius(10)
                            }
                        }
                        .padding(.top)
                    },
                    label: {
                        HStack(spacing: 12) {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .foregroundColor(.orange)
                                .font(.title2)

                            VStack(alignment: .leading, spacing: 2) {
                                Text("Liste des défis de niveau :")
                                    .foregroundColor(.white)
                                    .font(.subheadline)

                                Text("Moyen")
                                    .foregroundColor(.orange)
                                    .font(.headline)
                            }
                        }
                    }
                )
                .padding()
                .background(Color.black.opacity(0.8))
                .cornerRadius(12)
                
                
                
                // Niveau Extreme
                DisclosureGroup(
                    isExpanded: Binding(
                        get: { expandedSection == .extreme },
                        set: { expandedSection = $0 ? .extreme : nil }
                    ),
                    content: {
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Prenez garde à ce que les défis que vous réalisez ne mettent en danger ni vous ni qui que ce soit")
                                .font(.caption)
                                .foregroundColor(.white)
                                .padding(.bottom)

                            ForEach(challengesByDifficulty[.extreme] ?? []) { challenge in
                                HStack {
                                    Button(action: {
                                        toggleChallenge(difficulty: .extreme, challenge: challenge)
                                    }) {
                                        Image(systemName: challenge.isCompleted ? "checkmark.square.fill" : "square")
                                            .resizable()
                                            .frame(width: 24, height: 24)
                                            .foregroundColor(.red)
                                    }

                                    Text(challenge.title)
                                        .foregroundColor(.white)
                                        .font(.body)

                                    Spacer()
                                }
                                .padding()
                                .background(Color(.sRGB, red: 0.1, green: 0.1, blue: 0.1, opacity: 1))
                                .cornerRadius(10)
                            }
                        }
                        .padding(.top)
                    },
                    label: {
                        HStack(spacing: 12) {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .foregroundColor(.red)
                                .font(.title2)

                            VStack(alignment: .leading, spacing: 2) {
                                Text("Liste des défis de niveau :")
                                    .foregroundColor(.white)
                                    .font(.subheadline)

                                Text("Moyen")
                                    .foregroundColor(.red)
                                    .font(.headline)
                            }
                        }
                    }
                )
                .padding()
                .background(Color.black.opacity(0.8))
                .cornerRadius(12)
            }
            .padding()
        }
        .background(Color.black.ignoresSafeArea())
        .onAppear {
            setupChallenges()
            fetchUserData()
        }
        .navigationBarBackButtonHidden(false)
    }

    
    
    // fonction utilitaire de bz
    private func setupChallenges() {
        challengesByDifficulty = Dictionary(uniqueKeysWithValues: Difficulty.allCases.map { level in
            let basePoints: Int
            switch level {
            case .facile: basePoints = 10
            case .moyen: basePoints = 25
            case .difficile: basePoints = 50
            case .extreme: basePoints = 100
            }

            let challenges: [Challenge]

            if level == .facile {
                // Titres personnalisés pour les faciles
                challenges = [
                    Challenge(key: "facile_defi_1", title: "Faire un compliment sincère", points: basePoints, isCompleted: false),
                    Challenge(key: "facile_defi_2", title: "Envoyer un selfie moche", points: basePoints, isCompleted: false),
                    Challenge(key: "facile_defi_3", title: "Manger un aliment étrange", points: basePoints, isCompleted: false),
                    Challenge(key: "facile_defi_4", title: "Tenir la porte à 3 inconnus", points: basePoints, isCompleted: false),
                    Challenge(key: "facile_defi_5", title: "Faire une grimace dans un miroir public", points: basePoints, isCompleted: false),
                    Challenge(key: "facile_defi_6", title: "Marcher en arrière pendant 10 secondes", points: basePoints, isCompleted: false),
                    Challenge(key: "facile_defi_7", title: "Envoyer un message vocal chanté", points: basePoints, isCompleted: false),
                    Challenge(key: "facile_defi_8", title: "Prendre une photo avec un inconnu", points: basePoints, isCompleted: false),
                    Challenge(key: "facile_defi_9", title: "Faire 10 pompes en public", points: basePoints, isCompleted: false),
                    Challenge(key: "facile_defi_10", title: "Changer ta photo de profil pour un truc drôle", points: basePoints, isCompleted: false)
                ]
            } else {
                // Génération automatique pour les autres niveaux
                challenges = (1...10).map { i in
                    Challenge(
                        key: "\(level.rawValue.lowercased())_defi_\(i)",
                        title: "Défi \(i) - \(level.rawValue)",
                        points: basePoints,
                        isCompleted: false
                    )
                }
            }

            return (level, challenges)
        })
    }


    private func toggleChallenge(difficulty: Difficulty, challenge: Challenge) {
        guard let index = challengesByDifficulty[difficulty]?.firstIndex(where: { $0.id == challenge.id }) else { return }

        challengesByDifficulty[difficulty]?[index].isCompleted.toggle()
        let value = challengesByDifficulty[difficulty]![index].isCompleted ? challenge.points : -challenge.points
        totalPoints += value

        db.collection("users").document(uid).updateData([
            "score": FieldValue.increment(Int64(value)),
            "challenges.\(challenge.key)": challengesByDifficulty[difficulty]![index].isCompleted
        ])
    }

    private func fetchUserData() {
        db.collection("users").document(uid).getDocument { doc, error in
            if let data = doc?.data() {
                if let score = data["score"] as? Int {
                    self.totalPoints = score
                }

                if let login = data["login"] as? String {
                    self.playerLogin = login
                }

                if let saved = data["challenges"] as? [String: Bool] {
                    for difficulty in Difficulty.allCases {
                        for i in 0..<10 {
                            let key = "\(difficulty.rawValue.lowercased())_defi_\(i+1)"
                            if let value = saved[key] {
                                self.challengesByDifficulty[difficulty]?[i].isCompleted = value
                            }
                        }
                    }
                }
            }
        }
    }
}




#Preview {
    DefisView()
}

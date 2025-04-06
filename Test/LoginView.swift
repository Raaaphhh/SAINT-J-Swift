import SwiftUI
import SafariServices

// STRUCTURE DU MENU BURGER
struct BurgerMenuView: View {
    @Binding var showMenu: Bool
    @Binding var showCredit: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Button("CRÉDIT") {
                showMenu = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    showCredit = true
                }
            }
            Button("À PROPOS") {
                showMenu = false
            }
            Button("CONTACT") {
                showMenu = false
            }
        }
        .padding()
        .background(Color.black)
        .cornerRadius(15)
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(Color.white, lineWidth: 2)
        )
        .foregroundColor(.white)
        .frame(width: 200)
        .padding(.top, 70)
        .padding(.trailing, 10)
        .transition(.move(edge: .trailing))
        .zIndex(2)
    }
}

// VUE PRINCIPALE
struct LoginView: View {
    @State private var currentImageIndex = 0
    let imageNames = ["img1", "img2", "img3", "img4", "img5", "img6"]
    
    @State private var showInstagram = false
    @State private var showLoginForm = false
    @State private var showRegisterForm = false
    @State private var showBurgerMenu = false
    @State private var showCredit = false

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack(spacing: 25) {
                // Titre + Boutons avec fond noir
                VStack(spacing: 20) {
                    Text("SAINT - J")
                        .font(.system(size: 36, weight: .black))
                        .foregroundColor(.white)

                    HStack {
                        Spacer()
                        Button(action: {
                            withAnimation {
                                showBurgerMenu.toggle()
                            }
                        }) {
                            Image(systemName: "line.horizontal.3")
                                .resizable()
                                .frame(width: 24, height: 18)
                                .foregroundColor(.white)
                                .padding(10)
                        }
                    }

                    HStack(spacing: 20) {
                        Button(action: {
                            showLoginForm = true
                        }) {
                            Text("CONNEXION")
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding(.horizontal, 20)
                                .padding(.vertical, 10)
                                .background(Color.black)
                                .clipShape(Capsule())
                                .overlay(Capsule().stroke(Color.white, lineWidth: 4))
                        }

                        Button(action: {
                            showRegisterForm = true
                        }) {
                            Text("INSCRIPTION")
                                .fontWeight(.bold)
                                .foregroundColor(.black)
                                .padding(.horizontal, 20)
                                .padding(.vertical, 10)
                                .background(Color.white)
                                .clipShape(Capsule())
                                .overlay(Capsule().stroke(Color.black, lineWidth: 4))
                        }
                    }
                }
                .padding()
                .background(Color(red: 62/255, green: 60/255, blue: 59/255).opacity(0.9))
                .cornerRadius(12)

                // Diaporama
                TabView(selection: $currentImageIndex) {
                    ForEach(0..<imageNames.count, id: \.self) { index in
                        Image(imageNames[index])
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 250, height: 300)
                            .cornerRadius(20)
                            .clipped()
                            .tag(index)
                    }
                }
                .frame(width: 250, height: 300)
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
                .onAppear {
                    Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { _ in
                        withAnimation {
                            currentImageIndex = (currentImageIndex + 1) % imageNames.count
                        }
                    }
                }

                // Vainqueur
                VStack(spacing: 10) {
                    Text("VAINQUEUR ÉDITION 1 / 2024")
                        .padding(.top, 5)
                        .padding(.bottom, 5)
                        .foregroundColor(.white)
                        .font(.headline)
                        .multilineTextAlignment(.center)

                    Text("LE GAGNANT DE LA PREMIÈRE ÉDITION DU \"SAINT - J\" PREMIÈRE ÉDITION 2024, EST :")
                        .foregroundColor(.white)
                        .font(.caption)
                        .multilineTextAlignment(.center)

                    Button(action: {
                        showInstagram = true
                    }) {
                        Text("SAM LASIER")
                            .foregroundColor(.purple)
                            .font(.title3)
                            .fontWeight(.heavy)
                            .underline()
                    }
                }
                .padding(.horizontal)

                Spacer()

                // Footer
                Text("SAINT – J, TOUT DROIT RÉSERVÉ, 2025")
                    .foregroundColor(.white)
                    .font(.footnote)
                    .padding()
                    .background(Color(red: 62/255, green: 60/255, blue: 59/255).opacity(0.9))
                    .cornerRadius(12)
            }

            // Menu burger
            if showBurgerMenu {
                VStack {
                    HStack {
                        Spacer()
                        BurgerMenuView(showMenu: $showBurgerMenu, showCredit: $showCredit)
                    }
                    Spacer()
                }
                .transition(.opacity)
            }
        }

        // Pages secondaires
        .fullScreenCover(isPresented: $showLoginForm) {
            LoginFormView()
        }
        .fullScreenCover(isPresented: $showRegisterForm) {
            RegisterView()
        }
        .sheet(isPresented: $showInstagram) {
            SafariView(url: URL(string: "https://www.instagram.com/sam.lsn/?utm_source=ig_web_button_share_sheet")!)
        }
        .fullScreenCover(isPresented: $showCredit) {
            CreditView()
        }
    }
}

// Vue Instagram
struct SafariView: UIViewControllerRepresentable {
    let url: URL

    func makeUIViewController(context: Context) -> SFSafariViewController {
        return SFSafariViewController(url: url)
    }

    func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {}
}

#Preview {
    LoginView()
}

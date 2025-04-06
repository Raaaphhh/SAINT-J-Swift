import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct MenuView: View {
    
    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                Text("Menu Principal")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .padding(.top)

                NavigationLink(destination: DefisView()
                    ) {
                    Text("Défis")
                        .font(.title2)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }

                NavigationLink(destination: ClassementView()) {
                    Text("Classement")
                        .font(.title2)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                
//                NavigationLink(destination: ContratView()) {
//                    Text("Contrat")
//                        .font(.title2)
//                        .padding()
//                        .frame(maxWidth: .infinity)
//                        .background(Color.red)
//                        .foregroundColor(.white)
//                        .cornerRadius(10)
//                }
                
//                NavigationLink(destination: RegleJeuView()) {
//                    Text("Classement")
//                        .font(.title2)
//                        .padding()
//                        .frame(maxWidth: .infinity)
//                        .background(Color.yellow)
//                        .foregroundColor(.white)
//                        .cornerRadius(10)
//                }

            

                Spacer()
            }
            .padding()
            .background(Color.black.ignoresSafeArea())
            .navigationBarBackButtonHidden(true)
            .navigationBarHidden(true)
        }
    }
}

#Preview {
    MenuView()
}

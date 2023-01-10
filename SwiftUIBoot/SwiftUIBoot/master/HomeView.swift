//
//  HomeView.swift
//  SwiftUIBoot
//
//  Created by jeong jinho on 2023/01/03.
//

import SwiftUI

struct HomeView: View {
    @Binding var showProfile: Bool
    @State var showUpdate = false
    
    var body: some View {
        VStack {
            HStack {
                Text("Watching")
                    .font(.system(size: 28,  weight: .bold))
                Spacer()
                
                AvatarView(showProfile: $showProfile)
                
                Button {
                    showUpdate.toggle()
                } label: {
                    Image(systemName: "bell")
                        .foregroundColor(.black)
                        .font(.system(size: 16, weight: .medium))
                        .frame(width: 36, height: 36)
                        .background(Color.white)
                        .clipShape(Circle())
                        .shadow(color: Color.black.opacity(0.1), radius: 1, x: 0, y: 1)
                        .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 10)
                }
                .sheet(isPresented: $showUpdate) {
                    LayoutAndStacks()
                }

            }
            .padding(.horizontal)
            .padding(.top, 30)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(sectionData) { section in
                        SectionView(section: section)
                    }
                }
                .padding(30)
                .padding(.bottom, 30)
            }
            
           
            Spacer()
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(showProfile: .constant(false))
    }
}

struct SectionView: View {
    
    var section: Section
    
    var body: some View {
        VStack {
            HStack(alignment: .top, spacing: 27) {
                Text(section.title)
                    .font(.system(size: 24, weight: .bold))
                    .frame(width: 160, alignment: .leading)
                    .foregroundColor(.white)
                Image(section.logo)
            }
//            .frame(maxWidth: .infinity)
         
            Text(section.text.uppercased())
                .frame(maxWidth: .infinity, alignment: .leading)
            section.image
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 210, height: 150)
        }
       
        .padding(.top, 20)
        .padding(.horizontal, 20)
        .frame(width: 275, height: 275)
        .background(section.color)
        .cornerRadius(30)
        .shadow(color: section.color.opacity(0.3), radius: 20, x: 0, y: 20)
    }
}


struct Section: Identifiable {
    var id = UUID()
    var title: String
    var text: String
    var logo: String
    var image: Image
    var color: Color
}


let sectionData = [Section(title: "SwiftUI Advanced",
                            text: "18 Sections",
                            logo: "Logo1",
                            image: Image("Card1"),
                            color: Color("card1")),
                   Section(title: "Build a SwiftUI App",
                                               text: "20 Sections",
                                               logo: "Logo2",
                                               image: Image("Card2"),
                                               color: Color("card2")),
                   Section(title: "SwiftUI Advanced",
                                               text: "20 Sections",
                                               logo: "Logo2",
                                               image: Image("Card3"),
                                               color: Color("card3")),
                   Section(title: "Concurrency SwiftUI",
                                               text: "18 Sections",
                                               logo: "Logo3",
                                               image: Image("Card2"),
                                               color: Color("card2"))

]

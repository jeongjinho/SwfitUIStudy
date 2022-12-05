//
//  CustomCurvesBootcamp.swift
//  SwiftUIBoot
//
//  Created by jeong jinho on 2022/11/01.
//

import SwiftUI

struct CustomCurvesBootcamp: View {
    @State private var phase = 1.0
    var body: some View {
//        WaterShape()
//            .fill(
//                LinearGradient(gradient: Gradient(colors: [.blue, .white]), startPoint: .leading, endPoint: .trailing)
//            )
//
//            //.stroke(lineWidth: 5)
//            //.frame(width: 200, height: 200)
//            .ignoresSafeArea(.all)
           // .rotationEffect(Angle(degrees: 90))
        
        ZStack {
            Wave(strength: 50, phase: 0, frequency: 30)
                .fill(Color.white)
                       
                        
                        
                }
                .background(Color.blue)
                .edgesIgnoringSafeArea(.all)
                .onAppear {
                    withAnimation(Animation.linear(duration: 5).repeatForever(autoreverses: false)) {
                        self.phase = .pi * 2
                    }
                }
                
    }
}

struct CustomCurvesBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        CustomCurvesBootcamp()
    }
}


struct ArcSample: Shape {
    func path(in rect: CGRect) -> Path {
        Path { path in
            
            path.move(to: CGPoint(x: rect.maxX, y: rect.midY))
            path
                .addArc(center: CGPoint(x: rect.midX, y: rect.midY),
                        radius: rect.height / 2,
                        startAngle: Angle(degrees: 0 ),
                        endAngle: Angle(degrees: 40),
                        clockwise: true)
            
            
        }
    }

}


struct ShapeWithArc: Shape {
    func path(in rect: CGRect) -> Path {
        Path { path in
            //top left
            path.move(to: CGPoint(x: rect.minX, y: rect.minY))
            
            //top right
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
            
            // midright
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
            
            // bottom
           // path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
            path.addArc(center: CGPoint(x: rect.midX, y: rect.midY),
                        radius: rect.height / 2,
                        startAngle: Angle(degrees: 0),
                        endAngle: Angle(degrees: 180),
                        clockwise: false)
            // mid left
            path.addLine(to: CGPoint(x: rect.minX, y: rect.midY))
        }
    }
}


struct QuardSample: Shape {
    func path(in rect: CGRect) -> Path {
        
        Path { path in
            
            path.move(to: .zero)
            path.addQuadCurve(to: CGPoint(x: rect.maxX, y: rect.maxY) , control: CGPoint(x: rect.minX, y: rect.maxY))
        }
    }
    
    
}



struct WaterShape: Shape {
    func path(in rect: CGRect) -> Path {
        Path { path in
            path.move(to: CGPoint(x: rect.minX + 50, y: rect.midY))
            
            path.addQuadCurve(to: CGPoint(x: rect.midX + 50 , y: rect.midY), control: CGPoint(x: rect.width * 0.25, y: rect.height * 0.35))
            
            path.addQuadCurve(to: CGPoint(x: rect.maxX + 50 , y: rect.midY), control: CGPoint(x: rect.width - 50 * 0.75, y: rect.height * 0.65))
            
            path.addLine(to: CGPoint(x: rect.maxX + 50 , y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.minX + 50 , y: rect.maxY))
            
        }
    }
    
        
}
 
struct Wave: Shape {
    // how high our waves should be
    var strength: Double
    var phase: Double
    // how frequent our waves should be
    var frequency: Double
    var animatableData: Double {
        get { phase }
        set { self.phase = newValue }
    }
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath()
       
        // calculate some important values up front
        let width = Double(rect.width)
        let height = Double(rect.height)
        let midWidth = width / 2
        let midHeight = height / 2

        // split our total width up based on the frequency
        let wavelength = width / frequency

        // start at the left center
        path.move(to: CGPoint(x: 0, y: midHeight))

        // now count across individual horizontal points one by one
        for x in stride(from: 0, through: width + 10, by: 1) {
            // find our current position relative to the wavelength
            let relativeX = x / wavelength

            // calculate the sine of that position
            let sine = sin(relativeX + phase)

            // multiply that sine by our strength to determine final offset, then move it down to the middle of our view
            let y = strength * sine + midHeight

            // add a line to here
            path.addLine(to: CGPoint(x: x, y: y))
           
        }
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.midY))
        
        return Path(path.cgPath)
    }
}

//
//  CirclePathBootcamp.swift
//  SwiftUIBoot
//
//  Created by jeong jinho on 2022/12/07.
//

import SwiftUI

struct CircleIndicator: View {
   @State var isRotationCircle: Bool = false
    var body: some View {
        VStack(spacing: 100) {
            Text("animate circle Indicator")
                .onTapGesture {
                    isRotationCircle.toggle()
                }
            
            VStack {
                Text("Path Drawing indicator")
                  
                CirclePath()
                    .stroke(Color.indigo,
                            style: StrokeStyle(lineWidth: 3,
                                               lineCap: .round)
                    )
                    .frame(width: 50, height: 50)
                    .rotationEffect(Angle(degrees: isRotationCircle ? 360 : 0))
                    .animation(.linear(duration: 0.5).repeatForever(autoreverses: false),value: isRotationCircle)
            }
           
            
            VStack {
                Text("Path Drawing indicator")
                Circle()
                    .trim(from: 0.0, to: 320 / 360)
                    .stroke(Color.indigo,
                            style: StrokeStyle(lineWidth: 3,
                                               lineCap: .round
                                              )
                            
                    )
                    .frame(width: 50, height: 50)
                    .rotationEffect(Angle(degrees: isRotationCircle ? 360 : 0))
                    .animation(.linear(duration: 0.5).repeatForever(autoreverses: false),value: isRotationCircle)
            }
            
        }
    }
}

struct CircleIndicator_Previews: PreviewProvider {
    static var previews: some View {
        CircleIndicator()
    }
}



struct CirclePath: Shape {
    func path(in rect: CGRect) -> Path {
        
        var path = Path()
        
        path.addArc(center:
                        CGPoint(x: rect.midX, y: rect.midY),
                    radius: rect.width/2,
                    startAngle: Angle.degrees(0),
                    endAngle: Angle(degrees: 320),
                    clockwise: false
        )
        
//        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
//        path.addLine(to: CGPoint(x: rect.midX, y: -200))
        
        return path
        
    }
    
    
}

////
//
////            CirclePath()
////                .stroke(Color.cyan, lineWidth: 2)
////                .frame(width: 200, height: 200)
////                .rotationEffect(Angle(degrees: isRotationCircle ? 360 : 0))
////                    .animation(Animation.linear(duration: 2).repeatForever(autoreverses: false))
////                      .onAppear {
////                          isRotationCircle = true
////                      }
//
//
// .rotation3DEffect(Angle(degrees: isRotationCircle ? 360 : 0), axis: (x: 100.0, y: 100.0, z: 1))


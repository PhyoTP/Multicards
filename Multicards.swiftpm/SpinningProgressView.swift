import SwiftUI

struct SpinningProgressView: View{
    var body: some View{
        HStack{
            RoundedRectangle(cornerRadius: 5)
                .frame(width: 50, height: 50)
                .rotation3DEffect(
                    .degrees(45),axis: (x: 0, y: -1, z: 0.0)
                )
                .scaleEffect(CGSize(width: 0.5, height: 0.5))
            RoundedRectangle(cornerRadius: 5)
                .frame(width: 50, height: 50)
            RoundedRectangle(cornerRadius: 5)
                .frame(width: 50, height: 50)
                .rotation3DEffect(
                    .degrees(45),axis: (x: 0, y: 1, z: 0.0)
                )
                .scaleEffect(CGSize(width: 1/2, height: 1/2))
        }
    }
}
#Preview{
    SpinningProgressView()
}

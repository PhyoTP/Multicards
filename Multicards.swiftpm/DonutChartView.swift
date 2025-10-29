import SwiftUI

struct DonutChartView: View{
    var total: Double
    var know: Double
    @State private var progress = 0.0
    var decimal = false
    var body: some View{
        ZStack {
            Circle()
                .stroke(lineWidth: 20)
                .opacity(0.3)
                .foregroundColor(Color.gray)
            
            Circle()
                .trim(from: 0.0, to: CGFloat(know*progress) / CGFloat(total))
                .stroke(style: StrokeStyle(lineWidth: 20, lineCap: .round, lineJoin: .round))
                .foregroundStyle(know==total ? .green : accent)
                .rotationEffect(Angle(degrees: -90))
            if decimal{
                Text("\(String(format: "%.1f", know))/\(String(format: "%.1f", total))")
                    .fontWeight(.medium)
            }else{
                Text("\(Int(know))/\(Int(total))")
                    .fontWeight(.medium)
            }
            
        }
        .frame(width: 200, height: 200)
        .scaleEffect(x: 0.9+progress*0.1, y: 0.9+progress*0.1)
        .onAppear(){
            progress = 0
            withAnimation { 
                progress += 1.0
            }
        }
    }
}

#Preview {
    DonutChartView(total: 5, know: 2)
}

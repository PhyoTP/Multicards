import SwiftUI

struct DonutChartView: View{
    var total: Int
    var know: Int
    
    var body: some View{
        ZStack {
            Circle()
                .stroke(lineWidth: 20)
                .opacity(0.3)
                .foregroundColor(Color.gray)
            
            Circle()
                .trim(from: 0.0, to: CGFloat(know) / CGFloat(total))
                .stroke(style: StrokeStyle(lineWidth: 20, lineCap: .round, lineJoin: .round))
                .foregroundStyle(.blue)
                .rotationEffect(Angle(degrees: -90))
            
            Text("\(know)/\(total)")
                .foregroundStyle(Color.primary)
        }
        .frame(width: 200, height: 200)
    }
}

#Preview {
    DonutChartView(total: 5, know: 2)
}

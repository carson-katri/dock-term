import SwiftUI

struct DockTile: View {
    @EnvironmentObject var terminal: Terminal
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack { Spacer() }
            if let output = terminal.output {
                Text(output)
                    .layoutPriority(1)
            } else {
                (Text("›").font(.system(size: 24, weight: .heavy, design: .monospaced)).baselineOffset(-1.5) + Text("\(terminal.input)\(terminal.isFocused && terminal.isShown ? "█" : "")"))
                    .lineLimit(terminal.output != nil ? 1 : nil)
                    .layoutPriority(1)
            }
            Spacer()
        }
        .multilineTextAlignment(.leading)
        .foregroundColor(.white)
        .padding(.leading, 12)
        .padding(.top, 4)
        .font(.system(size: 18, weight: .bold, design: .monospaced))
        .background(ZStack {
            RoundedRectangle(cornerRadius: 18)
                .stroke(Color.black, lineWidth: 4)
                .padding(8)
            RoundedRectangle(cornerRadius: 25)
                .stroke(LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.8809571862, green: 0.9750807881, blue: 1, alpha: 1)), Color(#colorLiteral(red: 0.5036019087, green: 0.493819952, blue: 0.4939008355, alpha: 1))]), startPoint: .top, endPoint: .bottom), lineWidth: 8)
        })
        .background(Color(#colorLiteral(red: 0.1490026712, green: 0.1490303874, blue: 0.148996681, alpha: 1)))
        .cornerRadius(25)
        .padding(10)
    }
}

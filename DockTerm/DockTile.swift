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
                (Text("›").font(.system(size: 28, weight: .heavy, design: .monospaced)).baselineOffset(-1.5) + Text("\(terminal.input)\(terminal.isFocused && terminal.isShown ? "█" : "")"))
                    .lineLimit(terminal.output != nil ? 1 : nil)
                    .layoutPriority(1)
            }
            Spacer()
        }
        .multilineTextAlignment(.leading)
        .foregroundColor(.white)
        .padding(.horizontal)
        .padding(.vertical, 8)
        .font(.system(size: 21, weight: .bold, design: .monospaced))
        .background(Color.black)
        .cornerRadius(25)
    }
}

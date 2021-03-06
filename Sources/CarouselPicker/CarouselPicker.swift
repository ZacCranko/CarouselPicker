import SwiftUI

public struct CarouselPicker<Value: Hashable, Content: View> : View {
    public static var defaultSpacing: CGFloat { 8 }
    public static var defaultSize: CGFloat { 10 }
    
    @State private var entityWidth: CGFloat = .zero
    @GestureState
    private var dragState: (initial: CGFloat?, offset: CGFloat, active: Bool) = (nil, .zero, false)
    
    private let spacing: CGFloat
    private let data: [Value]
    private let markSize: CGFloat
    private let content: (Int, Value) -> Content
    @Binding private var selection: Value
    
    public init(selection: Binding<Value>,
                data: [Value],
                spacing: CGFloat = Self.defaultSpacing,
                markSize: CGFloat = Self.defaultSize,
                content: @escaping (Int, Value) -> Content) {
        self.data = data
        self.spacing = spacing
        self.markSize = markSize
        self.content = content
        self._selection = selection
    }
    
    public init(selection: Binding<Value>,
                data: [Value],
                spacing: CGFloat = Self.defaultSpacing,
                markSize: CGFloat = Self.defaultSize,
                content: @escaping (Value) -> Content) {
        let content = { (offset: Int, value: Value) -> Content in
            content(value)
        }
        self.init(selection: selection, data: data, spacing: spacing, markSize: markSize, content: content)
    }
    
    public var body: some View {
        GeometryReader { proxy in
            VStack {
                CarouselPickerLineGraphic()
                    .frame(width: proxy.size.width, height: 10)
                carouselView()
                    .frame(width: proxy.size.width)
                    .mask(gradientMask)
            }
        }
    }
    
    
    @ViewBuilder
    private func gradientMask() -> some View {
        LinearGradient(gradient: Gradient(colors: [.clear, .black, .clear]),
                       startPoint: .leading, endPoint: .trailing)
    }

    private var carouselOffset: CGFloat {
        dragState.active ? dragState.offset : currentSelectionOffset()
    }
    
    @ViewBuilder
    private func carouselView() -> some View {
        HStack(spacing: spacing) {
            ForEach(Array(data.enumerated()), id: \.offset, content: pickerItemView)
        }
        .offset(x: carouselOffset)
        .onPreferenceChange(MaxWidthPreferenceKey.self) { width in
            entityWidth = max(entityWidth, width)
        }
        .animation(.easeInOut, value: dragState.active)
        .highPriorityGesture(drag)
    }
    
    @ViewBuilder
    private func pickerItemView(index: Int, tag: Value) -> some View {
        content(index, tag)
            .modifier(MaxWidthModifier(width: $entityWidth))
    }
}

//MARK: Gestural Behaviour
extension CarouselPicker {
    private var drag: some Gesture {
        DragGesture()
            .updating($dragState) { value, dragState, transaction in
                let initial = dragState.initial ?? currentSelectionOffset()
                let offset = value.translation.width + initial
                dragState = (initial: initial, offset: offset, active: true)
            }
            .onChanged { _ in
                guard dragState.active else { return }
                if let newSelection = calculateSelection(from: dragState.offset) {
                    selection = newSelection
                }
            }
    }
}

//MARK: Dimensional Calculations
extension CarouselPicker {
    private func currentSelectionOffset() -> CGFloat {
        guard let selectionIndex = data.firstIndex(of: selection) else { return .zero }
        return calculateOffset(from: selectionIndex)
    }

    private var totalWidth: CGFloat {
        let count = CGFloat(data.count)
        return count * entityWidth + (count - 1) * spacing
    }
    
    private func calculateOffset(from index: Int) -> CGFloat {
        let index = CGFloat(index)
        return -(entityWidth * (1 + 2 * index) + 2 * index * spacing - totalWidth) / 2
    }
    
    private func calculateIndex(from offset: CGFloat) -> CGFloat {
        return (-entityWidth - 2 * offset + totalWidth)/(2 * (entityWidth + spacing))
    }
    
    private func calculateSelection(from offset: CGFloat) -> Value? {
        let index = Int(round(calculateIndex(from: offset)))
        guard data.indices.contains(index) else {
            return index < 0 ? data.first : data.last
        }
        return data[index]
    }
}

//#if DEBUG
struct CarouselPickerPreview: View {
    @State private var selection = 5
    @State private var selection2 = 8
    @State private var selection3 = 9
    
    let data: [Int] = Array(stride(from: 0, to: 40, by: 1))
    
    var body: some View {
        VStack {
            VStack(spacing: 8) {
                Text(selection.formatted())
                    .font(.headline)
                CarouselPicker(selection: $selection.animation(.easeInOut),
                               data: data, spacing: 10, content: pickerItem)
            }
            Divider()
            CarouselPicker(selection: $selection,  data: data, content: pickerItem)
            CarouselPicker(selection: $selection2, data: data, content: pickerItem)
                .border(Color.red)
            CarouselPicker(selection: $selection3, data: data) { value in
                Text(value.formatted())
                    .font(.body)
                    .fontWeight(value == selection3 ? .bold : nil)
                    .foregroundColor(value == selection3 ? .white : nil)
                    .padding(8)
                    .background(
                        Circle().fill(Color(.separator))
                    )
                    .compositingGroup()
            }
        }
    }
    
    @ViewBuilder
    private func pickerItem(value: Int) -> some View {
        Button(value.formatted()) {
            withAnimation {
                selection = value
            }
        }
        .buttonStyle(.bordered)
        .clipShape(Circle())
        .tint(selection == value ? .accentColor : nil)
    }
}
//#endif

struct CarouselPicker_Previews: PreviewProvider {
    static var previews: some View {
        CarouselPickerPreview()
    }
}

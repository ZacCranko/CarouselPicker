# Carousel Picker

It basically just provides the `CarouselPicker` struct, which you can put in your stuff. It's my best attempt to copy the beautiful picker from the Apple Health app in the period and medication tracker. Surprisingly creating a picker is quite tricky since it also needs to gracefully respond to changes to the binding from other views. Anyway this was a huge pain to code. Hopefully I'll not lose interest and upload some gifs of the beautiful animation behaviour I managed to get by slaving over this thing.

Also, and this is completely unrelated to anything Swift or SwiftUI, I invented a cocktail this evening, which was pretty great. It's basically a boozed up Lemon Lime and Bitters (which is an Australian classic drink) But I have already had some incredible Italian wine so my sense of taste might be off. Anyway it is as follows:

- 22.5mL lime juice
- 22.5ml demorara syrup (1:1)
- 15mL Angostura bitters. 
- 60mL gin (I used Tanq London dry, it's just great isn't it)

Shake with ice and double strain into a chilled coup and just like totally slam that shit because it's not gonna taste any better if you leave it to get warm. Any astute mixologists reading this will observe that it is just a gin gimlet with a heap of Ango. And you would be right. But I believe the combination of Ango and lime really gives it a unique lift.

## Usage

Here is a thing. I copied it straight out of the `PreviewProvider` I already coded in `CarouselPicker.swift`. Go look there. If you have some suggestions for how to make this suck less I am interested and willing to subscribe to your newsletter. 

```swift
import CarouselPicker

struct SomeViewThatDoesStuff: View {
  @State private var selection = 5
  let data: [Int] = Array(stride(from: 0, to: 40, by: 1))

  var body: some View {
      VStack(spacing: 8) {
          Text(selection.formatted())
              .font(.headline)
          CarouselPicker(selection: $selection.animation(.easeInOut),
                         data: data, spacing: 10, content: pickerItem)
      }
  }

  @ViewBuilder
  private func pickerItem(value: Int) -> some View {
      Text(value.formatted())
          .padding(3)
          .background(
              Circle().fill(Color(.separator))
                  .frame(width: 20, height: 20)
          )
  }
}
```

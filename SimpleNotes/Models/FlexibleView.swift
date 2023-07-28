//
//  FlexibleView.swift
//  SimpleNotes
//
//  Created by Jared Kozar on 7/13/23.
//

import SwiftUI

struct NoteTagDropView: View {
    var tags: [Tag]
    @State var tappedTagAction: ((Tag) -> Void)
    @State private var borderColor: Color = .black
     @State private var borderWidth: CGFloat = 1.0
    var title: String
    var fillInTag: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.caption)
                .foregroundColor(.gray)
            
            ScrollView {
                FlowLayout(tags, numberOfLines: 4, spacing: 9) { tag in
                    TagChip(tagName: tag.tagName!, tagIcon: tag.symbolName!, tagColor: Color(hex: tag.color!)!, fillInTag: fillInTag, tagSize: .large)
                        .onTapGesture {
                            tappedTagAction(tag)
                        }
                        .draggable(tag)
                }
                
              }
            .background(.tertiary)
            .cornerRadius(15)
             
        }
    }
}

enum TagSize {
    case small
    case large
    
    var fontSize: Font {
        switch self {
        case .large:
            return .title
        case .small:
            return .system(size: 16.0)
        }
    }
}
struct TagChip: View {
    var tagName: String
    var tagIcon: String
    var tagColor: Color
    var fillInTag: Bool
    var tagSize: TagSize
    
    var body: some View {
        HStack {
            Image(systemName: tagIcon)
            
            Text(tagName.isEmpty ? "No tag name entered" : tagName)
                .bold()
        }
        .padding(12)
        .foregroundColor(fillInTag ? .primary : tagColor)
        .background(fillInTag ? tagColor : .clear)
        .cornerRadius(12)
        .lineLimit(1)
        .font(tagSize.fontSize)
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(tagColor, lineWidth: fillInTag ? 0.0 : 4.0)
        )
        .contentShape(Rectangle())
    }
}

struct FlowLayout<Data, RowContent>: View where Data: RandomAccessCollection, RowContent: View, Data.Element: Identifiable, Data.Element: Hashable {
  @State private var height: CGFloat = .zero
  private var data: Data
  private var spacing: CGFloat
  private var rowContent: (Data.Element) -> RowContent
    
    public init(_ data: Data, numberOfLines: Int, spacing: CGFloat = 4, @ViewBuilder rowContent: @escaping (Data.Element) -> RowContent) {
    self.data = data
    self.spacing = spacing
    self.rowContent = rowContent
  }

  var body: some View {
    GeometryReader { geometry in
        content(in: geometry)
        .background(viewHeight(for: $height))
    }
    .frame(height: height)
  }

    private func content(in geometry: GeometryProxy) -> some View {
    var bounds = CGSize.zero
        
    return ZStack {
      ForEach(data) { item in
        rowContent(item)
          .padding(.all, spacing)
          .alignmentGuide(VerticalAlignment.center) { dimension in
            let result = bounds.height

            if let firstItem = data.first, item == firstItem {
              bounds.height = 0
            }
            return result
          }
          .alignmentGuide(HorizontalAlignment.center) { dimension in
            if abs(bounds.width - dimension.width) > geometry.size.width {
              bounds.width = 0
                bounds.height -= dimension.height
            }

            let result = bounds.width

            if let firstItem = data.first, item == firstItem {
              bounds.width = 0
            } else {
              bounds.width -= dimension.width
            }
            return result
          }
      }
    }
  }

  private func viewHeight(for binding: Binding<CGFloat>) -> some View {
    GeometryReader { geometry -> Color in
      let rect = geometry.frame(in: .local)

      DispatchQueue.main.async {
        binding.wrappedValue = rect.size.height
      }
      return .clear
    }
  }
}

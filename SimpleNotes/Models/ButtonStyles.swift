//
//  ButtonStyles.swift
//  SimpleNotes
//
//  Created by Jared Kozar on 5/20/23.
//

import Foundation
import SwiftUI

struct BaseButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .frame(width: 100, alignment: .center)
            .frame(maxHeight: .infinity)
            .background(Color(uiColor: .quaternarySystemFill))
            .buttonStyle(PlainButtonStyle())
            .cornerRadius(15)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }
}

struct RoundedIcon: View {
    var icon: IconTypes
    
    enum IconTypes {
        case systemImage(iconName: String, backgroundColor: Color, tintColor: Color)
        case customImage(iconName: String, backgroundColor: Color)
    }
    
    var body: some View {
        ZStack {
            
            switch icon {
            case .systemImage(iconName: let name, backgroundColor: let bgColor, tintColor: let iconTintColor):
                self.roundedRectangle(backgroundColor: bgColor)
                Image(systemName: name)
                    .foregroundColor(iconTintColor)
            case .customImage(iconName: let name, backgroundColor: let bgColor):
                
                self.roundedRectangle(backgroundColor: bgColor)
                
                Image(name)
            }
        }
    }
}

extension RoundedIcon {
    func roundedRectangle(backgroundColor: Color) -> some View {
        
        RoundedRectangle(cornerRadius: 8, style: .continuous)
            .fill(backgroundColor)
    }
}

struct IconModifier: ViewModifier {
    let icon: RoundedIcon
    
    func body(content: Content) -> some View {
        HStack {
            icon
                .frame(width: 40, height: 40)
            
            content
        }
    }
}

struct RightSideDetailModifier<DetailView: View>: ViewModifier {
    let detailContent: DetailView

    init(@ViewBuilder content: () -> DetailView) {
        self.detailContent = content()
    }

    func body(content: Content) -> some View {
        HStack {
            content
       }
       .overlay(
           self.detailContent
            .padding(.trailing, 25),
           alignment: .trailing
       )
    }
}

extension SettingsItem where Self: View {
    func iconModifier(icon: RoundedIcon) -> some View {
        modifier(IconModifier(icon: icon))
    }
    
    func rightDetail<Content: View>(@ViewBuilder content: () -> Content) -> some View {
        modifier(RightSideDetailModifier(content: content))
    }
}


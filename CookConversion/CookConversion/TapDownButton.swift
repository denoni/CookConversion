//
//  TapDownButton.swift
//  CookConversion
//
//  Created by Gabriel on 11/1/21.
//

import SwiftUI

struct TapDownButton: View {
  var text: String

  @State private var shouldShowMenu = false

  var body: some View {
    Button(action: {
      withAnimation(.interactiveSpring()) {
        shouldShowMenu.toggle()
      }
    }, label: {
      ZStack {
        RoundedRectangle(cornerRadius: 19, style: .continuous)
          .foregroundColor(.white)
        HStack {
          Text(text)
            .foregroundColor(.black)
            .fontWeight(.semibold)
            .padding(.leading, 20)
            .padding(.trailing, 10)
          Spacer()
          Rectangle()
            .foregroundColor(.black.opacity(0.2))
            .frame(width: 2)
            .frame(maxHeight: .infinity)
          Image(systemName: shouldShowMenu ? "chevron.up" : "chevron.down")
            .foregroundColor(.black)
            .scaledToFit()
            .padding(.trailing, 10)
        }
      }
    })
    .overlay(
      VStack {
        if self.shouldShowMenu {
          Spacer(minLength: 60 + 10)
          PopOverMenu()
        }
      }, alignment: .topLeading
    )
  }
}

struct PopOverMenu: View {
  var items = ["Sugar", "Flour", "Salt", "Butter", "Water", "Milk",
               "Sugar", "Flour", "Salt", "Butter", "Water", "Milk"]

  var body: some View {
      ZStack {
        RoundedRectangle(cornerRadius: 19, style: .continuous)
          .foregroundColor(.white)
        ScrollView {
          VStack {
            ForEach(items, id: \.self) { item in
              Text(item)
                .foregroundColor(.black)
                .padding(.top, 5)
              Divider()
            }
          }
          .padding()
        }
      }
      .padding(.horizontal, 30)
      .shadow(radius: 25)
      .frame(width: 200)
      .frame(height: 400)
      .scaledToFit()
      .ignoresSafeArea()
      .zIndex(1)
    }
}

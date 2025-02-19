//
//  CharacterDetailView.swift
//  RickMorty
//
//  Created by Riyad Anabtawi on 12/02/25.
//

import Foundation
import SwiftUI

struct CharacterDetailView: View {
    let character: Character

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: backgroundColor(for: character.status)),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 20) {
                    AsyncImage(url: URL(string: character.image)) { phase in
                        if let image = phase.image {
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(width: 200, height: 200)
                                .clipShape(Circle())
                                .overlay(Circle().stroke(Color.white, lineWidth: 4))
                                .shadow(radius: 10)
                        } else {
                            ProgressView()
                                .frame(width: 200, height: 200)
                        }
                    }
                    .padding(.top, 30)

                    Text(character.name)
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.white)
                        .shadow(radius: 5)

                    VStack(spacing: 12) {
                        DetailCard(title: "Species", value: character.species)
                        DetailCard(title: "Gender", value: character.gender)
                        DetailCard(title: "Status", value: character.status)
                    }
                    .padding(.horizontal, 20)
                }
                .padding(.bottom, 40)
            }
        }
    }

    private func backgroundColor(for status: String) -> [Color] {
        switch status.lowercased() {
        case "alive":
            return [Color.green.opacity(0.8), Color.blue.opacity(0.8)]
        case "dead":
            return [Color.red.opacity(0.8), Color.black.opacity(0.8)]
        default:
            return [Color.gray.opacity(0.7), Color.black.opacity(0.8)]
        }
    }
}


struct DetailCard: View {
    let title: String
    let value: String

    var body: some View {
        HStack {
            Text(title)
                .font(.headline)
                .foregroundColor(.white)
            Spacer()
            Text(value)
                .font(.subheadline)
                .foregroundColor(.white)
                .bold()
        }
        .padding()
        .background(Color.white.opacity(0.2))
        .cornerRadius(12)
        .shadow(radius: 5)
    }
}

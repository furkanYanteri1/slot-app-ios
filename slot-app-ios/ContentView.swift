//
//  ContentView.swift
//  slot-app-ios
//
//  Created by Furkan Yanteri on 6.05.2025.
//

import SwiftUI

struct Hexagoni: Shape {
    func path(in rect: CGRect) -> Path {
        return Path { path in
            let p1 = CGPoint(x: 0, y: 20)
            let p2 = CGPoint(x: 0, y: rect.height - 20)
            let p3 = CGPoint(x: rect.width/2, y: rect.height)
            let p4 = CGPoint(x: rect.width, y: rect.height - 20)
            let p5 = CGPoint(x: rect.width, y: 20)
            let p6 = CGPoint(x: rect.width/2, y: 0)
            path.move(to: p6)
            path.addArc(tangent1End: p1, tangent2End: p2, radius: 15)
            path.addArc(tangent1End: p2, tangent2End: p3, radius: 15)
            path.addArc(tangent1End: p3, tangent2End: p4, radius: 15)
            path.addArc(tangent1End: p4, tangent2End: p5, radius: 15)
            path.addArc(tangent1End: p5, tangent2End: p6, radius: 15)
            path.addArc(tangent1End: p6, tangent2End: p1, radius: 15)
        }
    }
}

enum Choice: Int, Identifiable {
    var id: Int { rawValue }
    case success, failure
}

struct ContentView: View {
    @State public var symbols = ["eating", "happy", "love"]
    @State public var numbers = [0, 1, 2, 1, 0]
    @State public var counter = 0
    @State private var showingAlert: Choice?
    @State private var rotation: Double = 0
    @State private var textColor: Color = .white
    @State private var isShuffling = false
    @State private var buttonOpacity: Double = 1.0
    @State private var buttonScale: CGFloat = 1.0

    private let maxTries = 10 // Total tries allowed before failure

    var body: some View {
        ZStack {
            Image("sunshine")
                .resizable()
                .ignoresSafeArea(.all)

            VStack(alignment: .center, spacing: 80) {
                VStack(spacing: 8) {
                    HStack {
                        Image("fire")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 40)
                            .shadow(color: .orange, radius: 15, y: 5)

                        Text("Slot Machine")
                            .font(.system(size: 30))
                            .fontWeight(.black)

                        Image("fire")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 40)
                            .shadow(color: .orange, radius: 15, y: 5)
                    }
                    .frame(maxWidth: .infinity, alignment: .center)

                    Text("Remaining Tries: \(max(0, maxTries - counter))")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.vertical, 6)
                        .padding(.horizontal, 12)
                        .background(
                            Capsule()
                                .fill(Color.black.opacity(0.4))
                                .overlay(Capsule().stroke(Color.white.opacity(0.5), lineWidth: 1))
                        )
                }

                VStack(spacing: 15) {
                    HStack(spacing: 35) {
                        ForEach([0, 1], id: \.self) { i in
                            Hexagoni().fill(Color.green).opacity(0.7)
                                .frame(width: 100, height: 120)
                                .overlay(Image(symbols[numbers[i]])
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 80, height: 70)
                                    .shadow(color: .gray, radius: 7, y: 7))
                                .overlay(
                                    Hexagoni()
                                        .stroke(
                                            LinearGradient(
                                                gradient: Gradient(colors: [Color.white.opacity(0.8), Color.clear]),
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            ),
                                            lineWidth: 5
                                        )
                                )
                        }
                    }

                    Hexagoni().fill(Color.green).opacity(0.7)
                        .frame(width: 100, height: 120)
                        .overlay(Image(symbols[numbers[2]])
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 70)
                            .shadow(color: .gray, radius: 7, y: 7))
                        .overlay(
                            Hexagoni()
                                .stroke(
                                    LinearGradient(
                                        gradient: Gradient(colors: [Color.white.opacity(0.8), Color.clear]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                    lineWidth: 5
                                )
                        )

                    HStack(spacing: 35) {
                        ForEach([3, 4], id: \.self) { i in
                            Hexagoni().fill(Color.green).opacity(0.7)
                                .frame(width: 100, height: 120)
                                .overlay(Image(symbols[numbers[i]])
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 80, height: 70)
                                    .shadow(color: .gray, radius: 7, y: 7))
                                .overlay(
                                    Hexagoni()
                                        .stroke(
                                            LinearGradient(
                                                gradient: Gradient(colors: [Color.white.opacity(0.8), Color.clear]),
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            ),
                                            lineWidth: 5
                                        )
                                )
                        }
                    }
                }

                Button(action: {
                    withAnimation(.easeOut(duration: 0.3)) {
                        buttonOpacity = 0.0
                        buttonScale = 0.8
                    }

                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        isShuffling = true
                        var shuffleCount = 0
                        let maxShuffles = 20
                        let shuffleInterval = 0.1

                        Timer.scheduledTimer(withTimeInterval: shuffleInterval, repeats: true) { timer in
                            for i in 0..<numbers.count {
                                numbers[i] = Int.random(in: 0...2)
                            }
                            shuffleCount += 1
                            if shuffleCount >= maxShuffles {
                                timer.invalidate()
                                isShuffling = false

                                withAnimation(.interpolatingSpring(stiffness: 200, damping: 10)) {
                                    buttonOpacity = 1.0
                                    buttonScale = 1.0
                                }

                                counter += 1
                                if numbers.allSatisfy({ $0 == numbers.first }) {
                                    showingAlert = .success
                                    counter = 0
                                } else if counter >= maxTries {
                                    showingAlert = .failure
                                    counter = 0
                                }
                            }
                        }
                    }
                }) {
                    Text("SPIN")
                        .font(.title)
                        .fontWeight(.black)
                        .foregroundColor(textColor)
                        .frame(width: 300, height: 70)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.purple.opacity(0.3))
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(
                                    AngularGradient(
                                        gradient: Gradient(colors: [.green, .yellow, .white, .green]),
                                        center: .center,
                                        angle: .degrees(rotation)
                                    ),
                                    lineWidth: 8
                                )
                                .blur(radius: 2)
                                .opacity(1)
                        )
                        .shadow(color: .green.opacity(0.5), radius: 10, y: 10)
                }
                .opacity(buttonOpacity)
                .scaleEffect(buttonScale)
                .disabled(isShuffling)
                .onAppear {
                    withAnimation(Animation.linear(duration: 2).repeatForever(autoreverses: false)) {
                        rotation = 360
                    }

                    withAnimation(Animation.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                        textColor = .pink
                    }
                }
                .onChange(of: textColor) {
                    switch textColor {
                        case .pink:
                            withAnimation(Animation.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                                textColor = .yellow
                            }
                        case .yellow:
                            withAnimation(Animation.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                                textColor = .white
                            }
                        case .white:
                            withAnimation(Animation.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                                textColor = .green
                            }
                        default:
                            withAnimation(Animation.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                                textColor = .pink
                            }
                    }
                }
            }
            .alert(item: $showingAlert) { alert -> Alert in
                switch alert {
                    case .success:
                        return Alert(title: Text("NICE"), message: Text("You got it!"), dismissButton: .cancel())
                    case .failure:
                        return Alert(title: Text("OOPS"), message: Text("Opsie opsie! TRY AGAIN:("), dismissButton: .cancel())
                }
            }
        }
    }
}

#Preview {
    ContentView()
}

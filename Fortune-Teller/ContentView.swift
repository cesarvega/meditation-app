//
//  ContentView.swift
//  Fortune-Teller
//
//  Created by Cesar Vega on 9/23/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]
    @State private var languageManager = LanguageManager()
    @State private var showLanguagePicker = false

    var body: some View {
        NavigationSplitView {
            List {
                ForEach(items) { item in
                    NavigationLink {
                        Text("Item at \(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))")
                            .background(Color.clear)
                    } label: {
                        Text(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))
                    }
                }
                .onDelete(perform: deleteItems)
                .listRowBackground(Color.clear)
            }
            .scrollContentBackground(.hidden)
            .background(
                Image("BackgroundImage")
                    .resizable()
                    .scaledToFill()
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                    .clipped()
                    .ignoresSafeArea(.all)
            )
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    VStack {
                        Text(languageManager.localizedString(.welcome))
                            .font(.title2)
                            .foregroundColor(.white)
                        Text(languageManager.localizedString(.userName))
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                    .padding(.top, 30)
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        showLanguagePicker = true
                    }) {
                        Image(systemName: "globe")
                            .foregroundColor(.white)
                    }
                }
            }
            .toolbarBackground(.clear, for: .navigationBar)
            .toolbarBackgroundVisibility(.hidden, for: .navigationBar)
        } detail: {
            Text(languageManager.localizedString(.selectItem))
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(
                    Image("BackgroundImage")
                        .resizable()
                        .scaledToFill()
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                        .clipped()
                        .ignoresSafeArea(.all)
                )
        }
        .background(
            Image("BackgroundImage")
                .resizable()
                .scaledToFill()
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                .clipped()
                .ignoresSafeArea(.all)
        )
        .sheet(isPresented: $showLanguagePicker) {
            LanguagePickerView(languageManager: languageManager)
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}

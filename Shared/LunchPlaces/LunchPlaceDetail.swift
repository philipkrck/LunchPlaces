//
//  LunchPlaceDetail.swift
//  Lunch Places
//
//  Created by Philip Krück on 24.06.20.
//

import SwiftUI
import MapKit

struct NavigationBarTitleStyle: ViewModifier {
    var title: String
    
    @ViewBuilder func body(content: Content) -> some View {
        #if os(iOS)
        content
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle(title)
        #else
        content
        #endif
    }
}

struct LunchPlaceDetail: View {
    
    @Binding var region: MKCoordinateRegion
    
    var lunchPlace: LunchPlace
    
    private var platformIsiOS: Bool {
        #if os(iOS)
        return true
        #else
        return false
        #endif
    }
    
    @ViewBuilder var body: some View {
        Group {
            #if os(iOS)
            container
            #else
            container
                .frame(minWidth: 500, idealWidth: 700, maxWidth: .infinity, minHeight: 300, maxHeight: .infinity)
            #endif
        }
        .modifier(NavigationBarTitleStyle(title: lunchPlace.name))
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button(action: {
                    // ToDo: Toggle lunch place
                    print("toggling lunch place")
                }) {
                    Label("Favorite", systemImage: lunchPlace.isFavorite ? "heart.fill" : "heart")
                        .labelStyle(IconOnlyLabelStyle())
                }
            }
        }
    }
    
    var container: some View {
        ZStack {
            GeometryReader { proxy in
                ScrollView {
                    #if os(iOS)
                    content(size: proxy.size)
                    #else
                    content(size: proxy.size)
                        .frame(maxWidth: 600)
                        .frame(maxWidth: .infinity)
                    #endif
                }
            }
            .overlay(bottomBar, alignment: .bottom)
        }
    }
    
    var bottomBar: some View {
        VStack(spacing: 0) {
            Divider()
            HStack {
                VStack(alignment: .leading) {
                    Text("\(lunchPlace.address.streetName) \(lunchPlace.address.houseNumber)")
                        .font(.caption)
                        .foregroundColor(.primary)
                    Text("\(lunchPlace.address.postalCode) \(lunchPlace.address.city)")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
                Spacer()
                
                OpenMapButton(lunchPlace: lunchPlace)
    
            }
            .padding(16)
            
        }
        .background(VisualEffectBlur().edgesIgnoringSafeArea(.all))
    }
    
    func content(size: CGSize) -> some View {
        VStack {
            lunchPlace.image
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: size.width)
                .background(Color.accentColor)
            
            VStack(alignment: .leading) {
                Text("Map")
                    .font(Font.title).bold()
                    .foregroundColor(.secondary)
                    .padding(.horizontal)
                
                HStack {
                    Spacer()
                    Map(coordinateRegion: $region, interactionModes: .all, showsUserLocation: true, annotationItems: [lunchPlace], annotationContent: { _ in
                        MapMarker(coordinate: lunchPlace.locationCoordinate)
                    })
                        .frame(width: size.width - 20, height: 300) // ToDo: Maybe make this dynamic for MacOS || iPadOS
                        .cornerRadius(15)
                        .shadow(radius: 6)
                    Spacer()
                }
            }
            .padding(.bottom, 90)
            
        }
    }
}

struct LunchPlaceDetail_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            LunchPlaceDetail(region: .constant(testData[0].coordinateRegion), lunchPlace: testData[0])
        }
        .previewDevice("iPhone SE (2nd generation)")
    }
}

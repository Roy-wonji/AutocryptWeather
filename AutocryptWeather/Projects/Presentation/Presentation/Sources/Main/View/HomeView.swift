//
//  HomeView.swift
//  Presentation
//
//  Created by 서원지 on 8/8/24.
//

import SwiftUI

import ComposableArchitecture
import DesignSystem

public struct HomeView : View {
    @Bindable var store: StoreOf<Home>
    
    public init(store: StoreOf<Home>) {
        self.store = store
    }
    
    public var body: some View {
        ZStack{
            Image(asset: .bgClear)
                .edgesIgnoringSafeArea(.all)
        }
    }
    
}

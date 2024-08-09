//
//  DailyWeatherInfoView.swift
//  Presentation
//
//  Created by 서원지 on 8/9/24.
//

import SwiftUI
import Model
import DesignSystem

 struct DailyWeatherInfoView: View {
     @State var dailyWeatherItem: DailyWeatherItem
     
    var body: some View {
        ZStack {
            Rectangle()
                .background(.clear)
                .opacity(0)
            
            HStack {
                Text(dailyWeatherItem.timeText)
                    .pretendardFont(family: .SemiBold, size: 20)
                    .foregroundStyle(Color.basicWhite)
                
                Image(assetName: dailyWeatherItem.weatherImageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 32, height: 32)
                
                
                Spacer()
                 
                
                
                HStack {
                    Text("최소: ")
                        .pretendardFont(family: .SemiBold, size: 18)
                        .foregroundStyle(Color.basicWhite)
                    
                    Spacer()
                        .frame(width: 5)
                    
                    Text("\(Int(dailyWeatherItem.minTemp))º")
                        .pretendardFont(family: .Regular, size: 18)
                        .foregroundStyle(Color.basicWhite)
                        .opacity(0.7)
                    
                    Spacer()
                        .frame(width: 10)
                    
                    Text("최대: ")
                        .pretendardFont(family: .SemiBold, size: 18)
                        .foregroundStyle(Color.basicWhite)
                    
                    Spacer()
                        .frame(width: 5)
                    
                    Text("\(Int(dailyWeatherItem.maxTemp))º")
                        .pretendardFont(family: .Regular, size: 20)
                        .foregroundStyle(Color.basicWhite)
                        .foregroundColor(.white)
                }
            }
            .padding(.horizontal, 20)
        }
        .frame(height: 40)
    }
}

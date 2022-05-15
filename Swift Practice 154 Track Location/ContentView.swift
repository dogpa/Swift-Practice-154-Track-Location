//
//  ContentView.swift
//  Swift Practice 154 Track Location
//
//  Created by Dogpa's MBAir M1 on 2022/5/15.
// .constant(.follow)

import SwiftUI
import MapKit
import CoreLocationUI

struct ContentView: View {
    
    //locationVM為LocationViewModel
    @StateObject private var locationVM = LocationViewModel()
    
    //MapUserTrackingMode的追蹤模式
    @State private var trackMode = MapUserTrackingMode.none
    
    var body: some View {
        //ZStack最底層是一個Map，上一層為一層GeometryReader
        ZStack{
            
            //Map內顯示使用者的位置，並且在MapAnnotation放入locationVM.locations透過coordinate顯示位置
            //透過ocationVM.locations裡面的地理坐標計算使用者的直線距離顯示在Text內
            //第二個Text為locationVM.locations地理位置名稱
            Map(coordinateRegion: $locationVM.region, showsUserLocation: true, userTrackingMode: $trackMode  , annotationItems: locationVM.locations) { item in
                MapAnnotation(coordinate: item.coordinate, content: {
                    VStack{
                        Text("\(getKOrKMDString(distance: locationVM.locationforCL.distance(from: CLLocation(latitude:   item.coordinate.latitude, longitude: item.coordinate.longitude))))")
                            .font(.system(size: 25))
                            .foregroundColor(.red)
                        Text(item.locationName)
                            .font(.system(size: 15))
                            .foregroundColor(.black)
                        Image(systemName: "hare.fill")
                            .foregroundColor(.brown)
                    }
                })
            }
                .ignoresSafeArea()
                .accentColor(.cyan)
                .onAppear {
                    locationVM.checkIfLocationServicesIsEnabled()
                }
            
            //GeometryReader內包一層ZStack第一層放LocationButton
            //使用者按下後會回到實際位置，不按時可自由滑動地圖
            //第二層放入Text顯示使用者目前的經緯度資訊
            GeometryReader{ geo in
                ZStack{
                    LocationButton(.currentLocation){
                        locationVM.requestUserLocation()
                    }
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .labelStyle(.iconOnly)
                    .symbolVariant(.fill)
                    .tint(.blue)
                    .position(x: CGFloat(geo.size.width*0.9), y: CGFloat(geo.size.height*0.05))
                    Text(locationVM.locationStr)
                        .frame(width: 300, height: 60, alignment: .center)
                        .background(RoundedRectangle(cornerRadius: 20).fill(.yellow))
                        .tint(.black)
                        .position(x: CGFloat(geo.size.width/2), y: CGFloat(geo.size.height*0.93))
                }
            }
        }
    }
    
    /// 若直線距離大於1000則除1000並顯示公里
    /// 小於1000則顯示公司
    /// 統一顯示小數點三位數
    ///  - Parameters :
    ///      - distance : 直線距離的Double值
    /// - Returns: 回傳指定字串Double大於1000回傳公里，小於則回傳公尺
    func getKOrKMDString (distance: Double) -> String {
        if distance > 1000 {
            return "\(String(format: "%.2f", distance/1000)) 公里"
        }else{
            return "\(String(format: "%.2f", distance)) 公尺"
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

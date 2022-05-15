//
//  LocationInfo.swift
//  Swift Practice 154 Track Location
//
//  Created by Dogpa's MBAir M1 on 2022/5/15.
//

import MapKit

/// 自定義Struct顯示地理位置名稱、座標
struct LocationInfo: Identifiable {
    let id = UUID()
    var locationName: String
    var coordinate: CLLocationCoordinate2D
}

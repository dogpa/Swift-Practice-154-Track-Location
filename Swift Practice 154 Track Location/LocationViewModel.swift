//
//  LocationViewModel.swift
//  Swift Practice 154 Track Location
//
//  Created by Dogpa's MBAir M1 on 2022/5/15.
//

import MapKit


/// 存放初始的地理位置與地圖比例尺
enum MapDetails {
    static let originLocation = CLLocationCoordinate2D(latitude: 24.138419004819387, longitude: 121.27559334860734)
    static let span = MKCoordinateSpan(latitudeDelta: 0.007, longitudeDelta: 0.007)
}

final class LocationViewModel : NSObject, ObservableObject, CLLocationManagerDelegate {
    
    //存放User的經緯度座標位置的String
    @Published var locationStr = ""
    
    //存放User的經緯度座標位置的CLLocation，用於計算指定距離使用
    @Published var locationforCL = CLLocation(latitude: 0, longitude: 0)
    
    //取得使用者授權前的MAP顯示位置與比例尺透過MapDetails的值來顯示
    @Published var region = MKCoordinateRegion(center: MapDetails.originLocation, span: MapDetails.span)
    
    //指定的地理位置資訊
    @Published var locations : [LocationInfo] = [
        LocationInfo(locationName: "南京中山路口", coordinate: CLLocationCoordinate2D(latitude: 25.05209613290682, longitude: 121.52262644205325)),
        LocationInfo(locationName: "佳德鳳梨酥", coordinate: CLLocationCoordinate2D(latitude: 25.05149309289402, longitude: 121.56136908217748)),
        LocationInfo(locationName: "雙連捷運站", coordinate: CLLocationCoordinate2D(latitude: 25.057665287774267, longitude: 121.52070258908108)),
        LocationInfo(locationName: "武嶺", coordinate: CLLocationCoordinate2D(latitude: 24.13841623015346, longitude: 121.27613231089555) ),
        LocationInfo(locationName: "玉山", coordinate: CLLocationCoordinate2D(latitude: 23.47144414607863, longitude: 120.9565614647542) ),
        LocationInfo(locationName: "台北101", coordinate: CLLocationCoordinate2D(latitude: 25.034124805468366, longitude: 121.56459742830336)),
        LocationInfo(locationName: "誠品信義", coordinate: CLLocationCoordinate2D(latitude: 25.040111912498237, longitude: 121.56530375802147)),
        LocationInfo(locationName: "國父紀念館", coordinate: CLLocationCoordinate2D(latitude: 25.04023173572094, longitude: 121.56025206624714)),
        LocationInfo(locationName: "爭艷館", coordinate: CLLocationCoordinate2D(latitude: 25.0697284745406, longitude:121.5207299230507)),
        LocationInfo(locationName: "花博美術", coordinate: CLLocationCoordinate2D(latitude: 25.070605526965235, longitude:121.52491989810517)),
        LocationInfo(locationName: "圓山捷運站", coordinate: CLLocationCoordinate2D(latitude: 25.07135797854527, longitude:121.52013845451364)),
        LocationInfo(locationName: "台北美術館", coordinate: CLLocationCoordinate2D(latitude: 25.072551133729885, longitude:121.5249537247578)),
        LocationInfo(locationName: "迎風狗公園", coordinate: CLLocationCoordinate2D(latitude: 25.071947203878448, longitude:121.56542726090473)),
        LocationInfo(locationName: "中正紀念堂", coordinate: CLLocationCoordinate2D(latitude: 25.037079231508375, longitude:121.52255289693066)),
        LocationInfo(locationName: "故宮博物館", coordinate: CLLocationCoordinate2D(latitude: 25.105894564671516, longitude:121.5495002060138)),
        LocationInfo(locationName: "淡水捷運站", coordinate: CLLocationCoordinate2D(latitude: 25.167849548485794, longitude:121.56542726090473)),
        LocationInfo(locationName: "台北動物園", coordinate: CLLocationCoordinate2D(latitude: 25.003414347204167, longitude:121.58200230646047)),
        LocationInfo(locationName: "Apple Infinite Loop", coordinate: CLLocationCoordinate2D(latitude: 37.33194497023909, longitude:-122.03082664386939)),
        LocationInfo(locationName: "Apple Park", coordinate: CLLocationCoordinate2D(latitude: 37.33538567968964, longitude:-122.00906722448553)),
        LocationInfo(locationName: "Homestead High School", coordinate: CLLocationCoordinate2D(latitude: 37.337994707450775, longitude:-122.05113142147135))
    ]
    
    //取得CLLocationManager
    var locationManager =  CLLocationManager()
    
    func checkIfLocationServicesIsEnabled () {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.startUpdatingLocation()
        }else{
            print("可通知使用者去設定開啟地理位置權限")
        }
    }
    
    /// 取得使用者目前所在的位置，並顯示在MAP當中
    func requestUserLocation () {
        locationManager.requestLocation()
        DispatchQueue.main.async { [self] in
            self.region = MKCoordinateRegion(center: self.locationManager.location!.coordinate , span: MapDetails.span)
        }
    }
    
    /// 確認使用者的授權，若允許存取將使用者的位置指派給region
    private func checkLocationAuthorization () {
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            print("你的地理位置權限受限")
        case .denied:
            print("你的地理位置沒有獲得你的允許，可至設定中開啟權限")
        case .authorizedAlways, .authorizedWhenInUse:
            region = MKCoordinateRegion(center: locationManager.location?.coordinate ?? MapDetails.originLocation, span: MapDetails.span)
        @unknown default:
            break
        }
    }
    
    /// 使用者若改變使用授權，再次檢查授權狀況
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
    
    /// 若使用者的位置改變，將最新的位置存入locationforCL，locationStr存入將使用者的經緯度
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationforCL = locations[0]
        print("目前位置 緯度：\(locations[0].coordinate.latitude) 經度：\(locations[0].coordinate.longitude)")
        locationStr = "緯度：\(locations[0].coordinate.latitude)\n經度：\(locations[0].coordinate.longitude)"
    }
    
    ///若遭遇Error則列印Error
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}

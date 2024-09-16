//
//  SNGCarouselBannerViewModel.swift
//  SongTraining
//
//  Created by William Rena on 7/9/23.
//

import UIKit
import WSRUtils
import WSRCommon

final class SNGCarouselBannerViewModel {
    var isLoading: WSRObservableObject<Bool> = WSRObservableObject(false)
    var error: WSRObservableObject<String> = WSRObservableObject("")
    
    var bannerData: WSRObservableObject<SNGBannerModel> = WSRObservableObject(SNGBannerModel.defaultData())
    var banners: [SNGBannerDataModel] {
        bannerData.value.data
    }
    
    let defaultImages = [
        UIImage(named:"CarouselBike1"),
        UIImage(named:"CarouselBike2"),
        UIImage(named:"CarouselBike3")
    ]
    
    let defaultBanner = SNGBannerDataModel.defaultData()
    
    func getBanners() async {
        self.isLoading.value = true
        
        do {
            let data = try await WSRApiService().getBanners()
            bannerData.value = data
            
            self.isLoading.value = false
            self.error.value = ""
        }
        catch(let error) {
            if let error = error as? WSRApiError {
                wsrLogger.api(message: error.description)
                
                if error.description == WSRApiError.badRequest.description {
                    self.isLoading.value = false
                    self.error.value = SNGErrorAlertType.badRequest.rawValue
                }
                else {
                    self.isLoading.value = false
                    self.error.value = SNGErrorAlertType.somethingWentWrong.rawValue
                }
            }
            else {
                wsrLogger.api(message: "\(error.localizedDescription)")
                
                self.isLoading.value = false
                self.error.value = SNGErrorAlertType.domain.rawValue
            }
            
        }
    }
}

//
//  SNGNewsViewModel.swift
//  SongTraining
//
//  Created by William Rena on 7/6/23.
//

import Foundation

final class SNGNewsViewModel {
    var isLoading: WSRObservableObject<Bool> = WSRObservableObject(false)
    var error: WSRObservableObject<String> = WSRObservableObject("")
    
    var postData: WSRObservableObject<SNGPostDataModel> = WSRObservableObject(SNGPostDataModel.defaultData())
    
    var postList: [SNGPostModel] { return postData.value.data }
    
    func getPosts() async {
        self.isLoading.value = true
        
        do {
            let data = try await WSRApiService().getPosts()
            
            self.postData.value = data
            self.isLoading.value = false
            self.error.value = ""
        }
        catch(let error) {
            if let error = error as? WSRApiError {
                logger.api(message: error.description)
                
                if error.description == WSRApiError.badRequest.description {
                    self.isLoading.value = false
                    self.error.value = SNGErrorAlertType.badRequest.rawValue
                }
                else {
                    self.isLoading.value = false
                    self.error.value = SNGErrorAlertType.somethingWentWrong.rawValue
                }
            }
        }
    }
    
    func getPostList() -> [SNGPostModel] {
        return postData.value.data
    }
    
}

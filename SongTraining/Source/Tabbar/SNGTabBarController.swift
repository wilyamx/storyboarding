//
//  SNGTabBarController.swift
//  SongTraining
//
//  Created by William Rena on 6/28/23.
//

import UIKit

enum SNGScreenTab: String {
    case home = "SNGHomeViewController"
    case products = "SNGProductsViewController"
    case favorites = "SNGFavoritesViewController"
    case cart = "SNGCartViewController"
    case profile = "SNGProfileViewController"
    
    func getNavigationControllerIdentifier() -> String {
        switch self {
        case .home:
            return "SNGHomeNavigationController"
        case .products:
            return "SNGProductsNavigationController"
        case .favorites:
            return "SNGFavoritesNavigationController"
        case .cart:
            return "SNGCartNavigationController"
        case .profile:
            return "SNGProfileNavigationController"
        }
        
    }
    
    func getTabBarItem() -> UITabBarItem {
        switch self {
        case .home:
            let tabBarItem =  UITabBarItem(title: "Home",
                                image: UIImage(systemName: "house"),
                                selectedImage: UIImage(systemName: "house.fill"))
            return tabBarItem
        case .products:
            return UITabBarItem(title: "Explore",
                                image: UIImage(systemName: "magnifyingglass"),
                                selectedImage: UIImage(systemName: "magnifyingglass"))
        case .favorites:
            return UITabBarItem(title: "Favorites",
                                image: UIImage(systemName: "heart"),
                                selectedImage: UIImage(systemName: "heart.fill"))
        case .cart:
            return UITabBarItem(title: "Cart",
                                image: UIImage(systemName: "cart"),
                                selectedImage: UIImage(systemName: "cart.fill"))
        case .profile:
            return UITabBarItem(title: "Profile",
                                image: UIImage(systemName: "person.circle"),
                                selectedImage: UIImage(systemName: "person.circle.fill"))
        }
    }
    
}

class SNGTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // opaque tabbar
        if #available(iOS 13.0, *) {
            let tabBarAppearance: UITabBarAppearance = UITabBarAppearance()
            tabBarAppearance.configureWithDefaultBackground()
            
            UITabBar.appearance().standardAppearance = tabBarAppearance
            UITabBar.appearance().tintColor = UIColor.black
            
            if #available(iOS 15.0, *) {
                UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    static func tabController(forAuthenticatedUser: Bool? = false) -> UITabBarController {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        
        let tabbar = SNGTabBarController()
        
        let homeVC = storyboard.instantiateViewController(withIdentifier: SNGScreenTab.home.getNavigationControllerIdentifier())
        let productsVC = storyboard.instantiateViewController(withIdentifier: SNGScreenTab.products.getNavigationControllerIdentifier())
        let favoritesVC = storyboard.instantiateViewController(withIdentifier: SNGScreenTab.favorites.getNavigationControllerIdentifier())
        let cartVC = storyboard.instantiateViewController(withIdentifier: SNGScreenTab.cart.getNavigationControllerIdentifier())
        let profileVC = storyboard.instantiateViewController(withIdentifier: SNGScreenTab.profile.getNavigationControllerIdentifier())
        
        homeVC.tabBarItem = SNGScreenTab.home.getTabBarItem()
        productsVC.tabBarItem = SNGScreenTab.products.getTabBarItem()
        favoritesVC.tabBarItem = SNGScreenTab.favorites.getTabBarItem()
        cartVC.tabBarItem = SNGScreenTab.cart.getTabBarItem()
        profileVC.tabBarItem = SNGScreenTab.profile.getTabBarItem()
        
        
        var viewControllers = [homeVC, productsVC, profileVC]
        if let forAuthenticatedUser = forAuthenticatedUser, forAuthenticatedUser {
            viewControllers = [homeVC, productsVC, favoritesVC, cartVC, profileVC]
        }
        
        tabbar.viewControllers = viewControllers
        return tabbar
    }
}

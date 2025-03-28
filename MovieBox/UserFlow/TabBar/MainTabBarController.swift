//
//  ViewController.swift
//  MovieBox
//
//  Created by marty.academy on 1/24/25.
//

import UIKit

final class MainTabBarController: UITabBarController {
    
    let selectedColor = AppColor.woodenConcept2.inUIColorFormat
    let unselectedColor = AppColor.subInfoDeliver.inUIColorFormat
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppColor.mainBackground.inUIColorFormat
        
        configureViewControllers()
        configureBarAppearance()
    }
    
    private func configureViewControllers() {
        tabBar.tintColor = selectedColor
        
        let mainViewController = MainViewController()
        let mainVCSymbol = AppSFSymbol.film.image.withTintColor(unselectedColor)
        let mainVCSymbolSelected = AppSFSymbol.film.image.withTintColor(selectedColor)
        let mainNC = UINavigationController(rootViewController: mainViewController)
        mainNC.tabBarItem = UITabBarItem(title: "", image: mainVCSymbol, selectedImage: mainVCSymbolSelected)
        
        let searchViewController = SearchViewController()
        let upcommingVCSymbol = AppSFSymbol.magnifyingglass.image.withTintColor(unselectedColor)
        let upcommingVCSymbolSelected = AppSFSymbol.magnifyingglass.image.withTintColor(selectedColor)
        let upcommingNC = UINavigationController(rootViewController: searchViewController)
        upcommingNC.tabBarItem = UITabBarItem(title: "", image: upcommingVCSymbol, selectedImage: upcommingVCSymbolSelected)
        
        let settingViewController = SettingViewController()
        let settingVCSymbol = AppSFSymbol.person.image.withTintColor(unselectedColor)
        let settingVCSymbolSelected = AppSFSymbol.person.image.withTintColor(selectedColor)
        let settingNC = UINavigationController(rootViewController: settingViewController)
        settingNC.tabBarItem = UITabBarItem(title: "", image: settingVCSymbol, selectedImage: settingVCSymbolSelected)
        
        setViewControllers([mainNC, upcommingNC, settingNC], animated: true)
    }
    
    private func configureBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = AppColor.mainBackground.inUIColorFormat
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
    }
}

extension MainTabBarController: UITabBarControllerDelegate {}


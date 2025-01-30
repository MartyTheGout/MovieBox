//
//  ViewController.swift
//  MovieBox
//
//  Created by marty.academy on 1/24/25.
//

import UIKit

final class MainTabBarController: UITabBarController {
    
    let selectedColor = AppColor.mainInfoDeliver.inUIColorFormat
    let unselectedColor = AppColor.subInfoDeliver.inUIColorFormat
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppColor.mainBackground.inUIColorFormat
        
        configureViewControllers()
        configureBarAppearance()
    }
    
    private func configureViewControllers() {
        let mainViewController = MainViewController()
        let mainVCSymbol = AppSFSymbol.popcorn.image.withTintColor(unselectedColor)
        let mainVCSymbolSelected = AppSFSymbol.popcorn.image.withTintColor(selectedColor)
        let mainNC = UINavigationController(rootViewController: mainViewController)
        mainNC.tabBarItem = UITabBarItem(title: "CINEMA", image: mainVCSymbol, selectedImage: mainVCSymbolSelected)
        
        let upcomingViewController = UIViewController() //TODO: 준비중이라는 메세지를 띄워주도록 구현
        let upcommingVCSymbol = AppSFSymbol.film.image.withTintColor(unselectedColor)
        let upcommingVCSymbolSelected = AppSFSymbol.film.image.withTintColor(selectedColor)
        let upcommingNC = UINavigationController(rootViewController: upcomingViewController)
        upcommingNC.tabBarItem = UITabBarItem(title: "UPCOMING", image: upcommingVCSymbol, selectedImage: upcommingVCSymbolSelected)
        
        let settingViewController = UIViewController()
        let settingVCSymbol = AppSFSymbol.person.image.withTintColor(unselectedColor)
        let settingVCSymbolSelected = AppSFSymbol.person.image.withTintColor(selectedColor)
        let settingNC = UINavigationController(rootViewController: settingViewController)
        settingNC.tabBarItem = UITabBarItem(title: "PROFILE", image: settingVCSymbol, selectedImage: settingVCSymbolSelected)
        
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


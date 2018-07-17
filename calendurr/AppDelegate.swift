//
//  AppDelegate.swift
//  calendurr
//
//  Created by Johnny Sheeley on 6/21/18.
//  Copyright © 2018 Johnny Sheeley. All rights reserved.
//

import UIKit
import EventKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    override init() {
        store = EKEventStore()
    }

    var window: UIWindow?
    let store: EKEventStore

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        checkCalendarAuthorizationStatus()
        
        return true
    }
    
    func loadIt() {
        let calendars = store.calendars(for: EKEntityType.event)
        print(calendars)
//        for cal in calendars {
//            print("title: \(cal.title)\n\(cal)")
//        }
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
    
    func checkCalendarAuthorizationStatus() {
        let status = EKEventStore.authorizationStatus(for: EKEntityType.event)
        
        switch (status) {
        case EKAuthorizationStatus.notDetermined:
            // This happens on first-run
            requestAccessToCalendar()
        case EKAuthorizationStatus.authorized:
            let cal = store.calendar(withIdentifier: "1CFEAAAB-91F7-4BA5-877B-FB447CE06B97")
//            if cal == nil {
//            }
            let now = Date()
            let ti = TimeInterval(60 * 60)

            let example = EKEvent(eventStore: store)
            example.location = "Conference Room - SM - Buttcheeks"
            example.title = "Always Open"
            example.startDate = now.addingTimeInterval(ti)
            example.endDate = example.startDate.addingTimeInterval(ti)
            example.calendar = cal


            do {
                try store.save(example, span: EKSpan.thisEvent)
            } catch {
                print("error creating test event: \(error)")
            }

//            self.loadIt()
        case EKAuthorizationStatus.restricted, EKAuthorizationStatus.denied:
            print("holy crap")
            // We need to help them give us permission
//            needPermissionView.fadeIn()
        }
    }
    
    func requestAccessToCalendar() {
        self.store.requestAccess(to: EKEntityType.event, completion: {
            (accessGranted: Bool, error: Error?) in
            print("granted = \(accessGranted)")
//            if accessGranted == true {
////                DispatchQueue.main.async(execute: {
//////                    self.loadCalendars()
//////                    self.refreshTableView()
////                })
//            } else {
////                DispatchQueue.main.async(execute: {
//////                    self.needPermissionView.fadeIn()
////                })
//            }
        })
    }


}


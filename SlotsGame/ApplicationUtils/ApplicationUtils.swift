import Foundation
import SwiftUI

class ApplicationUtils: NSObject, UIApplicationDelegate {
        
    static var orientationLock = UIInterfaceOrientationMask.landscape

    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return ApplicationUtils.orientationLock
    }
    
}

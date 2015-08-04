//
//  SettingsController.swift
//  UniChef
//
//  Created by Leena Annamraju on 8/3/15.
//  Copyright (c) 2015 Andrew/Leena. All rights reserved.
//

import UIKit

class SettingsController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showRules" {
            if let vc = segue.destinationViewController as? ImportantStuff {
                let title = "We reserve the right to suspend or block users for violating our regulations. Edible is meant to be a safe environment where users can upload and view each other's content. We ask that you avoid posting any content that may be deemed offensive, illegal, or useless. \n 1. Do not post or share personal information. \n 2. Do not bully or harass other users. \n 3. Users who spam the feed or consistently have their content flagged will be suspended."
                vc.importantStr = title
            }
        }
        if segue.identifier == "showPrivacy" {
            if let vc = segue.destinationViewController as? ImportantStuff {
                let title = "All of our users are pseudoanonymous. We do not collect nor distribute any personal data about our users. We do not expect users to provide their email address or name and we will not distribute any information to Third Party Vendors. However, we may use Third Party Analytics to assess usage of our services. \n\n We collect any and all content you submit to the services. Any information you post or upload is available publicly for other users to view. You are able to delete this information at will, however we may retain it for our records."
                vc.importantStr = title
            }
        }
        if segue.identifier == "showTerms" {
            if let vc = segue.destinationViewController as? ImportantStuff {
                let title = "Your access to and use of this app is conditioned on your compliance with our Terms of Service. By using this app, you agree to be bound by these Terms. These terms apply to all users who access or use or Services. \n\n We reserve the right to terminate or suspend access to this app immediately, without prior notice or liability, upon violation or breaching of our Terms. \n\n Additionally, we cannot guarentee that your use of this app will be uninterrupted or error-free. We may make changes to our service at any time, or make provisions to our terms at any time by posting the updated policy within the app. \n\nBy using this app you are also acknowledging and agreeing that you are at least 18 years of age. Persons under 18 years of age are not allowed to access our Services.\n\nUsers may not upload or submit copyrighted or trademarked material. By using this app you agree to pay all royalties, fees, or damages that may result from your uploaded content. We respect the intellectual rights of others. If you feel that your intellectual property appears in this app, feel free to contact us regarding the issue so that we may get it quickly resolved. \n\nUsers may not discuss or incite illegal activity. Edible is not liable for any legal issues that may stem from inappropriate use of this app. Use Edible at your own risk."
                vc.importantStr = title
            }
        }

    }

}
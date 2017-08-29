//
//  UserDetail.swift
//  TrollyAppItem
//
//  Created by Rashdan Natiq on 29/08/2017.
//  Copyright © 2017 Devclan. All rights reserved.
//
import Foundation
import UIKit

class UserDetail {
    
    var userId: String!
    var userTitle: String!
    var userFirstName: String!
    var userLastName: String!
    var userCountryCode: String!
    var userMobileCode: String!
    var userMobileNumber: String!
    var userEmail: String!
    var userBirthDay: String?
    var userGender: String?
    var userNationality: String?
    var userReligon: String?
    var userAreaAddress: String?
    var userApparment: String?
    var userBuildingAddress: String?
    var userSpecialInstruction: String?
    init(userId: String, userTitle: String, userFirstName: String, userLastName: String, userCountryCode: String, userMobileCode: String, userMobileNumber: String, userEmail: String, userBirthDay: String, userGender: String, userNationality: String, userReligon: String, userAreaAddress: String, userApparment: String, userBuildingAddress: String, userSpecialInstruction: String) {
        self.userId = userId
        self.userTitle = userTitle
        self.userFirstName = userFirstName
        self.userLastName = userLastName
        self.userCountryCode = userCountryCode
        self.userMobileCode = userMobileCode
        self.userMobileNumber = userMobileNumber
        self.userEmail = userEmail
        self.userBirthDay = userBirthDay
        self.userGender = userGender
        self.userNationality = userNationality
        self.userReligon = userReligon
        self.userAreaAddress = userAreaAddress
        self.userApparment = userApparment
        self.userBuildingAddress = userBuildingAddress
        self.userSpecialInstruction = userSpecialInstruction
    }
    
    
}

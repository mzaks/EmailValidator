//
//  EmailValidationResult.swift
//  EmailValidator
//
//  Created by Maxim Zaks on 01.09.21.
//  Copyright © 2021 Evan Robertson. All rights reserved.
//

import Foundation


/// Represents validation result which can be a success, or one of validation issues based on rfc5322 & rfc653x.
/// It allows app developers to present proper feedback to app users in case of a potentially invalid input.
public enum EmailValidationResult: Equatable {
  case success
  case emptyString
  case stringIsTooLong(Int)
  case localPartIsQoutedBadly(String.Index)
  case localPartIsMalformed(String.Index)
  case localPartIsTooLong(String.Index)
  case noAtCharacterFound
  case domainIsMalformed(String.Index)
  case ipAddressIsMalformed(String.Index)
  case ipV6AddressIsMalformed(String.Index)
  case ipV4AddressIsMalformed(String.Index)
}

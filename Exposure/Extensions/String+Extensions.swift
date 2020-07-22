//
//  String+Extensions.swift
//  Analytics
//
//  Created by Fredrik Sjöberg on 2017-07-28.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation

extension String {
    /// Generates a *sha256* hash from `self`
    internal var sha256Hash: Data? {
        return (self.data(using: .utf8) as NSData?)?.sha256Hash()
    }
}

extension String {
    /// Convert Date String to Date
       ///
       /// - Parameter format: date format
       /// - Returns: Date
       public func toDate()-> Date? {
           if #available(iOS 10.0, *) {
               let formatter = ISO8601DateFormatter()
               formatter.formatOptions = [.withFullDate,.withTime,.withDashSeparatorInDate,.withColonSeparatorInTime]
               if let date = formatter.date(from: self) {
                   return date
               } else {
                   return checkTimeFormatWithString(date: self)
               }
           } else {
               // Fallback on earlier versions
               return checkTimeFormatWithString(date: self)
           }
       }
       
       /// Date in Specific Format
       ///
       /// - Returns: Formatted String
       public func dateInSwedishFormat() -> String {
           
           if #available(iOS 10.0, *) {
               let formatter = ISO8601DateFormatter()
               formatter.formatOptions = [.withFullDate,.withTime,.withDashSeparatorInDate,.withColonSeparatorInTime]
               if let newdate = formatter.date(from: self){
                   let dateFormatter = DateFormatter()
                   dateFormatter.dateFormat = "dd/MM/yyyy"
                   return dateFormatter.string(from: newdate)
               } else {
                   if let newDate =  checkTimeFormatWithString(date: self) {
                       let dateFormatter = DateFormatter()
                       dateFormatter.dateFormat = "dd/MM/yyyy"
                       return dateFormatter.string(from: newDate)
                   } else {
                       return ""
                   }
               }
           } else {
               // Fallback on earlier versions
               if let newDate =  checkTimeFormatWithString(date: self) {
                   let dateFormatter = DateFormatter()
                   dateFormatter.dateFormat = "dd/MM/yyyy"
                   return dateFormatter.string(from: newDate)
               } else {
                   return ""
               }
           }
       }
       
       
       /// Convert given String Date Time to 24hour Time format
       ///
       /// - Returns: Formatted Time
       public func timeIn24Hours()-> String {
           
           if #available(iOS 10.0, *) {
              let formatter = ISO8601DateFormatter()
              formatter.formatOptions = [.withFullDate,.withTime,.withDashSeparatorInDate,.withColonSeparatorInTime]
              if let newdate = formatter.date(from: self){
                  let dateFormatter = DateFormatter()
                  dateFormatter.dateFormat = "HH:mm"
                  return dateFormatter.string(from: newdate)
              } else {
                  if let newDate =  checkTimeFormatWithString(date: self) {
                      let dateFormatter = DateFormatter()
                      dateFormatter.dateFormat = "HH:mm"
                      return dateFormatter.string(from: newDate)
                  } else {
                      return ""
                  }
              }
          } else {
              // Fallback on earlier versions
              if let newDate =  checkTimeFormatWithString(date: self) {
                  let dateFormatter = DateFormatter()
                  dateFormatter.dateFormat = "HH:mm"
                  return dateFormatter.string(from: newDate)
              } else {
                  return ""
              }
          }
       }
       
       
       
       /// Server can send time string in different formats, so app has to check the correct time format :(
       /// - Parameter date: date
       public func checkTimeFormatWithString(date: String) -> Date? {
           let dateFormatter = DateFormatter()
           dateFormatter.calendar = Calendar(identifier: .gregorian)
           dateFormatter.locale = Locale(identifier: "en_US_POSIX")
           dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
           
           dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
           
           if let newdate = dateFormatter.date(from: date) {
               return newdate
           } else {
               dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZ"
               if let newdate = dateFormatter.date(from: date) {
                   return newdate
               } else {
                   return nil
               }
           }
       }
}

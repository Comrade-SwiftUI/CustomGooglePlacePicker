//
//  Place.swift
//  CustomGooglePlacePicker
//
//  Created by Bhavesh_iOS on 21/08/19.
//  Copyright © 2019 Bhavesh_iOS. All rights reserved.
//

import Foundation
import ObjectMapper

struct Place : Mappable {
   
    var description : String?
    var id : String?
    var matched_substrings : [Matched_substrings]?
    var place_id : String?
    var reference : String?
    var structured_formatting : Structured_formatting?
    var terms : [Terms]?
    var types : [String]?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        description <- map["description"]
        id <- map["id"]
        matched_substrings <- map["matched_substrings"]
        place_id <- map["place_id"]
        reference <- map["reference"]
        structured_formatting <- map["structured_formatting"]
        terms <- map["terms"]
        types <- map["types"]
    }
}


class Matched_substrings : Mappable {
    var length : Int?
    var offset : Int?
    
    required init?(map: Map) {
        
    }
    init() {
    }
    func mapping(map: Map) {
        
        length <- map["length"]
        offset <- map["offset"]
    }
    
}


class Main_text_matched_substrings : Mappable {
    var length : Int?
    var offset : Int?
    
    required init?(map: Map) {
        
    }
    
    init() {
    }
    
    func mapping(map: Map) {
        length <- map["length"]
        offset <- map["offset"]
    }
}


class Structured_formatting : Mappable {
    var main_text : String?
    var main_text_matched_substrings : [Main_text_matched_substrings]?
    var secondary_text : String?
    
    required init?(map: Map) {
        
    }
    init() {
    }
    
    func mapping(map: Map) {
        
        main_text <- map["main_text"]
        main_text_matched_substrings <- map["main_text_matched_substrings"]
        secondary_text <- map["secondary_text"]
    }
    
}

class Terms : Mappable {
    var offset : Int?
    var value : String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        offset <- map["offset"]
        value <- map["value"]
    }
}

//
//  String+Extension.swift
//  NathaliaPlayer
//
//  Created by Nathalia Rodrigues on 4/18/26.
//

import Foundation

extension String {

    func getFilter(with defaultTerm: String) -> String {
        if self.isEmpty {
            return defaultTerm
        }

        return self.replacingOccurrences(of: " ", with: "+")
    }
}

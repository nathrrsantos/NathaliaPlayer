//
//  Double+Extension.swift
//  NathaliaPlayer
//
//  Created by Nathalia Rodrigues on 4/18/26.
//

import Foundation

extension Double {
    
    func toTimeString() -> String {
        guard self.isFinite else { return "0:00" }

        let minutes = Int(self) / 60
        let seconds = Int(self) % 60

        return String(format: "%d:%02d", minutes, seconds)
    }
}

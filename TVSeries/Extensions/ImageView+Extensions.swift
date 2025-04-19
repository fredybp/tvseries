//
//  ImageView+Extensions.swift
//  TVSeries
//
//  Created by Fred on 19/04/25.
//

import UIKit

extension UIImageView {
    func loadImage(from urlString: String) {
        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let data = data, error == nil else { return }

            DispatchQueue.main.async {
                self?.image = UIImage(data: data)
            }
        }.resume()
    }
}

//
//  CKAsset+UIImage.swift
//  MakerU
//
//  Created by Bruno Cardoso Ambrosio on 12/10/20.
//

import Foundation
import UIKit
import CloudKit

extension CKAsset {
    convenience init?(data: Data, compression: CGFloat) {
        
        guard let image = UIImage(data: data),
              let fileURL = ImageHelper.saveToDisk(image: image, compression: compression)
        else { return nil }
        self.init(fileURL: fileURL)
    }
    convenience init?(image: UIImage, compression: CGFloat) {
        guard let fileURL = ImageHelper.saveToDisk(image: image, compression: compression)
        else { return nil }
        self.init(fileURL: fileURL)
    }
    
    var image: UIImage? {
        guard let url = fileURL,
              let data = try? Data(contentsOf: url),
              let image = UIImage(data: data) else {
            return nil
        }
        
        return image
    }
}


struct ImageHelper {
    static func saveToDisk(image: UIImage, compression: CGFloat = 1.0) -> URL? {
        var fileURL = FileManager.default.temporaryDirectory
        let filename = UUID().uuidString
        fileURL.appendPathComponent(filename)
        guard let data = image.jpegData(compressionQuality: compression) else { return nil }
        try? data.write(to: fileURL)
        return fileURL
    }
}


// TODO: Only saving a way to convert Data to pdf
struct PDFHelper {
    func convertToPDF(data: Data) -> CGPDFDocument{
        let data: CFData = data as CFData
        let provider: CGDataProvider = CGDataProvider(data: data)!
        let pdf: CGPDFDocument = CGPDFDocument(provider)!
        
        return pdf
    }
}


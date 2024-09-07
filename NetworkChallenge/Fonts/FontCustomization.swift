//
//  FontCustomization.swift
//  NetworkChallenge
//
//  Created by Layza Maria Rodrigues Carneiro on 30/08/24.
//

import SwiftUI

extension View {
    func font(_ textStyle: UIFont.TextStyle, weight: Font.Weight = .regular) -> ModifiedContent<Self, CustomFont> {
        return modifier(CustomFont(textStyle: textStyle, weight: weight))
    }
}

struct CustomFont: ViewModifier {
    let textStyle: UIFont.TextStyle
    let weight: Font.Weight
    @Environment(\.sizeCategory) var sizeCategory: ContentSizeCategory

    func body(content: Content) -> some View {
        guard let fontDescription = fontDescriptions[textStyle] else {
            print("textStyle não encontrado: \(textStyle)")
            return content.font(.system(.body))
        }

        let fontName: String
        switch weight {
        case .bold:
            fontName = fontDescription.bold
        case .semibold:
            fontName = fontDescription.semibold
        default:
            fontName = fontDescription.regular
        }

        let fontMetrics = UIFontMetrics(forTextStyle: textStyle)
        let fontSize = fontMetrics.scaledValue(for: fontDescription.size)

        return content.font(.custom(fontName, size: fontSize))
    }
}

// Defina as fontes personalizadas a serem usadas, dependendo do TextStyle.
// swiftlint:disable:next large_tuple
typealias CustomFontDescription = (regular: String, semibold: String, bold: String, size: CGFloat)
private var fontDescriptions: [UIFont.TextStyle: CustomFontDescription] = [
    .caption2: ("PixelifySans-Regular", "PixelifySans-SemiBold", "PixelifySans-Bold", 11),
    .caption1: ("PixelifySans-Regular", "PixelifySans-SemiBold", "PixelifySans-Bold", 12),
    .footnote: ("PixelifySans-Regular", "PixelifySans-SemiBold", "PixelifySans-Bold", 13),
    .subheadline: ("PixelifySans-Regular", "PixelifySans-SemiBold", "PixelifySans-Bold", 15),
    .callout: ("PixelifySans-Regular", "PixelifySans-SemiBold", "PixelifySans-Bold", 16),
    .headline: ("PixelifySans-Regular", "PixelifySans-SemiBold", "PixelifySans-Bold", 17),
    .body: ("PixelifySans-Regular", "PixelifySans-SemiBold", "PixelifySans-Bold", 17),
    .title3: ("PixelifySans-Regular", "PixelifySans-SemiBold", "PixelifySans-Bold", 20),
    .title2: ("PixelifySans-Regular", "PixelifySans-SemiBold", "PixelifySans-Bold", 22),
    .title1: ("PixelifySans-Regular", "PixelifySans-SemiBold", "PixelifySans-Bold", 28),
    .largeTitle: ("PixelifySans-Regular", "PixelifySans-SemiBold", "PixelifySans-Bold", 34),
]

// PixelifySans-Medium

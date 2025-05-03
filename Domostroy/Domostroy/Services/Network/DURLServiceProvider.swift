//
//  DURLServiceProvider.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 29.04.2025.
//

import Foundation
import NodeKit
import NodeKitThirdParty

final class DURLServiceChainProvider: URLServiceChainProvider {
    override func provideRequestMultipartChain(
        with providers: [MetadataProvider]
    ) -> any AsyncNode<MultipartURLRequest, Json> {
        let responseChain = provideResponseMultipartChain()
        let requestSenderNode = RequestSenderNode(
            rawResponseProcessor: responseChain,
            manager: session
        )
        let aborterNode = AborterNode(next: requestSenderNode, aborter: requestSenderNode)
        return FileMultipartRequestCreatorNode(next: aborterNode, providers: providers)
    }
}

// MARK: - Костыли для того, чтобы названия полей соответствовали названию файлов

private final class FileMultipartRequestCreatorNode<Route>: MultipartRequestCreatorNode<Route> {
    override func append(multipartForm: MultipartFormDataProtocol, with request: MultipartURLRequest) {
        request.data.payloadModel.forEach { key, value in
            multipartForm.append(value, withName: key)
        }
        request.data.files.forEach { key, value in
            switch value {
            case .data(data: let data, filename: let filename, mimetype: let mimetype):
                multipartForm.append(data, withName: filename, fileName: filename, mimeType: mimetype)
            case .url(url: let url):
                multipartForm.append(url, withName: key)
            case .customWithURL(url: let url, filename: let filename, mimetype: let mimetype):
                multipartForm.append(url, withName: key, fileName: filename, mimeType: mimetype)
            }
        }
    }
}

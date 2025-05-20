//
//  NodeKit+ext.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 20.05.2025.
//

import Foundation
import NodeKit

public enum DResponseHttpErrorProcessorNodeError: Error {
    case badRequest(Data)
    case unauthorized(Data)
    case forbidden(Data)
    case notFound
    case conflict(Data)
    case internalServerError(Data)
}

open class DResponseHttpErrorProcessorNode<Type>: AsyncNode {

    public typealias HttpError = DResponseHttpErrorProcessorNodeError

    /// The next node for processing.
    public var next: any AsyncNode<URLDataResponse, Type>

    /// Initializer.
    ///
    /// - Parameter next: The next node for processing.
    public init(next: some AsyncNode<URLDataResponse, Type>) {
        self.next = next
    }

    /// Matches HTTP codes with the specified ones and passes control further in case of mismatch.
    /// Otherwise, returns `HttpError`.
    ///
    /// - Parameter data: The server response model.
    open func process(
        _ data: URLDataResponse,
        logContext: LoggingContextProtocol
    ) async -> NodeResult<Type> {
        await .withCheckedCancellation {
            switch data.response.statusCode {
            case 400:
                let log = LogChain(
                    "Match with 400 status code (badRequest)",
                    id: objectName,
                    logType: .failure,
                    order: LogOrder.responseHttpErrorProcessorNode
                )
                await logContext.add(log)
                return .failure(HttpError.badRequest(data.data))
            case 401:
                let log = LogChain(
                    "Match with 401 status code (unauthorized)",
                    id: objectName,
                    logType: .failure,
                    order: LogOrder.responseHttpErrorProcessorNode
                )
                await logContext.add(log)
                return .failure(HttpError.unauthorized(data.data))
            case 403:
                let log = LogChain(
                    "Match with 403 status code (forbidden)",
                    id: objectName,
                    logType: .failure,
                    order: LogOrder.responseHttpErrorProcessorNode
                )
                await logContext.add(log)
                return .failure(HttpError.forbidden(data.data))
            case 404:
                let log = LogChain(
                    "Match with 404 status code (notFound)",
                    id: objectName,
                    logType: .failure,
                    order: LogOrder.responseHttpErrorProcessorNode
                )
                await logContext.add(log)
                return .failure(HttpError.notFound)
            case 409:
                let log = LogChain(
                    "Match with 409 status code (conflict)",
                    id: objectName,
                    logType: .failure,
                    order: LogOrder.responseHttpErrorProcessorNode
                )
                await logContext.add(log)
                return .failure(HttpError.conflict(data.data))
            case 500:
                let log = LogChain(
                    "Match with 500 status code (internalServerError)",
                    id: objectName,
                    logType: .failure,
                    order: LogOrder.responseHttpErrorProcessorNode
                )
                await logContext.add(log)
                return .failure(HttpError.internalServerError(data.data))
            default:
                break
            }
            let log = LogChain(
                "Cant match status code -> call next",
                id: objectName,
                logType: .info,
                order: LogOrder.responseHttpErrorProcessorNode
            )
            await logContext.add(log)
            return await next.process(data, logContext: logContext)
        }
    }
}

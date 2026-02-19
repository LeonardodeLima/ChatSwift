import Foundation

enum ServiceError: LocalizedError {
    case networkError(String)
    case notFound(String)
    case unauthorized
    case unknown

    var errorDescription: String? {
        switch self {
        case .networkError(let msg): return "Erro de rede: \(msg)"
        case .notFound(let msg):     return "Não encontrado: \(msg)"
        case .unauthorized:          return "Sessão expirada. Faça login novamente."
        case .unknown:               return "Ocorreu um erro inesperado."
        }
    }
}

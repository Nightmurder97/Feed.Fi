import Foundation

public protocol MainThreadOperationDelegate: AnyObject {
    func operationDidComplete(_ operation: MainThreadOperation)
}

open class MainThreadOperation {
    
    public typealias MainThreadOperationCompletionBlock = (MainThreadOperation) -> Void
    
    open weak var operationDelegate: MainThreadOperationDelegate?
    open var completionBlock: MainThreadOperationCompletionBlock?
    open var isCanceled: Bool = false
    open var id: Int?
    open var name: String?
    
    public init() {}
    
    open func run() {
        // Override in subclasses
    }
    
    public func finish() {
        DispatchQueue.main.async {
            self.completionBlock?(self)
            self.operationDelegate?.operationDidComplete(self)
        }
    }
    
    public func addDependency(_ operation: MainThreadOperation) {
        // Simple dependency tracking - in a real implementation this would be more sophisticated
        // For now, we'll just store the dependency but not enforce it
    }
    
    public func cancel() {
        isCanceled = true
    }
}

public class MainThreadOperationQueue {
    
    private var operations: [MainThreadOperation] = []
    private let queue = DispatchQueue(label: "MainThreadOperationQueue", qos: .userInitiated)
    private var isSuspended: Bool = false
    
    public init() {}
    
    public func add(_ operation: MainThreadOperation) {
        queue.async {
            if !self.isSuspended {
                self.operations.append(operation)
                operation.operationDelegate = self
                operation.run()
            }
        }
    }
    
    public func addOperations(_ operations: [MainThreadOperation]) {
        queue.async {
            if !self.isSuspended {
                for operation in operations {
                    self.operations.append(operation)
                    operation.operationDelegate = self
                    operation.run()
                }
            }
        }
    }
    
    public func suspend() {
        isSuspended = true
    }
    
    public func resume() {
        isSuspended = false
        queue.async {
            // Run any pending operations
            for operation in self.operations {
                operation.run()
            }
        }
    }
    
    public func cancelAllOperations() {
        queue.async {
            for operation in self.operations {
                operation.cancel()
            }
            self.operations.removeAll()
        }
    }
}

extension MainThreadOperationQueue: MainThreadOperationDelegate {
    public func operationDidComplete(_ operation: MainThreadOperation) {
        queue.async {
            if let index = self.operations.firstIndex(where: { $0 === operation }) {
                self.operations.remove(at: index)
            }
        }
    }
}
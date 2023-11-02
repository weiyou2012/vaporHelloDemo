import Fluent
import Vapor

// Controllers 是应用程序不用逻辑的分组
struct TodoController: RouteCollection {
    // 绑定路由请求和实现方法
    func boot(routes: RoutesBuilder) throws {
        let todos = routes.grouped("todos")
        todos.get(use: index)
        todos.post(use: create)
        todos.group(":todoID") { todo in
            todo.get(use: show)
            todo.put(use: update)
            todo.delete(use: delete)
        }
    }

    /// 查列表
    func index(req: Request) async throws -> [Todo] {
        try await Todo.query(on: req.db).all()
    }

    /// 增
    func create(req: Request) async throws -> Todo {
        let todo = try req.content.decode(Todo.self)
        try await todo.save(on: req.db)
        return todo
    }

    /// 查一个
    func show(req: Request) async throws -> Todo {
        guard let todo = try await Todo.find(req.parameters.get("todoID"), on: req.db) else {
            throw Abort(.notFound)
        }
        return todo
    }

    /// 改
    func update(req: Request) async throws -> Todo {
        guard let todo = try await Todo.find(req.parameters.get("todoID"), on: req.db) else {
            throw Abort(.notFound)
        }
        let updateTodo = try req.content.decode(Todo.self)
        todo.title = updateTodo.title
        try await todo.save(on: req.db)
        return todo
    }

    /// 删
    func delete(req: Request) async throws -> HTTPStatus {
        guard let todo = try await Todo.find(req.parameters.get("todoID"), on: req.db) else {
            throw Abort(.notFound)
        }
        try await todo.delete(on: req.db)
        return .noContent
    }
}

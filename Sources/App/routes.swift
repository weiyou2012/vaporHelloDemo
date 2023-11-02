import Fluent
import Vapor

// 路由注册
func routes(_ app: Application) throws {
    app.get { req async in
        "It works!"
    }

    app.get("hello") { req async -> String in
        "这是一个hello, world的例子"
    }

    try app.register(collection: TodoController())
}

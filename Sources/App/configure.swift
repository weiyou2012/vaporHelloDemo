import NIOSSL
import Fluent
import FluentSQLiteDriver
import Vapor

// 配置函数
public func configure(_ app: Application) async throws {
    // 取消注释以从/Public文件夹中提供文件
    app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

    app.databases.use(DatabaseConfigurationFactory.sqlite(.file("db.sqlite")), as: .sqlite)

    app.migrations.add(CreateTodo())

    // 注册路由
    try routes(app)
}

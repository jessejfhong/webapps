use actix_web::{
    http::header::ContentType,
    middleware::Logger,
    web::{get, post, Data},
    App, HttpResponse, HttpServer, Responder,
};
use env_logger::Env;
use sqlx::{migrate::MigrateDatabase, Sqlite, SqlitePool};
use webserver::routes::get_user;
use webserver::SqliteDbMgr;

const DB_URL: &str = "sqlite://dummy.db";

async fn prepare_database(db_url: &str) {
    if !Sqlite::database_exists(db_url).await.unwrap_or(false) {
        Sqlite::create_database(db_url)
            .await
            .expect("Failed to create database");
    }

    let pool = SqlitePool::connect(db_url)
        .await
        .expect("Failed to connect to database");

    sqlx::migrate!("./migrations")
        .run(&pool)
        .await
        .expect("Failed to migrate the database");
}

async fn status() -> impl Responder {
    HttpResponse::Ok()
        .content_type(ContentType::html())
        .body("Simple API server is running.")
}

async fn echo(req_body: String) -> impl Responder {
    HttpResponse::Ok()
        .content_type(ContentType::plaintext())
        .body(req_body)
}

async fn hey() -> impl Responder {
    HttpResponse::Ok()
        .content_type(ContentType::plaintext())
        .body("Hey there!")
}

#[tokio::main]
async fn main() -> std::io::Result<()> {
    env_logger::init_from_env(Env::default().default_filter_or("info"));

    prepare_database(DB_URL).await;

    let dbmgr = Data::new(SqliteDbMgr::new(DB_URL));

    HttpServer::new(move || {
        App::new()
            .wrap(Logger::new("%a %{User-Agent}i"))
            .app_data(dbmgr.clone())
            .route("/", get().to(status))
            .route("/echo", post().to(echo))
            .route("/hey", get().to(hey))
            .route("/user/{id}", get().to(get_user))
    })
    .bind(("0.0.0.0", 8080))?
    .run()
    .await
}

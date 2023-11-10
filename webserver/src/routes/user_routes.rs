use crate::{DbMgr, SqliteDbMgr};
use actix_web::{
    body::BoxBody,
    http::header::ContentType,
    web::{Data, Path},
    HttpRequest, HttpResponse, Responder,
};
use serde::Serialize;

#[derive(Serialize)]
struct UserDto {
    id: i32,
    name: String,
    age: i32,
}

impl Responder for UserDto {
    type Body = BoxBody;

    fn respond_to(self, _req: &HttpRequest) -> HttpResponse<Self::Body> {
        let body = serde_json::to_string(&self).unwrap();
        HttpResponse::Ok()
            .content_type(ContentType::json())
            .body(body)
    }
}

pub async fn get_user(path: Path<String>, dbmgr: Data<SqliteDbMgr>) -> impl Responder {
    let id: i32 = path.into_inner().parse().unwrap();
    let user = dbmgr.get_user_by_id(id);

    UserDto {
        id: user.id,
        name: user.username,
        age: 30,
    }
}

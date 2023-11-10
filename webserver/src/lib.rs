pub mod routes;

pub struct User {
    pub id: i32,
    pub username: String,
    pub password: String,
}

pub struct Contact {
    pub id: i32,
    pub first_name: String,
    pub last_name: String,
    pub email: String,
    pub phone: String,
}

pub struct Product {
    pub id: i32,
    pub name: String,
    pub price: f64,
}

pub trait DbMgr {
    fn get_user_by_id(&self, id: i32) -> User;
    fn get_contact_by_id(&self, id: i32) -> Contact;
    fn get_product_by_id(&self, id: i32) -> Product;
}

pub struct SqliteDbMgr {
    db_url: String,
}

impl SqliteDbMgr {
    pub fn new(db_url: &str) -> Self {
        Self {
            db_url: db_url.to_owned(),
        }
    }
}

impl DbMgr for SqliteDbMgr {
    fn get_user_by_id(&self, id: i32) -> User {
        User {
            id,
            username: String::from("looper"),
            password: String::from("123456"),
        }
    }

    fn get_contact_by_id(&self, id: i32) -> Contact {
        Contact {
            id,
            first_name: String::from("Jack"),
            last_name: String::from("Harper"),
            email: String::from("jack@example.com"),
            phone: String::from("1457775"),
        }
    }

    fn get_product_by_id(&self, id: i32) -> Product {
        Product {
            id,
            name: String::from("iPhone 15"),
            price: 8900_f64,
        }
    }
}

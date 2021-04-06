#![feature(proc_macro_hygiene, decl_macro)]

#[macro_use]
extern crate rocket;

#[get("/")]
fn index() -> &'static str {
    "Destroy the world!"
}

fn rocket() -> rocket::Rocket {
    rocket::ignite().mount("/", routes![index])
}

fn main() {
    rocket().launch();
}

#[cfg(test)]
mod test {
    use super::rocket;
    use rocket::http::Status;
    use rocket::local::Client;

    #[test]
    fn hello_world() {
        let client = Client::new(rocket()).expect("valid rocket instance");
        let mut response = client.get("/").dispatch();
        assert_eq!(response.status(), Status::Ok);
        assert_eq!(response.body_string(), Some("Destroy the world!".into()));
    }
}

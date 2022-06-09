// use std::{borrow::Cow, sync::Mutex};
// use std::{env::var, sync::atomic::AtomicBool};
// use std::{error::Error, sync::atomic::Ordering};
// use std::{
//     fs,
//     io::{Read, Write},
//     path::Path,
// };

// use linear_map::LinearMap;
// use serde_yaml::{Mapping, Value};
// use tmpl::TemplatingReader;

pub enum NotificationLevel {
    Error,
    Warn,
    Success,
    Info,
}

pub struct Notification {
    time: f64,
    level: NotificationLevel,
    code: usize,
    title: String,
    message: String,
}

impl std::fmt::Display for NotificationLevel {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        match self {
            NotificationLevel::Error => write!(f, "ERROR"),
            NotificationLevel::Warn => write!(f, "WARN"),
            NotificationLevel::Success => write!(f, "SUCCESS"),
            NotificationLevel::Info => write!(f, "INFO"),
        }
    }
}

fn main() {

}
use std::thread;
use std::time::Duration;

use mouce::{Mouse, MouseActions};

// Learn more about Tauri commands at https://tauri.app/develop/calling-rust/
#[tauri::command]
fn greet(name: &str) -> String {
    format!("Hello, {}! You've been greeted from Rust!", name)
}

#[tauri::command]
fn move_to(x: i32, y: i32) {
    let mouse_manager = Mouse::new();
    let _ = mouse_manager.move_to(x, y);
}

#[cfg_attr(mobile, tauri::mobile_entry_point)]
pub fn run() {
    tauri::Builder::default()
        .plugin(tauri_plugin_opener::init())
        .invoke_handler(tauri::generate_handler![greet])
        .invoke_handler(tauri::generate_handler![move_to])
        .run(tauri::generate_context!())
        .expect("error while running tauri application");
}

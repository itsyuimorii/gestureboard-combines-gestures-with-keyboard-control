use std::thread;
use std::time::Duration;

use mouce::{Mouse, MouseActions};



// Learn more about Tauri commands at https://tauri.app/develop/calling-rust/
#[tauri::command]
fn greet(name: &str) -> String {
    format!("Hello, {}! You've been greeted from Rust!", name)
}

#[cfg_attr(mobile, tauri::mobile_entry_point)]
pub fn run() {
    tauri::Builder::default()
        .plugin(tauri_plugin_opener::init())
        .invoke_handler(tauri::generate_handler![greet])
        .invoke_handler(tauri::generate_handler![move_mouse])
        .run(tauri::generate_context!())
        .expect("error while running tauri application");
}

#[tauri::command]
fn move_mouse() {
    println!("Moving mouse");   
    let mouse_manager =Mouse::new();
    let mut x = 0;
    while x < 1920 {
        let _ = mouse_manager.move_to(x, 540);
        x += 1;
        thread::sleep(Duration::from_millis(2));
    }
    println!("Mouse moved");
}
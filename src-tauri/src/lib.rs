use mouce::{common::MouseButton, common::ScrollDirection, Mouse, MouseActions};

// Learn more about Tauri commands at https://tauri.app/develop/calling-rust/
#[tauri::command]
fn greet(name: &str) -> String {
    format!("Hello, {}! You've been greeted from Rust!", name)
}

#[tauri::command]
fn move_relative(x: i32, y: i32) {
    let mouse_manager = Mouse::new();
    let _ = mouse_manager.move_relative(x, y);
}

#[tauri::command]
fn mouse_left_click() {
    let mouse_manager = Mouse::new();
    let _ = mouse_manager.click_button(&MouseButton::Left);
}

#[tauri::command]
fn scroll_up() {
    let mouse_manager = Mouse::new();
    let _ = mouse_manager.scroll_wheel(&ScrollDirection::Left);
}

#[tauri::command]
fn scroll_down() {
    let mouse_manager = Mouse::new();
    let _ = mouse_manager.scroll_wheel(&ScrollDirection::Right);
}

#[cfg_attr(mobile, tauri::mobile_entry_point)]
pub fn run() {
    tauri::Builder::default()
        .plugin(tauri_plugin_opener::init())
        .invoke_handler(tauri::generate_handler![
            greet,
            move_relative,
            mouse_left_click,
            scroll_up,
            scroll_down
        ])
        .run(tauri::generate_context!())
        .expect("error while running tauri application");
}

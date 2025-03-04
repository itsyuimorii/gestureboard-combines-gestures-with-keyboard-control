// use ::{common::MouseButton, common::ScrollDirection, Mouse, MouseActions};
use enigo::{Axis, Button, Coordinate, Direction, Enigo, Mouse, Settings};

// Learn more about Tauri commands at https://tauri.app/develop/calling-rust/
#[tauri::command]
fn greet(name: &str) -> String {
    format!("Hello, {}! You've been greeted from Rust!", name)
}

#[tauri::command]
fn move_relative(x: i32, y: i32) {
    let mut enigo = Enigo::new(&Settings::default()).unwrap();
    enigo.move_mouse(x, y, Coordinate::Rel).unwrap();
}

#[tauri::command]
fn mouse_left_click() {
    let mut enigo = Enigo::new(&Settings::default()).unwrap();
    enigo.button(Button::Left, Direction::Click).unwrap();
}

#[tauri::command]
fn scroll_up() {
    let mut enigo = Enigo::new(&Settings::default()).unwrap();
    enigo.scroll(2, Axis::Vertical).unwrap();
}

#[tauri::command]
fn scroll_down() {
    let mut enigo = Enigo::new(&Settings::default()).unwrap();
    enigo.scroll(-2, Axis::Vertical).unwrap();
}

#[tauri::command]
fn mouse_left_press() {
    let mut enigo = Enigo::new(&Settings::default()).unwrap();
    enigo.button(Button::Left, Direction::Press).unwrap();
}

#[tauri::command]
fn mouse_left_release() {
    let mut enigo = Enigo::new(&Settings::default()).unwrap();
    enigo.button(Button::Left, Direction::Release).unwrap();
}

#[cfg_attr(mobile, tauri::mobile_entry_point)]
pub fn run() {
    #[cfg(target_os = "windows")]
    // This is needed on Windows if you want the application to respect the users scaling settings.
    // Please look at the documentation of the function to see better ways to achive this and
    // important gotchas
    enigo::set_dpi_awareness().unwrap();

    tauri::Builder::default()
        .plugin(tauri_plugin_opener::init())
        .invoke_handler(tauri::generate_handler![
            greet,
            move_relative,
            mouse_left_click,
            scroll_up,
            scroll_down,
            mouse_left_press,
            mouse_left_release
        ])
        .run(tauri::generate_context!())
        .expect("error while running tauri application");
}

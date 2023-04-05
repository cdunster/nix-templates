use cursive::{
    view::Nameable,
    views::{Dialog, TextView},
    Cursive,
};

#[derive(Default)]
struct UserData {
    count: u32,
}

enum Message {
    IncrementPressed,
    DecrementPressed,
}

fn on_press(cursive: &mut Cursive, message: Message) {
    if let Some(count) = cursive.with_user_data(|user_data: &mut UserData| {
        user_data.count = match message {
            Message::IncrementPressed => user_data.count.saturating_add(1),
            Message::DecrementPressed => user_data.count.saturating_sub(1),
        };
        user_data.count
    }) {
        cursive.call_on_name("count_value", |view: &mut TextView| {
            view.set_content(format!("Count is {count}"));
        });
    }
}

fn main() {
    let mut cursive = cursive::default();
    cursive.set_global_callback('q', Cursive::quit);
    let user_data = UserData::default();

    cursive.add_layer(
        Dialog::around(
            TextView::new(format!("Count is {}", user_data.count)).with_name("count_value"),
        )
        .title("Counter")
        .button("-", |cursive| on_press(cursive, Message::DecrementPressed))
        .button("+", |cursive| on_press(cursive, Message::IncrementPressed)),
    );

    cursive.set_user_data(user_data);
    cursive.run();
}

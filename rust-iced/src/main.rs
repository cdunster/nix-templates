use iced::{
    widget::{column, Button, Container, Text},
    Alignment, Length, Sandbox, Settings,
};

struct Counter {
    count: u32,
}

#[derive(Debug, Clone, Copy)]
enum CounterMessage {
    Increment,
    Decrement,
}

impl Sandbox for Counter {
    type Message = CounterMessage;

    fn new() -> Self {
        Self { count: 0 }
    }

    fn title(&self) -> String {
        "Counter App - Iced".to_string()
    }

    fn update(&mut self, message: Self::Message) {
        match message {
            CounterMessage::Increment => self.count = self.count.saturating_add(1),
            CounterMessage::Decrement => self.count = self.count.saturating_sub(1),
        }
    }

    fn view(&self) -> iced::Element<'_, Self::Message> {
        let content = column![
            Button::new("Increment").on_press(Self::Message::Increment),
            Text::new(format!("Count: {}", self.count)),
            Button::new("Decrement").on_press(Self::Message::Decrement),
        ]
        .padding(20)
        .spacing(20)
        .max_width(500)
        .align_items(Alignment::Center);

        Container::new(content)
            .center_x()
            .center_y()
            .width(Length::Fill)
            .height(Length::Fill)
            .into()
    }
}

fn main() -> iced::Result {
    Counter::run(Settings::default())
}

use cursive::{
    view::Nameable,
    views::{Dialog, TextView},
    CbSink, Cursive,
};
use std::sync::{
    atomic::{AtomicI32, Ordering},
    Arc,
};
use tokio::{
    sync::mpsc::{self, Receiver, Sender},
    task::JoinHandle,
};

#[derive(Debug)]
enum ViewEvent {
    IncrementPressed,
    DecrementPressed,
}

#[derive(Debug)]
enum ModelEvent {
    CountChanged(i32),
}

async fn handle_view_event(event: ViewEvent, tx_model: Sender<ModelEvent>) {
    match event {
        ViewEvent::IncrementPressed => {
            tx_model.send(ModelEvent::CountChanged(1)).await.unwrap();
        }
        ViewEvent::DecrementPressed => {
            tx_model.send(ModelEvent::CountChanged(-1)).await.unwrap();
        }
    }
}

async fn handle_model_event(event: ModelEvent, tx_cursive: CbSink, atomic_count: Arc<AtomicI32>) {
    match event {
        ModelEvent::CountChanged(delta) => {
            tx_cursive
                .send(Box::new(move |cursive| {
                    cursive.call_on_name("count_value", |view: &mut TextView| {
                        let mut count = atomic_count.load(Ordering::Relaxed);
                        count = count.saturating_add(delta);
                        atomic_count.store(count, Ordering::Relaxed);
                        view.set_content(format!("Count is {count}"));
                    });
                }))
                .unwrap();
        }
    }
}

fn spawn_model_event_thread(
    tx_cursive: CbSink,
    mut rx_model: Receiver<ModelEvent>,
    count: i32,
) -> JoinHandle<()> {
    let atomic_count = Arc::new(AtomicI32::new(count));
    tokio::spawn(async move {
        while let Some(event) = rx_model.recv().await {
            tokio::spawn(handle_model_event(
                event,
                tx_cursive.clone(),
                atomic_count.clone(),
            ));
        }
    })
}

#[tokio::main]
pub async fn main() {
    let mut cursive = cursive::default();
    cursive.add_global_callback('q', Cursive::quit);

    let (tx_view, mut rx_view) = mpsc::channel::<ViewEvent>(50);
    let (tx_model, rx_model) = mpsc::channel::<ModelEvent>(50);
    let tx_view_inc = tx_view.clone();
    let tx_view_dec = tx_view;
    let count = 0;

    cursive.add_layer(
        Dialog::around(TextView::new(format!("Count is {count}")).with_name("count_value"))
            .button("+", move |_| {
                tx_view_inc
                    .try_send(ViewEvent::IncrementPressed)
                    .expect("Failed to send message to the queue")
            })
            .button("-", move |_| {
                tx_view_dec
                    .try_send(ViewEvent::DecrementPressed)
                    .expect("Failed to send message to the queue")
            })
            .title("Counter"),
    );

    tokio::spawn(async move {
        while let Some(event) = rx_view.recv().await {
            tokio::spawn(handle_view_event(event, tx_model.clone()));
        }
    });
    spawn_model_event_thread(cursive.cb_sink().clone(), rx_model, count);

    cursive.run();
}

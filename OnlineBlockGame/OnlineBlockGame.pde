import processing.net.*;
int port = 10001;
Server server;

App app;

void setup() {
    size(1000, 720);

    server = new Server(this, port);
    println("server address: " + server.ip()); // IPアドレスを出力

    noStroke();
    app = new App();
}

void draw() {
    app.draw();
}

void keyPressed() {
    if (keyCode == 'R') {
        app = new App();
    }
}

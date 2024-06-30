class App {
    Ball ball;
    private boolean isStart;
    private boolean isEnd;
    private Racket[] playersRacket;
    private final float RACKET_HORIZONTAL_MARGIN = 100;
    private Blocks[] blocks;
    private int winNum = 0;

    ArrayList<Integer> racketPosNums;

    App() {
        this.racketPosNums = new ArrayList<Integer>();
        this.isStart = false;
        this.isEnd = false;
        final int start_vy = (random(1) < 0.5 ? 1 : -1);
        final int start_vx = (random(1) < 0.5 ? 1 : -1);
        this.ball = new Ball(new PVector(width/2.0, height/2.0), new PVector(3 * start_vx, 3 * start_vy));
        this.playersRacket = new Racket[] {
            new MouseOperationRacket(new PVector(RACKET_HORIZONTAL_MARGIN, height/2.0), color(230, 100, 100)),
            new OnlineOperationRacket(new PVector(width-RACKET_HORIZONTAL_MARGIN, height/2.0), color(100, 100, 230)),
        };

        this.blocks = new Blocks[] {
            new Blocks(new PVector(0, 0), 3, 1),
            new Blocks(new PVector(width-Blocks.WIDTH, 0), 3, 1),
        };
    }

    void draw() {
        background(10);

        push();
        textSize(50);
        textAlign(CENTER, CENTER);
        fill(255, 180);
        for (int i=1; i<=3; i++) {
            text(i, width - 150, (i-0.5) * (height/3));
        }
        pop();

        Client client = server.available();
        if (client !=null) {
            String whatClientSaid = client.readString();
            if (whatClientSaid != null) {
                final String[] datas = whatClientSaid.split(", ");
                for (String str : datas) {
                    racketPosNums.add(int(str));
                }
                println(racketPosNums);
            }
        }

        for (Racket playerRacket : playersRacket) {
            playerRacket.draw();
        }
        for (Blocks _blocks : blocks) {
            _blocks.draw();
        }
        for (Racket playerRacket : playersRacket) {
            playerRacket.update();
            if (playerRacket.isBallOverlap(ball.pos, Ball.DIAMETER/2.0)) {
                ball.horizontalRefrection(playerRacket.pos, playerRacket.getHeight(), true);
            }
        }

        if (isStart) {
            ball.draw();
            ball.update();
            for (Blocks _blocks : blocks) {
                if (_blocks.isHitBlock(ball.pos)) {
                    ball.horizontalRefrection(ball.pos, 0, false);
                }
            }
            final int n = ball.isOverHorizontal();
            if (n != 0) {
                winNum = n;
                isEnd = true;
            }
        } else {
            push();
            textSize(100);
            textAlign(CENTER, CENTER);
            fill(100, 255, 100);
            text("Press Enter To Start", width/2.0, height/2.0);
            pop();
            if (keyCode == ENTER) {
                isStart = true;
            }
        }
        if (isEnd) {
            push();
            textSize(100);
            textAlign(CENTER, CENTER);
            
                fill(255);
            if (winNum == -1) {
                text("Winner is Red !", width/2.0 + 2, height/2.0 + 5);
                fill(255, 80, 80);
                text("Winner is Red !", width/2.0, height/2.0);
            } else {
                text("Winner is Blue !", width/2.0 + 2, height/2.0 + 5);
                fill(80, 80, 255);
                text("Winner is Blue !", width/2.0, height/2.0);
            }
            pop();
        }
    }
}

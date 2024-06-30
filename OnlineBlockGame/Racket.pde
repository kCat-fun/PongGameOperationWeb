abstract class Racket {
    private PVector pos;
    private final float WIDTH = 16;
    private final float HEIGHT = height/3.0;
    private color c;
    
    float getHeight() {
        return HEIGHT;   
    }

    void draw() {
        push();
        fill(c);
        rect(pos.x, pos.y, WIDTH, HEIGHT);
        pop();
    }

    void update() {
    }

    boolean isBallOverlap(PVector ballPos, float ballRadius) {
        boolean horizontalOverlap = (pos.x < ballPos.x) && (ballPos.x < pos.x + WIDTH) && (pos.y - ballRadius < ballPos.y) && (ballPos.y < pos.y + HEIGHT + ballRadius);
        boolean verticalOverlap = (pos.x - ballRadius < ballPos.x) && (ballPos.x < pos.x + WIDTH + ballRadius) && (pos.y < ballPos.y) && (ballPos.y < pos.y + HEIGHT);
        boolean leftTopOverlap = (pow((ballPos.x - pos.x), 2) + pow((ballPos.y - pos.y), 2) < ballRadius);
        boolean rightTopOverlap = (pow((ballPos.x - (pos.x + WIDTH)), 2) + pow((ballPos.y - pos.y), 2) < ballRadius);
        boolean leftBottomOverlap = (pow((ballPos.x - pos.x), 2) + pow((ballPos.y - (pos.y + HEIGHT)), 2) < ballRadius);
        boolean rightBottomOverlap = (pow((ballPos.x - (pos.x + WIDTH)), 2) + pow((ballPos.y - (pos.y + HEIGHT)), 2) < ballRadius);

        return (horizontalOverlap || verticalOverlap ||leftTopOverlap || rightTopOverlap || leftBottomOverlap || rightBottomOverlap);
    }
}

class MouseOperationRacket extends Racket {
    private boolean isAIMode = true;
    private long stopTime, startTime;

    MouseOperationRacket(PVector pos, color c) {
        super.pos = new PVector(pos.x - super.WIDTH/2.0, pos.y - super.HEIGHT/2.0);
        super.c = c;
        this.startTime = millis();
        this.stopTime = 0;
    }

    void update() {
        if (keyCode == '1') {
            isAIMode = true;
        } else if (keyCode == '2') {
            isAIMode = false;
        }
        if (!isAIMode)
            super.pos.y = constrain(mouseY - super.HEIGHT/2.0, 0, height - super.HEIGHT);
        else {
            if (random(200) < 1) {
                startTime = millis();
                stopTime = floor(random(3, 5) * 1000);
            }
            if (millis() - startTime < stopTime) return;
            super.pos.y -= (super.pos.y + super.HEIGHT/2.0 - app.ball.pos.y) * 0.03;
            super.pos.y = constrain(super.pos.y, 0, height - super.HEIGHT);
        }
    }
}

class OnlineOperationRacket extends Racket {
    private boolean isMove;
    private int movePosNum;
    private float vecY;
    private final float SPEED = 10.0;

    OnlineOperationRacket(PVector pos, color c) {
        super.pos = new PVector(pos.x - super.WIDTH/2.0, pos.y - super.HEIGHT/2.0);
        super.c = c;
        this.isMove = false;
        this.movePosNum = 1;
    }

    void update() {
        //super.pos.y = constrain(app.ball.pos.y - super.HEIGHT/2.0, 0, height - super.HEIGHT);

        if (!isMove) {
            if (app.racketPosNums.size() > 0) {
                setMovePosNum(app.racketPosNums.get(0));
                app.racketPosNums.remove(0);
            }
        }

        if (isMove) {
            if (
                (vecY < 0 && super.pos.y < getCalcPos(movePosNum)) ||
                (vecY > 0 && super.pos.y > getCalcPos(movePosNum))
                ) {
                isMove = false;
                return;
            }
            super.pos.y += vecY;
        }
    }

    float getCalcPos(int num) {
        return ((num-1) * super.HEIGHT);
    }

    void setMovePosNum(int num) {
        movePosNum = num;
        isMove = true;
        vecY = SPEED * (getCalcPos(num) < super.pos.y + super.HEIGHT/2.0 ? -1 : 1);
    }

    boolean isMoving() {
        return isMove;
    }
}

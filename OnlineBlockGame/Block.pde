class Block {
    private float w, h;
    private PVector pos;
    boolean isActive;

    Block(PVector pos, float w, float h) {
        this.pos = pos;
        this.w = w;
        this.h = h;
        this.isActive = true;
    }

    void draw() {
        if (!isActive) return;
        push();
        fill(250);
        rect(pos.x, pos.y, w, h);
        stroke(10);
        strokeWeight(1);
        line(pos.x, pos.y, pos.x + w, pos.y);
        line(pos.x, pos.y + h, pos.x + w, pos.y + h);
        pop();
    }
    
    boolean isBallOverlap(PVector ballPos, float ballRadius) {
        boolean horizontalOverlap = (pos.x < ballPos.x) && (ballPos.x < pos.x + w) && (pos.y - ballRadius < ballPos.y) && (ballPos.y < pos.y + h + ballRadius);
        boolean verticalOverlap = (pos.x - ballRadius < ballPos.x) && (ballPos.x < pos.x + w + ballRadius) && (pos.y < ballPos.y) && (ballPos.y < pos.y + h);
        boolean leftTopOverlap = (pow((ballPos.x - pos.x), 2) + pow((ballPos.y - pos.y), 2) < ballRadius);
        boolean rightTopOverlap = (pow((ballPos.x - (pos.x + w)), 2) + pow((ballPos.y - pos.y), 2) < ballRadius);
        boolean leftBottomOverlap = (pow((ballPos.x - pos.x), 2) + pow((ballPos.y - (pos.y + h)), 2) < ballRadius);
        boolean rightBottomOverlap = (pow((ballPos.x - (pos.x + w)), 2) + pow((ballPos.y - (pos.y + h)), 2) < ballRadius);

        return (horizontalOverlap || verticalOverlap ||leftTopOverlap || rightTopOverlap || leftBottomOverlap || rightBottomOverlap);
    }
}

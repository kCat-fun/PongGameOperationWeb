class Ball {
    static final float DIAMETER = 50.0;
    PVector pos, vec;

    Ball(PVector pos, PVector vec) {
        this.pos = pos;
        this.vec = vec;
    }

    void draw() {
        push();
        fill(200, 200, 100);
        circle(pos.x, pos.y, Ball.DIAMETER);
        pop();
    }

    void update() {
        if(isOverHorizontal() == 0)
            pos.add(vec);
        //if (pos.x < Ball.DIAMETER/2.0 || width < pos.x + Ball.DIAMETER/2.0) {
        //    vec.x *= -1;
        //}
        if (pos.y < Ball.DIAMETER/2.0 || height < pos.y + Ball.DIAMETER/2.0) {
            vec.y *= -1;
        }
    }

    void horizontalRefrection(PVector _pos, float racketHeight, boolean flag) {
        if (flag) {
            PVector _vec = new PVector(3*sqrt(2), 0);

            float angle = radians(map(pos.y - (_pos.y + racketHeight/2.0), -racketHeight/2.0, racketHeight/2.0, -30, 30));
            _vec = _vec.rotate(angle);
            _vec.x *= -((vec.x)/abs(vec.x));
            vec = _vec;
        } else {
            vec.x *= -1;
        }

        update();
        update();
    }

    int isOverHorizontal() {
        if (pos.x - Ball.DIAMETER/2.0 > width) {
            return -1;
        } else if (pos.x + Ball.DIAMETER/2.0 < 0) {
            return 1;
        }

        return 0;
    }
}

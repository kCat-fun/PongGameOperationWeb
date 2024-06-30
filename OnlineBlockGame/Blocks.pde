class Blocks {
    private Block[][] blocks;
    static final float WIDTH = 50;

    Blocks(PVector pos, int row, int col) {
        float w = Blocks.WIDTH;
        float h = (float)height / row;
        this.blocks = new Block[row][col];
        for (int i=0; i<row; i++) {
            for (int j=0; j<col; j++) {
                this.blocks[i][j] = new Block(new PVector(pos.x + j * w, pos.y + i * h), w, h);
            }
        }
    }

    void draw() {
        for (Block[] _blocks : blocks) {
            for (Block block : _blocks) {
                block.draw();
            }
        }
    }

    boolean isHitBlock(PVector ballPos) {
        for (int i=0; i<blocks.length; i++) {
            for (int j=0; j<blocks[i].length; j++) {
                if (blocks[i][j].isBallOverlap(ballPos, Ball.DIAMETER/2.0) && blocks[i][j].isActive) {
                    blocks[i][j].isActive = false;
                    return true;
                }
            }
        }
        return false;
    }
}

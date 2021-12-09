import java.util.Scanner;
import java.util.List;
import java.util.ArrayList;

class Range {
    private int x1;
    private int y1;
    private int x2;
    private int y2;

    public Range(int x1, int y1, int x2, int y2) {
        this.x1 = x1;
        this.y1 = y1;
        this.x2 = x2;
        this.y2 = y2;
    }

    public String toString() {
        return String.format("%d,%d -> %d,%d", this.x1, this.y1, this.x2, this.y2);
    }

    public void mark(int[][] matrix) {
        if (this.x1 != this.x2 && this.y1 != this.y2) {
            // Skip coordinates that don't have a common element
            return;
        }

        if (this.x1 == this.x2) {
            // horizontal range
            int min = Math.min(this.y1, this.y2);
            int max = Math.max(this.y1, this.y2);
            for(int i = min; i <= max; i++) {
                matrix[i][this.x1] += 1;
            }
        } else {
            // vertical range
            int min = Math.min(this.x1, this.x2);
            int max = Math.max(this.x1, this.x2);
            for(int j = min; j <= max; j++) {
                matrix[this.y1][j] += 1;
            }
        }
    }
}

public class Main {
    public static void renderBoard(int[][] board) {
        for(int i = 0; i < board.length; i++) {
            for(int j = 0; j < board[i].length; j++) {
                System.out.printf("%d ", board[i][j]);
            }
            System.out.printf("\n");
        }
    }

    public static int getSafeSpots(int[][] board) {
        int acc = 0;
        for(int i = 0; i < board.length; i++) {
            for(int j = 0; j < board.length; j++) {
                if(board[i][j] > 1) {
                    acc++;
                }
            }
        }
        return acc;
    }

    public static void main(String[] input) {
        List<Range> ranges = new ArrayList<>();
        Scanner s = new Scanner(System.in);
        int max = 0, right = 0;

        while(s.hasNextLine()) {
            String line = s.nextLine();
            Scanner row = new Scanner(line);
            row.useDelimiter(" -> ");

            String tuple1 = row.next();
            Scanner s1 = new Scanner(tuple1);
            s1.useDelimiter(",");
            int x1 = s1.nextInt();
            int y1 = s1.nextInt();

            String tuple2 = row.next();
            Scanner s2 = new Scanner(tuple2);
            s2.useDelimiter(",");
            int x2 = s2.nextInt();
            int y2 = s2.nextInt();

            ranges.add(new Range(x1, y1, x2, y2));

            max = Math.max(max, x1);
            max = Math.max(max, x2);
            max = Math.max(max, y1);
            max = Math.max(max, y2);
        }

        System.out.printf("Ranges length: %d\n", ranges.size());

        int[][] board = new int[max + 1][max + 1];
        ranges.forEach(range -> {
                // System.out.printf("%s\n", range.toString());
                range.mark(board);
                // renderBoard(board);
            });

        System.out.printf("%d\n", getSafeSpots(board));
    }
}

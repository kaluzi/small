import java.util.*;
import java.awt.*;
import java.util.Scanner.*;

public class C140111_MouseJourney {
	public static int count = 0, row, col;
	public static void main(String[] args){
		Scanner c = new Scanner(System.in);
		row = c.nextInt();
		col = c.nextInt();
		int[][] cage= new int[row][col];
		int k = c.nextInt();
		int x,y;
		for (int i = 0; i < k; i++){
			x = c.nextInt();
			y = c.nextInt();
			cage[x-1][y-1] = 1;
		}
		move(0,0,cage);
		System.out.println(count);
	}
	public static void move(int x, int y, int[][] cage){
		if (x == row-1 && y == col-1){
			count++;
		}else{
			if (x != row-1){
				if (cage[x+1][y] == 0)
					move(x+1,y,cage);
			}
			if (y != col-1){
				if (cage[x][y+1] == 0)
					move(x,y+1,cage);
			}
		}
	}
}

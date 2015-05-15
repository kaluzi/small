import java.awt.*;
import java.util.*;

public class C140118_Waterpark {
	public static int n,m = 0, count = 0;
	public static void main(String[] args){
		Scanner c = new Scanner(System.in);
		n = c.nextInt();
		int x, y;
		int[][] pt = new int[n*n][2];
		x = c.nextInt();
		y = c.nextInt();
		while (x != 0 && y != 0){
			pt[m][0] = x;
			pt[m++][1] = y;
			x = c.nextInt();
			y = c.nextInt();
		}
		slide(1,pt);
		System.out.println(count);
		c.close();
	}
	public static void slide(int x, int[][]pt){
		for (int i = 0; i < m; i++){
			if (pt[i][0] == x){
				if (pt[i][1] == n){
					count++;
				}else{
					slide(pt[i][1],pt);
				}
			}
		}
	}
}
/*
Sample Input:
4
1 2
1 4
2 3
2 4
3 4
0 0

Sample Output: 3
*/

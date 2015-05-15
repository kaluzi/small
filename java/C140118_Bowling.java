import java.util.*;

public class C140118_Bowling {
	public static void main(String[] args){
		Scanner c = new Scanner (System.in);
		int t = c.nextInt();
		int n = c.nextInt();
		int k = c.nextInt();
		int w = c.nextInt();
		int[] pin = new int[n];
		int[] bowl = new int[k];
		for (int i = 0; i < n; i++){
			pin[i] = c.nextInt();
		}
		int sum,high,a=0,score=0;
		int l = w/2;
		int x,cur;
		for (int z = 0; z < k; z++){
			sum = 0;
			high = 0;
			for (int i = l; i < n-l; i++){
				sum = pin[i];
				x= 1;
				while (x <= l){
					sum+=pin[i-x];
					x++;
				}
				x = 1;
				while (x <= l){
					sum+=pin[i+x];
					x++;
				}
				if (sum > high){
					high = sum;
					a = i;
				}
			}
			score += high;
			pin[a] = 0;
			x= 1;
			while (x <= l){
				pin[a-x] = 0;
				x++;
			}
			x = 1;
			while (x <= l){
				pin[a+x] = 0;
				x++;
			}
		}
		System.out.println(score);
		c.close();
	}
}

/*
Sample Input:
 1
 9 2 3
 2
 8
 5
 1
 9
 6
 9
 3
 2
 
 Sample Output: 39
 */

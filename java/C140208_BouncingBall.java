import java.awt.*;
import java.util.*;
import java.util.Scanner.*;

public class C140208_BouncingBall {
public static int count = 0;
public static double ang, m, n,p,q;
	
	public static void main (String[] args){
		Scanner c = new Scanner(System.in);
		n = c.nextInt();
		m = c.nextInt();
		p = c.nextInt();
		q = c.nextInt();
		//double d = Math.sqrt(Math.pow(p, 2) + Math.pow(q, 2));
		double an = Math.atan(q/(n-p));
		ang = an;
		bounce(-1,m-q,an);
	}
	
	public static void bounce(double xlen, double ylen, double an){
		int a;
		if (xlen == -1){
			xlen = (ylen*(Math.tan(an)));
			a = 1;
		}else{
			ylen = (xlen*(Math.tan(an)));
			a = 2;
		}
		if ((xlen >= n-5 || xlen <= 5) && (ylen >= m-5 || ylen <= 5)){
			System.out.println(count);
		
		}else if (xlen == p && ylen == q && Math.PI/2.0-an == ang){
				System.out.println("0");
		}else{
			count++;
			if (a == 1){
				bounce((n-xlen),-1,(Math.PI/2.0-an));
			}else{
				bounce(-1,(m-ylen),(Math.PI/2.0-an));
			}
		}
		
	}

}

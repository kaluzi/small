import java.util.*;
import java.awt.*;
import java.util.Scanner;

public class C131102_Tarjan {
	static public int x,y,index = 0, co = 0,scc = 0;
	static public void main(String[] args){
		Scanner c = new Scanner(System.in);
		x = c.nextInt();
		y = c.nextInt();
		boolean[] instack = new boolean[x+1];
		int[] st = new int[x];
		int[] Low = new int[x+1];
		int[] DFN = new int[x+1];
		int[][] map = new int[x+1][x+1];
		for (int i = 0; i < y; i++){
			map[c.nextInt()][c.nextInt()] = 1;
		}
		tarjan(1, st,Low,map,DFN,instack);
		System.out.println("# of scc is " + scc);
		
	}
	static public void tarjan(int u,int[]st, int[]Low, int[][]map, int[]DFN,boolean[] instack)
	{
		DFN[u] = Low[u] = ++index;
		st[++co]=u;//Stack.push(u)
		instack[u] = true;
		for (int v = 1; v <= x; v++){//for each (u,v) in E
			if (map[u][v] == 1){
				//v = i;
				if (DFN[v] == 0){ //v not visited
					tarjan(v, st,Low,map,DFN,instack);
					if (Low[u]>Low[v]){
						Low[u] = Low[v];
					}
				}else {
					if (instack[v] == true){
						if (Low[u]>DFN[v]){
							Low[u] = DFN[v];
						}
					}
				}
			}
		}
		if (DFN[u] == Low[u]){ //u is the root
			scc++;
			int v = 0;
				while( v!=u){
					v = st[co];
					System.out.print(v+" ");
					instack[v] = false;
					co--;
				}
				System.out.println();
		}
	}
}

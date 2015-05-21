import java.util.*;

public class puzzle {

	public static void main(String args[]){
		Scanner in = new Scanner(System.in);
		int d = in.nextInt(); 
		String junk = in.nextLine();
		String dict[] = new String[d];
		for (int i = 0; i < d; i++){
			String word = in.nextLine();
			dict[i] = word;
		}
		Arrays.sort(dict);
		int w = in.nextInt();
		junk = in.nextLine();
		for (int k = 0; k < w; k++){
			String big = in.nextLine();
			System.out.println(big);
			for (int j = 0; j < d; j++){
				String temp = big.toLowerCase();
				int len = dict[j].length();
				for (int a = 0; a < len; a++){
					int n = temp.indexOf(dict[j].charAt(a));
					if (n >= 0){
						String temp2 = temp.substring(0,n);
						if (n < temp.length()-1)
							temp2 = temp2 + temp.substring(n+1);
						temp = temp2;
					}else{
						break;
					}
					if (a >= len-1)
						System.out.println("   "+ dict[j]);
				}
			}
			System.out.println();
		}
	}
}

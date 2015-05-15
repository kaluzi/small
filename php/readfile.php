<?php
  // Read a "Past ECOO Contest Page" and save it in a database. Part of a larger project.

	function rdfile($file)
	{
		//----------------------------Initialization
		$closed = false; //if it is a tag(open) or text(closed)
		$sol = false;	//if it is a textarea >> solution,input
		$c1 = 0;	//# of lines for text
		$tnum = 0;	//array index of solution and inputs
		$len = 0;	// len of string to substr
		$sn = 1;	//if it is a solution, input1, or input2
		//---------------------------------------------------

		echo $file."<br>";
		
		for ($i = 0; $i < strlen($file);$i++){
			if ($file{$i} >= '0' && $file{$i} <= '9'){
				$year = substr($file, $i, 4);
				$temp = substr($file,0,$i);
				break;
			}
		}
		$temp2 = explode('/',$temp);
		
		$temp = trim($temp2[count($temp2)-1]);
		if ($temp == "brd")
		$ctype = "Boardwide";
		else if ($temp == "fin")
		$ctype = "Finals";
		else
		$ctype = "Regionals";
		$pn = intval(substr($file, -6,1));
		
		//----------------get data 
		//$data = file_get_contents("files/boardwide/brd2002p1.html");
		$data = file_get_contents("$file");
		$se = array("<B>","</B>","'","<blockquote>","</blockquote>"); //find these
		$re = array("","","\'","","");	//replace with these
		$data = str_replace($se,$re,$data);	//replace
		$data = nl2br($data);	//change /n to <br>
		$slen = strlen($data);	//length of $data
		//-------------------------------
		
		
		//for every char of data
		for ($i = 0; $i < $slen; $i++){
			//---------------------------------skips out the comments
			if ($i+3 < $slen )
				if (substr($data,$i,4) == "<!--"){
					do{
						$i++;
					}while(substr($data,$i-2,3) != "-->");
					$i++;
					$len = 0;
				}
				
			//---------------------------------if it is an open tag
			if ($data{$i} == '<'){
				if (!$closed)//if not tag
					continue;
				if (strlen(trim(substr($data,$i-$len,$len))) != 0)//gets leng of all char before open tag
					
					//--------------if it is a textarea (solution, inputs)
					if ($sol){
						$temp=substr($data,$i-$len,$len);
						$temp = str_replace(" ","&nbsp;",$temp);//to properly output the " "
						if ($sn == 1 || $sn == 11)
						$solution[$tnum++] = $temp;
					}
					//-----------------------------------------------------
					
					else{
						//save each line to an array "line" as long as it isn't a tag
						$y = $c1;
						$line[$c1++] = substr($data,$i-$len,$len);
						//echo "$line[$y] <br>";
						}
				$len = 0;
				$closed = false;
				
				//----------Textarea
				if ($i + 8 < $slen+1)
				  if (substr($data, $i+1,8) == "TEXTAREA")
				   $sol = true;
				  else if (substr($data, $i+1,9) == "/TEXTAREA"){
				  $sol = false;
				  if ($sn == 1 && $file == "filen/scar1996p1.html")
				  $sn = 11;
				  else if ($sn == 11)
				  $sn = 2;
				  else
				  $sn++;
					$tnum = 0;
				  }
				//-------------------  
			//-----------------------end of open tag

			//-----------------------if closed tag
			}else if ($data{$i} == '>'){
				if ($closed)
					continue;
				$len = 0;
				$closed = true;
			//-----------------------end of closed tag
			
			//if anything in between
			}else{
				$len++;		//increase number of characters
			}
		}
				
		$fname = $line[0];	//Problem information (to be exploded)
			//title of problem
		
		if (intval($year) < 2002){
			if (intval($year)<=1999 && intval($year)>=1997 || intval($year) == 1986){
				$title = $line[1];
				$x = 1;
			}else if (intval($year) <=1996 && intval($year) >= 1990){
				$title = $line[5];
				$x = 5;
			}else{
				$title = $line[2];
				$x = 2;
			}
			if (strpos($file, "scar") !== false){
				if (intval($year) == 1999 || intval ($year) == 2000){
					$title = $line[1];
					$x = 1;
				}else if (intval($year) == 1998){
					$title = $line[4];
					$x = 4;
				}else{
					$title = $line[2];
					$x = 2;
				}
			}
			
			for ($i = 0; $i < strlen($title);$i++){
				if ($title{$i} >= '0' && $title{$i} <= '9'){
					break;
				}
			}
		}else{
				$title = $line[1];
				$x = 1;
			}
		
		
		//-----------------------------problem description
		$ln = 1;
		$pos = false;
		//find position of problem description
		do{
			$ln++;	//count number of lines for problem
			if ($ln >= count($line))
				break;
			if (strlen(trim($line[$ln])) < 6)
				continue;
			$temp1 = explode(' ',trim($line[$ln]));
			$pos = strpos(strtolower($temp1[0]), "sample");
			if ($pos === false)
				$pos = strpos(strtolower($temp1[0]), "data file");
			if ($pos === false)
				$pos = strpos($temp1[0], "INPUT DATA");	
		}while ($pos === false);
		
		//save problem decription
		$problem = "";
		$x++;
		for ($i = $x; $i <$ln;$i++){
			
			$problem .= $line[$i]."<br><br>";
		}//-----------------------------------------------
		$t = $ln;

			$lm = 1;
			do{
				$lm++;
				$temp1 = explode(' ',$line[$lm]);
				$pos = strpos(strtolower($temp1[0]), "sample");
				if ($pos === false)
				$pos = strpos(strtolower($temp1[0]), "data file");
				if ($pos === false)
				$pos = strpos($temp1[0], "INPUT DATA");
			}while($pos === false && $lm < count($line)-1);
			$pos = false;
			$x = 0;
			$i = $lm +1;

			if ($i < count($line)-2)
			do{
				$temp = $line[$i++];
				$temp = str_replace(" ","&nbsp;",$temp);//to properly output the " "
				$temp = str_replace("'","&#39;",$temp);
				$temp = str_replace("\\","&#92;",$temp);
				$input1[$x++] = $temp;
				if ($i >= count($line))
					break;
				if(strlen(trim($line[$i]))<6)
					continue;
				$temp1 = explode(' ',trim($line[$i]));
				$pos = strpos(strtolower($temp1[0]), "sample");
			}while($pos === false);

		
		
		//-------------find program language (found next to "sample solution")
		$temp3 = false; 
		$ln = 1;
		$pos = false;
		do{
			$ln++;
				
				if (strlen($line[$ln]) < 14)
					continue;
				$pos = strpos(strtolower($line[$ln]), "sample program");
				if ($pos === false){
				if (strlen($line[$ln]) < 15)
					continue;
				$pos = strpos(strtolower($line[$ln]), "sample solution");
				if ($file == "filen/brd2003p2.html" || $file == "filen/reg2004p1.html" || $file == "fin2003p4.html" && $temp3 == false && $pos !== false){
				$pos = false;
				$temp3 = true;
				}
				}
		}while($pos === false && $ln < count($line)-1);
		if ($file == "filen/fin2007p2.html")
		$ln++;
		$lang = $line[$ln];
		$temp = explode(" ",$lang);
		$index = count($temp)-1;
		$lang = substr($temp[$index],0,strlen($temp[$index])-1);
		//----------------------------------------------------
		
		
		$x = 0;
		
		if (intval($year) != 2002){
			for ($i = $ln + 1; $i < count($line); $i++){
				$temp = $line[$i];
				$temp = str_replace(" ","&nbsp;",$temp);//to properly output the " "
				$temp = str_replace("'","&#39;",$temp);
				$temp = str_replace("\\","&#92;",$temp);
				$solution[$x++] = $temp;
			}
		}
		$diff = $pn;
		$tout = 6;

		
		$table = intval($year);

		//-----------------------------------insert into mysql
		
		$val = mysql_query('select 1 from `'.$table.'`');

		if($val === FALSE)
		{

		//-------------------------------------------------create a table
		$sql_qy ="CREATE TABLE `$table`(ctype VARCHAR(30),pn INT,title VARCHAR(100)";// UNIQUE KEY
		$sql_qy.=",input TEXT(10000), prob TEXT(50000),solution VARCHAR(10000),lang VARCHAR(20) ";
		//echo $sql_qy;
		$sql_qy.=",diff INT, tout INT,comm TEXT(10000))"; 
		$rslt = mysql_query( $sql_qy );
		//-------------------------------------------------------------
		}
		
		$sql_qy = "INSERT INTO `".$table."` ";
		$sql_qy .= "( `ctype` , `pn` , `title` , `input` , `prob` , `solution` , `lang` , `diff` , `tout` , `comm`) ";
		$sql_qy .= "VALUES (";
		$sql_qy .= " '$ctype', ";
		$sql_qy .= " '$pn', ";
		$sql_qy .= " '$title', ";
		
		//------change input >> fm array to string.... and save it
		$sql_qy .= " '";
		if (!isset($input1)){
			$sql_qy .="";
		}
		else{
			for ($m = 0; $m < count($input1);$m++){
				$sql_qy .="$input1[$m]";
				$sql_qy .="<br>";
			}
		}
		$sql_qy .= "', ";
		//--------------------------------------------------------
		
		$sql_qy .= " '$problem', "; //problem
		
		//------change solution >> fm array to string.... and save it
		$sql_qy .= " '";
		if (!isset($solution)){		//if solution is undefined, then no solution given, same as language
		$sql_qy .="";
		$lang = "";
		}else{						//or else save solution as a string
			for ($m = 0; $m < count($solution);$m++){
				$sql_qy .="$solution[$m]";
				$sql_qy .="<br>";
			}
		}
		$sql_qy .= "', ";
		//-------------------------------
		$sql_qy .= " '$lang', ";	//language
		$sql_qy .= " '$diff', ";	//difficulty
		$sql_qy .= " '$tout', ";	//type of output >> set as 6
		$sql_qy .= " '' )";
		$rslt = mysql_query( $sql_qy ) or die ("insert was failed.");
		echo "<p>The insert was successful.\n</p>";
		
		//-------------------------------------------------
	}
?>

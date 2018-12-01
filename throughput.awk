BEGIN{
	pcksize = 0;
	dropped = 0;
	rate = 0;
	time = 4;
}
{
	if($1 == "r" && $4 == "3" && $5 == "tcp" || $1 == "r" && $4 == "3" && $5 == "tcp") {
	  pcksize+= $6;
	  time = $2;
	}
	if($1 == "d") {
	  dropped++;
	}
}
END{
	rate = (pcksize/time)*8/1000000;
	printf("%f",rate);
}
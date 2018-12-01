BEGIN{
	pcksize = 0;
	dropped = 0;
	rate = 0;
	time = 4.5;
}
{
	if($1 == "d") {
	  dropped++;
	}
}
END{
	printf("%d",dropped);
}
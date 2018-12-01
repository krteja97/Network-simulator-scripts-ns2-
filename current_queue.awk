BEGIN{
	
}
{
	if($1 == "Q")
	{
	   printf("%f %f\n",$2,$3);
	}
}
END{
	
}
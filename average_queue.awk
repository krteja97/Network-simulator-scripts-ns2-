BEGIN{
	
}
{
	if($1 == "a"){
	   printf("%f %f\n",$2,$3);
	}
}
END{
	
}
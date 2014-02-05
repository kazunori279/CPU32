void main() 
{
	int i, *r = (int *)0x7f00;
	while (1) 
	{
		for (i = 1; i <= 25; i++) 
		{
			*r = fib(i);
		}
	}
}

int fib(int n)
{
	if (n == 1) return 0;
	if (n == 2) return 1;
	return fib(n-2) + fib(n-1);
}

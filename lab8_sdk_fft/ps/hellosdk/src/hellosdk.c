#include <stdio.h>

int main()
{
	printf("Hello SDK\n\r");

	int i = 12;
	float f = 12.20;
	double d = 321.67;

	printf("The variable i is integer and its value is %d\n", i);
	printf("The variable f is float and its value is %f\n", f);
	printf("The variable d is double and its value is %lf\n", d);

	printf("Enter the new value of i\n");
	scanf("%d", &i);
	printf("The updated value of i is %d\n", i);

	return 0;
}

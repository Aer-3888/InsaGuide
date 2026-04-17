void main() {
	int a = 1 ;
	int b = 2 ;
	int c= 3 ;
	// a	b	c	ptr1	ptr2
	int *ptr1,*ptr2 ;
	ptr1 = &a ;
	// 1	2	3	&a	?
	ptr2 = &c ;
	// 1	2	3	&a	&c
	*ptr1 = (*ptr2) + 1 ;
	// 4	2	3	&a	&c
	ptr1 = ptr2 ;
	// 4	2	3	&c	&c
	ptr2 = &b ;
	// 4	2	3	&c	&b
	*ptr1 -= *ptr2 ;
	// 4	2	1	&c	&b
	*ptr1 *= *ptr2 ;
	// 4	2	2	&c	&b
}

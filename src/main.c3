module nanograd_c3;
import std::io;
import std::core::builtin;
import engine;
import nn;


fn int main(String[] args)
{
	io::printn("Hello, World!");

	Value v;
	v.data = 100.;
	v.label = "v";

	Value w;
	w.data = 10.;
	w.label = "w";

	Value z = v.add(&w);
	z.label = "z";

	z.grad = 2.0;

	z.display();

	
	double n = 2.;

	Value zpow = z.pow(n);
	zpow.label = "zpow";

	//zpow.display();

	v.display();

	w.display();

	z.addgrad(&v,&w);

	v.display();

	w.display();


	// cast not working
	// free lists? (replace by arrays?
	//int b = 2;
	//any *a = (any *)&b;
	// builtin::anycast could not be found
	//float*! c = std::varcast(a, float); // Will return TYPE_MISMATCH
	// int*! d = builtin::anycast(a, int);
	// io::printn("bla");  
	// (void)io::printf("bla:%s", &d);   // Works!

	//v.printExpr(&Value.addTen);

	return 0;
}

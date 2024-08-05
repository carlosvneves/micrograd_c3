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
	v.label = "a";

	Value w;
	w.data = 10.;
	w.label = "b";

	Value z = v.add(&w);

	z.display();
	
	double n = 2.;

	Value zpow = z.pow(n);
	zpow.label = "zpow";

	zpow.display();


	v.display();

	// cast not working
	// free lists? (replace by arrays?
	//int b = 2;
	//any *a = (any *)&b;
	// builtin::anycast could not be found
	//float*! c = std::varcast(a, float); // Will return TYPE_MISMATCH
	// int*! d = builtin::anycast(a, int);
	// io::printn("bla");  
	// (void)io::printf("bla:%s", &d);   // Works!

	return 0;
}	




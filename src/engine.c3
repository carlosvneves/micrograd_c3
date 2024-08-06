module engine;

import std::io;
import std::collections::list;

import std::math;
import std::core::builtin;



// def DoubleBackward= fn double(double);

// fn void apply(double[] arr, DoubleBackward t)
// {
//     foreach (&i : arr) *i = t(*i);
// }


// implements callback for backward gradient (_backward : lambda:None)
// def IntCallback = fn int(int x);

// fn void print3(IntCallback callback)
// {
// 	for (int i = 1; i <= 3; i++)
// 	{
// 		io::printfn("%d -> %d", i, callback(i));
// 	}
// }

/*
import std::io;
import std::core::string;

def IntCallback = fn int(int x);

fn void print3(IntCallback callback)
{
	for (int i = 1; i <= 5; i++)
	{
		io::printfn("%d -> %d", i, callback(i));
	}
}

fn void main()
{
	print3(fn int(int x) { return x * x; });
	//print3(fn(x) => x * x * x);
	
	
	String name = "name";
	String age = string::tformat("%d",21);
	String name_age = name.concat(age);
	//String age = (String)21;
	//char[*] hi = "1";
	//name.appendf();
	//DString ages = DString("%d",age);
	
	io::printf("%s", name_age);
	
	List
*/
//def ValueCallback = fn Value(Value* v);
//def ValueCallback = fn void (Value* v, Value* z, Value* w);

struct Value{
	double data;
	double grad;
	String label;
	String op;
	List(<Value>) prev;
	//ValueCallback backward;
	//double[] backward; 

}

// fn Value Value.addTen(Value* v){
// 	return Value{.data=v.data + 1000};
// }

def Vcall = fn void (Value*v, Value* w); 


fn void Value.backward(Value* v, Value* w, Vcall vf)
{
	vf(v,w);

}

fn void Value.gradAdd(Value* z, Value* v, Value* w){
	v.grad += z.grad;
	w.grad += z.grad;
}

fn void Value.gradMul(Value* z, Value* v, Value* w){
	v.grad *= z.grad;
	w.grad *= z.grad;
}

fn void Value.gradPow(Value* z, double d){
	// self.grad += (other * self.data**(other-1)) * out.grad
	v.grad += d * math::pow(v.grad, d-1)  * z.grad;
	w.grad = w.grad + z.grad;
}

// fn void Value.printExpr(Value* v, ValueCallback valuecallback)
// {
// 	Value r = valuecallback(v);
// 	double d = r.data;
// 	io::printfn("%d", d);
// }

fn Value Value.add(Value* v, Value* w)
{
	
	Value out; 
	out.data = v.data + w.data;
	out.op = "+";
	out.prev.push(*v);
	out.prev.push(*w);

	//out.backward = &Value.backwardAdd();
	
	//backward
	//v.grad += z.grad;
	//w.grad += z.grad;

	return out;
}

fn Value Value.sub(Value* v, Value* w){
	
	Value z; 
	z.data = v.data - w.data;
	z.op = "-";
	z.prev.push(*v);
	z.prev.push(*w);

	//backward
	v.grad -= z.grad;
	w.grad -= z.grad;

	return z;
}

fn Value Value.mul(Value* v, Value* w){
	
	Value z; 
	z.data = v.data * w.data;
	z.op = "*";
	z.prev.push(*v);
	z.prev.push(*w);
	
	//backward
	v.grad += z.grad * w.grad;
	w.grad *= z.grad * v.grad;

	return z;
}

fn Value Value.div(Value* v, Value* w){
	
	Value z; 
	z.data = v.data * math::pow(v.data,-1);
	z.op = "/";
	z.prev.push(*v);
	z.prev.push(*w);
	
	//backward
	v.grad += z.grad * w.grad;
	w.grad *= z.grad * v.grad;

	return z;
}

fn Value Value.pow(Value* v, double n){
	
	Value out; 

	out.data = math::pow(v.data, n);
	// string format + type coertion
	out.op = "pow(".concat(string::tformat("%d)",n));

	return z;
}

fn void Value.print_prev(Value* v){
	if (!v.prev.is_empty()){

		io::print("The previous nodes are: ");
		foreach (s : v.prev)
		{
			io::printf("%s ",s.label);
			
		}
	}
	else{
		io::printn("There are no previous nodes to display!");
	}
}

fn void Value.relu(Value* v){

	Value z;

	z.data = {|
			if (v.data < 0){
				return 0;
			} else{
				return v.data;	
			}|};
	
	z.op = "ReLU";

}

fn void Value.neg(Value* v){
	v.data = v.data * (-1.);
}


fn void Value.bakward(Value* v){
	List(<Value>) topo;
	List(<Value>) visited;

	v.build_topo();
	v.grad = 1;
	foreach (&i : topo)
	{
		//i.backward(); lambda to apply backward
	}

}

fn void Value.build_topo(Value* v){
	List(<Value>) topo;
	List(<Value>) visited;

	// if (visited.contains(*v)==false){
	// 	visited.push(*v);
	// 	foreach (&i : v.prev) 
	// 	{
	// 		build_topo(i);
	// 	}
	// 	topo.push(*v);
	// }

}


// check wether the pointers are the same
// St* p = &v;
// 	p = &z;	
// 	bool res={|
// 		if (p == &v) return true;
// 		return false;
// 	|};
	




// fn void Value.backward(Value *v){
// 	Value[] topo;
// 	List(<Value>) visited;
// 	/*topo = {|
// 		if (visited.contains(*v)==false){
// 			visited.push(*v);
// 			foreach (&i : v.prev) 
// 		}
// 	|};*/

// }

// fn void Value.buildtopo(Value *v){
// 	List(<Value>) topo;
// 	List(<Value>) visited;

// 	if (!visited.contains(*v)){

// 	}


// } 
/*def backward(self):

        # topological order all of the children in the graph
        topo = []
        visited = set()
        def build_topo(v):
            if v not in visited:
                visited.add(v)
                for child in v._prev:
                    build_topo(child)
                topo.append(v)
        build_topo(self)

        # go one variable at a time and apply the chain rule to get its gradient
        self.grad = 1
        for v in reversed(topo):
            v._backward()
*/

fn void Value.display(Value *v){


	io::printf("\n------------- About the node: -----------------");
	io::printf("\nValue(data: %f | grad: %f)\n", v.data, v.grad);
	
	if (v.label.len > 0){
		io::printf("\nLabel: %s", v.label);
	}

	if (v.op.len > 0 && v.prev.is_empty()){
		io::printf("\nOperation was: %s", v.op);
	
	} else if (v.prev.is_empty() == false){
		io::printf("\nPrevious nodes: ");
		foreach (s : v.prev)
		{
			io::printf("%s ",s.label);
			
		}

		io::printf("\nResult from: %s", v.op);
		
	}
	io::printf("\n-----------------------------------------------\n");
	
}

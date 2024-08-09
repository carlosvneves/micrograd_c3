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
	String age = (String)21;
	char[*] hi = "1";
	name.appendf();
	DString ages = DString("%d",age);
	
	io::printf("%s", name_age);
	
	List
*/

//def ValueCallback = fn Value(Value* v);
//def ValueCallback = fn void (Value* v, Value* z, Value* w);

def ValueList = List(<Value>);


struct Value{
	
	double data;
	double grad;
	String label;
	String op;
	ValueList prev;
	//ValueCallback backward;
	//double[] backward; 

}


interface MyName
{

	fn String myname();
}

//fn Value Value.addTen(Value* v){
// 	return Value{.data=v.data + 1000};
//}

def Vcall = fn void (Value* v, Value* w); 


// fn void Value.backward(Value* v, Value* w, Vcall vf)
// {
// 	vf(v,w);

//}


//syntax highlight com problema na hora de colocar o retorno da função
fn void Value.gradAdd(Value* z){
	
	foreach (&el : z.prev)
	{
		
		el.grad = el.grad + z.grad;
	}	
	
}

fn void Value.gradMul(Value* z, Value* v, Value* w){
	v.grad *= z.grad;
	w.grad *= z.grad;
}

fn void Value.gradPow(Value* z, double d){
	// self.grad += (other * self.data**(other-1)) * out.grad
	z.grad += d * math::pow(z.grad, d - 1)  * z.grad;
}

//fn void Value.printExpr(Value* v, ValueCallback valuecallback)
// {
// 	Value r = valuecallback(v);
// 	double d = r.data;
// 	io::printfn("%d", d);
//}

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

	return out;
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



fn bool ValueList.contains(&self, Value value){
    
    foreach (i, v : self)
	{
		if (equals(v, value)) return true;
	}
	return false;
}

fn bool Value.equals(&self, Value value) {
    
	if (value.data == self.data && value.label == self.label) return true;

    return false;
	
}


fn void Value.backward(&self){
	ValueList topo;
	ValueList visited;
	ValueList stack;



	// topo.temp_init();
	// visited.temp_init();


	//topo.push(*self);
	stack.push(*self);

	Value v;

	if (try v = stack.last()){

		bool in = visited.contains(v);
		io::printn(in);


		if (!in){
			visited.push(v);
			//io::printn(visited[0].label);
			foreach(&child : v.prev){
				if(!visited.contains(*child)){
					stack.push(child);
					}else{
						topo.push(stack.pop());
					}
				stack.push(child);
			}

		}else{
			stack.pop();
		}


		/* foreach(&el : visited)
		{
			
			if (el.label == v.label && el.data == v.data){
				;	
			} else {
				io::printn("diferente");
			}
		}*/
		
			

	}


	/*  while (!stack.is_empty())
	{
		Value v = stack.last();


	}*/
	/* foreach (&child : self.prev)
	{
		io::printn(child.label);
	}

	Value ptr = self.prev[0];

	io::printn(ptr.label);

	
	foreach(&el : visited)
	{
		
		if (el.label == ptr.label && el.data == ptr.data){
			io::printn("igual");	
		} else {
			io::printn("diferente");
		}
	}

	foreach(&child : ptr.prev)
	{
		io::printn(child.label);
	}*/


	//visited.contains(&ptr);

	//io::printn(visited.contains(self));

	/*if (!visited.is_empty() || ){
	
	}*/

	//build_topo(self, &topo,  &visited);
	

	/*topo.reverse();

	foreach (&child : topo)
	{
		//child.gradAdd();
	}*/

	self.grad = 1;


}


fn void build_topo(Value v, ValueList* topo, ValueList* visited){
	
	/* if (visited.contains(v))
	{
		//visited.push(*v);
		foreach (&child : v.prev)
		{
			build_topo(child, topo, visited);
		}
		//topo.push(*v);
	}*/
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
// 	ValueList visited;
// 	/*topo = {|
// 		if (visited.contains(*v)==false){
// 			visited.push(*v);
// 			foreach (&i : v.prev) 
// 		}
// 	|};*/

// }

// fn void Value.buildtopo(Value *v){
// 	ValueList topo;
// 	ValueList visited;

// 	if (!visited.contains(*v)){

// 	}


// } 
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
			io::printf("%s | Value(data = %f )\t",s.label, s.data);
			
		}

		io::printf("\nResults from: %s", v.op);
		
	}
	io::printf("\n-----------------------------------------------\n");
	
}

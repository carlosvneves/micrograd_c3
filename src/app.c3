import std::io;
import std::collections::list;

struct Object (Printable){
	int x;
	int y;
	ListRef prev; 

}

def ListObjects = List(<Object>);
def ListRef = List(<Object*>);

fn bool ListObjects.contains(&self, Object* o) {
	
	foreach(&v: self){
		if(v.equals((Object*)o)) return true;
	}

	return false;
}

/*fn bool ListRef.contains(&self, Object* o) {
	

}*/

fn bool Object.equals(&self, Object* o){


	if (self.x == o.x && self.y == o.y) return true;

	return false;
}

fn void Object.foo(&self){
	ListObjects topo;
	ListObjects visited;
	ListObjects stack;


	// regras de desalocação de memória
	topo.temp_init();
	visited.temp_init();
	stack.temp_init();


	//topo.push(*self);
	stack.push(*self);

	Object v;

	if (try v = stack.last()){

		bool in = visited.contains(&v);
		io::printn(in);


		/*if (!in){
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
		}*/

	}
}



fn void bar(Object v){

	ListRef topo = {};
	ListRef visited = {};

	//Object o = *v;
	//io::printn(v.y);

	//topo.push(&v);
	//visited.push(&v);

	//io::printn(topo[0].y);

	if (!visited.contains(&v)){
		//io::printn("foo");
		visited.push(&v);
		//topo.push(&v);
		foreach(c: v.prev){
			if(!visited.contains(&v)){
				bar(*c);
			}
		}
		topo.push(&v);

	}

	foreach(p: topo){
		io::printn(p.x);
	}

}

fn void Object.baz(&self, ListObjects t){

}

fn void main() {
	io::printn("Hello, World!");


	Object o1 = {.x = 1, .y = 2};
	Object o2 = {.x = 3, .y = 4};
	Object o3 = {.x = 7, .y = 6};
	Object o4 = {.x = 5, .y = 6}; // when declaring prev = {}, all the values will be zeroed. Why?


	ListObjects list;


	list.push(o1);
	list.push(o2);


	//io::printn(o3.x);

	o3.prev.push(&o1);
	o3.prev.push(&o2);



	foreach (&e:list){
		io::printn(e.x);
	}


	foreach (e:o3.prev){
		io::printn(e.x);

	}

	io::printn(list.contains(&o2));
	

	io::printn(o3.prev.contains(&o4));
	

	bar(o3);




}

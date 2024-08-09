/*import std::collections::list;
import std::io;


// Define Obj.equals(...)
// Define Obj.compare_to(...)
// Define Obj.less(...)
// Or this works obj1 == obj2

struct Obj(Printable){

    int data;
    
}

def ObjList = List(<Obj>);

fn bool ObjList.contains(&self, Obj value){
    foreach (i, v : self)
	{
		if (equals(v, value)) return true;
	}
	return false;
}

// macro bool equals(a, b) @builtin
// {
//     $switch
//     $case $defined(a.equals, a.equals(b)):
//         return a.equals(b);
//     $case $defined(a.compare_to, a.compare_to(b)):
//         return a.compare_to(b) == 0;
//     $case $defined(a.less):
//         return !a.less(b) && !b.less(a);
//     $default:
//         return a == b;
//     $endswitch
// }

fn bool Obj.equals(&self, Obj value){
    
	if (value.data == self.data) return true;

    return false;
	
}

fn void main(){

    Obj o1 = {.data =1};
    Obj o2 = {.data =2};
    Obj o3 = {.data =3};
    Obj o4 = {.data =4};


    ObjList l;
    l.temp_init();
    l.push(o1);
    l.push(o2);
    l.push(o3);

    io::printn(l.contains(o4));




    // Obj *p = &l[0];
    // p = &o1;

    
    
    
    
    
    
    
    // Vforeach (&e : l)
    // {
    //     io::printn(&e);   
    // }
    // io::printn(&o1); 


    // foreach(i,e: l){
    //     //Obj *q = &l[i];
    //     io::printn(equals(&l[i], p));

    // }
    // //io::printn(l.contains(&o1));
    // //io::printn(equals(p,&o4));

    // Obj[2] a = {o1, o2};
    // Obj* q = &o1;

     

    // l.contains(o1);

}*/
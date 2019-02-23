#include <itpp/itcomm.h>
#include <Eigen/Sparse>
#include <Eigen/Core>

#include <regex>
#include <fstream>
//#include <vector>
#include <list>
#include <iostream>
#include <iomanip>
#include <cstdlib>
#include <climits>
//#include <algorithm>
//#include <string>
//#include <time.h>
//#include <chrono>
#include <stdio.h>
//#include <stdio.h>
//#include <gmp.h>
//#include <gmpxx.h>
//#include <assert.h>

typedef Eigen::SparseMatrix<int> SpMati;
typedef Eigen::SparseVector<int> SpVeci;
//typedef Eigen::Triplet<int> Trip;
//typedef SpMati::InnerIterator Spit;
typedef unsigned long int ulint;
typedef long int lint;
typedef std::vector< std::vector<int> > varray;
typedef Eigen::Triplet<int> Ti;

//class that organizes the qc code and propagates errors
//erros are stored in 3 vectors each with length equal to the number of qbits
//the codes are organized in parallel blocks
//each block is organized in 9 sparse  matricies:
//xx, xy, xz, yx, yy ,yz, zx, zy, zz
//columns represent the incoming erros 
//while rows represent the qbits erros propagate to
class Qcode{
 public:
     //vector that store sparse matricies that store how errors propagate
     std::vector< SpMati > pm;
     //stores vectors that determine if a measurement is to be made
     std::vector< std::vector<int> > mv;
     //ev: vector that store the final error values and the total error values
     //positions x=[0,Nq),z=[Nq,2Nq)
     //s: syndrome vector
     Eigen::VectorXi ev;
     std::vector<int> s;
     //number of qbits, number of times steps, size of syndrome
     ulint Nq, Nt, Ns;
     //imports the code found in file
     void ImportCode(std::string file);
     //Runs through the code once 
     //errors are added with probability p per time set per qubit
     //if reset is set true than ev is cleared of errors and set to 0
     void Run(const double p, const bool reset);
     //Reduces error vector ev
     void Reduce();
     //Adds errors to ev with probability p
     void AddErrors(const double p);
     //weilei add following two
     void setInitialError(Eigen::VectorXi ev_input);
     void Reset();
};

void Qcode::setInitialError(Eigen::VectorXi ev_input){
  ev=ev_input;
  return;
}

void Qcode::AddErrors(const double p){
    int r=0;
    for(size_t i=0; i<Nq; i++){
	if((double)rand()/RAND_MAX<p){
	    r=rand();
	    if(r%3==0) ev(i)+=1;
	    else if(r%3==1) ev(i+Nq)+=1;
	    else{
		ev(i)+=1;
		ev(i+Nq)+=1;
	    }
	}
    }
    //Weilei add for output

    /*  std::cout<<"ev = ";
    for (size_t i=0;i<ev.size();i++){  
      std::cout << ev[i] << " ";
    }
    std::cout<<std::endl;*/
    return;
}

void Qcode::Reduce(){
    for(size_t i=0;i<2*Nq;i++) ev(i)=ev(i)%2;	
    return;
}

void Qcode::Reset(){//weilei add for reset, Feb 19,2019
    ev=Eigen::VectorXi::Zero(2*Nq);
    return;
}

void Qcode::Run(const double p,const bool reset){
    std::fill(s.begin(),s.end(),0);
    if(reset) ev=Eigen::VectorXi::Zero(2*Nq);
    for(size_t i=0;i<Nt;i++){
      //std::cout << "<Qcode::Run> before addReeors i=" << i << std::endl;
	AddErrors(p);
	//	std::cout << "<Qcode::Run> afterAddError " << i << std::endl;
	for(size_t j=0;j<mv[i].size();j+=2){
	  //	  std::cout << "j=" << j <<" mv[i].size() =  "<<mv[i].size()<< std::endl;
	    if(ev(mv[i][j+1])%2>0){
		s[mv[i][j]]=1;
	    }
	}

	ev=pm[i]*ev;
    }
    Reduce();
    //    std::cout << "<Qcode::Run> after Reduce " << std::endl;
    return;
}

//finds the next gate
//it treats # as comments
//if a line is just a newline it ignore it
//anything after a # is treated as comments
//returns true if a gate is found and false otherwise
//if the first character in a line is a number then it returns it in b1
//it assumes it is the number of qbits and g=N
/*
bool NextGate(std::ifstream f, char &g, int &b1, int &b2){
    std::string line;
    while(getline(f,line)){
    }
    return false;
}
*/
//the file containing the code must follow the following pattern
//Nq
//c 0 1
//h 4
//...
//p 01
//where Nq is the number of qbits
//the following gates can be used
//single qbit:
//H (Hadamard)
//x, y, z (pauli gates)
//two qbit:
//c (CNOT)
//p (phase gate)
//gate rules
//bit|h|c  |p  |
//x,1|z|x,x|x,z|
//y,1|y|y,x|y,z|
//z,1|x|z,1|z,1|
//1,x|-|1,x|z,x|
//1,y|-|z,y|z,y|
//1,z|-|z,z|1,z|
void Qcode::ImportCode(std::string file){
    std::ifstream f;
    f.open(file.c_str());
    if(f.is_open()){
	pm.clear();
	Nq=0;
	Ns=0;
	//gets first line
	std::string line;
	int t=0,b1=-1,b2=-1,l=-1;
	size_t p1,p2;
	char g;
	const std::string whitespace=" \n\t\r";

	//finds Nq
	while(getline(f,line)){
	    l++;
	    //std::cout << "line: " << line << std::endl;
	    //removes comments
	    p1=line.find_first_of("#");
	    if(p1!=std::string::npos){
		line.erase(p1,line.size()-p1);
	    }

	    //checks if line is blank
	    p1=line.find_first_not_of(whitespace);
	    if(p1==std::string::npos){
		//std::cout << "This is a white line: " << p1 << std::endl;
		continue;
	    }
	    else if(p1>0){
		std::cout << "Leading whitespace on line " << l << std::endl;
		throw;
	    }
	    else{
		p1=line.find_first_of(whitespace);
		//std::cout << "p1=" << p1 << std::endl;
		if(p1!=std::string::npos&&line.find_first_not_of(whitespace,p1+1)!=std::string::npos){
		    std::cout << "Extra non white space on line " << l << "\n"
		              << "line = " << line << std::endl;
		    throw;
		}
		Nq=std::stoi(line);
		break;
	    }
	}
	if(Nq==0){
	    std::cout << "Nq is 0" << std::endl;
	    throw;
	}


	//std::cout << Nq << std::endl;
	ev=Eigen::VectorXi::Constant(2*Nq,0);
	//triplet list
	std::vector<Ti> tlist;
	tlist.clear();
	tlist.reserve(2*2*Nq);
	
	//time step position, line position
	//qbits that have had a gate for this time step
	//0=nothing,1=something
	std::vector<int> qbt(Nq);
	//holds code to append to pm
	SpMati tm(2*Nq,2*Nq);
	//stores which qbits to be measured
	//every even number is syndrome position 
	//while the odds are the qbits to be measured
	std::vector<int> m;
	
	while(getline(f,line)){
	    l++;
	    //std::cout << "line: " << line << std::endl;
	    //removes comments
	    p1=line.find_first_of("#");
	    if(p1!=std::string::npos){
		line.erase(p1,line.size()-p1);
	    }

	    //checks if line is blank
	    p1=line.find_first_not_of(whitespace);
	    if(p1==std::string::npos){
		//std::cout << "This is a white line: " << p1 << std::endl;
		continue;
	    }
	    
	    //finds gate
	    p1=line.find_first_of(whitespace);
	    if(p1>1){
		std::cout << "Gate value is not right on line " << l << std::endl;
		throw;
	    }
	    g=line.at(0);

	    //finds qbit numbers
	    p2=line.find_first_of(whitespace,p1+1);
	    //if p2 is at the end this should be a one qbit gate
	    if((p2==std::string::npos)||(p2==line.size())){
		b1=std::stoi(line.substr(p1+1,line.size()-p1));
		b2=-1;
	    }
	    //if p2 is not at the end this may not be a 1 qbit gate
	    else{
		b1=std::stoi(line.substr(p1+1,p2-p1-1));
		p1=line.find_first_of(whitespace,p2+1);
		//if the next space is only 1 from p2 then
		//test for trailing spaces for a 1 qbit gate
		//if p1 is at the end changes it to make things simplers
		if(p1==std::string::npos) p1=line.size();
		//if a not whitespace is found after p1 then it is wrong
		else if(line.find_first_not_of(whitespace,p1+1)!=std::string::npos){
		    std::cout << "There is extra characters on line " << l << std::endl;
		    throw;
		}
		//if p1 and p2 are only off by 1
		//then there can't be another qbit
		if(p1-p2>1){
		    b2=std::stoi(line.substr(p2+1,p1-p2));
		}
		else b2=-1;
	    }
	    //std::cout << l << " (" << g << "," 
	    //          << b1 << "," << b2 << ")" << std::endl;

	    //finds if a new time step needs to be found
	    if((qbt[b1]==1&&g!='m')||(b2>=0&&qbt[b2]==1)){
		t++;
		//std::cout << "t=" << t << std::endl;
		for(size_t i=0;i<qbt.size();i++){
		    if(qbt[i]==0){
			tlist.push_back(Ti(i,i,1));//x
			tlist.push_back(Ti(i+Nq,i+Nq,1));//z
		    }
		}
		std::fill(qbt.begin(),qbt.end(),0);
		
		tm.setFromTriplets(tlist.begin(),tlist.end());
		tlist.clear();
		pm.push_back(tm);
		mv.push_back(m);
		m.clear();
	    }
	    //bit|h|c  |p  |
	    //x,1|z|x,x|x,z|
	    //y,1|y|y,x|y,z|
	    //z,1|x|z,1|z,1|
	    //1,x|-|1,x|z,x|
	    //1,y|-|z,y|z,y|
	    //1,z|-|z,z|1,z|
	    if(g=='h'){
		//x
		tlist.push_back(Ti(b1+Nq,b1,1));
		//z
		tlist.push_back(Ti(b1,b1+Nq,1));

		qbt[b1]=1;
	    }
	    else if(g=='c'){
		if(b2<0){
		    std::cout << "gate at line " << l 
			      << " is missing the 2nd qbit" << std::endl;
		    throw;
		}
		tlist.push_back(Ti(b1,b1,1));//x:1-1
		tlist.push_back(Ti(b2,b1,1));//x:1-2

		tlist.push_back(Ti(b1+Nq,b1+Nq,1));//z:1-1
		//z:1-2
		qbt[b1]=1;

		//x:2-1
		tlist.push_back(Ti(b2,b2,1));//x:2-2

		tlist.push_back(Ti(b2+Nq,b2+Nq,1));//z:2-2
		tlist.push_back(Ti(b1+Nq,b2+Nq,1));//z:2-1
		qbt[b2]=1;
	    }
	    else if(g=='p'){
		if(b2<0){
		    std::cout << "gate at line " << l 
			      << " is missing the 2nd qbit" << std::endl;
		    throw;
		}
		tlist.push_back(Ti(b1,b1,1));//x:1-1
		tlist.push_back(Ti(b2+Nq,b1,1));//x:1-2

		tlist.push_back(Ti(b1+Nq,b1+Nq,1));//z:1-1
		//z:1-2
		qbt[b1]=1;

		tlist.push_back(Ti(b2,b2,1));//x:2-2
		tlist.push_back(Ti(b1+Nq,b2,1));//x:2-1

		tlist.push_back(Ti(b2+Nq,b2+Nq,1));//z:2-2
		//z:2-1
		qbt[b2]=1;
	    }
	    else if((g=='x')||(g=='y')||(g=='z')){
		tlist.push_back(Ti(b1,b1,1));//x
		tlist.push_back(Ti(b1+Nq,b1+Nq,1));//z
		qbt[b1]=1;
	    }
	    else if(g=='m'){
		if(b2<0){
		    std::cout << "gate at line " << l
			      << " is missing the qubit to measured" 
			      << std::endl;
		}
		qbt[b2]=1;
		m.push_back(b1);
		m.push_back(b2);
		//std::cout << "b1=" << b1 << ",b2=" << b2 << std::endl;
		if(Ns<b1+1) Ns=b1+1;
		//std::cout << "Ns=" << Ns << std::endl;
	    }
	    else{
		std::cout << "At line " << l << ", there is an invalid gate." 
		          << std::endl;
		throw;
	    }
	}
	t++;
	//std::cout << "t=" << t << std::endl;
	for(unsigned int i=0;i<qbt.size();i++){
	    if(qbt[i]==0){
		tlist.push_back(Ti(i,i,1));//x
		tlist.push_back(Ti(i+Nq,i+Nq,1));//z
	    }
	}
	//std::fill(qbt.begin(),qbt.end(),0);
	/*
	for(unsigned int i=0;i<tlist.size();i++){
	    std::cout << "(" << tlist[i].col() << "," << tlist[i].row()
		      << "," << tlist[i].value() << ")" << std::endl;
	}
	*/
	tm.setFromTriplets(tlist.begin(),tlist.end());
	pm.push_back(tm);
	mv.push_back(m);
	Nt=t;
	s.clear();
	s.resize(Ns,0);
    }
    else{
	std::cout << file << " could not be opened" << std::endl;
	throw;
    }

    return;
}

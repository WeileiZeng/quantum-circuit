#include <itpp/itcomm.h>
//#include <Eigen/Sparse>
//#include <Eigen/Core>

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
//#include <stdio.h>
//#include <stdio.h>
#include <gmp.h>
#include <gmpxx.h>
#include <assert.h>

//typedef Eigen::SparseMatrix<int> SpMati;
//typedef Eigen::Triplet<int> Trip;
//typedef SpMati::InnerIterator Spit;
typedef unsigned long int ulint;
typedef long int lint;
typedef std::vector< std::vector<int> > varray;

//finds the root of site i in ptr and repoints it directly to it
int findroot(const ulint i, std::vector<lint> &ptr)
{
  if (ptr[i]<0) return i;
  return ptr[i] = findroot(ptr[i],ptr);
}

/*
void swap(int &a1, int &a2)
{
  int hold=a1;
  a1=a2;
  a2=hold;
}
*/

template <class T>
void swap(std::vector< std::vector<T> > &a, const ulint Nb, const ulint p1, const ulint p2)
{
  T hold=a[0][p1];
  a[0][p1]=a[0][p2];
  a[0][p2]=hold;
  
  hold=a[0][p1+Nb];
  a[0][p1+Nb]=a[0][p2+Nb];
  a[0][p2+Nb]=hold;
  

  hold=a[1][p1];
  a[1][p1]=a[1][p2];
  a[1][p2]=hold;

  hold=a[1][p1+Nb];
  a[1][p1+Nb]=a[1][p2+Nb];
  a[1][p2+Nb]=hold;
  
}

template <class T>
void scramble(std::vector< std::vector<T> > &a, const ulint p1, const ulint p2, const ulint Nb)
{
  if(p2<=p1) return;
  ulint j=std::rand()%(p2-p1+1)+p1;
  if(j!=p1){
      swap(a,Nb,j,p1);
  }
  //if(j!=p1) swap(a,p1,j);
  scramble(a,p1+1,p2,Nb);
  return;
}

template <class T>
void permutation(std::vector< std::vector<T> > &a)
{
    ulint N=a[0].size();
    if(N%2!=0){
	std::cout << "Vector does not have an even length" << std::endl;
	throw;
    }
    if((a.size()==2)&&(N==a[1].size())){
	if(N>1){
	    scramble(a,0,N/2-1,N/2);
	}
    }
    else{
	std::cout << "Vector is not of the right dimensions" << std::endl;
	throw;
    }
}

//A class that conatins all the info to describe clusters
//on a graph when doing percolation
//h=k-k'-s+b
class cluster{
 public:
  //ptr: each site points to a site it is connected to
  //roots contain negative the size of the cluster
  std::vector<lint> ptr;
  //nsave: minimum number of cluster sizes to keep in rm
  //nsavemax: max number of cluster sizes to keep in rm
  ulint nsave,nsavemax;
  //rm: root of the largest cluster
  //rm2: root of the 2nd largest cluster
  //nclst: number of clusters
  //nd: number of clusters on dual lattice
  ulint nclst;
  //stores list of largest clusters
  std::list<ulint> rm;
  //Ns: number of sites
  //Nb: number of bonds
  ulint Ns, Nb;
  //reads in file and initializes cluster and adds bonds to list
  void initialize(std::vector<lint> &bonds,const std::string file,ulint nsave);
  //adds one more bond to ptr and updates rm, rm2, nclst, h
  void addbond(const ulint s1, const ulint s2);
  //outputs ptr and rm
  void output();
  //finds root of site i
  ulint findroot(const ulint i);
  //updates sum
  void UpdateData(std::vector<mpf_class> &dat);
  //updates sum with homology information
  void UpdateHomologies(std::vector<std::vector<mpf_class> > &dat,
	  std::vector<ulint> k,std::vector<ulint> kd);
  //inserts root r into list
  void rmInsert(const ulint r);
  //Fills rm with roots if it is too small
  void rmFill();
  //cuts rm to size if it is too big
  void rmCut();
};

void cluster::rmCut(){
   if(rm.size()>nsavemax){
	//std::cout << "rm is too big" << std::endl;
	//output();
	int cut=rm.size()-nsavemax;
	std::list<ulint>::iterator it=rm.end();
	it--;
	for(int i=0; i<cut; i++){
	    rm.erase(it);
	    it--;
	}
   }
   return;
}

void cluster::rmFill(){
    /*
    std::cout << "size=" << rm.size() << "\n"
	      << "nsave=" << nsave << "\n"
	      << "nsavemax=" << nsavemax << "\n"
	      << "nclst=" << nclst << std::endl;
	      */
    //std::list<ulint>::iterator it=rm.begin();
    if((rm.size()<nsave)&&(rm.size()<nclst)){
	std::list<ulint>::iterator it=rm.begin();
	//std::cout << "Filling rm" << std::endl;
	//output();
	for(size_t i=0;i<ptr.size();i++){
	    if(ptr[i]<0){
		//std::cout << "ptr=(" << i << "," << ptr[i] << ")" << std::endl;
		for(it=rm.begin();it!=rm.end();++it){
		    //std::cout << "rm=(" << *it << "," << ptr[*it] << ")" << std::endl;
		    if(i==*it) break;
		    else if(ptr[i]<ptr[*it]){
			//std::cout << "Inserted\n";
			//output();
			rm.insert(it,i);
			if(rm.size()==nclst){
			    //std::cout << "Filled\n";
			    //output();
			    return;
			}
			else break;
		    }		  
		}
		if(it==rm.end()){
		    //std::cout << "Adding at end " << i << std::endl;
		    rm.push_back(i);
		    if(rm.size()==nclst){
			//std::cout << "Filled\n";
			//output();
		        return;
		    }
		}
	    }
	}
    }
    //std::cout << "Filled\n";
    //output();
    return;
}

void cluster::rmInsert(ulint r){
    //want to order list and insert r1
    //std::cout << "Inserting root " << r << std::endl;
    std::list<ulint>::iterator it1,it2;
    it1=it2=rm.end();
    it1--;
    if(ptr[*it1]>=0){
	rm.erase(it1);
	it1--;
    }

    if(ptr[*it1]<ptr[r]) return;

    while(it1!=rm.begin()&&it2!=rm.begin()){
	it1--;
	it2--;
	//std::cout << "it1=" << *it1 << ", it2=" << *it2 << std::endl;
	
	//checks if *it1 is still a root
	if(ptr[*it1]<0){
	    //checks if *it1 and *it2 is in the right order
	    if(ptr[*it2]<ptr[*it1]) std::swap(*it1,*it2);

	    //checks if cluster r is smaller than *it1
	    //if r is larger no need to do anything
	    if(ptr[*it1]<=ptr[r]){
		//insert only if r does not equal *it1 and *it2
		//and its size is < *it1 and >= *it2
		if(r==*it1) continue;
		else if(r==*it2||ptr[*it2]<ptr[r]) return;
		else if(ptr[r]<=ptr[*it2]){
		    rm.insert(it2,r);
		    return;
		}
	    }
	}
	else{
  	    rm.erase(it1);
	    //std::cout << "erased: it1=" << *it1 << ", it2=" << *it2 << std::endl;
	    it2++;
	    it1=it2;
	    it1--;
	}
    }

    if(ptr[*it1]>=ptr[r]&&*it1!=r) rm.insert(it1,r);
    return;
}

ulint cluster::findroot(const ulint i){
  if(ptr[i]<0) return i;
  return ptr[i] = findroot(ptr[i]);
}

void cluster::output(){
  std::cout << "ptr = ";
  for(size_t i=0; i<ptr.size(); i++){
    std::cout << ptr[i] << " ";
  }
  std::cout << std::endl;
  std::cout << "rm = ";
  for(std::list<ulint>::iterator it=rm.begin(); it!=rm.end(); ++it){
      std::cout << "(" << *it << "," << ptr[*it] << ") ";
  }
  std::cout << std::endl;
  return;
}

//reads in file and initializes cluster and adds bonds to list
void cluster::initialize(std::vector<lint> &bonds, 
	const std::string file, 
	ulint msave){
  //rm: root of the largest cluster
  //rm2: root of the 2nd largest cluster
  //nclst: number of clusters
  //nd: number of clusters on the dual

  //rm1=0;
  //rm2=1;
  nsave=msave;
  for(ulint i=0; i<nsave; i++){
      rm.push_back(i);
  }

  std::ifstream infile;
  infile.open(file.c_str());
  
  //std::cout << "opening file" << std::endl;
  
  if(infile.is_open()){
    while(infile.peek()=='%') infile.ignore(2048,'\n');
    
    //initializes arrays and constants
    //Ns: number of sites on regular lattice
    //Nb: number of bonds
    
    ulint t1,t2,t3,Nl;
    
    infile >> Ns;
    infile >> Nb;	
    infile >> Nl;
    nclst=Ns;

    if(Ns==0){
      std::cout << "This is an empty graph" << std::endl;
      throw;
    }
    nsavemax=3*Ns/250+44;
    if(nsave>nsavemax) nsavemax=nsave;
    else if(nsavemax>Ns) nsavemax=Ns;

    //std::cout << "making pointer" << std::endl;
    ptr.resize(Ns);
    for(ulint i=0; i<Ns; i++){
      ptr[i]=-1;
    }
    
    //std::cout << "Nb=" << Nb << std::endl;
    //std::cout << "making bonds" << std::endl;
    bonds.clear();
    bonds.resize(2*Nb);
    for(ulint i=0; i<2*Nb; i++) bonds[i]=-1;

    //creates bond list
    //std::vector<Trip> tripletList;
    //tripletList.reserve(2*Nb);
    
    for(ulint k=0; k<Nl; k++){
      //t1: site label
      //t2: bond label
      //t3: 1
      infile >> t1 >> t2 >> t3;
      if(bonds[t2-1]==-1) bonds[t2-1]=t1-1;
      else if(bonds[t2-1+Nb]==-1) bonds[t2-1+Nb]=t1-1;
      else{ 
	  std::cout << "Import matrix from file, " 
	            << file << ", has too many 1s in column " << t2 
		    << std::endl;
	  throw;
      }
    }
    infile.close();
    for(ulint i=0; i<2*Nb; i++){
	if(bonds[i]==-1){
	    std::cout << "Missing a 1 in column ";
	    if(i>Nb) std::cout << i-Nb << std::endl;
	    else std::cout << i << std::endl;
	    throw;
	}
    }
    rmFill();
    rmCut();
  }
  else{
    std::cout << "Could not open file: " << file << std::endl;
    throw;
  }
  return;
}

//adds data to dat line about the homologies
void cluster::UpdateHomologies(std::vector<std::vector<mpf_class> > &dat,
	std::vector<ulint> k,std::vector<ulint> kd){
    //std::cout << "Homologies" << std::endl;
    //mpf_class tmp(0,128);
    //mpf_init2(tmp,256);
    //ulint h=k-kd-Ns+mpf_get_d(dat[0])+1;
    if(dat.size()!=k.size()||dat.size()!=kd.size()){
	std::cout << "dat, k and kd do match sizes\n" 
	          << "dat.size()=" << dat.size() << "\n"
		  << "k.size()=" << k.size() << "\n"
		  << "kd.size()=" << kd.size() << std::endl;
	throw;
    }
	
    ulint h=0,n=dat.size();
    for(size_t i=0;i<dat.size();i++){
	h=k[i]-kd[n-i-1]-Ns+dat[i][0].get_ui()+1;
	/*
	std::cout << "(i,k[i],kd[n-i-1],dat[i][0],Ns,h) = (" << i << "," 
		  << k[i] << ","
		  << kd[n-i-1] << ","
		  << dat[i][0].get_ui() << ","
		  << Ns << ","
		  << h << ")" << std::endl;
	*/
    	//sum contains the following sums in its list (n is nsave):
	//(0) N_bs
        //(1) N_s
        //(2) S_1 
        //(3) S_2
        //(4) S_3
        //    ...
	//(n+1) S_n
        //(n+2) S_2/S_1
        //(n+3) S_3/S_1
        //...
        //(2n) S_n/S_1
        //(2n+1) Pr(N_H>0)
        //if(h>0) mpf_add_ui(dat[2*nsave+1],dat[2*nsave+1],1);
        if(h>0) dat[i][2*nsave+1]+=1;
        //(2n+2) N_H
        //mpf_add_ui(dat[2*nsave+2],dat[2*nsave+2],h);
        dat[i][2*nsave+2]+=h;
        //(2n+3) N_c^2
        //(2n+4) S_1^2
        //(2n+5) S_2^2
        //(2n+6) S_3^2
        //...
        //(3n+3) S_n^2
        //(3n+4) (S_2/S_1)^2
        //(3n+5) (S_3/S_1)^2
        //...
        //(4n+2) (S_n/S_1)^2
        //(4n+3) N_H^2
        //mpf_add_ui(dat[4*nsave+3],dat[4*nsave+3],h*h);
        dat[i][4*nsave+3]+=h*h;
	//|C(0)|
    }
    //mpf_clear(tmp);
    return;
}

//adds data to dat line
void cluster::UpdateData(std::vector<mpf_class> &dat){
    /*
    std::cout << "rm= ";
    for(std::list<ulint>::iterator it=rm.begin();it!=rm.end();it++){
	std::cout << "(" << *it << "," << -ptr[*it] << ") ";
    }
    std::cout << std::endl;
    */
    //std::cout << "Updating dat" << std::endl;
    if(dat.size()<4*nsave+4){
	std::cout << "Data storage size is too small\n"
	          << "nsave=" << nsave << "\n"
	          << "dat.size()=" << dat.size() << "\n"
	          << "Dat = ";
	for(size_t i=0;i<dat.size();i++){
	    std::cout << dat[i] << " ";
	}
	std::cout << std::endl;
	throw;
    }
    //mpf_class tmp(0,128);
    //mpf_init2(tmp,256);
    //sum contains the following sums in its list (n is nsave):
    //(0) N_bs
    //(1) N_s
    //mpf_add_ui(dat[1],dat[1],nclst);
    //std::cout << "nclst" << std::endl;
    if(nclst<1){
	std::cout << "nclst<0" << std::endl;
	throw;
    }
    dat[1]+=nclst;
    //(2) S_1 
    //(3) S_2
    //(4) S_3
    //    ...
    //(n+1) S_n
    //std::cout << "S_n" << std::endl;
    std::list<ulint>::iterator it=rm.begin(),it2=rm.begin();
    for(ulint i=0; i<nsave; i++){
	if(it==rm.end()) break;
	//mpf_add_ui(dat[i+2],dat[i+2],*it);
	if(ptr[*it]>=0){
	    std::cout << "The " << i << "th largest cluster is not a root\n"
		      << "*it=" << *it << ", ptr[*it]=" 
		      << ptr[*it] << std::endl;
	    throw;
	}
	dat[i+2]-=ptr[*it];
	it++;
    }
    //(n+2) S_2/S_1
    //(n+3) S_3/S_1
    //...
    //(2n) S_n/S_1
    //std::cout << "s_n/s_1" << std::endl;
    it=rm.begin();
    it++;
    it2=rm.begin();
    //double r=0;
    for(ulint i=1;i<nsave;i++){
	if(it==rm.end()) break;
	//mpf_set_ui(tmp,*it);
	//mpf_div_ui(tmp,tmp,*it2);
	//mpf_add(dat[nsave+i+1],dat[nsave+i+1],tmp);
	//std::cout << i << " [" << nsave+i+1 << "] " 
	//          << dat[nsave+i+1].get_d() << "\n"
	//	  << "S_n=" << ptr[*it] << "\n"
	//	  << "S_1=" << ptr[*it2] << std::endl;
	//r=ptr[*it];
	//r=r/ptr[*it2];
	//std::cout << "r=" << r << std::endl;
	dat[nsave+i+1]+=((double)ptr[*it])/ptr[*it2];
	//std::cout << "increment" << std::endl;
	it++;
    }
    //(2n+1) Pr(N_H>0)
    //(2n+2) N_H
    //(2n+3) N_c^2
    //mpf_add_ui(dat[2*nsave+3],dat[2*nsave+3],nclst*nclst);
    //std::cout << "nclst^2" << std::endl;
    dat[2*nsave+3]+=nclst*nclst;
    //(2n+4) S_1^2
    //(2n+5) S_2^2
    //(2n+6) S_3^2
    //...
    //(3n+3) S_n^2
    //std::cout << "S_n^2" << std::endl;
    it=rm.begin();
    for(ulint i=0; i<nsave; i++){
	if(it==rm.end()) break;
	//mpf_add_ui(dat[2*nsave+i+4],dat[2*nsave+i+4],(*it)*(*it));
	dat[2*nsave+i+4]+=ptr[*it]*ptr[*it];
	it++;
    }
    //(3n+4) (S_2/S_1)^2
    //(3n+5) (S_3/S_1)^2
    //...
    //(4n+2) (S_n/S_1)^2
    //std::cout << "(s_n/s_1)^2" << std::endl;
    it=rm.begin();
    it++;
    it2=rm.begin();
    for(ulint i=1;i<nsave;i++){
	if(it==rm.end()) break;
	//mpf_set_ui(tmp,*it);
	//mpf_div_ui(tmp,tmp,*it2);
	//mpf_pow_ui(tmp,tmp,2);
	//mpf_add(dat[3*nsave+3+i],dat[3*nsave+3+i],tmp);
	dat[3*nsave+3+i]+=pow(((double)ptr[*it])/ptr[*it2],2);
    }
    //(4n+3) N_H^2
    //(4n+4) |C(0)|
    dat[4*nsave+4]-=ptr[findroot(0)];
    //(4n+5) |C(0)|^2
    dat[4*nsave+5]+=pow(ptr[findroot(0)],2);
    //mpf_clear(tmp);
    //std::cout << "Done" << std::endl;
    return;
}

//adds one more bond to ptr and updates rm, rm2, nclst, h
void cluster::addbond(const ulint s1, const ulint s2){
    //checks if s1 and s2 are in the right region
    if(s1<0||s1>=Ns||s2<0||s2>=Ns){
	std::cout << "Sites " << s1 << "and/or" << s2 
	          << " is you of bounds" << std::endl;
	throw;
    }

    ulint r1=findroot(s1),r2=findroot(s2);

    //checks if s1 and s2 are already in the same cluster
    if(r1==r2) return;
    nclst--;
    //checks which cluster is larger
    if(ptr[r1]<ptr[r2]){
	//cluster r1 is larger than r2
	ptr[r1]+=ptr[r2];
	ptr[r2]=r1;
	r2=r1;
    }
    else{
	//cluster r2 is larger or they are equal
	ptr[r2]+=ptr[r1];
	ptr[r1]=r2;
	r1=r2;
    }
    
    //updates rm----------------------------
    rmInsert(r1);
    rmFill();
    rmCut();
    return;
}


#include <itpp/itcomm.h>
#include <Eigen/Sparse>
#include <Eigen/Core>

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

typedef Eigen::SparseMatrix<int> SpMati;
typedef Eigen::Triplet<int> Trip;
typedef SpMati::InnerIterator Spit;
typedef std::vector< std::vector<int> > varray;

/*
long double runavg(long double Mk, int xk, int k)
{
  return (long double)(xk-Mk)/((long double)k);
}
*/

//finds the root of site i in ptr and repoints it directly to it
int findroot(const int i, std::vector<int> &ptr)
{
  if (ptr[i]<0) return i;
  return ptr[i] = findroot(ptr[i],ptr);
}

/*
//swaps site p1 and p2 in array a
template <class T>
void swap(T &a, const int p1, const int p2)
{
  T hold;
  hold=a[p1];
  a[p1]=a[p2];
  a[p2]=hold;
}
*/


template <class T>
void swap(std::vector<T> &a, const int p1, const int p2)
{
  T hold;
  hold=a[p1];
  a[p1]=a[p2];
  a[p2]=hold;
}

template <class T>
void swap(T &a1, T &a2)
{
  T hold=a1;
  a1=a2;
  a2=hold;
}

//randomally permutes all sites between p1 and p2 in array a
template <class T>
void scramble(T &a, const int p1, const int p2)
{
  if(p2<=p1) return;
  int j=std::rand()%(p2-p1+1)+p1;
  if(j!=p1) a[p1].swap(a[j]);
  //if(j!=p1) swap(a,p1,j);
  scramble(a,p1+1,p2);
  return;
}

//randomly permutes the array order
template <class T>
void permutation(T &order, int N)
{
  scramble(order,0,N-1);
}

template <class T>
void scramble(std::vector<T> &a, const int p1, const int p2, const int N)
{
  if(p2<=p1) return;
  int j=std::rand()%(p2-p1+1)+p1;
  if(j!=p1){
    swap(a[j],a[p1]);
    swap(a[j+N],a[p1+N]);
  }
  //if(j!=p1) swap(a,p1,j);
  scramble(a,p1+1,p2,N);
  return;
}

//randomly permutes the array order
//it assumes order is a Nx2 matrix organized into a single vector
template <class T>
void permutation(std::vector<T> &order, int N)
{
  scramble(order,0,N-1,N);
}



std::vector<int> Neigborhood(const SpMati &A, const int s, const int R, const int rmin, std::vector<int> &list);

//A class that conatins all the info to describe a Network when doing percolation
class Network{
 public:
  //ptr: each site points to a site it is connected to
  //roots contain negative the size of the cluster
  std::vector<int> ptr;
  //rm: root of the largest cluster
  //rm2: root of the 2nd largest cluster
  //nclst: number of clusters
  int rm,rm2,nclst;
  //Ns: number of sites
  //Nb: number of bonds (not including bonds to city center
  int Ns, Nb;
  //A: Adjacency Matrix
  SpMati A;
  //reads in file and initializes bonds, Ns and Nb
  void Initialize(std::vector<int> &bonds, const std::string file);
  //adds data to dat line
  void UpdateData(std::vector<mpz_class> &dat, const int R, const int sample);
  //adds one more bond to ptr and updates rm, rm2, nclst, ncty and cities
  void addbond(const int s1, const int s2);
  void outputptr();
  int distancecount(const int R, const int sample);
  int findroot(const int i);
  //finds if site s is within distance R of the largest cluster
  bool IsConnected(const int s, const int R);
};

int Network::findroot(const int i){
  if(ptr[i]<0) return i;
  return ptr[i] = findroot(ptr[i]);
}

//finds if site s is within distance R of the largest cluster
bool Network::IsConnected(const int s, const int R){
  
  if(findroot(s)==rm) return true;
  
  int d=0;
  std::vector<int> dis(Ns,-1), v;
  v.reserve(Ns);
  v.push_back(s);
  dis[s]=0;
  
  for(unsigned int i=0; i<v.size(); i++){
    d=dis[v[i]]+1;
    //doesn't add sites that are larger than R away
    if(d>R) continue;
    else{
      //adds new sites to v if they have their distance value change
      for(SpMati::InnerIterator it(A,v[i]); it; ++it){
	if((dis[it.row()]==-1)||(dis[it.row()]>d)){
	  if(findroot(it.row())==rm) return true;
	  dis[it.row()]=d;
	  v.push_back(it.row());
	}//if
      }//SpMati
    }//else
  }//i
  return false;
}

int Network::distancecount(const int R, const int sample)
{
  if(R==0){
    return -ptr[rm];
  }
  
  std::vector<int> sites;
  sites.reserve(Ns);
  for(int i=0; i<Ns; i++){
    sites.push_back(i);
  }
  
  //permutes the first sample number of sites
  int x=0,t=0;
  for(int i=0; i<sample; i++){
    x=rand()%(sample-i)+i;
    t=sites[i];
    sites[i]=sites[x];
    sites[x]=t;
  }

  x=0;
  for(int k=0; k<sample; k++){
    if(IsConnected(sites[k],R)) x++;
    /*
      std::cout << sites[k] << " is ";      
      if(IsConnected(sites[k],R))
      {
      std::cout << "connected" << std::endl;
      x++;
      }
      else{
      std::cout << "not connected" << std::endl;
      }
    */
  }
  return x;
}

void Network::outputptr(){
  std::cout << "ptr = ";
  for(unsigned int i=0; i<ptr.size(); i++){
    std::cout << ptr[i] << " ";
  }
  std::cout << std::endl;
}

//reads in file and initializes bonds, Ns and Nb
void Network::Initialize(std::vector<int> &bonds, const std::string file){

  //rm: root of the largest cluster
  //rm2: root of the 2nd largest cluster
  //nclst: number of clusters
  rm=0;
  rm2=1;

  std::ifstream infile;
  infile.open(file.c_str());
  
  //std::cout << "opening file" << std::endl;
  
  if(infile.is_open()){
    while(infile.peek()=='%') infile.ignore(2048,'\n');
    
    //initializes arrays and constants
    //Ns: number of sites on regular lattice
    //Nb: number of bonds
    
    int t1,t2,t3;
    
    infile >> t1;
    infile >> Ns;	
    infile >> Nb;
    nclst=Ns;
    if(Ns==1) rm2=-1;
    else if(Ns==0){
      std::cout << "This is an empty graph" << std::endl;
      throw;
    }
    //std::cout << "making pointer" << std::endl;
    ptr.resize(Ns);
    for(int i=0; i<Ns; i++){
      ptr[i]=-1;
    }
    
    //std::cout << "Nb=" << Nb << std::endl;
    //std::cout << "making bonds" << std::endl;
    bonds.clear();
    bonds.resize(2*Nb);
    
    //creates adjacency matrix and bond matrix
    std::vector<Trip> tripletList;
    tripletList.reserve(2*Nb);
    
    for(int k=0; k<Nb; k++){
      infile >> t1 >> t2 >> t3;
      bonds[k]=t1-1;
      bonds[k+Nb]=t2-1;
      tripletList.push_back(Trip(t1-1,t2-1,1));
      tripletList.push_back(Trip(t2-1,t1-1,1));

    }
    infile.close();
    A.resize(Ns,Ns); 
    A.setFromTriplets(tripletList.begin(),tripletList.end());
    A.makeCompressed();
  }
  else{
    std::cout << "Could not open file: " << file << std::endl;
    throw;
  }
  return;
}

//adds data to dat line
void Network::UpdateData(std::vector<mpz_class> &dat, const int R, const int sample){
  //data contains the following in its list:
  //(0) Selected bonds
  //(1) Largest cluster
  //(2) 2nd largest cluster
  //(3) Number of clusters
  //(4) Number of sites within distance R from largest cluster
  //std::cout << "adding data for i=" << dat[0] << std::endl;
  if(ptr[rm]<0) dat[1]-=ptr[rm];
  else std::cout << "ptr[rm] >= 0 for some reason" << std::endl;
  //std::cout << "added rm" << std::endl;
  if(rm2>=0){
    if(ptr[rm2]<0) dat[2]-=ptr[rm2];
    else std::cout << "ptr[rm2] >= 0 for some reason" << std::endl;
  }
  //std::cout << "added rm2" << std::endl;
  dat[3]+=nclst;
  //std::cout << "added nclst" << std::endl;
  dat[4]+=distancecount(R,sample);
  //std::cout << "added distance count" << std::endl;
  return;
}

//adds one more bond to ptr and changes cities
void Network::addbond(const int s1, const int s2){
  int r1,r2;
  //std::cout << "adding bond" << std::endl;
  //std::cout << "finding roots" << std::endl;
  if((s1<0)||(s2<0)||(s1>=Ns)||(s2>=Ns)){
    std::cout << "s1 or s2 is out of range\n"
	      << "s1=" << s1 << " s2=" << s2 << " Ns=" << Ns << std::endl;
    throw;
  }

  r1=findroot(s1);
  r2=findroot(s2);
  
  //if s1 and s2 are already in the same cluster nothing changes
  if(r1==r2){
    //std::cout << "they are the same root" << std::endl;
    return;
  }

  bool changerm=false,changerm2=false;
  if((r1==rm)||(r2==rm)) changerm=true;
  if((r1==rm2)||(r2==rm2)) changerm2=true;
  
  //updates nclst
  nclst--;
  
  //combining two clusters together
  //keeps cluster with larger count
  if(ptr[r1]>ptr[r2]){
    ptr[r2]+=ptr[r1];
    ptr[r1] = r2;//points neighbor cluster root to new site's root
    r1=r2;
  } 
  else{
    ptr[r1]+=ptr[r2];
    ptr[r2] = r1;//points neighbor cluster root to new site's root
    r2=r1;
  }  

  //updates rm and rm2----------------------------
  
  //rm is unchanged
  if(!changerm){
    //rm2 is unchanged
    if(!changerm2){
      if(ptr[r1]<ptr[rm]){
	rm2=rm;
	rm=r1;
      }
      else if(ptr[r1]<ptr[rm2]){
	rm2=r1;
      }
    }
    //rm2 is changed
    else{
      if(ptr[r1]<ptr[rm]){
	rm2=rm;
	rm=r1;
      }
      else if(ptr[rm2]>0) rm2=r1;
    }
  }
  //rm is changed
  else{
    //rm2 is unchanged
    if(!changerm2){
      if(ptr[rm]>0) rm=r1;
    }
    //rm2 is changed
    else{
      rm=r1;
      rm2=-1;
      for(int i=0; i<Ns; i++){
	//i is a root and doesn't equal rm
	if((ptr[i]<0)&&(i!=rm)){
	  if(rm2==-1) rm2=i;
	  else if(ptr[i]<ptr[rm2]) rm2=i;
	}
      }
    }
  }


  /*
  //rm is still a valid root
  if(ptr[rm]<0){
    //rm2 is still a valid root
    if(ptr[rm2]<0){
      //cluster r1 is bigger than rm
      if(ptr[r1]<ptr[rm]){
	rm2=rm;
	rm=r1;
      }
      //cluster r1 is bigger than rm2
      else if(ptr[r1]<ptr[rm2]) rm2=r1;
    }
    //rm2 is not a valid root
    else{
      //checks if rm2 and rm were added together
      if(r1==rm){
	//rm is right need to find new rm2
	rm2=-1;
	for(int i=0; i<Ns; i++){
	  //i is a root and doesn't equal rm
	  if((ptr[i]<0)&&(i!=rm)){
	    if(rm2==-1) rm2=i;
	    else if(ptr[i]<ptr[rm2]) rm2=i;
	  }
	}
      }
      //checks if r1 cluster is bigger than rm
      else if(ptr[r1]<ptr[rm]){
	rm2=rm;
	rm=r1;
      }
      else rm2=r1;
    }
  }
  //rm is not a valid root
  else{
    //rm2 is still a valid root
    if(ptr[rm2]<0){ 
      //checks if rm and rm2 become connected
      if(r1==rm2){
	rm=r1;
	//rm is right need to find new rm2
	rm2=-1;
	for(int i=0; i<Ns; i++){
	  //i is a root and doesn't equal rm
	  if((ptr[i]<0)&&(i!=rm)){
	    if(rm2==-1) rm2=i;
	    else if(ptr[i]<ptr[rm2]) rm2=i;
	  }
	}
      }
      else rm=r1;
    }
    //rm2 must be a valid root since rm is already not valid
  }
  */
    
  /*
  if((rm>=0)||(rm2>=0)){    
    for(int i=0; i<Ns; i++){
      if(ptr[i]<0){
	if(ptr[i]<ptr[rm]){
	  rm2=rm;
	  rm=i;
	}
	if((i!=rm)&&(ptr[i]<ptr[rm2])) rm2=i;
      }
    }
  }
  else{
    if(ptr[r1]<ptr[rm]){
      rm2=rm;
      rm=r1;
    }
    else if(ptr[r1]<ptr[rm2]) rm2=r1;
    }
  */
  return;
}

//returns a vector with the distance of each site within dmax is given
std::vector<int> Neigborhood(const SpMati &A, const int s, const int R, const int rmin, std::vector<int> &list){
  list.resize(0);
  int d=0,dmax=2*R+rmin+1;
  //All sites listed in vector dis[i] is a distance i away from s
  std::vector<int> v;//sites to look at
  v.push_back(s);

  //contains distance of each site from s (or -1)
  std::vector<int> dis;
  dis.resize(A.cols(),-1);
  dis[s]=0;
  
  for(unsigned int i=0; i<v.size(); i++){
    d=dis[v[i]]+1;
    //doesn't add sites that are larger than dmax away
    if(d>dmax) continue;
    //checks if site v[i] is less than R distance away from s
    if(d<=R+1) list.push_back(v[i]);
    //adds new sites to v if they have their distance value change
    for(SpMati::InnerIterator it(A,v[i]); it; ++it){
      if((dis[it.row()]==-1)||(dis[it.row()]>d)){
	dis[it.row()]=d;
	v.push_back(it.row());
      }
    }
  }
  return dis;
}

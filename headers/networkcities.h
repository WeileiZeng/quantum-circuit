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
  //cities: containes 0 all sites except roots that contains the number of cities in cluster
  std::vector<int> ptr,cities;
  //rm: root of the largest cluster
  //rm2: root of the 2nd largest cluster
  //nclst: number of clusters
  int rm,rm2,nclst,ncty;
  //Ns: number of sites
  //Nb: number of bonds (not including bonds to city center
  int Ns, Nb;
  //A: Adjacency Matrix
  SpMati A;
  //reads in file and initializes bonds, Ns and Nb
  void Initialize(std::vector<int> &bonds, const std::string file);
  //inializes ptr to set up city center positions, cities, rm, rm2, nclst, ncty, and outputs number of cities
  int make_city(const std::vector<int> &bonds, const int R, const int rmin);
  //adds data to dat line
  void UpdateData(std::vector<mpz_class> &dat);
  //adds one more bond to ptr and updates rm, rm2, nclst, ncty and cities
  void addbond(const int s1, const int s2);
  void addbond_cities(const int s1, const int s2);
  void outputptr();
  int distancecount(const int R, const int sample);
  int findroot(const int i);
};

int Network::findroot(const int i)
{
  if (ptr[i]<0) return i;
  return ptr[i] = findroot(ptr[i]);
}


int Network::distancecount(const int R, const int sample)
{
  if(R==0){
    return -ptr[rm];
  }
  
  int d=0,s=0,count=0;
  std::vector<int> dis, v;
  bool exit=false;
  
  for(int k=0; k<sample; k++){
    s=rand()%Ns;
  
    if(findroot(s)==rm){
      count++;
      continue;
    }
    v.clear();
    v.push_back(s);

    dis.resize(A.cols(),-1);
    dis[s]=0;
  
    exit=false;
    for(unsigned int i=0; i<v.size(); i++){
      d=dis[v[i]]+1;
      //doesn't add sites that are larger than dmax away
      if(d>R) continue;
      else{
	//adds new sites to v if they have their distance value change
	for(SpMati::InnerIterator it(A,v[i]); it; ++it){
	  if((dis[it.row()]==-1)||(dis[it.row()]>d)){
	    if(findroot(it.row())==rm){
	      count++;
	      exit=true;
	      break;
	    }//if
	    dis[it.row()]=d;
	    v.push_back(it.row());
	  }//if
	}//SpMati
	if(exit) break;
      }//else
    }//i
  }//k
  
  return count;
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
  rm2=0;
  ncty=0;
  
  ptr.resize(Ns);
  cities.resize(Ns);
  for(int i=0; i<Ns; i++){
    ptr[i]=-1;
    cities[i]=0;
  }
  

  std::ifstream infile;
  infile.open(file.c_str());
  
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
    
    //std::cout << "Nb=" << Nb << std::endl;

    bonds.clear();
    bonds.resize(2*Nb,-1);
    
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
    A.setFromTriplets(tripletList.begin(),tripletList.end());
    A.makeCompressed();


  }
  else{
    std::cout << "Could not open file: " << file << std::endl;
    throw;
  }
}

//inializes ptr to set up city center positions, cities, rm, rm2, nclst, and outputs number of cities
int Network::make_city(const std::vector<int> &bonds, const int R, const int rmin){
  //creates adjacency matrix
  /*
    std::vector<Trip> tripletList;
  tripletList.reserve(2*Nb);
  for(int l=0; l<Nb; l++){
    //std::cout << "l=" << l << std::endl;
    tripletList.push_back(Trip(bonds[l],bonds[l+Nb],1));
    tripletList.push_back(Trip(bonds[l+Nb],bonds[l],1));
  }
  SpMati A(Ns,Ns);
  A.setFromTriplets(tripletList.begin(),tripletList.end());
  A.makeCompressed();
  */
  //std::cout << "made A" << std::endl;
  
  //location of all possible cities (non valid cities moved to end)
  std::vector<int> vcity(Ns);
  //ncut: first site that can't be chosen as a city
  //ncity: city to be added
  int ncut=Ns,ncity;
  nclst=Ns;
  rm=0;
  rm2=0;
  ncty=0;

  //std::cout << "inial vcity" << std::endl;
  //initializes vcity to contain all possible site labels
  for(int i=0; i<Ns; i++){
    vcity[i]=i;
  }

  //initializes ptr so that each site contains 1 site (itself) (-1)
  ptr.resize(Ns);
  cities.resize(Ns);
  for(int i=0; i<Ns; i++){
    ptr[i]=-1;
    cities[i]=0;
  }
  
  //dis: contains list of all distances from ncity (or -1)
  //Rlist: list of sites within R;
  std::vector<int> Rlist, dis;
  
  //loops until no more cities can be chosen
  while(ncut>0){
    //std::cout << "ncty=" << ncty << std::endl;
    ncty++;
    //resets ands picks new random city location
    ncity=vcity[rand()%ncut];
    cities[ncity]=1;
    //sets new city as root containing 1 city (itself)
    //ptr0[ncity]=-2;
 
    //finds distance from site ncity and finds sites within R and changes Rlist
    dis=Neigborhood(A,ncity,R,rmin,Rlist);
    
    //points sites to ncity
    for(unsigned int i=1; i<Rlist.size(); i++){
      nclst--;
      ptr[Rlist[i]]=ncity;
      ptr[ncity]=ptr[ncity]-1;
    }
    
    if(ptr[ncity]<ptr[rm]){
      rm2=rm;
      rm=ncity;
    }
    else if(ptr[ncity]<ptr[rm2]) rm2=ncity;
    
    //moves sites in vcity to the end and updates ncut
    for(int i=0; i<ncut; i++){
      if(dis[vcity[i]]>=0){
	ncut--;
	swap(vcity[ncut],vcity[i]);

	/*
	temp=vcity[ncut];
	vcity[ncut]=vcity[i];
	vcity[i]=temp;
	*/
	i--;
      }
    }
  }
  return ncty;
}

//adds data to dat line
void Network::UpdateData(std::vector<mpz_class> &dat){
  //data contains the following in its list:
  //(0) Selected bonds
  //(1) Largest cluster
  //(2) 2nd largest cluster
  //(3) Number of clusters
  //(4) Number of clusters with cities

  if(ptr[rm]<0) dat[1]-=ptr[rm];
  else std::cout << "rm > 0 for some reason" << std::endl;
  if(ptr[rm2]<0) dat[2]-=ptr[rm2];
  dat[3]+=nclst;
  //dat[4]+=ncty;
  return;
}

//adds one more bond to ptr and changes cities
void Network::addbond(const int s1, const int s2){
  int r1,r2;
  //std::cout << "adding bond" << std::endl;
  r1=findroot(s1);
  r2=findroot(s2);
  
  //if s1 and s2 are already in the same cluster nothing changes
  if(r1==r2) return;

  //updates nclst
  nclst--;
  //updates city count
  if((cities[r1]>0)&&(cities[r2]>0)) ncty--;

  //combining two clusters together
  //keeps cluster with larger count
  if(ptr[r1]>ptr[r2]){
    ptr[r2]+=ptr[r1];
    cities[r2] += cities[r1];
    ptr[r1] = r2;//points neighbor cluster root to new site's root
    cities[r1]=0;
    r1=r2;
  } 
  else{
    ptr[r1]+=ptr[r2];
    cities[r1] += cities[r2];
    ptr[r2] = r1;//points neighbor cluster root to new site's root
    cities[r2]=0;
  }
  
  //if rm or rm2 are no longer roots then a new rm or rm2 needs to be found
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
  
  return;
}



//adds one more bond to ptr and changes cities
void Network::addbond_cities(const int s1, const int s2){
  int r1,r2;
  //std::cout << "adding bond" << std::endl;
  r1=findroot(s1);
  r2=findroot(s2);
  
  //if s1 and s2 are already in the same cluster nothing changes
  if(r1==r2) return;

  //updates nclst
  nclst--;
  //updates city count
  if((cities[r1]>0)&&(cities[r2]>0)) ncty--;

  //combining two clusters together
  //keeps cluster with larger count
  if(ptr[r1]>ptr[r2]){
    ptr[r2]+=ptr[r1];
    cities[r2] += cities[r1];
    ptr[r1] = r2;//points neighbor cluster root to new site's root
    cities[r1]=0;
    r1=r2;
  } 
  else{
    ptr[r1]+=ptr[r2];
    cities[r1] += cities[r2];
    ptr[r2] = r1;//points neighbor cluster root to new site's root
    cities[r2]=0;
  }
  
  //if rm or rm2 are no longer roots then a new rm or rm2 needs to be found
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

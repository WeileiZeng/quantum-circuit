#include <itpp/itcomm.h>
#include <Eigen/Sparse>
//#include <Eigen/KroneckerProduct>

#include <stdio.h>
//#include <fstream>
#include <vector>
#include <list>
#include <iostream>
#include <climits>
//#include <cstdlib>
//#include <algorithm>
//#include <string>
//#include <time.h>
//#include <gmp.h>

#include "network.h"

typedef std::vector< std::vector<int> > varray;
typedef Eigen::SparseMatrix<int> SpMati;
typedef std::vector<short>::iterator itr;
//typedef unsigned long int bigi;
typedef long long int bigi;
typedef Eigen::Triplet<int> Trip;
//typedef mpz_t bigi;
//typedef std::list< std::vector<bigi> > larray;
//typedef larray::iterator itar;

//creates incidence matrix for a torrus with lengths L
SpMati Torrus(const int L, const bool dual){
  int r,c;
  std::vector<Trip> triplets;
  triplets.reserve(2*2*L*L);
  if(!dual){
      for(int i=0; i<L; i++){
    	  //Kronecker Product
    	  //(AxB)[p*r+v][q*s+w]=a[r][s]b[v][w]
    	  //a is mxn b is pxq
    	  //A[L*r+j][L*c+j]=R[r][c]I[j][j]
    	  //A[L*j+r][L*j+c+L^2]=I[j][j]RT[r][c]
    	  for(int j=0; j<L; j++){
    	      //Diagonal values of R      
    	      r=i;
    	      c=i;
    	      triplets.push_back(Trip(L*r+j,L*c+j,1));
    	      triplets.push_back(Trip(L*j+r,L*j+c+L*L,1));

    	      //Off Diagonal values of R
    	      r=(i+1)%L;
    	      c=i;
    	      triplets.push_back(Trip(L*j+r,L*j+c,1));
    	      triplets.push_back(Trip(L*c+j,L*r+j+L*L,1));
    	  }
      }
  }
  else{
      for(int i=0; i<L; i++){
    	  //Kronecker Product
    	  //(AxB)[p*r+v][q*s+w]=a[r][s]b[v][w]
    	  //a is mxn b is pxq
    	  //A[L*r+j][L*c+j]=R[r][c]I[j][j]
    	  //A[L*j+r][L*j+c+L^2]=I[j][j]RT[r][c]
    	  for(int j=0; j<L; j++){
    	      //Diagonal values of R      
    	      r=i;
    	      c=i;
    	      triplets.push_back(Trip(L*r+j,L*c+j+L*L,1));
    	      triplets.push_back(Trip(L*j+r,L*j+c,1));

    	      //Off Diagonal values of R
    	      r=i;
    	      c=(i+1)%L;
    	      triplets.push_back(Trip(L*j+r,L*j+c+L*L,1));
    	      triplets.push_back(Trip(L*c+j,L*r+j,1));
    	  }
      }
 
  }
  SpMati A(L*L,2*L*L);
  A.setFromTriplets(triplets.begin(),triplets.end());
  A.makeCompressed();
  return A;
}

void swap(varray &a, const int p1, const int p2)
{
  std::vector<int> hold;
  hold=a[p1];
  a[p1]=a[p2];
  a[p2]=hold;
}


//gives the index of the first bond connected from the bottom (top if top is true)
int lastindexA(const SpMati &A, bigi c0, int nv)
{
  //cout << nv << endl;
  //loops over non zero values of col c0 or R
  bigi index=-1,index2=-1;
  for(SpMati::InnerIterator it(A,c0); it; ++it)
    {
      index=it.row();
      if(A.col(index).nonZeros()<nv) index2=index;
    }
  //cout << "lastindex=" << index << endl;
  return index2;
}

//adds a new bond with vert c1 and c2
bool newbondA(bigi c1, //first bond
	      bigi c2, //2nd bond
	      SpMati &A, //Adjacency matrix
	      std::vector<short> &dlist, //list of distances
	      bigi size,//size of A
	      bigi &cnew)
{
  //cout << "c1=" << c1 << ", c2=" << c2 << endl;
  if((size<=c1)||(size<=c2)||(c1==c2)) 
    {
      std::cerr << "BROKE in newbondA:" << "\n"
		<< "c1 = " << c1 << "\n"
		<< "c2 = " << c2 << "\n" 
		<< "size = " << size << std::endl;
      
      throw 2;
      return false;
    }
  A.insert(c1,c2)=1;
  A.insert(c2,c1)=1;
  if((c1==cnew)||(c2==cnew)) 
    {
      dlist.push_back(-1);
      cnew++;
    }
  //dlist.push_back(-1);
  //cout << dlist.size() << endl;
  return true;
}

//changes the distance of site s
//takes in s=site index, dis=list of distances, R=bond matrix
void distanceA(bigi s, std::vector<short> &dis, const SpMati &A)
{
  if(dis[s]<0)
    {
      dis[s]=-2;
      int min=-2,temp;
      std::list<int> bonds;
      //loops over bonds connected to s
      for(SpMati::InnerIterator it(A,s); it; ++it)
	{
	  //finds index of bonded site
	  if(dis[it.row()]!=-2)
	    {
	      bonds.push_back(it.row());
	      distanceA(it.row(), dis, A);
	      temp=dis[it.row()];
	      if(temp>=0)
		{
		  if(temp<min) min=temp;
		  else if(min<0) min=temp;
		}
	    }
	}
      dis[s]=min+1;

      //checks to make sure neighbors make sense
      if(dis[s]>0)
	{
	  for(std::list<int>::iterator i=bonds.begin(); i!=bonds.end(); ++i)
	    {
	      if(abs(dis[*i]-dis[s])>1)
		{
		  dis[*i]=-1;
		  distanceA(*i,dis,A);
		}
	    }
	}
    }
}

//finds the size of a (nv,ne) lattice that is closed 
//and has radius d with vertex centered
bigi number_dis(int nv, int ne, int d, bool face=false)
{
  if((nv==3)&&(ne==3)) throw "ne and nv cannot both be 3";
  if((nv<3)||(ne<3)) throw "neither ne or nv can ne less than 3";
  int dm=floor(ne/2);

  if(d<dm)
    {
      if(face) return ne;
      else return 1;
    }
  bigi sum=0;
  int odd=ne%2, L, r=1;
  if(odd) L=2*dm;
  else if(face) L=2*dm-1;
  else L=dm;
  //Matrix<int,L,1> a0,a1;
  //Matrix<int,L,L> A;
  Eigen::VectorXi a0(L),a1(L);
  Eigen::MatrixXi A(L,L);
  a0.setZero();
  a1.setZero();
  A.setZero();
  
  //Make A
  A.row(0)=Eigen::VectorXi::Constant(L,nv-2);
  for(int c=0; c<L-1; c++)
    {
      A(c+1,c)=1;
    }
  
  if(odd)
    {
      A(0,dm-1)=nv-4;
      A(0,L-1)=-1;
    }
  else if(face)
    {
      A(dm,dm-1)=0;
      A(0,dm-1)=-1;
      A(0,L-1)=nv-3;
      A(dm,L-1)=1;
    }
  else A(0,L-1)=-1;
  
  if(face) 
    {
      a0(0)=ne*(nv-3);
      a0(dm)=ne;
      sum=ne*(nv-1);
    }
  else 
    {
      a0(0)=nv;
      sum=1+nv;
    }
  if(sum<0)
    {
      std::cerr << "cols too big" << std::endl;
      throw 1;
    }
  //cout << "A=\n" << A << "\n";
  //<< "a0=" << a0 << "\n"
  //   << "A*a0=" << A*a0 << endl;
  
  while(r<d-dm+1)
    {
      a1=A*a0;
      //Sums over a1
      for(int i=0; i<L-1; i++)
	{
	  sum+=a1(i);
	}
      if((face)&&(!odd)) 
	{
	  sum+=a1(L-1)-a1(dm-1);
	}
      a0=a1;
      r++;
      if(sum<0)
	{
	  std::cerr << "cols too big" << std::endl;
	  throw 1;
	}

      /*
      std::cout << "r=" << r << "\n"
		<< "sum=" << sum << "\n"
		<< "a1=" << a1 << std::endl;
      */
      //std::cout << "sum = " << sum << std::endl;
    }
  //cout << "break" << endl;
  //std::cout << sum << std::endl;
  A.row(0).setZero();
  if(odd) A(dm,dm-1)=0;
  else if(face) 
    {
      a1=A*a0;
      //Sums over a1
      for(int i=0; i<dm-1; i++)
	{
	  sum+=2*a1(i);
	  if(sum<0)
	    {
	      std::cerr << "cols too big" << std::endl;
	      throw 1;
	    }
	}
      sum+=a1(dm-1);
      for(int i=dm+1; i<L; i++)
	{
	  sum+=2*a1(i);
	  if(sum<0)
	    {
	      std::cerr << "cols too big" << std::endl;
	      throw 1;
	    }
	}
      a0=a1;
      r++;
      A(dm,L-1)=0;
    }
  /*
    std::cout << "r=" << r << "\n"
    << "sum=" << sum << "\n"
    << "a1=" << a1 << std::endl;
  */
  //std::cout << "sum = " << sum << std::endl;
  while(r<d)
    {
      a1=A*a0;
      if(odd)
	{
	  for(int i=0; i<L-1; i++)
	    {
	      sum+=2*a1(i);
	      if(sum<0)
		{
		  std::cerr << "cols too big" << std::endl;
		  throw 1;
		}
	    }
	  /*
	  for(int i=0; i<dm; i++)
	    {
	      sum+=2*a1(i);
	    }
	  for(int i=dm+1; i<L-1; i++)
	    {
	      sum+=2*a1(i);
	    }
	  */
	  sum+=a1(L-1);
	  if(sum<0)
	    {
	      std::cerr << "cols too big" << std::endl;
	      throw 1;
	    }
	}
      else if(face)
	{
	  for(int i=0; i<dm-1; i++)
	    {
	      sum+=2*a1(i);
	    }
	  sum+=a1(dm-1);
	  for(int i=dm+1; i<L; i++)
	    {
	      sum+=2*a1(i);
	      if(sum<0)
		{
		  std::cerr << "cols too big" << std::endl;
		  throw 1;
		}
	    }
	}
      else
	{
	  for(int i=0; i<L-1; i++)
	    {
	      sum+=2*a1(i);
	      if(sum<0)
		{
		  std::cerr << "cols too big" << std::endl;
		  throw 1;
		}
	    }
	  sum+=a1(L-1);
	  if(sum<0)
	    {
	      std::cerr << "cols too big" << std::endl;
	      throw 1;
	    }
	}
      a0=a1;
      r++;
      /*
      std::cout << "r=" << r << "\n"
		<< "sum=" << sum << "\n"
		<< "a1=" << a1 << std::endl;
      */
      //std::cout << "sum = " << sum << std::endl;
    }
  return sum;
}

bigi indexcomplete(bigi c0, bigi index, int nv, int ne, const SpMati &A, int &count)
{
  //cout << "c0=" << c0 << ", index=" << index << endl;
  if(ne-2==0) return 0;
  bigi temp=0,max=c0;
  int ct=0;
  
  for(SpMati::InnerIterator it(A,c0); it; ++it)
    {
      if((it.row()!=index)&&(A.col(it.row()).nonZeros()<nv))
	{
	  max=it.row();
	  break;
	}
    }
  
  if(max==c0)
    {
      for(SpMati::InnerIterator it(A,c0); it; ++it)
	{
	  if((it.row()>max)&&(it.row()!=index))
	    {
	      if(A.col(it.row()).nonZeros()<nv) max=it.row();
	      else
		{
		  ct=0;
		  temp=indexcomplete(it.row(),index,nv,ne-1,A,ct);
		  if(max<temp) 
		    {
		      max=temp;
		      count=ct;
		    }
		}
	    }
	}
    }
  count++;
  return max;
}

//nq=nv=degree of each node; np==ne=number of edges for each face
SpMati Lattice_dis(const int d, const int ne, const int nv, bool face, bool diag=false)
{ 
  int dmin=floor(ne/2);
  //cout << "dmin = " << dmin << endl;
  /*
  if(d<dmin)
    {
      SpMati A(1,1);
      return A;
    }
  */
  bigi i=0, //loop index
    cnew=1, //row and col indecies that are empty
    c0=0,//col that is being completed to 5 bonds
    index=0,//place holder to update A
    index2=0,
    newb=0;
  //bigi inner;
  int nz0,count; //number of non zero elements in col c0
  
  //max number of rows and cols needed for vert centered
  //vector<long int> sizes=numbersites(nv,ne,d);
  //std::cout << "estimating cols" << std::endl;
  bigi cols=number_dis(nv,ne,d,face);
  if(cols<0)
    {
      std::cerr << "cols size is larger than int capacity" << std::endl;
      throw 1;
    }
  //std::cout << "cols = " << cols << std::endl;
  //std::cout << "d=" << d << ", cols=" << cols << std::endl;
  /*
  VectorXi valloc(cols);  
  for(int j=0; j<inner; j++)
    {
      valloc[j]=nv;
    }
  for(int j=inner; j<cols; j++)
    {
      valloc[j]=3;
    }
  */
  //std::cout << "Allocating Space" << std::endl;
  //SpMati A = *(new SpMati(cols,cols));
  SpMati A;
  //A.reserve(valloc);
  try
    {
      //std::cout << cols << std::endl;
      A.resize(cols,cols);
      A.reserve(Eigen::VectorXi::Constant(cols,nv));
    }
  catch(std::bad_alloc& ba)
    {
      std::cout << "cols estimate = " << cols << "\n"
		<< "bytes reserved = " << nv*cols*sizeof(int) << std::endl;
      std::cerr << ba.what() << std::endl;
      throw ba;
    }
  //std::cout << "Space Allocated" << std::endl;

  //std::cout << "cols = " << cols << std::endl;
  std::vector<short> dlist; //list of all the distance bonds
  dlist.reserve(cols);
  itr it;
    
  //A.reserve(5*cols);
  //creates starting pentagon
  //std::cout << "Creating First Pentagon" << std::endl;
  dlist.push_back(0);
  newb++;
  if(cols>1)
    {
      for(int j=0; j<ne-1; j++)
	{
	  newbondA(j,cnew,A,dlist,cols,cnew);
	}
      newbondA(cnew-1,0,A,dlist,cols,cnew);
    }
  else
    {
      
      A.prune(1,1);
      A.makeCompressed();
      return A;
    }
  //loops until the correct distance is reached
  //int count=0;
  //cout << "starting loop" << endl;
  //while(notbrk)
  
  //sets up initial distance of vert
  if(face)
    {
      for(int j=1; j<ne; j++) 
	{
	  dlist[j]=0;
	  newb++;
	}
    }
  
  /*
  cout << "dlist[0,ne-1] = ";
  for(int j=0; (j<ne)&&(j<cols); j++)
    {
      cout << dlist[j] << " ";
    }
  cout << endl;
  */
  
  while((cnew<cols)&&(c0<cnew))
    {
      //if(cnew%10000==0) cout << "cnew=" << cnew << endl;
      
      //cout << "cnew: " << cnew << " c0: " << c0 << endl;
      //count++;
      //cout << count << endl;
      
      for(i=newb;i<cnew;++i) 
	{
	  if(dlist[i]<0) distanceA(i,dlist,A);
	  //if(dlist[i]<=d) notbrk=true;
	}
      newb=cnew;
      /*
      cout << "dlist = ";
      for(vector<short>::iterator it=dlist.begin(); it!=dlist.end(); it++)
	{
	  cout << *it << " ";
	}
      cout << endl;
      */
      nz0=A.col(c0).nonZeros();
      //cout << "nz0=" << nz0 << endl;
      if(dlist[c0]<d-(dmin-1))
	{
	  if(nz0<nv)
	    {
	      //cout << "nz0<nv-1" << endl;
	      index=lastindexA(A,c0,nv);
	      //puts a one under location of most bottom bond
	      //if(A.col(index).nonZeros()<nv)
	      if(index>0)
		{
		  if(!newbondA(index,cnew,A,dlist,cols,cnew)) break;
		  
		  //adds next inbetween bonds bonds
		  for(i=0;i<ne-3;i++)
		    {
		      if(!newbondA(cnew-1,cnew,A,dlist,cols,cnew)) break;
		    }
		  
		  //adds last bond
		  if(!newbondA(cnew-1,c0,A,dlist,cols,cnew)) break;
		}
	      else c0++;
	    }
	  
	  if(nz0>=nv-1)
	    {
	      //cout << "nz0==nv" << endl;
	      index=lastindexA(A,c0,nv);
	      //index=indexcomplete(c0,c0,nv,ne,A,count)
	      //if(A.col(index).nonZeros()<nv)
	      //{
	      if(index>0)
		{
		  count=0;
		  index2=indexcomplete(c0,index,nv,ne,A,count);
		  //cout << "index=" << index 
		  //     << ", index2=" << index2 
		  //     << ", count=" << count << endl;
		  if((index2!=c0)&&(count+1<ne))
		    {
		      if(count+1==ne-1)
			{
			  if(!newbondA(index2,index,A,dlist,cols,cnew)) break;
			  c0++;
			  continue;
			}
		      if(!newbondA(index2,cnew,A,dlist,cols,cnew)) break;
		      
		      //adds next bond
		      for(int j=0;j<ne-count-3;j++)
			{
			  if(!newbondA(cnew-1,cnew,A,dlist,cols,cnew)) break;
			}
		      
		      if(!newbondA(cnew-1,index,A,dlist,cols,cnew)) break;
		    }
		}
	      c0++;
	    }
	}
      else if(nz0==nv)
	{
	  //cout << "nz0==nv" << endl;
	  index=lastindexA(A,c0,nv);
	  //index=indexcomplete(c0,c0,nv,ne,A,count)
	  if(index>0)
	    {
	      count=0;
	      index2=indexcomplete(c0,index,nv,ne,A,count);
	      //cout << "index=" << index << ", index2=" << index2 << endl;
	      if((index2!=c0)&&(count+1<ne))
		{
		  //cout << "count=" << count << endl;
		  if(dlist[index2]>dlist[index]) std::swap(index2,index);
		  
		  if(dlist[index]<=d-(ne-count-dlist[index]+dlist[index2]-1)/2)
		    {
		      if(count+1==ne-1)
			{
			  if(!newbondA(index2,index,A,dlist,cols,cnew)) break;
			  c0++;
			  continue;
			}
		      
		      if(!newbondA(index2,cnew,A,dlist,cols,cnew)) break;
		      
		      //adds next bond
		      for(int j=0;j<ne-count-3;j++)
			{
			  if(!newbondA(cnew-1,cnew,A,dlist,cols,cnew)) break;
			}
		      
		      if(!newbondA(cnew-1,index,A,dlist,cols,cnew)) break;
		    }
		}
	    } 
	  c0++;
	}
      else c0++;
    }
  //cout << "End cnew=" << cnew << endl;
  /*
  for(i=newb;i<cnew;++i) 
    {
      if(dlist[i]<0) distanceA(i,dlist,A);
    }
  */
  //Finds A---------------------------------------------------------------
  //cout << "Cutting A" << endl;
  //cout << "cnew=" << cnew << endl;

  /*
  cout << "dlist = ";
  for(vector<short>::iterator it=dlist.begin(); it!=dlist.end(); it++)
    {
      cout << *it << " ";
    }
  cout << endl;
  */

  /*
  std::cout << "face = " << face << " "
	    << "cols = " << cols << " "
	    << "cnew = " << cnew << std::endl;
  */
  if(cnew==cols)
    {
      A.prune(1,1);
      //cout << "pruned" << endl;
      A.makeCompressed();
      //cout << "Compressed" << endl;
      //return A;
    }
  else
    {
      A=A.topLeftCorner(cnew,cnew);
      //cout << "Made B" << endl;
      A.prune(1,1);
      //cout << "pruned" << endl;
      A.makeCompressed();
      
      /*
      SpMati B=A.topLeftCorner(cnew,cnew);
      //cout << "Made B" << endl;
      B.prune(1,1);
      //cout << "pruned" << endl;
      B.makeCompressed();
      //cout << "Compressed" << endl;
      //cout << A << endl;
      return B;
      */
    }
  //std::cout << "outputting A" << std::endl;
  if(!diag) return A;
  else
    {
      Eigen::VectorXi d=A*Eigen::VectorXi::Constant(cnew,1);

      SpMati D(cnew,cnew);
      D.reserve(Eigen::VectorXi::Constant(cnew,1));

      for(int i=0; i<cnew; i++)
	{
	  D.insert(i,i)=d(i);
	}
      D.makeCompressed();
      return D-A;
    }
}

//creates a random lattice by creating an (n,m) lattice with radius R and then deleting bonds from each site with probability p and then deletes isolated vertecies
//n=edge count; m=degree
SpMati Random_Lattice(const int n, const int m, const int R, const double p)
{
  srand(time(NULL));
  
  SpMati A=Lattice_dis(R,n,m,false);
  //std::cout << "A=\n" << A << std::endl;
  //N=Number of sites, Nb=Number of bonds, Np=Number of bonds to pick
  int N=A.cols(), Nb=A.nonZeros()/2, Np=Nb*p;
  typedef Eigen::Triplet<int> T;
  std::vector<T> triplets;
  triplets.reserve(Nb);
  //std::cout << A << std::endl;
  
  //std::cout << "creating bonds" << std::endl;
  //creates a bond array
  int r1=0,r2=0,i=0,j=0,k=0;
  bool swapped=false;

  std::vector<int> bonds(2*Nb);
  for(k=0; k<A.outerSize(); k++){
    for(SpMati::InnerIterator it(A,k); it; ++it){
      if(it.col()>it.row()){
	bonds[i]=it.col();
	bonds[i+Nb]=it.row();
	i++;
      }
    }
  }
  
  /*
  std::cout << "bonds = \n";
  for(k=0; k<Nb; k++){
    std::cout << "(" << bonds[k] << "," << bonds[k+Nb] << ")\n";
  }
  std::cout << std::endl;
  */
  
  //std::cout << "permutes the bond" << std::endl;
  //permutes the bond array
  permutation(bonds,Nb);
  
  /*
  std::cout << "bonds = \n";
  for(i=0; i<Nb; i++){
    std::cout << "(" << bonds[i] << "," << bonds[i+Nb] << ")\n";
  }
  std::cout << std::endl;
  */
  
  //walk goes from site r1 or r2  
  //std::cout << "swapping bond" << std::endl;
  //loops until it finds a bond to swap into the right place
  for(i=1; i<Np; i++){
    //std::cout << "i=" << i << std::endl;
    swapped=false;
    //loops over each previous bond chosen to finds connected bonds
    for(j=0; j<i; j++){
      //std::cout << "j=" << j << std::endl;
      r1=bonds[i-1-j];
      r2=bonds[i-1-j+Nb];
      //std::cout << "(" << r1 << "," << r2 << ")" << std::endl;
      //loops over nonchosen bonds until a connecting bond is found
      for(k=i; k<Nb; k++){
	//std::cout << "k=" << k << std::endl;
	if((bonds[k]==r2)||(bonds[k+Nb]==r2)||(bonds[k]==r1)||(bonds[k+Nb]==r1)){
	  swapped=true;
	  break;
	}//if
      }//l3
      if(swapped){
	swap(bonds,i,k);
	swap(bonds,i+Nb,k+Nb);
	//bonds[i].swap(bonds[k]);
	//bonds[i+Nb].swap(bonds[k+Nb]);
	//std::cout << "(" << r1 << "," << r2 << ")" << std::endl;
	break;
      }//if
    }//l2
    if(!swapped) std::cout << "Wierd, Nothing could be swapped." << std::endl;
  }//l1
  //std::cout << std::endl;
  //std::cout << "making triplets" << std::endl;
  //loops over all of A and keeps sites until all sites are created
  
  //std::cout << "(bonds[i][0],bonds[i][1])" << std::endl;
  for(i=0; i<Np; i++){
    //std::cout << "(" << bonds[i][0] << "," << bonds[i][1] << ")" << std::endl;
    triplets.push_back(T(bonds[i],bonds[i+Nb],1));
    triplets.push_back(T(bonds[i+Nb],bonds[i],1));
  }
  //std::cout << std::endl;
  //SpMati B(N,N);
  A.setZero();
  A.setFromTriplets(triplets.begin(),triplets.end());
  //std::cout << A << std::endl;
  //B.prune();
  //Eigen::VectorXi pv(N);
  
  Eigen::PermutationMatrix<-1,-1> P(N);
  P.setIdentity();
  
  //int c=0; //count of deleted rows/cols
  //deleting empty rows
  i=N;
  j=N;
  //i=index of first zero col
  //j=index of col to check
  //std::cout << "Before:\n" << A << std::endl;
  //std::cout << "N = " << N << std::endl;

  //finds first zero col
  for(k=0;k<N;k++){
    if(A.col(k).nonZeros()==0){
      i=k;
      break;
    }
  }
  
  for(j=i+1; j<N; j++){
    if(A.col(j).nonZeros()!=0){
      //std::cout << i << " " << j << std::endl;
      P.applyTranspositionOnTheRight(i,j);
      //swap(P.indices(),i,j);
      i++;
    }
  }
  //std::cout << "N=" << N << ", i=" << i << std::endl;
  //std::cout << "end of loop" << std::endl;
  //Eigen::PermutationMatrix<-1,-1> P(pv);

  //std::cout << "twisted" << std::endl;
  A=A.twistedBy(P.transpose());
  //std::cout << "A twisted =\n" << A << std::endl;
  //std::cout << P.indices() << std::endl;
  //B=P*B;

  //std::cout << "resize" << std::endl;
  A=A.topLeftCorner(i,i);
  //A.conservativeResize(N-c,N-c);
  
  A.makeCompressed();
  //std::cout << "After:\n" << A << std::endl;
  //std::cout << "B final=\n" << B << std::endl;
  
  return A;
}



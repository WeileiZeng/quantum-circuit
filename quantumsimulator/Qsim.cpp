#include <iostream>
#include <fstream>
#include <regex>

#include <itpp/itcomm.h>
#include <Eigen/Sparse>
#include <Eigen/Core>

#include "../headers/errorqc.h"

typedef Eigen::SparseMatrix<int> SpMati;

int main(int argc, char **argv){
    
    itpp::Parser p;
    p.init(argc,argv);
    p.set_silentmode(true);

    std::string file;
    //file="zz.qc";
    //file="conv4v1.qc";
    //file="quantum_circuit/conv6v2.qc";
    file="quantum_circuit/conv9v2.qc";
    //file="quantum_circuit/conv1v2.qc";
    //file="quantum_circuit/conv1v2v3.qc";
    //file="quantum_circuit/xx2.qc";
    p.get(file,"file");
    std::cout<<"file = "<<file<<"\n";
    srand(time(NULL));

    double prob=0;
    p.get(prob,"prob");
    
    Qcode test;
    //std::cout << "Import" << std::endl;
    test.ImportCode(file);
    //test.ev[3]=1;
    int i=0;
    p.get(i,"i");
    test.ev[i]=1;
    //check 1 w W; test.ev[1]=1; test.ev[2]=1; test.ev[300]=1; test.ev[302]=1;
    //check W w 1
    //    test.ev[1]=1;
    //test.ev[0]=1;
    //test.ev[300]=1;
    //test.ev[302]=1;
       
    //    test.ev[201]=1; //ancilla qubits
    //    test.ev[301]=1;
    
    //std::cout << "Run" << std::endl;
    for ( int i1=0; i1<1;i1++){
      test.Run(prob,false);
      std::cout << "ev = " ;
      int length=test.ev.size()/2;
      for(size_t i=0;i<test.ev.size()/2;i++){
	std::cout << test.ev[i] << " ";
      }
      std::cout<<std::endl<<" | ";
      
      for(size_t i=test.ev.size()/2;i<test.ev.size();i++){
	std::cout << test.ev[i] << " ";
      }
      std::cout<< "\n"<< "s  = ";
      for(size_t i=0;i<test.s.size();i++){
	std::cout << test.s[i] << " ";
      }
      std::cout << std::endl;
    //    std::cout <<test.ev[length-1]+test.s[10]<< std::endl;


      Eigen::VectorXi ev=test.ev;
      std::cout<<"ev.size()="<<ev.size()<<std::endl;

      /*      if (test.s[0]==1){
	break;
	}*/
    }
   //   std::cout<<ev(0)<<std::endl;
   //   std::cout<<ev(1)<<std::endl;
   
    return 0;
}

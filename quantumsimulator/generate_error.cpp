//#include <stdio.h>
#include <iostream>
#include <fstream>
#include <regex>

#include <itpp/itcomm.h>
#include <Eigen/Sparse>
#include <Eigen/Core>

#include "../headers/errorqc.h"
#include "../../weilei_lib/my_lib.h"

typedef Eigen::SparseMatrix<int> SpMati;

int matrix_to_MM(SpMati M, char * filename);
char * get_file_name(char * sth);

int main(int argc, char **argv){

    Real_Timer timer;    timer.tic();

    itpp::Parser parser;
    parser.init(argc,argv);
    parser.set_silentmode(true);

    std::string file;
    //    file="conv1v2.qc";    file="conv4v1.qc";
    //file="quantum_circuit/conv4v2.qc"; //GI code. 24 qubits
    //    file="quantum_circuit/conv5v5v2.qc"; //GA code 24 qubits
    parser.get(file,"file");
    //std::cout<<"file = "<<file<<std::endl;
    //    char errorFilenamePrefix[]="code1repeat7";
    //    char error_folder[]="error/run53";   //run53  //run8
    std::string errorFilenamePrefix;//[]="code1repeat7"
    parser.get(errorFilenamePrefix,"errorFilenamePrefix");
    std::string error_folder;//="error/run10";
    parser.get(error_folder,"error_folder");
    int t;//=100;//number of errors
    parser.get(t,"t");
    //      std::cout<<t;
    //double prob_begin=0.01,prob_end=0.000001,prob_step=2;//precision 6
    //    double prob_begin=0.1,prob_end=0.0001,prob_step=2;//precision 6
    double prob_begin=0.3,prob_end=0.00003,prob_step=1.7;//precision 6
    parser.get(prob_begin,"prob_begin");
    parser.get(prob_end,"prob_end");
    parser.get(prob_step,"prob_step");
   
   
    srand(time(NULL));

    Qcode qcode;
    qcode.ImportCode(file);
    timer.toc_print();
    qcode.Run(0.01,true);//run a trial to read the code and get some parameter

   //generate errors and save into .mm file
   Eigen::VectorXi ev=qcode.ev;

   int n=ev.size(), ns=qcode.s.size();
   SpMati mat_ev(t,n),mat_s(t,ns);//error matrix and syndrome matrix
   

   // double prob,prob_begin=0.0001,prob_end=0.0010,prob_step=0.0001;
   double prob=prob_begin;
   //   double prob,prob_begin=0.000,prob_end=0.001,prob_step=0.001;
   //   int prob_int,prob_begin=1000
   //std::cout<<"start generating errors. prob = "
   //	    <<prob_begin<<":"<<prob_step<<":"<<prob_end
   //	    <<", t = "<<t<<", n = 2 * n_qubits ="<<n
   //	    <<", ns = "<<ns<<std::endl;
   int division=100;// maximum 100, truncate later. std::round((prob_end-prob_begin)/prob_step+0.1);
   itpp::mat prob_mat(division,2);
   int i_prob=0;
   for ( i_prob=0;i_prob<division;i_prob++){
     timer.toc_print();
     //     prob=prob_begin+i_prob*prob_step;
     if ( prob < prob_end){
       break;
     }
     prob_mat.set(i_prob,0,i_prob); //save prob into .mtx
     prob_mat.set(i_prob,1,prob);
     std::cout<<"prob = "<<prob<<std::endl;
     
     for ( int i=0;i<t;i++){
       qcode.Run(prob,true);
       //std::cout<<"<generate> i = "<<i<<std::endl;
       ev=qcode.ev;
       for ( int j=0;j<n;j++){
	 mat_ev.coeffRef(i,j)=ev(j);
       }
       for ( int j=0;j<ns;j++){
	 mat_s.coeffRef(i,j)=qcode.s[j];
       }
     }
     // std::cout<<"debug :0 "<<std::endl;
   //write a function to convert matrix to GF2mat and then save in MM format. Then try to open it in Matlab.
     char filename_error[256],filename_syndrome[256];
     //     sprintf(filename_error,'hello');
     //std::cout<<"printing file..."<<std::endl;
     //     std::sprintf(filename_error,"%s/%sp%0.6ferror.mtx",error_folder,errorFilenamePrefix,prob);
     //std::sprintf(filename_syndrome,"%s/%sp%0.6fsyndrome.mtx",error_folder,errorFilenamePrefix,prob);
     std::sprintf(filename_error,"%s/%sp%0.6ferror.mtx",error_folder.c_str(),errorFilenamePrefix.c_str(),prob);
     std::sprintf(filename_syndrome,"%s/%sp%0.6fsyndrome.mtx",error_folder.c_str(),errorFilenamePrefix.c_str(),prob);
     //std::cout<<"printing file..."<<filename_error<<std::endl;
     matrix_to_MM(mat_ev,filename_error);
     matrix_to_MM(mat_s,filename_syndrome);

     prob=prob/prob_step;
   }

   char filename_prob_mat[256];
   std::sprintf(filename_prob_mat,"%s/%sprob_mat.mtx",error_folder.c_str(),errorFilenamePrefix.c_str());
   //   std::cout<<filename_prob_mat<<std::endl;
   prob_mat.set_size(i_prob,2,true);
   //prob_mat=prob_mat.get_submatrix(0,0,i_prob-1,1);
   //   std::cout<<prob_mat;
   mat_to_MM(prob_mat,filename_prob_mat);
   timer.toc_print();
   std::cout<<"finish generating errors. prob = "
	    <<prob_begin<<":"<<prob_step<<":"<<prob_end
	    <<", t = "<<t<<", n = "<<n
	    <<". saved in "<<error_folder<<std::endl;   
    return 0;
}

int matrix_to_MM(SpMati M, char * filename){
  int r=M.rows(),c=M.cols();
  GF2mat G(r,c);
  for ( int i = 0;i<r;i++){
    for ( int j=0;j<c;j++){
      G.set(i,j,M.coeffRef(i,j));
    }
  }
  //  std::cout<<G;
  GF2mat_to_MM(G,filename);
  return 0;
}

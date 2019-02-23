%GI code
%Feb 10 2019, Weilei Zeng, modified from convolutional/simualtionRepeatCircuit.m
%this file convert .mtx to matlab data file (.mat)

%add path for necessary tool files
addpath('../../matlab/mmio/')
addpath('../../convolutional/')

%define the code
repeat = 7;%3
           %code='code1';
folder = ['data/trellis/',code];

%example input 2: terminated convolutional code [1 1 1 1 w W]
constructCode=1;
if constructCode ==1
%construct the code
switch code
  case {'code1','code2'}
    g1=[1 1 1;2 2 2 ];g2=[ 1 2 3; 2 3 1 ];
    grepeat=repeat;
    G=[zeros(2,(grepeat+1)*3);kron(eye(grepeat+1),g1)] ...
      +[kron(eye(grepeat+1),g2);zeros(2,(1+grepeat)*3) ];
    rowG = size(G,1);
    P=[G, eye(rowG)];
  case 'code8'
    %copy from code 1
    g1=[1 1 1;2 2 2 ];g2=[ 1 2 3; 2 3 1 ];
    grepeat=repeat;
    G=[zeros(2,(grepeat+1)*3);kron(eye(grepeat+1),g1)] ...
      +[kron(eye(grepeat+1),g2);zeros(2,(1+grepeat)*3) ];
    rowG = size(G,1);

    %modify G for code 8
    codeword=[3 2 1]; %for P and P_dual
    codeword2=[1 3 2]; %for P_dual

    G(2,1:3)=codeword;
    G(end-1,(end-2):end)=codeword;

    P=[G, eye(rowG)];
    %change
    ;%get P_dual here, and then transform with P later after massaging
     %half_row_P_dual=grepeat-1;%half of the number of rows in P_dual
     %P_dual = [ zeros(2*half_row_P_dual,3),  kron(eye(grepeat-1),[codeword;codeword2]),...
     % zeros(2*half_row_P_dual,3)];%This P_dual has some (rowG) missing zero colums, will add later
  case 'code3'
end
P = massageP(P);
%get trellis
tic
[strip,Ptransfer,Qtransfer,numInputSymbols,weightP] = matrix_parameter_strip(P);
%[strip,Ptransfer,Qtransfer,numInputSymbols,weightP] = matrix_parameter_strip(P);
disp('time to get trellisGF4Strip')
trellisGF4Strip= getTrellisGF4Strip(P,strip,numInputSymbols);
toc
end


%parameters for the data; get from shell
%set_max=100; %total number of set of errors
%error_folder_big='~/working/circuit/quantumsimulator/error/GI_run3';


%convert .mtx into .mat in each subfolder
parfor i_set=1:set_max
    %if 1==0
    % get error probabilities pms and save into  .mat file
    error_folder=[error_folder_big,'/set',num2str(i_set)];
    error_filename_prefix=[code,'repeat',num2str(repeat)];
    prob_mat_filename=[error_folder,'/',error_filename_prefix,'prob_mat.mtx'];
    prob_mat=mmread(prob_mat_filename);
    %prob_mat=mmread([error_folder,'/',error_filename_prefix,'prob_mat.mtx']);
    pms=full( prob_mat(:,2)' );
    save_pms([error_folder,'/',error_filename_prefix,'prob_mat.mat'],pms);

    %    convert error and syndrome files, and save both with pq into ont .mat file
    for pm=pms
        
        filename_prefix=[error_folder,'/',error_filename_prefix,'p',num2str(pm,"%.6f")];
        [errorMat,syndromeMatCircuit]=get_error_circuit(numInputSymbols,Qtransfer,filename_prefix);
        % pq=sum(sum(errorMat))/size(errorMat,1)/sum(1-Qtransfer)/sum(1-Qtransfer); %average qubit error rate from the data
        n=sum(1-Qtransfer);%total number of qubits, the same as the one find below
        pq=sum( sum( ceil(errorMat/4) ) /size(errorMat,1))/n;
        
        filename_mat=[filename_prefix,'.mat'];
        save_error(filename_mat,pq,errorMat,syndromeMatCircuit)
        %        disp( ['got data for pm = ',num2str(pm),', i_set = ',num2str(i_set) ]);
    end
    disp( ['got data for i_set = ',num2str(i_set) ]);
end

%now collect all .mat files in subfolder into one file in parent folder

%move pms file; by read and save pms file
error_folder=[error_folder_big,'/set',num2str(1)];
error_filename_prefix=[code,'repeat',num2str(repeat)];
prob_mat_filename=[error_folder,'/',error_filename_prefix,'prob_mat.mtx'];
prob_mat=mmread(prob_mat_filename);
pms=full( prob_mat(:,2)' );
save_pms([error_folder_big,'/',error_filename_prefix,'prob_mat.mat'],pms);

%read parameters for the big file
pm=pms(1);
filename_prefix=[error_folder,'/',error_filename_prefix,'p',num2str(pm,"%.6f")];
filename_mat=[filename_prefix,'.mat'];
[pq,errorMat,syndromeMatCircuit]=load_error(filename_mat);
[t nm]=size(errorMat); %t is number of errors in this file
m=size(syndromeMatCircuit,2); %number of syndrome bits
n=nm-m; %number of qubits
    


%collect all mat files into one file and save it in parent folder
division=size(pms,2)
parfor i_pm=1:division
    pm=pms(i_pm);
    %parfor pm=pms
    errorMatBig=zeros(set_max*t,nm);
    syndromeMatCircuitBig=zeros(set_max*t,m);
    pqs=zeros(1,set_max);
    for i_set = 1:set_max
        error_folder=[error_folder_big,'/set',num2str(i_set)];
        filename_prefix=[error_folder,'/',error_filename_prefix,'p',num2str(pm,"%.6f")];
        filename_mat=[filename_prefix,'.mat'];
        [pq,errorMat,syndromeMatCircuit]=load_error(filename_mat);
        row_begin=(i_set-1)*t;
        errorMatBig(row_begin+1:row_begin+t,:)=errorMat;
        syndromeMatCircuitBig(row_begin+1:row_begin+t,:)=syndromeMatCircuit;
        pqs(i_set)=pq;
    end
    pq=sum(pqs)/set_max;
    filename_prefix=[error_folder_big,'/',error_filename_prefix,'p',num2str(pm,"%.6f")];
    filename_mat=[filename_prefix,'.mat'];
    save_error(filename_mat,pq,errorMatBig,syndromeMatCircuitBig)
end


disp(['mtx2mat.m:  finish converting data in ',error_folder_big])





function     save_pms(pms_filename,pms)
    save(pms_filename,'pms');
end
function save_error(filename_mat,pq,errorMat,syndromeMatCircuit)
%    errorMat
    save(filename_mat,'pq','errorMat','syndromeMatCircuit','-v7.3');
end
function [pq,errorMat,syndromeMatCircuit] = load_error(filename_mat)
    load(filename_mat,'pq','errorMat','syndromeMatCircuit');
end
    
function [errorMat,syndromeMat]=get_error_circuit(numInputSymbols,Qtransfer,filename_prefix)
%get error generated by the cpp program for circuit model
%errorMat save qubit errors in the form of numInputSymbols
%syndrome error is not saved
%syndrome is saved in syndromeMatCircuit

%  addpath('~/working/matlab/mmio/')              %add path for mmio %already added in the beginning of this file
% The readin gpart takes half time of this function
%tic
errorFile   =[filename_prefix,'error.mtx'];
syndromeFile=[filename_prefix,'syndrome.mtx'];
%  errorFile   =[folder,'/code1repeat3p0.001000error.mtx'];
%  syndromeFile=[folder,'/code1repeat3p0.001000syndrome.mtx'];
errorMatCircuit = mmread(errorFile);
syndromeMatCircuit=mmread(syndromeFile);

t=size(errorMatCircuit,1);
nm=size(Qtransfer,2);
m=sum(Qtransfer);                              %number of checks
n=nm-m;
%combine X and Z errors, binary vector --> GF4 vector. extra zero positions are removed
%errorMatCircuit=plusGF4vec(errorMatCircuit(:,1:n),2*errorMatCircuit(:,1+end/2:n+1+end/2));

%errorMatCircuit=plusGF4vec(errorMatCircuit(:,1:n),2*errorMatCircuit(:,1+end/2:n+end/2)); %weilei Feb 14
errorMatCircuit=plusGF4vec(2*errorMatCircuit(:,1:n),errorMatCircuit(:,1+end/2:n+end/2)); %weilei Feb 17, flip 1 and 2

%in circuit model,e=(e_x|e_z). in matlab code, e=1,2,3 for Z,X,Y errors.

syndromeMatCircuit=    syndromeMatCircuit(:,1:m);
errorMat=zeros(t,nm);                           %save error in the form of numInputSymbols.

[temp,order]=sort(numInputSymbols); %temp is in increasing order,
                                    %temp = [2 2 .... 2 4 ... 4]
                                    %order=[[indexes of measuring bits],[indexes of qubits]]
errorMat(:,order((m+1):end))=errorMatCircuit(:,:);  %map qubit errors
syndromeMat=full(syndromeMatCircuit);
%toc
end


function P1 = massageP(P)
%masssage P to make it into strip form, in the repetition case,
% input P=[G,I]

    [rowP,colP]=size(P);
    strip=zeros(2,colP);
    %get first and last nonzero element in each column
    for i_col = 1:colP
        for i_row=1:rowP
            if P(i_row,i_col)
                strip(1,i_col)=i_row;
                break
            end
        end

        for i_row=1:rowP
            if P(rowP-i_row+1,i_col)
                strip(2,i_col)=rowP-i_row+1;
                break
            end
        end
    end
    P1=zeros(rowP,colP);
    ig=1;
    ii=1;
    for i =1:colP
        %         strip(1,colP-rowP-ig+1) , rowP-ii+1+1
        if strip(1,colP-rowP-ig+1) < rowP-ii+1+1
            P1(:,colP-i+1)=P(:,colP-ii+1);
            ii=ii+1;
        else
            P1(:,colP-i+1)=P(:,colP-rowP-ig+1);
            ig = ig+1;
        end

    end
    %P=P1
    %end

end



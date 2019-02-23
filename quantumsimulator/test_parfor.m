%test is the value in parfor loop mess up each other
% result, each process is independent, matlab will check it on its own

a=zeros(1,10);
q=1;
parfor i=1:4
    pause(i/10)
    a(i)=q
    parfor j=1:3
        pause(j/9)
        a(j)=j*10
    end
    a
end
a
    
    
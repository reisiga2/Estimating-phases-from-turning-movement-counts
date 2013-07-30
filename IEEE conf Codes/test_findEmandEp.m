% this script is to check how the errors changes with changing the protion
% of one maneuver in a phase. 


    clear all
    close all
    clc;

    phaseManeuvers=[0 0 0 0 0 0 0 0 0 10 11 12;...
                        0 0 0 0 0 0 0 0 0 0 11 12;...
                        0 0 0 0 0 0 0 0 0 10 0 0; ...
                        0 2 0 0 0 0 7 8 0 0 0 0;...
                        1 2 0 0 0 0 7 8 0 0 0 0;...
                        1 2 0 0 0 0 0 0 0 0 0 0;...
                        1 0 0 0 0 0 0 0 0 0 0 0];

    PD1=DiscreteD([1, 1, 1, 1, 1, 1, 1 , 1, 1, 25, 50, 16]);
    PD2=DiscreteD([1, 1, 1, 1, 1, 1, 1 , 1, 1, 1, 60, 30]);
    PD3=DiscreteD([1, 1, 1, 1, 1, 1, 1 , 1, 1, 89 , 1 ,1]);
    PD4=DiscreteD([1, 40, 1, 1, 1, 1, 40 , 11, 1, 1, 1 ,1]);
    PD5=DiscreteD([10, 35, 1, 1, 1, 1, 35 , 12, 1, 1, 1 ,1]);
    PD6=DiscreteD([30, 60, 1, 1, 1, 1, 1 , 1, 1, 1, 1 ,1]);
    PD7=DiscreteD([89, 1, 1, 1, 1, 1, 1 , 1, 1, 1, 1 ,1]);


                
    phases=[1,5];
   
                       
    minNumCycles=20;
    maxNumCycles= 20;                 
    minManeuver =[5,5];
    maxManeuver =[27,27];
    aij=0.01;
    delta =0.5; % reducing the value of the maneuver percentage in each iteration
    iter=28;% number of iteration
    numAve=30; % average over 100 values (number of times we try on same probability and then average over all of them.)
    x=zeros(1,iter);
    
    EpAve = zeros(1, numAve);
    EmAve = zeros(1, numAve);
    
    Ep=zeros(1,iter);
    Em=zeros(1,iter);
    
    
    for i=1:iter
        x(i)= 15-(iter-i+1)*delta;
    tic;    
        for j=1:numAve
      
     emissionProbs =[0.1 0.1 0.1 0.1 0.1 0.1 0.1 0.1 0.1 25 58.1 16;
                           14.2-i*delta 35+i*delta 0.1 0.1 0.1 0.1 35 15 0.1 0.1 0.1 0.1];
    x(i)=14.2-i*delta;
    [data,realphase] =... % generate a data set
    generate_fixTime_data(phases,minNumCycles,maxNumCycles,...
    emissionProbs, minManeuver,maxManeuver );
    
     %learn an HMM based on the training data. 
    P=[PD1,PD2,PD3,PD4,PD5,PD6,PD7]; % vector with all possible outcome probabilities.
    num_phases= size(P,2);
    hmm = trainHmm (data,num_phases,aij,P);
    %------------------------------------------------------------------inferring
    inferredPhase = viterbi(hmm,data);
   
    [EpAve(j), EmAve(j)] = FindTwoTypeErrors(phaseManeuvers, data, realphase, inferredPhase);
       end
        toc;
        
        Ep(i)=mean(EpAve);
        Em(i)=mean(EmAve);
    end
    
    figure
    plot(x,Ep, '--r', 'lineWidth' ,2);
    hold on
    plot(x,Em,'lineWidth' ,2 )
    
    
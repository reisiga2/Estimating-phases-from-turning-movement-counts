

% this scripts gives the experimental results for the data that was
% collected at a four- leg intersection with one one-way leg. The
% intersecting streets were Prospect Ave and University street. Here we
% manually enumerate all possible phases.


% defining all possible phases by assigning probabilities to each maneuver
% in each phase. This in fact generates an emission probability matrix. 

clear all;
close all;

num_phases =7;
aij=0.01; % initial transition from i to j for i~=j.
% the probabilites does not need to be normalized. here I wrote them so
% that it sums to 100.

% these values are for initiating an hmm for learning. If one change these
% values, the results might slightly be differet. 

PD1=DiscreteD([1, 1, 1, 1, 1, 1, 1 , 1, 1, 25, 50, 16]);
PD2=DiscreteD([1, 1, 1, 1, 1, 1, 1 , 1, 1, 1, 60, 30]);
PD3=DiscreteD([1, 1, 1, 1, 1, 1, 1 , 1, 1, 89 , 1 ,1]);
PD4=DiscreteD([1, 40, 1, 1, 1, 1, 40 , 11, 1, 1, 1 ,1]);
PD5=DiscreteD([10, 35, 1, 1, 1, 1, 35 , 12, 1, 1, 1 ,1]);
PD6=DiscreteD([30, 60, 1, 1, 1, 1, 1 , 1, 1, 1, 1 ,1]);
PD7=DiscreteD([89, 1, 1, 1, 1, 1, 1 , 1, 1, 1, 1 ,1]);

%-------------------------------------- import/translate and filter data 
maneuverIDList = [63127,63121, 0, 0, 0, 0, 63106, 63128, 0, 63108, 63129, 63123];
[training_data,time, realPhases] = ...
    data_filteration('April3_UniveandProsp1.xlsx',maneuverIDList );  
%--------------------------------------------- data stats
maneuPerce = find_percentage(training_data);
%----------------------------------------------------------- initiate and
%learn an HMM based on the training data. 
P=[PD1,PD2,PD3,PD4,PD5,PD6,PD7]; % vector with all possible outcome probabilities.
[hmm, probability] = trainHmm (training_data,num_phases,aij,P);
%------------------------------------------------------------------inferring
[inferredStateSequence,score] = viterbi(hmm,training_data);

%------------------------------------------------------ Errors
  [numMissLabled, percMissLabled] = ...
     find_inference_error(inferredStateSequence,realPhases );

%----------------------------------------------------------------- plot the
%results.

    generatePlots('Prospect and University', maneuPerce,time,training_data,...
    realPhases, inferredStateSequence, 80);


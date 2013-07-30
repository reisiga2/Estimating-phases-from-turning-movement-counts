
% this function caculates the average error over several runs with
% synthetic data and fix number of cycles. 

% input: 
 % numCycle: number of cycles that the data should be generated. if it is a
 % scalar the output would be an scalar. If it is a vector the out put
 % would be a vector that gives the errors correponds to each number of
 % cycles spanning data set. 
 
 % emissionProbsGenData: emission probability matrix for the phases from
 % which we want to generate data. 
 
 % minManeuver and maxManeuver : minimum and maximum number of maneuver in
 % a phase. This value should be a vector whose size is the number of
 % generating phases. 
 
 % iteration: number of data sets that we want t average over. 
 
 % initial_HMMemission : an initial HMM to train
 % aij: transition prob from i to j.
 % totalnumPhases:  total number of phases in the state space. How many
 % phase we consider as possible. 


function [averageError, averagePercError] = CalcAverError_synthData...
    (phases,numCycle,emissionProbsGenData,minManeuver,maxManeuver,iteration,...
    initial_HMMemission, aij, totalnumPhases,numDataSet)

        if nargin<10
            numDataSet=1;
        end
        
        cycleIte = size(numCycle,2);
        averageError = zeros(1,cycleIte);
        averagePercError = zeros(1,cycleIte);
        
  for j=1:cycleIte  
      
        totalMissLabled=0;
        totalDataSize=0;
        misslabled = zeros(1,iteration);
        percError = zeros(1,iteration);
        
    for i= 1: iteration
        
               
        [data,realPhases] = generate_fixTime_data(phases,...
            numDataSet*numCycle(j),numDataSet*numCycle(j),...
        emissionProbsGenData , minManeuver, maxManeuver); % synthetic data generation.
        
        dataSize = size(data,2);
    
        hmm = trainHmm (data,totalnumPhases, aij ,initial_HMMemission,numDataSet);
        inferredStateSequence = viterbi(hmm,data); % phase sequence that is inferred by the trained HMM.
        
        totalDataSize= totalDataSize+ dataSize;
        misslabled(i) = find_inference_error(inferredStateSequence,realPhases);
        percError(i)= misslabled(i)/dataSize;
        totalMissLabled = totalMissLabled + misslabled(i); % bookkeeping. 
        
        
          
    end
        averageError(j) = totalMissLabled/iteration;
        averagePercError(j)= sum(percError)*100/iteration;
        
        % this is another way of calculating percentage of the error. 
        
%         averageError(j) = totalMissLabled/iteration; 
%         averagePercError(j) =  (totalMissLabled/totalDataSize)*100;
  end    
end
        
        
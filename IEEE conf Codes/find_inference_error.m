% this function is calculating number of errors and the percentage of
% errors during the phase inference. 

function [error, percentage_error ] =...
    find_inference_error(trainedphaseSequence,realPhaseSequence )
error =0;
dataSize = size(trainedphaseSequence,2);

for j=1: dataSize
    if trainedphaseSequence(j)~= realPhaseSequence(j)
        error= error+1;
    end
end
    percentage_error= (error/dataSize)*100;
    
end
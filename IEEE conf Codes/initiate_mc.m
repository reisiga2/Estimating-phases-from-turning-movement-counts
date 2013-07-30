% this function generates inital Makov chain for the algorithm. 
% input: number of states: n
% aij:  transition probability from state i to j where i~=j
%output: a markov chain object.

function mc = initiate_mc(n,aij)
    pi = zeros(1, n);
    transitionProb = zeros(n,n);
   
    aii=1-(n-1)*aij; % the probability value to stay in phase i. 
    if aii<0
        error('aij is too large, consider smaller values')
    end
    for i=1:n
        pi(i)= 1/n;
        for j=1:n
            if i==j
                transitionProb(i,j)= aii;
            else
                transitionProb(i,j)= aij;
            end
        end
    end
    
    mc = MarkovChain(pi, transitionProb); 
   
 end
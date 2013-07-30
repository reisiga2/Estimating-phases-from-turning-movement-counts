


function data3 = filterConflicts(data)

    NtoSRing = [1,2,7,9]; % maneuvers from north to south. right turns does not included.  
    EtoWRing = [5,6,10,12]; % maneuvers from west to east. right turns does not included
    
    rowsOfData=size(data,1);
    colsOfData=size(data,2);
    k=1;    
    TimeTelorance = 5;
    
    
    if rowsOfData < 4
    
        error('data set is too short')
    else
        
    for i= 1: (rowsOfData)-2
        
          t = data(i+2,2)-data(i,2);
                    
                           
            if (ismember(data(i+1,1),NtoSRing) && ismember(data(i,1),EtoWRing)&&...
                    ismember(data(i+2,1),EtoWRing) && t<TimeTelorance)
                
               
                
            elseif (ismember(data(i+1,1),EtoWRing) && ismember(data(i,1),NtoSRing)&&...
                    ismember(data(i+2,1),NtoSRing) && t<TimeTelorance)
                
            else
                for j=1:colsOfData
                    data3(k,j)=data(i+1,j);
                   
                end
                    k=k+1;
    
            end
    end
    end
end

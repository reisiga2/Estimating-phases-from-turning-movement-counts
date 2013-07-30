function perc = find_percentage(data)


num=zeros(1,12);
iteration= size(data,2);

for i=1: iteration
    for j=1:12
    if data(1,i)==j
        num(j)=num(j)+1;
    end
    end
end
perc=(num/iteration)*100;

end
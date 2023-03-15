people = zeros(100, 7); %Array to store info about people
neighborhoods = zeros(4, 3); % Array to store info about neighborhoods
budget = 50; % The budget for choosing people
n1=0; % A flag to indicate if neighborhood 1 has been plotted
n2=0;% A flag to indicate if neighborhood 2 has been plotted
n3=0;% A flag to indicate if neighborhood 3 has been plotted
f=0;% A handle to plot object for choosing people
e1=0; % A handle to plot a object for excluded people base on distance
e2=0;% A handle to a plot object for excluded people based on value
legend('AutoUpdate','off')
%Set income values for each neighborhood
income = [2, 5; 3, 3; 1, 1; 0.9, 0.1];
%Set the radius os each neighborhood

neighborhood_radius = 100;
%Randomly assign each person to a neighborhood
% and set their location and income
for i = 1 : size(people)
    people(i,1) = round(rand()*3)+1;
end
% Ploting the neighborhood locations on an x & y grid
for i = 1 : size(neighborhoods)
    neighborhoods(i, 1) = round(rand()*(1000-neighborhood_radius));
    neighborhoods(i, 2) = round(rand()*(1000-neighborhood_radius));
    neighborhoods(i, 3) = round(rand()*2+1);
end
% Plotting the people locations on a x & y grid
% Assigning person value based on neighborhood location
for i = 1 : size(people)
    hood = people(i, 1);
    people(i, 2) = round(rand()*(2*neighborhood_radius-1)+1) + neighborhoods(hood, 1)-neighborhood_radius;
    people(i, 3) = round(rand()*(2*neighborhood_radius-1)+1) + neighborhoods(hood, 2)-neighborhood_radius;
    people(i, 4) = round(rand() * income(hood, 2) + income(hood, 1), 2);
end
% Determine how many people are in close distance (50 units)
for i = 1 : size(people) 
 for j=1 : size (people)
     if (people(i,2)-50<people(j,2) && people(i,2)+50>people(j,2))
         if (people(i,3)-50<people(j,3) && people(i,3)+50>people(j,3))
             people(i,5)=people(i,5)+1;
         else 
             continue;
         end
     else 
         continue;
     end
 end
end
%Calculates the average cost per person and store the value
for i = 1 : size(people)
    people(i,6)= people(i,4)/people(i,5);
end 
%Budget is consumed based on the current lowest average cost per person 
while (budget>0)
    minimum=people(1,6);
    index=1;
for i = 1 : size(people)
    if (people(i,7)==0)
    if people(i,6)<minimum
        minimum=people(i,6);
        index=i;
    end
    else
        continue;
    end
end
%If budget can afford it, allocate budget to selected person
%Subtract budget and mark person as allocated
if budget-people(index,4)>0
    budget=budget-people(index,4);
    people(index,7)=1;
else 
    break;
end
%If person has same value as another skip them,
%If location of person is too close skip them,
%If person does not match either do not skip and continue loop
for j=1 : size(people)
    if j==index
        continue;
    end
     if (people(index,2)-50<people(j,2) && people(index,2)+50>people(j,2) && people(index,3)-50<people(j,3) && people(index,3)+50>people(j,3))
             people (j,7)=2;
         else 
             continue;
     end
 end
end
%Plots people on a graph with multiple points,
%the color os the point is determined by their economic status
hold on
for i=1 : size(people)
    if(people(i, 7) == 1)
        x = people(i, 2);
        y = people(i, 3);
        f=scatter(x,y, "green","filled");
    elseif(people(i, 7) == 2)
        x = people(i, 2);
        y = people(i, 3);
        e1=scatter(x,y,"red");
    else
        x=people(i,2);
        y=people(i,3);
        e2=scatter(x,y,"black");
    end
end
%Plots neighborhoods based on the clusters of people
for i =1: size(neighborhoods)
    if(neighborhoods(i, 3) == 1)
        nX = neighborhoods(i, 1);
        nY = neighborhoods(i, 2);
        if (n1==0)
        n1=scatter(nX,nY,12000,"blue");
        else
           scatter(nX,nY,12000,"blue");
        end
        elseif(neighborhoods(i, 3) == 2)
        nX = neighborhoods(i, 1);
        nY = neighborhoods(i, 2);
        if(n2==0)
        n2=scatter(nX,nY,12000,"cyan");
        else
           scatter(nX,nY,12000,"cyan");
        end
        else
        nX = neighborhoods(i, 1);
        nY = neighborhoods(i, 2);
        if(n3==0)
        n3=scatter(nX,nY,12000,"magenta");
        else
           scatter(nX,nY,12000,"magenta");
        end
    end
end
hold off

legend([f,e1,e2],"Chosen","Ex(distance)","Ex(value)",'Location','northeast')

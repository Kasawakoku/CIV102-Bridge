%% 
% Beam Solver 3000

% change load here
case_loads = linspace(400/6, 400/6, 6);

% add first location of load and adjust load spacing
first = 172
loads = [case_loads; first + [0 176 340 516 680 856]];

% 

% reaction forces
By = sum(loads(2,:).*loads(1,:))/1200;
Ay = sum(loads(1,:)) - By;
V = max(Ay, By);

SFD = [Ay zeros(1, length(loads(1,:))); loads(2,1) zeros(1, length(loads(1,:))-1) 1200-loads(2, end)];
for i = 1:(length(loads(1,:)))
    SFD(1, i+1) = SFD(1, i) - loads(1, i);
end
for i = 1:length(loads(1,:))-1
    SFD(2, i+1) = loads(2,i+1) - loads(2,i);
end
SFD = [SFD;SFD(1,:).*SFD(2,:)];


locs = [loads(2,:) 1200];

SFD_exp = [linspace(0,1200,12001);zeros(1, 12001)];
for i = 1:length(SFD_exp(1,:))
    for k = 1:length(locs)
        if SFD_exp(1,i) <= locs(k)
            
            SFD_exp(2,i) = SFD(1,k);
           

            break
        end
    end
end

plot(SFD_exp(1,:),SFD_exp(2,:))

% bmd
BMD = [0 SFD(2,:);zeros(1,length(SFD(1,:))+1)];
for i = 2:length(SFD(1,:))+1
    BMD(2,i) = BMD(2, i-1) + SFD(3,i-1);
end



BMD_exp = [];
%BMD
for k = 1:length(BMD(2,:))-1
    %BMD(2,k)
    %BMD(2,k+1)
    %(BMD(1,k+1)) * 10 + 1
    %linspace(BMD(2,k),BMD(2,k+1),(BMD(1,k+1)) * 10 + 1)
    BMD_exp = [BMD_exp linspace(BMD(2,k),BMD(2,k+1),(BMD(1,k+1)) * 10 + 1)];
    if k ~= length(BMD(2,:))-1
        BMD_exp(end) = [];
    end
    
end
% bandaid fix to weird bug
if length(BMD_exp) == 12000
        BMD_exp = [BMD_exp, BMD_exp(end)];
end
BMD_exp;
BMD_exp = [linspace(0,1200,12001);BMD_exp];
plot(BMD_exp(1,:), BMD_exp(2,:))
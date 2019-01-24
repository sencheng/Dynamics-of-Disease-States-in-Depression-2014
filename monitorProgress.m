% function monitorProgress(n, N)
%
% Print progress of program execution 
%
% N: total number of executions, 
% n: current execution

function monitorProgress(n, N)
persistent stime lastprint gap
if nargin== 0
    fprintf(1,'**** end timer at %s\n',datestr(clock));
elseif n== 1; 
    stime= clock;
	fprintf(1,'** start timer at %s\n',datestr(stime));
	fprintf(1,'run: %4d/%4d\n',n, N);
    lastprint= 0;
    gap= 10;
else
    time= etime(clock, stime);
    if(time-lastprint) >= gap;
%        ETA= stime+ [0 0 0 0 0 time/(n-1)*N];
        ETA= addsec(stime, time/(n-1)*N);
        fprintf(1,'run: %4d/%4d, elapsed:%4.1f/%4.1f min, ETA: %s\n',...
            n, N, time/60, time/60/(n-1)*N, datestr(ETA) );
        lastprint= time;
    end
end

function dv= addsec(dv, s)

dv(6)= dv(6)+mod(s, 60); % sec
s= floor(s/60);
dv(5)= dv(5)+mod(s, 60); % min
s= floor(s/60);
dv(4)= dv(4)+mod(s, 24); % hours
s= floor(s/24);
dv(4)= dv(4)+s;      % hours


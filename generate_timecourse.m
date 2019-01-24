function [ M ] = generate_timecourse( t,a,b,c,d,I,M1)

m=-1;
if M1<0
    M(1)=m+(1.5*b-m)*rand; % random initial value, which is choosen from normal distribution from m to 1.5*b;
    
else
    M(1)=M1; % initial value;
end



dt=t(2)-t(1);

for it=1:length(t)-1
    
    e=1*randn;
    dM=-0.01*a*(M(it)-b)*(M(it)-c)*(M(it)-d)+I+e/sqrt(dt); % Dynamics of Mood
    M(it+1)=M(it)+dt*dM; % Mood
    
end

end

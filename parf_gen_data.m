function data= parf_gen_data(p)

%% parameters of the function;

nrep=p.nrep;
T=p.T;
dt=p.dt;
a= p.a;
b= p.b;
c= p.c;
d= p.d;
I= p.I;
M1=p.M1;
v=p.v;
t=(0:dt:T); % time with time step dt;

na=length(a);
nb=length(b);
nc=length(c);
nd=length(d);
nI=length(I);

Nrun=na*nb*nc*nd*nI;
N=Nrun*nrep;
nrun=0;

if nc>1
    x1=nc; x2=nI; x3= nb;
elseif nb>1
    x1=na; x2=nb; x3= nc;
else
    x1=na; x2=nd; x3= nc;
end

M=zeros(1,T);  % Mood
dM=zeros(1,T); % Dynamics of Mood

% variable;

episode_temp=zeros(1,nrep);% number of DE;
episode=zeros(x1, x2, x3); % median number of DE;
or=zeros(x1, x2, x3);
rr=zeros(x1, x2, x3);
r2=zeros(x1, x2, x3);
r3=zeros(x1, x2, x3);

relapse_temp=zeros(1,nrep);
relapse=zeros(x1, x2, x3); % median number of DE;
longest_DE=zeros(1,nrep); % duration of the longest DE;
t1_DE=zeros(1,nrep); % time of occurence of the 1st DE;
d1_DE=zeros(1,nrep); %  duration of the first DE;
dur_rec_1st=zeros(1,nrep); % duration of the 1st recovery;
rec_1st=zeros(1,nrep); % time of the 1st recovery;
recc_measure_temp=zeros(1,nrep); % time of the 1st recurrence;
recc_measure=zeros(x1, x2, x3);

M180_temp=zeros(1,nrep); % state of the mood one day after diagnosis of DE;
transition_time_temp=zeros(1,nrep); % duration of the first transition from negative to positive state;
transition_time=zeros(x1, x2, x3);% duration of the first transition from negative to positive state (for the range of parametres);
response_time_temp=zeros(1,nrep); % duration of first time to reponse;
response_time=zeros(x1, x2, x3);% duration of first time to reponse (for the range of parametres);
TR_temp=zeros(1,nrep); % time to remission;
TR=zeros(x1, x2, x3); % median time to remission;
TR_mn=zeros(x1, x2, x3); % mean time to remission;

for ia=1:na
    
    for ib=1:nb
        
        for ic=1:nc
            
            for id=1:nd
                
                for iI=1:nI
                    
                    nrun=nrun+1;
                    
                    monitorProgress(nrun, Nrun);
                    
                    parfor r=1:nrep
                        
                        M= generate_timecourse(t,a(ia),b(ib),c(ic),d(id),I(iI),M1);
                        
                        if hasInfNaN(M) % returns true if M has any Inf or NaN entry
                            disp('M is now NaN. I will stop')
                            fprintf('%f %f %f %f %f\n', a(ia), b(ib),c(ic), d(id), I(iI),M1);
                            longest_DE(r)=NaN; episode(r)=NaN;relapse(r)=NaN; t1_DE(r)=NaN;d1_DE(r)=NaN;TR_temp(r)=NaN;M15_temp(r)=NaN;rec_1st(r)=NaN;dur_rec_1st(r)=NaN;transition_time(r)=NaN;
                        end
                        
                        [longest_DE(r), episode_temp(r),relapse_temp(r),t1_DE(r),d1_DE(r),TR_temp(r),M_180_temp(r),rec_1st(r), dur_rec_1st(r),transition_time_temp(r),response_time_temp(r),recc_measure_temp(r)] = analyze_timecourse(t,M,v);
                        dbstop if error
                        
                    end
                    
                    if nc>1
                        y1=ic; y2=iI; y3= ib;
                    elseif nb>1
                        y1=ia; y2=ib; y3= ic;
                    else
                        y1=ia; y2=id; y3= ic;
                    end
                    
                    episode(y1, y2, y3)=median(episode_temp);% median number of DE;
                    relapse(y1, y2, y3)=median(relapse_temp); % median number of relapses;
                    TR(y1, y2, y3)=median(TR_temp); % median time to remission;
                    TR_mn(y1, y2, y3)=mean(TR_temp); % mean time to remission;
                    TR_mn(y1, y2, y3)= sum(TR_temp<360)/ nrep;
                    transition_time(y1, y2, y3)=median(transition_time_temp);
                    or(y1, y2, y3)=sum(episode_temp>=1)/nrep; % rate of occurrence of MDE;
                    rr(y1, y2, y3)=sum(episode_temp>=2)/sum(episode_temp>=1);  % rate of 1st recurrence of MDE;
                    
                    if isnan(rr(y1, y2, y3))==1
                        rr(y1, y2, y3)=0;
                    end
                    
                    r2(y1, y2, y3)=sum(episode_temp>=3)/sum(episode_temp>=2);
                    
                    if isnan(r2(y1, y2, y3))==1
                        r2(y1, y2, y3)=0;
                    end
                    
                    r3(y1, y2, y3)=sum(episode_temp>=4)/sum(episode_temp>=3);
                    
                    if isnan(r3(y1, y2, y3))==1
                        r3(y1, y2, y3)=0;
                    end
                    
                end
                
            end
            
        end
        
    end
    
end

data= [];
data.or=or;
data.rr=rr;
data.r2=r2;
data.r3=r3;
data.a=a;
data.b=b;
data.c=c;
data.d=d;
data.I=I;
data.nrep= nrep;
data.episode= episode;
data.episode_temp= episode_temp;
data.relapse= relapse_temp;
data.longest_DE=longest_DE;
data.t_occ_DE=median(10+(t1_DE/365)*.1);
data.t1_DE=10+(t1_DE/365)*.1;
data.d1_DE= d1_DE;
data.TR=TR;
data.TR_mn=TR_mn;
data.TR_temp=TR_temp;
data.M180=M_180_temp;
data.rec_1st=rec_1st;
data.dur_rec_1st= dur_rec_1st;
data.transition_time=transition_time;
data.transition_time_temp=transition_time_temp;
data.response_time=response_time;
data.response_time_temp=response_time_temp;
data.recc_measure_temp=recc_measure_temp;
data.recc_measure=recc_measure;

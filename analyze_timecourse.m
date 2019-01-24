function [longest_DE,episode,relapse,t1_DE,d1_DE, TR,M_180,rec_1st, dur_rec_1st,transition_time,response_time,recc_measure] = analyze_timecourse(t,M,v)

Trans=v.Trans; % number of all transitions;
nTrans=v.nTrans; % number of transitions from negative to positive state;
comp_nTrans=v.comp_nTrans;
ndt=v.ndt;
nsn=v.nsn; % number of steps after transition on negative side;
pTrans=v.pTrans; % number of transition from positive to negative state;
comp_pTrans=v.comp_pTrans;
pdt=v.pdt;
nps=v.nps; % number of steps after transition on positive side;
tneg=v.tneg; % time that sistem spends on negative side after single transition;
tpos=v.tpos; % time that sistem spends on positive side after single transition;
state=v.state; % current state;

state_seq=v.state_seq; % sequences of states;
relapse=v.relapse; % exacerbation after period without symptoms;
episode=v.episode; % number of depressive episods;
longest_DE=v.longest_DE; % the longest depressive episode;
count=v.count;

rec_1st=v.rec_1st; % duration of recovery after 1st DE;
rec=v.rec; % duration of recovery;
rcount=v.rcount;

M180=v.M15; % mood state day after diagnosis of DE;
M_180=v.M14; % mood state day after diagnosis of 1st DE;
c=v.c; % counter;
TR=v.TR; % time to remission;
dur_rec_1st=v.dur_rec_1st;
dur_rec=v.dur_rec;
transition_time= v.transition_time;  % duration of first transition from negative to positive;
response_time=v.response_time;  % duration of first time to response;
j=v.j;
ri=v.ri;
recc_measure_t=0;
recc_measure=0;
dt=t(2)-t(1);

for it =1:length(t)-1;
    
    %% time that system spends on the positive side;
    
    if M(it)>= 0
        pdt=pdt+dt;
        if M(it+1)<0  || (it+1)==length(t) % transition from positive to negative state;
            pTrans=pTrans +1;
            Trans=Trans +1;
            tpos(pTrans)=pdt;
            pdt=0;
            
            switch state
                
                case 0  % null state;
                    state= 0;
                    
                case 1  % depressive epsiode;
                    if tpos(pTrans)>= 180
                        state=4; % recovery;
                    elseif tpos(pTrans)>14
                        state=3; % remission;
                    else
                        tneg(nTrans)=tneg(nTrans)+tpos(pTrans);
                        pTrans=pTrans-1;
                        Trans=Trans-1;
                        state=5; % rebound depressive episode;
                    end
                    
                case 2   % relapse;
                    if tpos(pTrans)>= 180
                        state=4; % recovery;
                    elseif tpos(pTrans)>14
                        state=3; % remission;
                    else
                        tneg(nTrans)=tneg(nTrans)+tpos(pTrans);
                        Trans=Trans-1;
                        pTrans=pTrans-1;
                        state=6; % rebound relapse;
                    end
                    
                case 7 % interrupted remission;
                    tpos(pTrans-1)=tpos(pTrans-1)+tpos(pTrans);
                    Trans=Trans-1;
                    pTrans=pTrans-1;
                    if tpos(pTrans)<180
                        state=3; % remission;
                    else
                        state=4; % recovery;
                    end
                    
                case 8 % interupted recovery;
                    tpos(pTrans-1)=tpos(pTrans)+tpos(pTrans-1);
                    Trans=Trans-1;
                    pTrans=pTrans-1;
                    state=4; % recovery;
                    
                otherwise
                    error('incorrect state')
            end
            
            state_seq(Trans)=state;  % sequences of the states;
            
            % duration of recovery period;
            if Trans>0 && state_seq(Trans)==4
                
                if pTrans==comp_pTrans; % if condition prevent counter to make two steps for the same recovery when case 8 (interupted recovery);
                    rcount=rcount;
                else
                    rcount=rcount+1;
                    comp_pTrans=pTrans;
                end
                
                index_r(rcount)=it-(round(tpos(pTrans)/dt)); % time of recovery;
                dur_rec(rcount)=tpos(pTrans); % duration of recovery;
                M180(rcount)=M(index_r(rcount)+1800); % mood state day 90 remisssion;
                
            end
            
        end
        
    end
    
    %%     time that system spend on negative side;
    
    if M(it)< 0
        
        ndt=ndt+dt;
        
        % time to response;
        if M(it+1)>= M(1)/2
            ri=ri+1;
            if ri==1
                response_time=ndt; % duration of first transition from negative to positive state ;
            end
        end
        
        if M(it+1)>=0 || (it+1)==length(t)  % transition from negative to positive state;
            j=j+1;
            if j==1
                transition_time=ndt; % duration of first transition from negative to positive state;
            end
            
            nTrans=nTrans+1;
            Trans=Trans +1;
            tneg(nTrans)=ndt;
            ndt=0;
            
            switch state
                
                case 0  % null state;
                    if tneg(nTrans)>= 14
                        state=1;  % depressive epsiode;
                        
                    else
                        state=0;  % null state;
                    end
                    
                case  4 % recovery;
                    if tneg(nTrans)>= 14
                        state=1; % depressive epsiode;
                    else
                        tpos(pTrans)=tneg(nTrans)+tpos(pTrans);
                        Trans=Trans-1;
                        nTrans=nTrans-1;
                        state=8; % interupted recovery;
                    end
                    
                case 3  % remission;
                    if tneg(nTrans)>= 14
                        state=2; % relapse;
                    else
                        tpos(pTrans)=tneg(nTrans)+tpos(pTrans);
                        Trans=Trans-1;
                        nTrans=nTrans-1;
                        state=7;   % interrupted remission;
                    end
                    
                case 6 % rebound relapse;
                    tneg(nTrans-1)=tneg(nTrans)+tneg(nTrans-1);
                    nTrans=nTrans-1;
                    Trans=Trans-1;
                    state=2;  % relapse;
                    
                case 5 % rebound depressive episode;
                    tneg(nTrans-1)=tneg(nTrans)+tneg(nTrans-1);
                    nTrans=nTrans-1;
                    Trans=Trans-1;
                    state =1; % depressive epsiode;
                    
                otherwise
                    error('incorrect state')
            end
            
            state_seq(Trans)=state; % sequences of states;
            
            %% time of occurence of the 1st DE and mood state day after diagnosis of depression;
            
            if Trans>0 && state_seq(Trans)==1
                
                if nTrans==comp_nTrans; % if condition prevent counter to make two steps for the same DE when case 5 (rebound depressive episode);
                    count=count;
                else
                    count=count+1;
                    comp_nTrans=nTrans; % previous state of nTrans;
                end
                
                duration_de(count)= tneg(nTrans); % duration of DE;
                
                recc_measure_t(count)=(it-((tneg(nTrans)/.1))); % time point of the 1st recurrence;
                
                index(count)=it-(round(tneg(nTrans))); % time point of the 1st day of DE;
                
                M15(count)=M(index(count)+15); % mood state day after diagnosis of depression;
                
            end
            
        end
    end
end

tneg=tneg(1:nTrans);
tpos=tpos(1:pTrans);

if Trans>1
    state_seq=state_seq(1:Trans);
else
    state_seq=state;
end
%% sumation of the states;
episode=sum(state_seq==1);
relapse= sum(state_seq==2);
remission=sum(state_seq==3);
recovery=sum(state_seq==4);

%% duration and occurence of 1st DE & duratio of the longest DE;

dur_ep=tneg(tneg>=14); % duration of DE;

if episode >=1
    d1_DE=dur_ep(1); % duration of first DE;
    longest_DE=max(tneg); % duration of the longest DE;
    t1_DE=index(1); % time of occurrence of 1st DE;
    recc_measure= recc_measure_t(1)*.1;
else
    longest_DE=0;
    d1_DE=0;
    t1_DE=0;
    recc_measure=NaN;
end

if recovery >=1
    M_180=M180(1);  % mood state day after recovery;
else
    M_180=NaN;
end

% duration of the first recovery;
if recovery>=0
    dur_rec_1st=dur_rec(1);
else
    rec_1st=0; % time of 1st recovery;
    dur_rec_1st=0; % duration of 1st recovery;
end

if any(tneg)
    TR=tneg(1); % time to remission;
end;

end


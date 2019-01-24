
function [v]=select_variables(p)
% with initial value of "M", we define which set of parameters will be
% used;

M1=p.M1;
if sum(M1)>0
    
    vn.Trans=0; % number of all transitions;
    vn.nTrans=0; % number of transitions from negative to positive state;
    vn.state=0; % current state;
    vn.tneg=0; % time that sistem spends on negative side after single transition;
    
else
    
    %% to see an effect of antidepressants;
    vn.Trans=1; % number of all transitions;
    vn.nTrans=1; % number of transitions from negative to positive sate;
    vn.state=5; % current state;
    vn.tneg=14; % time that sistem spends on negative side after single transition;
    
end

vn.comp_nTrans=0;
vn.ndt=0;
vn.nsn=0; % number of steps after transition on negative side;
vn.pTrans=0; % number of transition from positive to negative;
vn.comp_pTrans=0;
vn.nps=0; % number of steps after transition on positive side;
vn.pdt=0;

vn.tpos=0; % time that sistem spends on positive side after single transition;

vn.state_seq=[];% sequences of states;
vn.relapse=0; % exacerbation after period without symptoms;
vn.episode=0; % number of depressive episodes;
vn.longest_DE=0; % the longest depressive episode;
vn.count=0;

vn.rec_1st=0; % duration of recovery after 1st DE;
vn.rec=0; % duration of recovery;
vn.rcount=0;
vn.M15=0; % mood state day after diagnosis of DE;
vn.M14=0; % mood state day after diagnosis of 1st DE;
vn.c=0;%counter;
vn.TR=0; % time to remission;
vn.dur_rec_1st=0;
vn.dur_rec=0;
vn.transition_time=0; % duration of the first transition from negative to positive state;
vn.j=0;
vn.response_time=0;  % duration of the first time to response;
vn.ri=0;
v=vn;

%% low-risk subpopulation;
% occurrence & recurrence rates;
clear all
pn.T=70*365;
pn.nrep=9201;
pn.a=5;
pn.b= -2.85;
pn.c= 0.1750;
pn.d= 5;
pn. I= 0.02;
pn.dt= 0.1;
pn.M1=1.75;
pn.v=select_variables(pn);
data1= parf_gen_data(pn);

%% high-risk subpopulation;
% occurrence & recurrence rates;
pn.T=70*365;
pn.nrep=711;
pn.a=4.4;
pn.b= -3.75;
pn.c= 0.1750;
pn.d= 4.25;
pn. I= 0;
pn.dt= 0.1;
pn.M1=1.75;
pn.v=select_variables(pn);
data2= parf_gen_data(pn);


fields= fieldnames(data1);
for i=1:length(fields)
    data.(fields{i})= [data1.(fields{i}) data2.(fields{i})];
end

save two_subpop_or&rr

%% Modeling antidepressant treatment(ADT);
% change in parameters a&b;

%% low-risk subpopulation;

% occurrence & recurrence rate (or);
clear all
pn.T=70*365;
pn.nrep=1002;
pn.a= 4.2:.1:5.4;
pn.b= -3.15:.1:-2.35;
pn.c= 0.1750;
pn.d= 5;
pn. I= 0.02;
pn.dt= 0.1;
pn.M1=1.75;
pn.v=select_variables(pn);
data1= parf_gen_data(pn);

% remission time(rt);
pc_s1= pn;
pn.T=10*365;
pn.M1=-1.75;
pn.v=select_variables(pn);
data3= parf_gen_data(pn);

%% high-risk subpopulation;

% occurrence & recurrence rates;
pn.T=70*365;
pn.nrep=1002;
pn.a= 4.2:.1:5.4;
pn.b= -4.05:.1:-3.25;
pn.c= 0.1750;
pn.d= 4.25;
pn. I= 0;
pn.dt= 0.1;
pn.M1=1.75;
pn.v=select_variables(pn);
data2= parf_gen_data(pn);

% remission time(rt);
pc_s2= pn;
pn.T=10*365;
pn.M1=-1.75;
pn.v=select_variables(pn);
data4= parf_gen_data(pn);

save or_rt_a&b

%% Modeling cognitive behavioral treatment (CBT);
% change in the parameters c&I;

%% low-risk subpopulation;
% occurrence & recurrence rates;
clear all
pn.T=70*365;
pn.nrep=1002;
pn.a= 5;
pn.b=  -2.85;
pn.c= [-.175:.025: .2];
pn.d= 5;
pn. I=[-0.03: 0.01: 0.04];
pn.dt= 0.1;
pn.M1=1.75;
pn.v=select_variables(pn);
data1= parf_gen_data(pn);

% remission time (rt);
pc_s1= pn;
pn.T=10*365;
pn.M1=-1.75; % comment this line when you calculate effect of andidepressants;
pn.v=select_variables(pn);
data3= parf_gen_data(pn);

%% high-risk subpopulation;
% occurrence & recurrence rates;
pn.T=70*365;
pn.nrep=1002;
pn.a= 4.4;
pn.b= -3.8;
pn.c= [-.175:.025: .2];
pn.d= 4.25;
pn. I=[-0.03: 0.01: 0.04];
pn.dt= 0.1;
pn.M1=1.75;
pn.v=select_variables(pn);
data2= parf_gen_data(pn);

% remission time (rt);
pc_s2= pn;
pn.T=10*365;
pn.M1=-1.75;
pn.v=select_variables(pn);
data4= parf_gen_data(pn);

save or_rt_c&I

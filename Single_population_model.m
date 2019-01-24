%% Single population model;
% Moodeling occurrence & recurrence rates;
clear all
pn.T=70*365;
pn.nrep=1002;
pn.a=4.65;
pn.b= -3;
pn.c= 0.175;
pn.d= 5;
pn. I= 0.02;
pn.dt= 0.1;
pn.M1=1.75;
pn.v=select_variables(pn);
data1= parf_gen_data(pn);

save single_pop_or&rr

%% Modeling antidepressant treatment(ADT)-first attempt;
% change in the parameters a&d;

%% occurrence & recurrence rates;
clear all
pn.T=70*365;
pn.nrep=1002;
pn.a= 1:.5:5;
pn.b= -3;
pn.c=  0;
pn.d= 2:.5:10;
pn. I= 0.02;
pn.dt= 0.1;
pn.M1=1.75; 
pn.v=select_variables(pn);
data1= parf_gen_data(pn);

%% remission time(rt)
pc_s1= pn;
pn.T=10*365;
pn.M1=-1.75;
pn.v=select_variables(pn);
data2= parf_gen_data(pn);

save single_pop_or_rt_a&d
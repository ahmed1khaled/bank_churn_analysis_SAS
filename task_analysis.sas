libname tsa "/home/u62064965/EPG1v2/data";
options validvarname=v7;
ods pdf file="/home/u62064965/EPG1v2/output/res_analysis.pdf" startpage=no style=journal 
	pdftoc=1;
proc import datafile="/home/u62064965/EPG1v2/data/Churn Modeling.csv" dbms=csv 
		out=churn replace;
	guessingrows=max;
run;

data bankChurn;
	set churn;
	length age_pr $7;
	length Balance_pr $7;
	length EstimatedSalary_pr $7;
	drop RowNumber CustomerId;
	if age <=20 then age_pr=">20";
	else if age >20 and age <=50 then age_pr="20-50";
	else if age >50 and age <=75 then age_pr="50-75";
	else if age >75 then age_pr="75<";
	
	if Balance <=50000 then Balance_pr=">50";
	else if Balance >50000 and Balance <=100000 then Balance_pr="50-100";
	else if Balance >100000 and Balance <=150000 then Balance_pr="100-150";
	else if Balance >150000 and Balance <=200000 then Balance_pr="150-200";
	else if Balance >200000 then Balance_pr="200<";
	
	if EstimatedSalary <=50000 then EstimatedSalary_pr=">50";
	else if EstimatedSalary >50000 and EstimatedSalary <=100000 then EstimatedSalary_pr="50-100";
	else if EstimatedSalary >100000 and EstimatedSalary <=150000 then EstimatedSalary_pr="100-150";
	else if EstimatedSalary >150000 then EstimatedSalary_pr="150<";
	
	format Balance Dollar20.2 EstimatedSalary Dollar20.2;
run;

proc print data=bankChurn (obs=10)noobs;
run;

proc means data=bankChurn;
run;

proc freq data=bankChurn;
	tables Geography Gender Tenure NumOfProducts HasCrCard IsActiveMember age_pr/nocum 
		nopercent;
run;

proc template;
	define statgraph my_pie_chart;
		begingraph;
		entrytitle "Pie Chart of Exited";
		layout region;
		piechart category=Exited;
		endlayout;
		endgraph;
	end;
run;

proc sgrender data=bankChurn template=my_pie_chart;
run;

proc sgplot data=bankChurn;
vbox CreditScore/ category = Exited;
run;

title"Older people do not leave the bank more than younger ones";
proc sgplot data=bankChurn;
	scatter x=Exited y=Age;
	title"scatter plot age with exited";
run;
title"The largest percentage of Balance between 100000 to 150000";
proc sgplot data=bankChurn;
    histogram Balance  / binstart=0 binwidth=25000 showbins;
run;
proc sgplot data=bankChurn;
    histogram EstimatedSalary  / binstart=0 binwidth=25000 showbins;
run;
*"female exited more than male";
PROC SGPLOT DATA=bankChurn;
	VBAR Exited / GROUP=Gender GROUPDISPLAY=CLUSTER;
	TITLE 'bankChurn by Exited and Gender';
RUN;
*"Majority of the data is from persons from France It is recommended to make many branches of the bank in France and improve the service in Germany ";
*"spain is less exited ";
PROC SGPLOT DATA=bankChurn;
	VBAR Exited / GROUP=Geography GROUPDISPLAY=CLUSTER;
	TITLE 'bankChurn by Exited and Geography';
RUN;

PROC SGPLOT DATA=bankChurn;
	VBAR Exited / GROUP=Tenure GROUPDISPLAY=CLUSTER;
	TITLE 'bankChurn by Exited and Tenure';
RUN;
*"age from 20 to 50 more exited ";
PROC SGPLOT DATA=bankChurn;
	VBAR Exited / GROUP=age_pr GROUPDISPLAY=CLUSTER;
	TITLE 'bankChurn by Exited and age_pr';
RUN;
*"The higher the balance, the less the bank left    50-150";
PROC SGPLOT DATA=bankChurn;
	VBAR Exited / GROUP=Balance_pr GROUPDISPLAY=CLUSTER;
	TITLE 'bankChurn by Exited and Balance ';
RUN;

PROC SGPLOT DATA=bankChurn;
	VBAR Exited / GROUP=EstimatedSalary_pr GROUPDISPLAY=CLUSTER;
	TITLE 'bankChurn by Exited and EstimatedSalary ';
RUN;
*"The more NumOfProducts, the lower the bank leave rate";
PROC SGPLOT DATA=bankChurn;
	VBAR Exited / GROUP=NumOfProducts GROUPDISPLAY=CLUSTER;
	TITLE 'bankChurn by Exited and NumOfProducts ';
RUN;

PROC SGPLOT DATA=bankChurn;
	VBAR Exited / GROUP=HasCrCard GROUPDISPLAY=CLUSTER;
	TITLE 'bankChurn by Exited and HasCrCard ';
RUN; 
*"People who are not active have a high percentage of leaving the bank";
PROC SGPLOT DATA=bankChurn;
	VBAR Exited / GROUP=IsActiveMember GROUPDISPLAY=CLUSTER;
	TITLE 'bankChurn by Exited and IsActiveMember ';
RUN;

ods pdf close;




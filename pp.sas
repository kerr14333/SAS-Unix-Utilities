/*******************************************************

Quick macro for reading


*******************************************************/

%macro pprint;
options  nofmterr pagesize=74 linesize=150 leftmargin=10;
libname here "&lib.";

proc print data=here.&DS.
    %if &obsval. ne none %then %do;
        (obs=&obsval.)
    %end;
    ; *semicolon to end dataset options;
run;

%mend pprint;
%pprint;

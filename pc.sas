
%macro pcontents;
    options  nofmterr pagesize=74 linesize=150 leftmargin=10;
    libname here "&lib." access=readonly;

    proc contents data=here.&DS. ; run; 

%mend pcontents;
%pcontents;
                     

:- use_module(library(lists)).
:- dynamic workflow/3.
setup :- assert(workflow(1,
		[select(1,'backend://location/dir/file1.txt'),
	         select(2,'file2.pl')],
	 
	        [job(1,'foobar', [ option('-i',input(select(2))),
			           option('-h',value(23)),
			           option('-o',output('output.txt'))]),
	         job(2,'baz', [ option('-k',input(from(1,'*.txt')))])])).

jobs(workflow(_,_,Jobs),Jobs).

job_num(job(N,_,_),N).
inputfileoption(option(_,input(from(_,_)))).

inputjobnumfromoption(option(_,input(from(N,_))),N).

inputnums([],[]).
inputnums([Option|Rest],[N | OtherNums ]) :-
	inputjobnumfromoption(Option,N),
	inputnums(Rest,OtherNums).

	
inputs(job(_,_,Options),InputJobNums) :-
	list:include(inputfileoption,Options,InputFileOptions),
	inputnums(InputFileOptions,InputJobNums).


wflow(WorkflowNum,W) :-
	workflow(WorkflowNum,X,Y),
	W =.. [workflow,WorkflowNum,X,Y].


jobinputs(WN,JB,JobInputNums) :-
	wflow(WN,W),
	jobs(W,Jobs),
	member(Job,Jobs),
	job_num(Job,JB),
	inputs(Job,JobInputNums).


depends(WID,JIDA,JIDB) :-
	jobinputs(WID,JIDA,Nums),
	member(JIDB,Nums).

inconsistent(WID) :-
	depends(WID,X,Y),
	depends(WID,Y,X).
% Abstract syntax for Celery expressions will go here
:-module(celery, [ compile/2 ]).


% Still feeling around for best way to express operations

% Job with no inputs is just a remote invocation
transform(job(Tool,[]),remote(Backend,Tool) :-
    tool(Tool,Backend).



compile_chain([], nullprogram).
compile_chain([ Job | Rest], seq(TransformedJob,TransformedRest)) :-
    transform(Job, TransformedJob),
    compile_chain(Rest, TransformedRest).

compile([], nullprogram).
compile([Chain | Chains],par(TransformedChain,TransformedChains)) :-
    compile_chain(Chain, TransformedChain),
    compile(Chains, TransformedChains).








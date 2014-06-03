:-module(loader, [load_workflow/2]).
:-use_module(library(http/json)).
:-use_module(library(http/json_convert)).


load_workflow(FileName,Workflow) :-
    open(FileName,read,Stream),
    json_read(Stream,JsonObj),
    close(Stream),
    json_to_prolog(JsonObj,Workflow).

    
    


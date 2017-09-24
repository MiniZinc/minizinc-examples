% This is a working edition of wumpus problem of workshop_08 at week 4 of the Modeling Discrete Optimization of coursera 
% Done by: Ahmed Hassan, <ahah432@yahoo.com>, 7.9.2016
int: n; % number of nodes
set of int: NODE = 1..n;
int: m; % number of edges
set of int: EDGE = 1..m;
array[EDGE] of NODE: from;
array[EDGE] of NODE: to;
int: maxsteps; % maximum number of steps
set of int: TIME = 0..maxsteps;

NODE: start;
NODE: gold;

set of int: ACTION = 0..n+1;
ACTION: donothing = 0; % do nothing action = 0
ACTION: pickup = n+1;  % action n+1 is pickup gold
                       % otherwise its move to node i

%% decisions
var 1..maxsteps: steps;  % number of actions required
array[1..maxsteps] of var ACTION: act;

%% auxiliaries to hold state
array[TIME] of var NODE: position;
array[TIME] of var bool: holding;



int: wumpus = 99; % forbiden point 
constraint forall(t in TIME)(position[t] != wumpus); 




solve :: int_search([steps], input_order, indomain_min, complete)
      minimize steps;
% solve minimize steps;


output ["Actions are : Starting at "  ++ show(start) ++ " , "]++[ if fix(act[t]) = donothing then 
            "do_nothing"
         else if fix(act[t]) = pickup then
            "pickup_gold"
         else "move_to " ++ show(act[t]) endif endif
         ++ " , "
       | t in 1..fix(maxsteps) ] ++ ["\n ACTIONS = " ++ show(act)]  ++ ["\n POSITIONS = " ++ show(position)]  ++ ["\n hold_status = " ++ show(holding)]  ++ ["\n Steps = " ++ show(steps)];
       
       
predicate valid(var int: current_position, var int: next_position) = exists(i in EDGE)(from[i] == current_position /\ to[i] == next_position);

predicate action(var int: current_position, var bool: current_holding,var ACTION: next_action,var int: next_position, var bool: next_holding) = 
((valid(current_position,next_position) /\ next_action == next_position) \/ (current_position == next_position /\ next_action in { pickup, donothing})) 
/\ (current_holding <= next_holding)
/\ (current_position == gold /\ not(current_holding)  <-> next_action == pickup); 

constraint forall(i in 0..maxsteps-1)(action(position[i], holding[i], act[i+1], position[i+1], holding[i+1]));

constraint position[0] = start;
constraint position[steps] = start /\ holding[steps];
constraint exists(i in 1..maxsteps-1)(act[i] = pickup);
constraint steps = sum(i in 1..maxsteps )(if act[i] != 0 then 1 else 0 endif);
constraint forall(i in 1..maxsteps-1)(act[i] == 0 -> act[i+1] == 0 );

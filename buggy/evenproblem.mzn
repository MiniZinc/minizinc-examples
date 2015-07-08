predicate even(var int:x) = 
          let { var lb(x) div 2 .. ub(x) div 2: y } in x >= 2*y /\ x <= 2 * y;

var -1..7: u;

constraint not even(u); 

solve satisfy;

output [ show(u) ];
```{.k}
requires "dai-core.k"

module ACCUMULATOR-SPEC
  imports DAI-CORE

  rule <k> frob(deltad, _) => true ... </k> //we don't just want this to evaluate to true, we want to say something about all future states
       <caller> USER </caller>

       <account>
         <id> USER </id>
         <eth> _ => _ </eth>
         <dai> DAI => DAI + deltad *Int CHI2 /Int (PHI ^Int (T2-T1)) </dai> //This needs to be formulated clearer.
         <eth-collateral> _ => _ </eth-collateral>
         <debt> DEBT => DEBT +Int deltad </debt>
       </account>

       <interestRate> PHI </interestRate>
       <totalDebt> TOTALDEBT => TOTALDEBT +Int deltad </totalDebt>
       <accumulator> CHI1 => CHI2 </accumulator>
       <time> T1 => T2 </time>


    requires deltad *Int CHI2 =Int 
```
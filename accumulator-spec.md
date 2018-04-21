```{.k}
module ACCUMULATOR-SPEC
  imports DAI-CORE

  rule <k> frob(_, DEBTDELTA) => true ... </k> //we don't just want this to evaluate to true, we want to say something about all future states
       <caller> USER </caller>

       <account>
         <id> USER </id>
         <eth> _ => _ </eth>
         <dai> PRIORDAI => _ </dai>
         <eth-collateral> _ => _ </eth-collateral>
         <debt> DEBT => _ </debt>
       </account>

       <interestRate> PHI </interestRate>
       <totalDebt> TOTALDEBT => TOTALDEBT +Int DEBTDELTA </totalDebt>
       <accumulator> CHI1 => CHI2 </accumulator>
       <time> T1 => T2 </time>


    requires (DEBTDELTA *Int CHI1) *Int (PHI ^Int (T2 -Int T1)) ==Int DEBTDELTA *Int CHI2
     andBool T1 <Int T2 // Make sure that we actually travel forwards in time.
endmodule
```
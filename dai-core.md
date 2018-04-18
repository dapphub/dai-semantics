DAI-K
=======

This is a K specification of the semantics of the Dai stablecoin. As with any
language or system defined in K, the specification consists of three steps:
syntax, configuration and semantics.

In the case of Dai, the syntax consists of the values and function of the system,
while the configuration specifies the state of the world as it pertains to Dai.
Finally, the semantics is given by a set of rewrites, outlining how the various
functions change the configuration.

## Syntax

We start by defining a module called `DAI-CORE`:

```{.k}
module DAI-CORE
```

## Configuration


## Semantics


A K definition consists of three major parts, often mixed:
syntactic definitions, configuration definitions, and semantic
rules.

## 1 Syntax

### 1.1 Values and Addresses

DAI-K refers to two major types of data: `Value` and `Address`.
We assume that any implementation provides an additional `Bool`
type, or ways to encode it. As we do not wish to make any
assumptions about the blockchain specific implementation
details at this stage, we encode both of these via the K predefined
syntactic category `Int`:

```{.k}
  syntax Value   ::= Int  // can be easily changed
  syntax Address ::= Int  // can be easily changed
  syntax Id      ::= Int  // can be easily changed
  // WHICH OTHER VALUES ARE THERE?
  
```

### 1.2 Main Functions

Below is the syntax for the main Dai functions, split into 
the two syntactic categories `AExp` and `BExp`, for arithmetic
or Boolean expressions respectively.

In practice, `BExp` consists of the actions available in the 
Dai system, while `AExp` consists of getter functions. Note however,
that all arguments of all functions are `AExp`, meaning that syntactically
speaking, arbitrary arithmetic expressions are allowed as arguments of these
functions. See the discussion at [erc20.md](https://github.com/runtimeverification/erc20-semantics/blob/master/erc20.md).

TODO: Provide arguments for the functions. This probably necessitates splitting
them up more categories as well, to improve readability.

```{.k}
  syntax DAISimulation ::= ".DAISimulation"
                         | DAICommand DAISimulation

  rule .DAISimulation => .
  rule DAIC:DAICommand DAIS:DAISimulation => DAIC ~> DAIS

  syntax DAICommand ::= Bool
                      | "frob" "(" AExp "," AExp ")"          [strict]   //  Cater your CDP by either withdrawing or locking up more collateral, pay back or withdraw more DAI
                      | "throw"
        
  syntax AExp ::= Value | Address
  
```

## 2 Configuration

Configurations hold the structure and the data on which the semantic rules
match and apply. At any given moment during its execution, the state of the
defined system or programming language is an instance of the defined
configuration. A configuration consists of a set of potentially nested
*semantic cells*, each cell having a name and containing a specific
kind of semantic information.
We use an XML-like notation to say where a cell starts and where it ends.
The configuration declaration also contains an initial value for each cell.
We first show the entire DAI configuration and then we discuss it:

```{.k}
  configuration <core>
                  <k> $PGM:DAISimulation </k>
                  <caller> 0 </caller>
                  <accounts>
                    <account multiplicity="*">
                      <id> 0 </id>
                      <eth> 0 </eth>
                      <dai> 0 </dai>
                      <eth-collateral> 0 </eth-collateral>
                      <debt> 0 </debt>
                    </account>
                  </accounts>

                  <root> 0 </root>

                  <interestRate> 2 </interestRate>
                  <totalDebt> 0 </totalDebt>
                  <time> 0 </time>
                  <lastTouched> 0 </lastTouched>
                  <liquidationFactor> 0 </liquidationFactor>
                  <lagLimit> 0 </lagLimit>
                  <debtCeiling> 0 </debtCeiling>
                  <accumulator> 1 </accumulator>
                </core>
```
The configuration consists or a top-level cell `<DAI/>`, which
holds the following cells:

The `<k/>` cell holds the computation to be performed by the caller.
The `$PGM:K` variable is replaced with the input program by the K
tools, that is, with the program that we want to execute or whose semantics
we are interested in.

The `<accounts/>` cell holds all the accounts.
Each account is held in a separate `<account/>` cell and identifies with
a unique `<id/>`. Each account has a balance of ether, dai, locked up ether collateral and debt.

The `multiplicity="*"` tag states that there could be zero, one or more
instances of that cell.

## 3 Semantics

DAI was originally implemented for the EVM, whose integers
(of type `uint256`) are unsigned and have `256` bits, so can go up
to `2^256`.
The exact size of integers is important for arithmetic overflow,
which needs to be rigorously defined in the formal specification.
However, the precise size of integers can be a parameter of the
ERC20-K specification.
This way, the specification can easily be used with various execution
environments, such as [eWASM](https://github.com/ewasm/) or 
[IELE](https://github.com/runtimeverification/iele-semantics), or
with various programming languages
(e.g., [Viper](https://github.com/ethereum/viper) appears to converge
towards integers up to `2^128`).
The syntax declaration and the rule below define an integer
constant `MAXVALUE` and initialize it with the largest integer
on 256 bits (one can set it to "infinity" if one does not care about
overflows or if one's computational infrastructure supports unbounded
integers, like
[IELE](https://github.com/runtimeverification/iele-semantics) does):

```{.k}
  syntax Int ::= "MAXVALUE"  [function]
  rule MAXVALUE => 2 ^Int 256 -Int 1
```

The attribute/tag `function` above states that `MAXVALUE`
is to be reduced, or *rewritten*, with its rule above, instantly
wherever it occurs (rewriting of non-function symbols is constrained
by the context).
The suffix `Int` to arithmetic operations indicates that these are
the K builtin operations on its unbounded integers; you can think
of them as the mathematical rather than the machine integer operations.

In K, variables are usually capitalized; `...` is a special variable,
called a *structural frame*, which matches the rest of a sequence, set,
map, cell, etc.  The arrow `=>` indicates that its left-hand-side term
is rewritten to its right-hand-side term.

### 3.1 CDP semantics

We begin with the K interpretation of the following function:

``
frobᵤ Δc Δd = let cᵤ₀=cᵤ dᵤ₀=dᵤ set Cᵤ⤓cᵤ↥Δc Dᵤ↥χ·Δd dᵤ↥Δd Σd↥Δd iff okay
``
where
```
okay = (safe ∨ nice) ∧ (cool ∨ calm) ∧ t ≤ t₀+Θ
safe = cᵤ·Ψ ≥ dᵤ·χ, nice = cᵤ·dᵤ₀ ≥ cᵤ₀·dᵤ, cool = Σd·χ ≤ Ω, calm = Δd ≤ 0
```
The semantics of catering a CDP is split up into a successful case and a failure case.
We begin with the case of a successful deposit/withdrawal of collateral, and simoultaneous 
withdrawal/payback of a loan where (`safe` or `nice`) and (`cool` or `calm`) are both true, and the call 
happens within the allowed lag limit.

TODO: incorporate overflow safety

```{.k}
rule <k> frob(ColDelta, DebtDelta) => true ... </k>
     <caller> Caller </caller>
   
     <account>
       <id> Caller </id>
       <eth> EthBal => EthBal -Int ColDelta </eth>
       <dai> DaiBal => DaiBal +Int DebtDelta *Int Chi </dai>
       <eth-collateral> EthCol => EthCol +Int ColDelta </eth-collateral>
       <debt> Debt => Debt +Int DebtDelta </debt>
     </account>
   
     <accumulator> Chi </accumulator>
     <time> T </time>
     <lastTouched> T0 </lastTouched>
     <totalDebt> TotalDebt => TotalDebt +Int DebtDelta </totalDebt>
     <debtCeiling> Omega </debtCeiling>
     <lagLimit> Theta </lagLimit>
   
  requires (EthCol +Int ColDelta >=Int (Debt +Int DebtDelta) *Int Chi                     // safe
    orBool (EthCol +Int ColDelta) *Int Debt >=Int EthCol *Int (Debt +Int DebtDelta))  // nice
   
   andBool ((TotalDebt +Int DebtDelta) *Int Chi <=Int Omega                           // cool
    orBool DebtDelta <=Int 0)                                                         // calm  
   
   andBool T <=Int T0 +Int Theta

   andBool EthBal >=Int 0
   andBool EthBal -Int ColDelta >=Int 0
   andBool DaiBal >=Int 0
   andBool DaiBal +Int DebtDelta *Int Chi >=Int 0
   andBool EthCol >=Int 0
   andBool EthCol +Int ColDelta >=Int 0
   andBool Debt >=Int 0
   andBool Debt +Int DebtDelta >=Int 0
  
```

If any of these conditions are unmet, the method fails.
```{.k}
rule <k> frob(ColDelta, DebtDelta) => throw ...</k>
     <caller> Caller </caller>
     
     <account>
       <id> Caller </id>
       <eth> EthBal => EthBal -Int ColDelta </eth>
       <dai> DaiBal => DaiBal +Int DebtDelta *Int Chi </dai>
       <eth-collateral> EthCol => EthCol +Int ColDelta </eth-collateral>
       <debt> Debt => Debt +Int DebtDelta </debt>
     </account>
   
     <accumulator> Chi </accumulator>
     <time> T </time>
     <lastTouched> T0 </lastTouched>
     <totalDebt> TotalDebt => TotalDebt +Int DebtDelta </totalDebt>
     <debtCeiling> Omega </debtCeiling>
     <lagLimit> Theta </lagLimit>
   
  requires notBool
           ((EthCol +Int ColDelta >=Int (Debt +Int DebtDelta) *Int Chi                     // safe
    orBool (EthCol +Int ColDelta) *Int Debt >=Int EthCol *Int (Debt +Int DebtDelta))  // nice
   
   andBool ((TotalDebt +Int DebtDelta) *Int Chi <=Int Omega                           // cool
    orBool DebtDelta <=Int 0)                                                         // calm  
   
   andBool T <=Int T0 +Int Theta

   andBool EthBal >=Int 0
   andBool EthBal -Int ColDelta >=Int 0
   andBool DaiBal >=Int 0
   andBool DaiBal +Int DebtDelta *Int Chi >=Int 0
   andBool EthCol >=Int 0
   andBool EthCol +Int ColDelta >=Int 0
   andBool Debt >=Int 0
   andBool Debt +Int DebtDelta >=Int 0)
``` 
```{.k}
endmodule
```
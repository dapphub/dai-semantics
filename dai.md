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

We start by defining a module called `ERC20`:

```{.k}
requires "dai-core.k"

module DAI
  imports DAI-CORE
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
  // WHICH OTHER VALUES ARE THERE? TIME?
  
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
  syntax BExp ::= Bool
                | "open" "(" Id "," Id ")"      [strict]   //  create a new cup (collateralized debt position)
                | "bite"       [strict]   //  initiate liquidation of an undercollateral cup
                | "boom"       [strict]   //  buy some amount of sai to process joy (surplus)
                | "bust"       [strict]   //  sell some amount of sai to process woe (bad debt)
                | "cage"       [strict]   //  lock the system and initiate settlement
                | "cash"       [strict]   //  cash in sai balance for gems after cage
                | "cupi"       [strict]   //  get the last cup id
                | "cups"       [strict]   //  list cups created by you
                | "draw"       [strict]   //  issue the specified amount of sai stablecoins
                | "drip"       [strict]   //  recalculate the internal debt price
                | "exit"       [strict]   //  sell SKR for gems
                | "free"       [strict]   //  remove excess SKR collateral from a cup
                | "give"       [strict]   //  transfer ownership of a cup
                | "heal"       [strict]   //  cancel debt
                | "help"       [strict]   //  print help about sai(1) or one of its subcommands
                | "join"       [strict]   //  buy SKR for gems
                | "lock"       [strict]   //  post additional SKR collateral to a cup
                | "prod"       [strict]   //  recalculate the accrued holder fee (par)
                | "safe"       [strict]   //  determine if a cup is safe
                | "setAxe"     [strict]   //  update the liquidation penalty
                | "setFee"     [strict]   //  update the governance fee
                | "setCap"     [strict]   //  update the debt ceiling
                | "setMat"     [strict]   //  update the liquidation ratio
                | "setTapGap"  [strict]   //  update the spread on `boom` and `bust`
                | "setTax"     [strict]   //  update the stability fee
                | "setTubGap"  [strict]   //  update the spread on `join` and `exit`
                | "setWay"     [strict]   //  update the holder fee (interest rate)
                | "shut"       [strict]   //  close a cup
                | "vent"       [strict]   //  process a caged tub
                | "wipe"        [strict]   //  repay some portion of your existing sai debt
                | "throw"
				
  syntax AExp ::= Value | Address
                | "air"           //  get the amount of backing collateral
                | "axe"           //  get the liquidation penalty
                | "caged"         //  get time of cage event (= 0 if system is not caged)
                | "chi"           //  get the internal debt price
                | "cup"           //  show the cup info
                | "fee"           //  get the governance fee
                | "fit"           //  get the gem per skr settlement price
                | "fix"           //  get the gem per sai settlement price
                | "fog"           //  get the amount of skr pending liquidation
				        | "gem"           //  get the collateral token
                | "gov"           //  get the governance token
                | "cap"           //  get the debt ceiling
                | "ice"           //  get the good debt
                | "ink"           //  get the amount of skr collateral locked in a cup
                | "joy"           //  get the amount of surplus sai
                | "lad"           //  get the owner of a cup
                | "mat"           //  get the liquidation ratio
                | "off"           //  get the cage flag
                | "out"           //  get the post cage exit flag
                | "par"           //  get the accrued holder fee (ref per sai)
                | "per"           //  get the current entry price (gem per skr)
                | "pie"           //  get the amount of raw collateral
                | "pep"           //  get the gov price feed
                | "pip"           //  get the gem price feed
                | "pit"           //  get the liquidator vault
                | "rap"           //  get the amount of governance debt in a cup
                | "ray"           //  parse and display a 27-decimal fixed-point number
                | "rho"           //  get the time of last drip
                | "rhi"           //  get the internal debt price (governance included)
                | "s2s"           //  get the skr per sai rate (for boom and bust)
                | "sai"           //  get the sai token
                | "sin"           //  get the sin token
                | "skr"           //  get the skr token
                | "tab"           //  get the amount of debt in a cup
                | "tag"           //  get the reference price (ref per skr)
                | "tapAsk"        //  get the amount of skr in sai for bust
                | "tapBid"        //  get the amount of skr in sai for boom
                | "tapGap"        //  get the spread on `boom` and `bust`
                | "tau"           //  get the time of last prod
                | "tax"           //  get the stability fee
                | "tubAsk"        //  get the amount of skr in gem for join
                | "tubBid"        //  get the amount of skr in gem for exit
                | "tubGap"        //  get the spread on `join` and `exit`
                | "vox"           //  get the target price engine
                | "wad"           //  parse and display a 18-decimal fixed-point number
                | "way"           //  get the holder fee (interest rate)
                | "woe"           //  get the amount of bad debt

```

### 1.3 Events

## 2 Configuration

Configurations hold the structure and the data on which 
the semantic rules match and apply.
At any given moment during its execution, the state of the defined
system or programming language is an instance of the defined
configuration.
A configuration consists of a set of potentially nested
*semantic cells*, each cell having a name and containing a specific
kind of semantic information.
We use an XML-like notation to say where a cell starts and where it ends.
The configuration declaration also contains an initial value for each cell.
We first show the entire ERC20 configuration and then we discuss it:

```{.k}
  configuration <DAI>
  				        <vox> 
	         				  <wut> 0 </wut>
	         				  <par> 0 </par>
	         				  <way> 0 </way>
	         				  <how> 0 </how>
	         				  <tau> 0 </tau>
	         			  </vox>
				  
				          //<era> /*TODO*/ </era>
				          //<mode> /*TODO*/ </mode>

                  //<accounts>
                  //  <account multiplicity="*">
                  //    <id> 0 </id>
                  //    <balances multiplicity="*"> 
					        //     <id> 0 </id>                // Token identifier
					       	//    <balance> 0 </balance>
					        //   </balances>
                  //  </account>
                  //</accounts>
                          		  
				          <urns>
				            <urn multiplicity="*">
					            <id> 0 </id>
					            <ilk-id> 0 </ilk-id>
					            <lad> 0 </lad>
					            <art> 0 </art>
					            <ink> 0 </ink>
					            <cat multiplicity="*">     //Better would be if there was a multiplicity feature stating that there can be at most one such cell
					              <id> 0 </id>
					            </cat>
				            </urn>
				          </urns>
				  
				          //<ilks>
				          //  <ilk multiplicity="*">
					        //  //TODO
					        //  </ilk>
				          //</ilks>

	                //<tags>
				          //  <tag multiplicity="*">
					        //  //TODO
					        //  </tag>
				          //</tags>
				          
                  //<log> Events: </log>
                </DAI>
```
The configuration consists or a top-level cell `<DAI/>`, which
holds the following cells:

The `<k/>` cell holds the computation to be performed by the caller.
The `$PGM:K` variable is replaced with the input program by the K
tools, that is, with the program that we want to execute or whose semantics
we are interested in.

The `<vox/>` cell hols the feedback mechanism record:
The feedback mechanism is the aspect of the system that adjusts the target price of dai based on market price. Its data is grouped in a record called Vox, consisting of...

The `<accounts/>` cell holds all the accounts.
Each account is held in a separate `<account/>` cell and identifies with
a unique `<id/>` and can have balances in multiple currencies.

The `multiplicity="*"` tag states that there could be zero, one or more
instances of that cell.

The `<urns>` cell holds all CDPs. In Maker jargon, the record keeping track of a CDP
is called an Urn. An Urn consists of:
TODO


The `<ilks>` cell holds all ilks. 
An ilk is a record keeps track of one CDP type, consisting of:
TODO

The `<log/>` cell holds and `EventLog` term, that is, a sequence of `Event`s.
Newly generated events are appended at the end of the log.

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

### 3.1 open (success)

We start with the semantics of `open`:
```{.k}
  rule <k> open(IdUrn, IdIlk) => true ... </k>
       //<ilk>
       //  <id> IdIlk </id> /*TODO*/
       //</ilk>
	     //<urns>
       //  ... => <urn> <id> IdIlk </id> /*TODO*/ </urn> 
			 //</urns>   
```
The rule above involves two cells, `<ilk/>` and `<supply/>`, and matches
`totalSupply()` as the first task in the `</k>` cell and the contents
of the `<supply/>` cell in the `Total` variable.
In K, variables are usually capitalized; `...` is a special variable,
called a *structural frame*, which matches the rest of a sequence, set,
map, cell, etc.  The arrow `=>` indicates that its left-hand-side term
is rewritten to its right-hand-side term.
```{.k}
endmodule
```
TODO: 

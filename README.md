DAI-K: Formal Executable Specification of the Dai stablecoin system
===================================================================


## Plan

To formally verify the correctness of the Dai stablecoin ecosystem, 
we follow the strategy employed by Runtime Verfication to prove the
correctness of the [ERC20 standard](https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md) using the [K framework](http://kframework.org).

The process consists of the following steps;

We construct a high level, *formal executable semantics* of the Dai 
stablecoin in [dai.md](dai.md). The specification defines the actions and 
state relevant to the Dai system independent of any particular blockchain 
implementation. Compare with [ERC20-K](https://github.com/runtimeverification/erc20-semantics/blob/master/erc20.md) or the [Dai purple paper](https://makerdao.com/purple/).

We refine the specification to an EVM-specific semantics at [dai-evm.md](dai-evm.md), 
outlining where and how state parameters are stored and encodes the actions
according to the [Ethereum contract ABI](https://solidity.readthedocs.io/en/develop/abi-spec.html). This specification is written in eDSL and yields a suite of verifiable
claims which can then be checked against a particular EVM bytecode implementation
and proven correct with K's built in automated theorem prover.
Compare with [ERC20-EVM](https://github.com/runtimeverification/verified-smart-contracts/blob/ds-token-verified/resources/erc20-evm.md).

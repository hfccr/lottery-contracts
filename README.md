# Lottery

This is a simple lottery contract repo. `./src/Lottery.sol` contains code for a simple lottery contract.

## Local Development With NextJS Frontend

Open a terminal and start a local hardhat node

```shell
npx hardhat node
```

Open another terminal and deploy the lottery contract on the local hardhat node

```shell
npx hardhat ignition deploy ./ignition/modules/Lottery.ts --network localhost
```

You can test your lottery contract using `npx hardhat test`

# Lottery

This is a simple lottery contract repo. `./src/Lottery.sol` contains code for a simple lottery contract.

## Configuration

To deploy the lottery contract on sepoila, the following variables are to be configured in `.env` file,

```env
PROVIDER_URL=https://sepoliaprovider.com
PRIVATE_KEY=asdf
```

## Testnet Deployment

Lottery contract has been deployed on Sepolia testnet at `0x61E82F00902f01dDA64cfC77bce973F6b21EFf1E`.

Deployement has been made using the following command,

```shell
npx hardhat ignition deploy ./ignition/modules/Lottery.ts --network sepolia
```

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

### Tasks

Enter the lottery using hardhat accounts

```shell
npx hardhat enterLottery --network localhost
```

Draw the lottery

```shell
npx hardhat drawLottery --network localhost
```


import { HardhatUserConfig, task } from "hardhat/config";
import { Lottery } from "./typechain-types";
import "@nomicfoundation/hardhat-toolbox";

const config: HardhatUserConfig = {
  solidity: "0.8.24",
};

task("enterLottery", "Enters 5 accounts in lottery", async (taskArgs, hre) => {
  const accounts = await hre.ethers.getSigners();
  const LotteryContract = await hre.ethers.getContractFactory("Lottery");
  const lottery = LotteryContract.attach(
    "0x5FbDB2315678afecb367f032d93F642f64180aa3"
  ) as Lottery;

  for (const account of accounts.slice(0, 5)) {
    try {
      const tx = await lottery.connect(account).enter({
        value: hre.ethers.parseEther("0.000015"),
      });
      await tx.wait();
    } catch (e) {
      console.log(e);
    }
  }
});

task("drawLottery", "Draws the lottery", async (taskArgs, hre) => {
  const accounts = await hre.ethers.getSigners();
  const LotteryContract = await hre.ethers.getContractFactory("Lottery");
  const lottery = LotteryContract.attach(
    "0x5FbDB2315678afecb367f032d93F642f64180aa3"
  ) as Lottery;
  const tx = await lottery.connect(accounts[0]).endLottery();
  await tx.wait();
});

export default config;

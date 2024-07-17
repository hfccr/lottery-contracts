import { loadFixture } from "@nomicfoundation/hardhat-toolbox/network-helpers";
import { expect } from "chai";
import hre, { ethers } from "hardhat";

describe("Lottery", function () {
  async function deployLottery() {
    const [owner, player1, player2, player3, player4, player5] =
      await hre.ethers.getSigners();
    const Lottery = await hre.ethers.getContractFactory("Lottery");
    const lottery = await Lottery.deploy();
    return {
      lottery,
      owner,
      player1,
      player2,
      player3,
      player4,
      player5,
    };
  }

  describe("Deployment", function () {
    it("Should set the right parameters", async function () {
      const { lottery, owner } = await loadFixture(deployLottery);
      expect(await lottery.owner()).to.equal(owner.address);
      expect(await lottery.maxParticipants()).to.equal(10);
      expect(await lottery.minParticipants()).to.equal(5);
      expect(await lottery.winnerCount()).to.equal(3);
      expect(await lottery.entryFee()).to.equal(ethers.parseEther("0.000015"));
      expect(await lottery.lotteryOpen()).to.equal(true);
    });
  });
});

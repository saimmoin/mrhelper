// scripts/create-box.js
const { ethers, upgrades } = require("hardhat");
const signerWithBalance = require("./utils.js");

async function main() {
  const signer = await signerWithBalance();
  const factoryAddress = "0xcBa96A9fb390C84293A8535aa5D829167A155618"; //mumbai
  const HelperFactory = await ethers.getContractFactory("HelperFactory");
  const helperFactory = await HelperFactory.attach(factoryAddress);
  console.log("helperFactory", helperFactory.address);
  console.log("read function", await helperFactory.getHelperAddress(signer.address));

  //call createHelper
  const args = {
    amount: ethers.utils.parseEther("0.001"),
    duration: 86400, //1day
    recipient: signer.address,
    description: "test1",
  };
  // const deployedHelper = await helperFactory.createHelper(args.amount, args.duration, args.recipient, args.description);
  // await deployedHelper.wait();
  // console.log("deployedHelper", deployedHelper);
}

(async () => {
  try {
    await main();
  } catch (error) {
    console.log(error);
  }
})();

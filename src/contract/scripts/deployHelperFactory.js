// scripts/create-box.js
const { ethers, upgrades } = require("hardhat");
const signerWithBalance = require("./utils.js");

async function main() {
  const signer = await signerWithBalance();

  const HelperFactory = await ethers.getContractFactory("HelperFactory");
  const helperFactory = await HelperFactory.deploy();
  await helperFactory.deployed();
  console.log("HelperFactory Contract Address", helperFactory.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });

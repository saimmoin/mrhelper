async function signerWithBalance() {
  const [signer] = await ethers.getSigners();
  const balance = await signer.getBalance();
  console.log(signer.address, "Account balance:", ethers.utils.formatEther(balance).toString());
  return signer;
}

module.exports = signerWithBalance;

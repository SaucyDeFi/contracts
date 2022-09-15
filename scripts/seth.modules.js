require("@nomiclabs/hardhat-waffle");

/**
 * @note Deploy the sETH contract
 */
async function deploy(args) {
  const [deployer] = await ethers.getSigners();
  console.log("Deploying contracts with the account:", deployer.address);
  console.log("Account balance:", (await deployer.getBalance()).toString());
  const factory = await ethers.getContractFactory("SETH");
  const sETH = await factory.deploy(args.name, args.symbol, args.decimals);
  console.log("sETH contract address", sETH.address);
  saveFrontendFiles(sETH, "SETH");
}

/**
 * @note Save contract JSON data
 */
function saveFrontendFiles(contract, name) {
  const fs = require("fs");
  const contractsDir = __dirname + "/../json";
  if (!fs.existsSync(contractsDir)) {
    fs.mkdirSync(contractsDir);
  }
  fs.writeFileSync(
    contractsDir + `/${name}-address.json`,
    JSON.stringify({ address: contract.address }, undefined, 2)
  );
  const contractArtifact = artifacts.readArtifactSync(name);
  fs.writeFileSync(
    contractsDir + `/${name}.json`,
    JSON.stringify(contractArtifact, null, 2)
  );
}

module.exports = { deploy };

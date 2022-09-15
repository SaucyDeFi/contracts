const sETH = require("./seth.modules.js");

/**
 * @note Deploy the sETH contract
 */
sETH
  .deploy({
    name: "Staked Ether",
    symbol: "sETH",
    decimals: 18,
  })
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });

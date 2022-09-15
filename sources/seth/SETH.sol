// SPDX-License-Identifier: GPL-3.0
pragma solidity =0.4.18;

/**
 * @notice sETH wrapper for ETH
 */
contract SETH {
  string public name     = "Staked Ether";
  string public symbol   = "sETH";
  uint8  public decimals = 18;

  /**
   * @notice Constructor
   * @param _name Name of the token
   * @param _symbol Symbol of the token
   * @param _decimals Decimals of the token
   */
  function SETH(
    string _name,
    string _symbol,
    uint8 _decimals
  ) {
    name = _name;
    symbol = _symbol;
    decimals = _decimals;
  }

  /**
   * @notice Events
   */
  event Approval(address indexed src, address indexed wallet, uint256 value);
  event Transfer(address indexed src, address indexed dst, uint256 value);
  event Deposit(address indexed dst, uint256 value);
  event Withdrawal(address indexed src, uint256 value);

  /**
   * @notice Map balances and allowances
   */
  mapping(address => uint256) public balanceOf;
  mapping(address => mapping(address => uint256)) public allowance;

  /**
   * @notice Fall back function
   * @dev Is a payable function
   */
  function() public payable {
    deposit();
  }

  /**
   * @notice Accept payments in ETH
   * @dev Is a payable function
   */
  function deposit() public payable {
    balanceOf[msg.sender] += msg.value;
    Deposit(msg.sender, msg.value);
  }

  /**
   * @notice Withdraw ETH in exchange for sETH
   * @dev Is a payable function
   * @dev Requires sender has enough sETH
   * @dev Deducts sETH from sender balance
   * @dev Transfers ETH to sender
   */
  function withdraw(uint256 value) public {
    require(balanceOf[msg.sender] >= value);
    balanceOf[msg.sender] -= value;
    msg.sender.transfer(value);
    Withdrawal(msg.sender, value);
  }

  /**
   * @notice Get the total supply of sETH
   * @dev The will always equal the ETH balance of the contract
   */
  function totalSupply() public view returns (uint256) {
    return this.balance;
  }

  /**
   * @notice Approve an address to spend sETH on your behalf
   */
  function approve(address wallet, uint256 value) public returns (bool) {
    allowance[msg.sender][wallet] = value;
    Approval(msg.sender, wallet, value);
    return true;
  }

  /**
   * @notice Transfer sETH
   * @dev {transfer} calls {transferFrom}
   */
  function transfer(address dst, uint256 value) public returns (bool) {
    return transferFrom(msg.sender, dst, value);
  }

  /**
   * @notice Transfer sETH on behalf of another address
   * @dev Requires balance and allowance to be greater than or equal to value
   */
  function transferFrom(
    address src,
    address dst,
    uint256 value
  ) public returns (bool) {
    require(balanceOf[src] >= value);
    if (src != msg.sender && allowance[src][msg.sender] != uint256(-1)) {
      require(allowance[src][msg.sender] >= value);
      allowance[src][msg.sender] -= value;
    }
    balanceOf[src] -= value;
    balanceOf[dst] += value;
    Transfer(src, dst, value);
    return true;
  }
}

//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IERC20 {
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );

    function totalSupply() external view returns (uint256);

    function balanceOf(address account) external view returns (uint256);

    function transfer(address to, uint256 amount) external returns (bool);

    function allowance(
        address owner,
        address spender
    ) external view returns (uint256);

    function approve(address spender, uint256 amount) external returns (bool);

    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) external returns (bool);
}

contract EVM20 {
    string public p; // BNB20
    string public op; // deploy
    string public tick; // tick name
    uint256 public max; // max supply
    uint256 public lim; // lim of hodler
    uint256 public id; // id

    // WBNB/WBNB...
    IERC20 public WBNB;
    // mint users
    address[] users;

    // address => lim number
    mapping(address => uint256) LIMbalance;
    // address => uint[] number
    mapping(address => uint256[]) IDblance;
    // valid user
    mapping(address => bool) isValidUser;

    event EVMmint(
        string p,
        string op,
        string tick,
        uint256 id,
        uint256 amount,
        string inscription
    );
    event EVMtransfer(
        string p,
        string op,
        string tick,
        uint256 id,
        uint256 amount,
        string inscription
    );

    constructor() {
        p = "BNB-20"; // default p
        op = "deploy"; // default op
        tick = "INSCRIPTION_NAME"; // inscription name
        max = 21000000;
        lim = 1000;
        id = 0;

        WBNB = IERC20(address(0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c));
    }

    function mint(
        address _to,
        string calldata _inscription
    ) external returns (bool) {
        if (id >= (max / lim)) revert("Mint has ended");
        if (_to != msg.sender) revert("Mint has User");

        bool success = WBNB.transfer(_to, 0);

        id += 1; //Every casting will make id+1
        LIMbalance[msg.sender] += lim; //Increase holdings
        IDblance[msg.sender].push(id); //Increase the number of IDs held

        if (!isValidUser[msg.sender]) {
            isValidUser[msg.sender] = true;
            users.push(msg.sender);
        }

        emit EVMmint("bnb-20", "mint", tick, id, lim, _inscription);
        return success;
    }

    function transfer(
        address _to,
        string calldata _inscription
    ) external returns (bool) {
        // The transfer address cannot be empty
        if (_to == address(0)) revert("The address cannot be empty");
        // The quantity owned must meet the minimum quantity of lim
        if (LIMbalance[msg.sender] < lim) revert("The balance cannot be 0");

        bool success = WBNB.transfer(_to, 0);

        LIMbalance[msg.sender] -= lim; //Reduced number of lims owned
        LIMbalance[_to] += lim; //Increase in number of recipients

        //Send the inscri[ption to the recipient
        uint256 _toID = IDblance[msg.sender][IDblance[msg.sender].length - 1];
        IDblance[_to].push(_toID);

        emit EVMtransfer("bnb-20", "transfer", tick, id, lim, _inscription);
        return success;
    }

    //Query lim balance ie. how many minting oppotunity left
    function LIMbalanceOf(address _address) external view returns (uint256) {
        return LIMbalance[_address];
    }

    // Query ID balance
    function IDblanceOf(
        address _address
    ) external view returns (uint256[] memory) {
        return IDblance[_address];
    }

    function usersOf() external view returns (address[] memory) {
        return users;
    }
}

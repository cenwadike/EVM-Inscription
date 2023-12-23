//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract EVM20 {
    string public p; // EVM20
    string public op; // deploy
    string public tick; // tick name
    uint256 public max; // max supply
    uint256 public lim; // lim of hodler
    uint256 public id; // inscription id

    address[] minters;

    // address => lim number
    mapping(address => uint256) LIMbalance;
    // single holder for multiple inscriptions
    // address => [ids]
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
        p = "EVM-20";
        op = "deploy";
        tick = "TICK_NAME";
        max = 21000000;
        lim = 1000;
        id = 0;
    }

    function mint(string calldata _inscription) external returns (bool) {
        if (id >= (max / lim)) revert("Mint has ended");

        LIMbalance[msg.sender] += lim; //Increase holdings
        IDblance[msg.sender].push(id); //Increase the number of IDs held

        if (!isValidUser[msg.sender]) {
            isValidUser[msg.sender] = true;
            minters.push(msg.sender);
        }

        id += 1;

        emit EVMmint("EVM-20", "mint", tick, id, lim, _inscription);
        return true;
    }

    function transfer(
        address _to,
        string calldata _inscription
    ) external returns (bool) {
        if (_to == address(0)) revert("can not transfer to zero address");
        if (LIMbalance[msg.sender] < lim)
            revert("You do not own any inscription");

        LIMbalance[msg.sender] -= lim; // reduce amount inscriptions owned by sender
        LIMbalance[_to] += lim; // increase amount inscriptions owned by recipients

        // transfer last inscription from sender to recipient
        uint256 _toID = IDblance[msg.sender][IDblance[msg.sender].length - 1];
        IDblance[_to].push(_toID);

        emit EVMtransfer("EVM-20", "transfer", tick, id, lim, _inscription);
        return true;
    }

    // get how many inscriptions left to mint
    function LIMbalanceOf() external view returns (uint256) {
        uint256 inscriptions_left = lim - id;
        return inscriptions_left;
    }

    // Query ID balance
    function IDblanceOf(
        address _address
    ) external view returns (uint256[] memory) {
        return IDblance[_address];
    }

    // get minters
    function get_minters() external view returns (address[] memory) {
        return minters;
    }

    //TODO: get minters and their inscriptiom
}

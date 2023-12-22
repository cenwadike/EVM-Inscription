# EVM20 Contract 

Playing with Inscriptions as Smart Contracts on BNB chain

Spamming the blockchain network for the fun of it!!🔥🔥

## mint function

```js
    function mint(address _to, string calldata _inscription) external returns (bool) {
        if (id >= (max / lim)) revert("Mint has ended");
        if (_to != msg.sender) revert("Mint has User");

        bool success = WBNB.transfer(_to, 0);

        id += 1; // guard minting

        //Increase holdings
        LIMbalance[msg.sender] += lim; 
        IDblance[msg.sender].push(id);

        if (!isValidUser[msg.sender]) {
            isValidUser[msg.sender] = true;
            users.push(msg.sender);
        }

        emit EVMmint("bnb-20", "mint", tick, id, lim, _inscription);
        return success;
    }
```

## transfer function

```js
    function transfer(address _to, string calldata _inscription) external returns (bool) {
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
```

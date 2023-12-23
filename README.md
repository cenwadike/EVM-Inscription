# EVM20 Contract

Playing with Inscriptions as Smart Contracts on EVM chains

Spamming the blockchain network for the fun of it!!🔥🔥

## mint function

```js
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
```

## transfer function

```js
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
```

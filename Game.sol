// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";


contract DegenToken is ERC20, Ownable, ERC20Burnable {
    struct ShopItem {
            string name;
            uint256 price;
            uint256 totalSupply;
    }

    ShopItem[] public shopItems;

    constructor() ERC20("Degen", "DGN") Ownable(msg.sender) {
        shopItems.push(ShopItem("Mansion", 5000, 1));
        shopItems.push(ShopItem("House", 500, 10)); 
        shopItems.push(ShopItem("Apartment", 50, 100));  
        shopItems.push(ShopItem("Sleeping bag", 5, 1000));  
    }

    function mintNewToken(address to, uint256 value) external onlyOwner {
        _mint(to, value);
    }

    function transferToken(address _receiver, uint256 _value) external {
        require(_receiver != address(0), "Invalid address");
        require(balanceOf(msg.sender) >= _value, "Insufficient funds!");
        _transfer(msg.sender, _receiver, _value);
    }

    event RedeemAttempt(address indexed sender, uint256 itemIndex, uint256 balance);
    function redeemTokens(uint256 _itemIndex) external payable {
        emit RedeemAttempt(msg.sender, _itemIndex, balanceOf(msg.sender));

        require(_itemIndex < shopItems.length, "Item does not exist!");
        ShopItem storage item = shopItems[_itemIndex];

        require(item.totalSupply > 0, "Item is out of stock!");
        uint256 itemPrice = item.price;

        require(itemPrice <= balanceOf(msg.sender), "Insufficient funds!");
        _burn(msg.sender, itemPrice);
        item.totalSupply--;
    }

    function checkTokenBalance(address _account) external view returns (uint256) {
        return balanceOf(_account);
    }

    function burnToken(uint256 _value) external {
        require(balanceOf(msg.sender) >= _value, "Insufficient funds!");
        _burn(msg.sender, _value);
    }
}
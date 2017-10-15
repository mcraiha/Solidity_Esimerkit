pragma solidity ^0.4.0;
contract SingleBuyItem
{
    bool canBeBought;
    uint priceOfItemInWei;
    string itemDescription;
    string buyerAdditionalIdentifier;
    
    function SingleBuyItem(uint price, string description) public payable
    {
        canBeBought = true;
        priceOfItemInWei = price;
        itemDescription = description;
    }
    
    function TryToBuyItem(string additionalIdentifier) public payable
    {
        require(canBeBought == true);
        require(msg.value == priceOfItemInWei);
        
        canBeBought = false;
        buyerAdditionalIdentifier = additionalIdentifier;
    }
}
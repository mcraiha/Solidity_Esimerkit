pragma solidity ^0.4.0;
contract MultiBuyItem
{
    uint private priceOfItemInWei;
    bytes32 private itemDescription;
    bytes32[] private buyerAdditionalIdentifiers;
    uint private howManyWillBeSold;
    
    function MultiBuyItem(uint price, bytes32 description, uint howManyToSell) public payable
    {
        require(howManyToSell > 0);
        
        priceOfItemInWei = price;
        itemDescription = description;
        howManyWillBeSold = howManyToSell;
    }
    
    function TryToBuySingleItem(bytes32 additionalIdentifier) public payable
    {
        require(buyerAdditionalIdentifiers.length < howManyWillBeSold);
        require(msg.value == priceOfItemInWei);
        
        buyerAdditionalIdentifiers.push(additionalIdentifier);
    }
    
    function GetCanBeBought() public view returns (bool)
    {
        return buyerAdditionalIdentifiers.length < howManyWillBeSold;
    }
    
    function GetPriceOfItemInWei() public view returns (uint)
    {
        return priceOfItemInWei;
    }
    
    function GetItemDescription() public view returns (bytes32)
    {
        return itemDescription;
    }
    
    function GetBuyerAdditionalIdentifier(uint buyerNumber) public view returns (bytes32)
    {
        require(buyerNumber < buyerAdditionalIdentifiers.length);
        
        return buyerAdditionalIdentifiers[buyerNumber];
    }
}
pragma solidity ^0.4.0;
contract SingleBuyItemAdvanced
{
    bool private canBeBought;
    uint private priceOfItemInWei;
    bytes32 private itemDescription;
    bytes32 private buyerAdditionalIdentifier;
    
    // Tämä on kommentti
    function SingleBuyItemAdvanced(uint price, bytes32 description) public payable
    {
        canBeBought = true;
        priceOfItemInWei = price;
        itemDescription = description;
    }
    
    function TryToBuyItem(bytes32 additionalIdentifier) public payable
    {
        require(canBeBought == true);
        require(msg.value == priceOfItemInWei);
        
        canBeBought = false;
        buyerAdditionalIdentifier = additionalIdentifier;
    }
    
    function GetCanBeBought() public view returns (bool)
    {
        return canBeBought;
    }
    
    function GetPriceOfItemInWei() public view returns (uint)
    {
        return priceOfItemInWei;
    }
    
    function GetItemDescription() public view returns (bytes32)
    {
        return itemDescription;
    }
    
    function GetBuyerAdditionalIdentifier() public view returns (bytes32)
    {
        return buyerAdditionalIdentifier;
    }
}
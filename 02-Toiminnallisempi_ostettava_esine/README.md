# Toiminnallisempi ostettava esine
[Ensimmäisessä esimerkissä](../01-Yksinkertainen_ostettava_esine/README.md) tutustuimme yksinkertaiseen ostettavaan esineeseen. Tässä toisessa esimerkissä muokkaamme tätä yksinkertaista toteutusta hieman, jotta saamme siihen hieman lisää toiminnallisuutta.

## Koodiesimerkin läpikäynti
Kooditiedosto eli [SingleBuyItemAdvanced.sol](SingleBuyItemAdvanced.sol) on ilman kommentteja, joten kannattaa tutustua siihen alla olevan esittelyn avulla.

### Muuttujat
Edellisen esimerkin neljään muuttujaan on tehty muutoksia, sillä niiden näkyvyys on muutettu **private**-tasolle. Private-taso ei vaikuta muuttujien näkyvyyteen lohkoketjussa, joten niiden arvot ovat edelleen sieltä kaikkien luettavissa. Muutoksen tarkoituksena on kuitenkin kertoa lohkoketjun ohjelmoijille, ettei SingleBuyItemAdvanced-luokan muuttujia voi enää käyttää suoraan Smart contract -ohjelmissa.

Lisäksi **string**-tyyppiset muuttujat on vaihdettu **bytes32**-tyyppisiksi, jotta [gas](http://solidity.readthedocs.io/en/develop/introduction-to-smart-contracts.html?highlight=gas#gas)-maksut saadaan tasaisemmaksi, kun muuttujat vievät aina saman verran muistia ja suoritusaikaa virtuaalikoneessa.
```
bool private canBeBought;
uint private priceOfItemInWei;
bytes32 private itemDescription;
bytes32 private buyerAdditionalIdentifier;
```

### Rakentaja
Rakentajassa ainoa muutos on description-muuttujan muuttaminen bytes32-tyyppiseksi.
```
function SingleBuyItemAdvanced(uint price, bytes32 description) public payable
```

### Ydintoteutus eli oston tekeminen
Ostoon on tehty rakentajan tavoin string -> bytes32 -muunnos.
```
function TryToBuyItem(bytes32 additionalIdentifier) public payable
```

### Getterit
Jokaiselle muuttujalle on nyt laitettu erilliset getterit. Ne ovat kaikki public-näkyvyydellä, joten kaikki halukkaat voivat hyödyntää niitä. Samalla kerrotaan **returns**-avainsanan yhteydessä kyseisen funktion [palauttaman paluuarvon tyyppi](http://solidity.readthedocs.io/en/develop/control-structures.html?highlight=returns#output-parameters).

Lisäksi ne on varustettu **view**-määrityksellä, joka [takaa tulevaisuudessa](http://solidity.readthedocs.io/en/develop/miscellaneous.html?highlight=view#modifiers) etteivät kyseiset funktiokutsut muuta olion sisäistä tilaa. Tällä on tarkoitus estää ohjelmointivirheitä ja antaa samalla tarkempi rajapintakuvaus luokasta.
```
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
```

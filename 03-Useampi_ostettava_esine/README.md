# Useampi ostettava esine samassa sopimuksessa
[Ensimmäisessä esimerkissä](../01-Yksinkertainen_ostettava_esine/README.md) ja [Toisessa esimerkissä](../02-Toiminnallisempi_ostettava_esine/README.md) tutustuttiin yksittäisiin ostettaviin esineisiin. Tässä esimerkissä yhteen sopimukseen sisällytetään useampi samanlainen ostettavissa oleva esine, jolloin jokaiselle esineelle ei tarvitse tehdä omaa sopimusta.

## Koodiesimerkin läpikäynti
Kooditiedosto eli [MultiBuyItem.sol](MultiBuyItem.sol) on ilman kommentteja, joten kannattaa tutustua siihen alla olevan esittelyn avulla.

### Muuttujat
Edellisen esimerkin neljään muuttujaan on tehty muutoksia, ja nyt ostajien antamat tiedot (**buyerAdditionalIdentifiers**) kootaan yhteen dynaamiseen listaan. Oston salliva muuttuja on korvattu muuttujalla (**howManyWillBeSold**) joka pitää kirjaa siitä kuinka monta esinettä on kokonaisuudessaan ostettavissa.
```
uint private priceOfItemInWei;
bytes32 private itemDescription;
bytes32[] private buyerAdditionalIdentifiers;
uint private howManyWillBeSold;
```

### Rakentaja
Rakentajassa muutoksia on tehty parametreihin, joita on nyt kolme. Uutena ostettavissa olevien esineiden määrän rajoittava **howManyToSell**. Rakentajassa myös tarkistetaan, että myyntiin tulee vähintään yksi esine, koska nollan esineen myynnissä ei ole järkeä.
```
function MultiBuyItem(uint price, bytes32 description, uint howManyToSell) public payable
{
	require(howManyToSell > 0);
	
	priceOfItemInWei = price;
	itemDescription = description;
	howManyWillBeSold = howManyToSell;
}
```

### Ydintoteutus eli oston tekeminen
Ostoon on tehty vain pieni muutos, joka tarkistaa ettei esineitä ole vielä myyty loppuun. (Dynaamisen) listan pituus tarkistetaan **.length**-kutsulla, joka palauttaa pituuden **uint**-tyyppisenä.
```
require(buyerAdditionalIdentifiers.length < howManyWillBeSold);
```

### Getterit
Gettereiden osalta muutoksia on tehty kahteen kohtaan. Onko esine vielä myytävissä kyselyyn (**GetCanBeBought**) on tehty oston tavoin muutos, jossa tarkistellaan jo ostettujen esineiden määrää.
```
function GetCanBeBought() public view returns (bool)
{
	return buyerAdditionalIdentifiers.length < howManyWillBeSold;
}
```

**GetBuyerAdditionalIdentifier** vaatii jatkossa parametriksi ostajan indeksinumeron, jotta ostajan antama lisätieto saadaan kaivettua esiin. Monien muiden ohjelmointikielten tavoin listojen indeksointi alkaa nollasta, joten ensimmäisen ostajan tieto löytyy indeksillä 0 ja toisen ostajan tieto indeksillä 1. Jos koetetaan hakea olemattoman oston tietoja niin vanha tuttu **require** pysäyttää tällaisen luvattoman toiminnan heti alkuunsa.
```
function GetBuyerAdditionalIdentifier(uint buyerNumber) public view returns (bytes32)
{
	require(buyerNumber < buyerAdditionalIdentifiers.length);
	
	return buyerAdditionalIdentifiers[buyerNumber];
}
```
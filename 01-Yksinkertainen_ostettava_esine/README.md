# Yksinkertainen ostettava esine
Tässä ensimmäisessä esimerkissä käsittelyssä on nimensä mukaisesti yksinkertainen ostetava esine. Tämä siis tarkoittaa joku voi laittaa liikkeelle yksittäisen ostettavan esineen, jonka kuka tahansa voi sitten ostaa itselleen Ethereumilla.

Selvennykseksi esine ei tässä tapauksessa ole fyysinen tai virtuaalinen, vaan se on asia joka on vain kirjattu talteen. esim. esineen antaminen pelaajalle pelissä ei siis tapahdu tämän kautta, vaan ostaessaan esineen pelaaja vain kirjataan tietyn esineen omistajaksi.

Esimerkki ei ole optimaalinen, mutta sitä hiotaan ja parannetaan tulevissa osissa.

## Koodiesimerkin läpikäynti
Kooditiedosto eli [SingleBuyItem.sol](SingleBuyItem.sol) on ilman kommentteja, joten kannattaa tutustua siihen alla olevan esittelyn avulla.

### Pragma eli versionumerovaatimus
Ensimmäisellä rivillä on [Version Pragma](http://solidity.readthedocs.io/en/develop/layout-of-source-files.html#version-pragma), jonka avulla rajoitetaan koodin toimivuus tiettyihin kääntäjäversioihin. Tämä siksi, että tulevaisuudessa saatetaan Solidityyn tehdä muutoksia, jotka saattavat rikkoa taaksepäinyhteensopivuuden, jolloin vanhemmalle versiolle tehty koodi saattaisi toimia väärin. Tässä tapauksessa koodi toimii kaikilla Solidity 0.4.x-versioilla.
```
pragma solidity ^0.4.0;
```

### Luokan esittely
Toisella rivillä esitellään kooditiedoston ainoa luokka, jonka nimi on **SingleBuyItem**. Solidityn kohdalla luokat esitellään **contract**-avainsanalla, koska niistä luodaan olioita, joita voidaan kutsua. Koodissa yksittäinen contract pitää sisällään kaikki pysyvät muuttujat ja funktiokutsut, joita se tarvitsee toimiakseen. Koska koodi saattaa tarvita alustusta toimiakseen, voi contract:illa olla yksi rakentaja, jonka avulla luokasta saadaan tehtyä käyttöä varten yksi olio halutuilla parametreillä.
```
contract SingleBuyItem
```

### Muuttujat
Seuraavaksi esitellään luokan neljä muuttujaa, jotka ovat:
* **canBeBought**-muuttujaan talletetaan tieto siitä, että onko esine edelleen ostettavissa (tarkoituksena on siis estää saman esineen ostaminen useampaan kertaan).
* **priceOfItemInWei**-muuttujassa on esineen hinta wei-yksiköissä. wei on siis pienin valuutan yksikkö Ethereumissa. ([Laskuri wei<->Ether](https://etherconverter.online/) -muunnoksiin)
* **itemDescription**-muuttujassa on kuvaus esineestä
* **buyerAdditionalIdentifier**-muuttuja on ostajan jättämä ylimääräinen kuvaus itsestään, jonka avulla myyjä osaa antaa esim. pelissä tuotteen oikealle taholle

```
bool canBeBought;
uint priceOfItemInWei;
string itemDescription;
string buyerAdditionalIdentifier;
```

**bool**-muuttujat ovat perinteisiä **true**/**false**-vaihtoehtoja. **uint** on etumerkitön kokonaisluku, joka monista muista ohjelmointikielistä poiketen on Solidityssä kuitenkin 256-bittinen. **string** muistuttaa monista muista ohjelmointikielistä tuttua merkkijonotyyppiä, mutta Solidityssä on luonnollisesti omat erikoisuutensa, joihin palataan myöhemmissä esimerkeissä.

Muuttujat ovat aina voimassa ja niiden arvot ovat aina tallessa. Monista muista ohjelmointikielistä poiketen muuttujia voi muokata ainoastaan funktio-kutsujen kautta, joten ulkopuoliset tahot eivät voi muokata suoraan luotujen olioiden sisäistä tilaa vaikka muuttujat olisivat **public**-tyyppisiä.

### Rakentaja
Muuttujien esittelyn jälkeen on vuorossa luokan rakentaja (rakentajan nimi on monien muiden ohjelmointikielten tavoin sama kuin luokan nimi), joka ottaa parametreikseen hinnan wei-yksiköissä ja kuvauksen myytävästä esineestä. Rakentaja on public-tyyppinen eli kuka tahansa voi koodin avulla luoda omia myytäviä tuotteita. Lisäksi mukana on avainsana **payable**, joka tarkoittaa luokan tukevan Ethereum-maksuja. Hinnan ja kuvauksen lisäksi rakenta asettaa canBeBought:in true-tilaan, jotta esine on ostettavissa.
```
function SingleBuyItem(uint price, string description) public payable
{
    canBeBought = true;
    priceOfItemInWei = price;
    itemDescription = description;
}
```

### Ydintoteutus eli oston tekeminen
Tämän toteutuksen varsinainen ydin, eli ostotapahtuman tekeminen (tai tarkemmin sen yrittäminen) löytyy **TryToBuyItem**-funktiosta. Rakentajan tavoin se on public, joten kuka tahansa voi yrittää ostamista. Lisäksi myös payable on tässä mukana, koska funktion käyttö vaatii Ethereum-siirtoa sille.

Ensimmäisenä funktio tarkistaa Solidityn omalle [require](http://solidity.readthedocs.io/en/develop/control-structures.html?highlight=require#error-handling-assert-require-revert-and-exceptions)-funktiolla, että esine on edelleen ostettavissa, eli canBeBought-muuttujan arvo on true. Jos require:lle asetettu ehto ei täyty, heittää se poikkeuksen, joka tässä tapauksessa lopettaa TryToBuyItem-funktion suorituksen välittömästi.

Samanlainen require-tarkistus on myös hinnassa. Eli ostajan on siirrettävä funktiolle juuri oikea määrä Ethereumia tai poikkeus lopettaa funktion käsittelyn.

Kun molemmat ehdot ovat täyttyneet voidaan varsinainen ostotapahtuma tehdä. Tällöin canBeBought-muuttujalle annetaan arvo false, jotta kukaan muu ei voi ostaa enää kyseistä tuotetta. Lisäksi ostaja voi kertoa tunnisteensa, joka kirjataan ylös buyerAdditionalIdentifier-muuttujaan, jotta myyjä voi tunnistaa hänet myöhemmin. Tällöin myyjän ei tarvitse tietää ostajan Ethereum-lompakon osoitetta, vaan tunnisteena voi toimia esim. tietokanta-avain, shäköpostiosoite (huono tapa, koska sähköpostiosoite jää lohkoketjuun ikuisesti talteen) tai tarkistussumma pelaajan käyttäjänimestä.
```
function TryToBuyItem(string additionalIdentifier) public payable
{
    require(canBeBought == true);
    require(msg.value == priceOfItemInWei);
    
    canBeBought = false;
    buyerAdditionalIdentifier = additionalIdentifier;
}
```

## Hyvä tietää
Hinnan yksikkö on wei, koska liukulukujen käsittely kymmenien desimaalien tarkkuudella on ongelmallista. Myyjän ja ostajan tulee tästä syystä olla tarkkoja, ettei tuotteen hinta tule liian matalaksi/korkeaksi.

Kaikki ostotapahtumat kirjataan lohkoketjuun ikuisesti, joten mitään arkaluonteista tietoa ei kannata laittaa esim. tuotekuvaukseen.

Ostotapahtuma ei pakota myyjää mihinkään toimenpiteisiin, joten ostajalla ei ole mitään takeita siitä, että myyjä pitää lupauksensa.
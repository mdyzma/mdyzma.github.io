---
layout:     post
author:     Michal Dyzma
title:      Jak napisać bota Twittera z panelem administracyjnym - projekt igła 
date:       2017-12-14 18:40:08
comments:   true
mathjax:    false
categories: python Flask Twitter, Bot
keywords:   python, Flask, Twitter, Bot
---

Dzisiaj przedstawię jak wygląda pisanie komercyjnego softu. Pełne TDD/BDD do tego Flask i Twitter. Przedmitem wpisu będzie bot automtyzujący różne żmudne czynności w serwisie Twitter. Może masz dziewczynę, która uwiebia, kiedy lajkujesz jej posty posty. Albo jesteś szefem zatroskanym o wizerunek firmy i chciałbyś nieco "podkręcić wyniki". Jesteś w dobrym miejscu. 



## Wtstęp

Budowa będzie miała pięć etapów:

1. Dokumentacja (SDD)
2. Konfiguracja środowiska deweloperskiego i produkyjnego
3. Kodzenie rozwiązań w TDD/BDD
4. Wypuszczenie na produkcję

## Specyfikacja, SDD

Co będzie robił Tweebot? 

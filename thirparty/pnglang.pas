{Portable Network Graphics Delphi Language Info (24 July 2002)}

{Feel free to change the text bellow to adapt to your language}
{Also if you have a translation to other languages and want to}
{share it, send me: gubadaud@terra.com.br                     }
unit pnglang;

interface

{$DEFINE English}
{.$DEFINE Polish}
{.$DEFINE Portuguese}
{.$DEFINE German}
{.$DEFINE French}
{.$DEFINE Slovenian}

{Language strings for english}
resourcestring
  {$IFDEF Polish}
  EPngInvalidCRCText = 'Ten obraz "Portable Network Graphics" jest nieprawid³owy ' +
      'poniewa¿ zawiera on nieprawid³owe czêœci danych (b³¹d crc)';
  EPNGInvalidIHDRText = 'Obraz "Portable Network Graphics" nie mo¿e zostaæ ' +
      'wgrany poniewa¿ jedna z czêœci danych (ihdr) mo¿e byæ uszkodzona';
  EPNGMissingMultipleIDATText = 'Obraz "Portable Network Graphics" jest ' +
    'nieprawid³owy poniewa¿ brakuje w nim czêœci obrazu.';
  EPNGZLIBErrorText = 'Nie mo¿na zdekompresowaæ obrazu poniewa¿ zawiera ' +
    'b³êdnie zkompresowane dane.'#13#10 + ' Opis b³êdu: ';
  EPNGInvalidPaletteText = 'Obraz "Portable Network Graphics" zawiera ' +
    'niew³aœciw¹ paletê.';
  EPNGInvalidFileHeaderText = 'Plik który jest odczytywany jest nieprawid³owym '+
    'obrazem "Portable Network Graphics" poniewa¿ zawiera nieprawid³owy nag³ówek.' +
    ' Plik mo¿ê byæ uszkodzony, spróbuj pobraæ go ponownie.';
  EPNGIHDRNotFirstText = 'Obraz "Portable Network Graphics" nie jest ' +
    'obs³ugiwany lub mo¿e byæ niew³aœciwy.'#13#10 + '(stopka IHDR nie jest pierwsza)';
  EPNGNotExistsText = 'Plik png nie mo¿e zostaæ wgrany poniewa¿ nie ' +
    'istnieje.';
  EPNGSizeExceedsText = 'Obraz "Portable Network Graphics" nie jest ' +
    'obs³ugiwany poniewa¿ jego szerokoœæ lub wysokoœæ przekracza maksimum ' +
    'rozmiaru, który wynosi 65535 pikseli d³ugoœci.';
  EPNGUnknownPalEntryText = 'Nie znaleziono wpisów palety.';
  EPNGMissingPaletteText = 'Obraz "Portable Network Graphics" nie mo¿e zostaæ ' +
    'wgrany poniewa¿ u¿ywa tabeli kolorów której brakuje.';
  EPNGUnknownCriticalChunkText = 'Obraz "Portable Network Graphics" ' +
    'zawiera nieznan¹ krytyczn¹ czêœæ która nie mo¿e zostaæ odkodowana.';
  EPNGUnknownCompressionText = 'Obraz "Portable Network Graphics" jest ' +
    'skompresowany nieznanym schemat który nie mo¿e zostaæ odszyfrowany.';
  EPNGUnknownInterlaceText = 'Obraz "Portable Network Graphics" u¿ywa ' +
    'nie znany schamat przeplatania który nie mo¿e zostaæ odszyfrowany.';
  EPNGCannotAssignChunkText = 'Stopka mysi byæ kompatybilna aby zosta³a wyznaczona.';
  EPNGUnexpectedEndText = 'Obraz "Portable Network Graphics" jest nieprawid³owy ' +
    'poniewa¿ dekoder znalaz³ niespodziewanie koniec pliku.';
  EPNGNoImageDataText = 'Obraz "Portable Network Graphics" nie zawiera' +
    'danych.';
  EPNGCannotAddChunkText = 'Program próbuje dodaæ krytyczn¹ ' +
    'stopkê do aktualnego obrazu co jest niedozwolone.';
  EPNGCannotAddInvalidImageText = 'Nie mo¿na dodaæ nowej stopki ' +
    'poniewa¿ aktualny obraz jest nieprawid³owy.';
  EPNGCouldNotLoadResourceText = 'Obraz png nie mo¿e zostaæ za³adowany z' +
    'zasobów o podanym ID.';
  EPNGOutMemoryText = 'Niektóre operacje nie mog¹ zostaæ zrealizowane poniewa¿ ' +
    'systemowi brakuje zasobów. Zamknij kilka okien i spróbuj ponownie.';
  EPNGCannotChangeTransparentText = 'Ustawienie bitu przezroczystego koloru jest ' +
    'zabronione dla obrazów png zawieraj¹cych wartoœæ alpha dla ka¿dego piksela ' +
    '(COLOR_RGBALPHA i COLOR_GRAYSCALEALPHA)';
  EPNGHeaderNotPresentText = 'Ta operacja jest niedozwolona poniewa¿ ' +
    'aktualny obraz zawiera niew³aœciwy nag³ówek.';
  EInvalidNewSize = 'The new size provided for image resizing is invalid.';
  EInvalidSpec = 'The "Portable Network Graphics" could not be created ' +
    'because invalid image type parameters have being provided.';
  {$ENDIF}

  {$IFDEF English}
  EPngInvalidCRCText = 'This "Portable Network Graphics" image is not valid ' +
      'because it contains invalid pieces of data (crc error)';
  EPNGInvalidIHDRText = 'The "Portable Network Graphics" image could not be ' +
      'loaded because one of its main piece of data (ihdr) might be corrupted';
  EPNGMissingMultipleIDATText = 'This "Portable Network Graphics" image is ' +
    'invalid because it has missing image parts.';
  EPNGZLIBErrorText = 'Could not decompress the image because it contains ' +
    'invalid compressed data.'#13#10 + ' Description: ';
  EPNGInvalidPaletteText = 'The "Portable Network Graphics" image contains ' +
    'an invalid palette.';
  EPNGInvalidFileHeaderText = 'The file being readed is not a valid '+
    '"Portable Network Graphics" image because it contains an invalid header.' +
    ' This file may be corruped, try obtaining it again.';
  EPNGIHDRNotFirstText = 'This "Portable Network Graphics" image is not ' +
    'supported or it might be invalid.'#13#10 + '(IHDR chunk is not the first)';
  EPNGNotExistsText = 'The png file could not be loaded because it does not ' +
    'exists.';
  EPNGSizeExceedsText = 'This "Portable Network Graphics" image is not ' +
    'supported because either it''s width or height exceeds the maximum ' +
    'size, which is 65535 pixels length.';
  EPNGUnknownPalEntryText = 'There is no such palette entry.';
  EPNGMissingPaletteText = 'This "Portable Network Graphics" could not be ' +
    'loaded because it uses a color table which is missing.';
  EPNGUnknownCriticalChunkText = 'This "Portable Network Graphics" image ' +
    'contains an unknown critical part which could not be decoded.';
  EPNGUnknownCompressionText = 'This "Portable Network Graphics" image is ' +
    'encoded with an unknown compression scheme which could not be decoded.';
  EPNGUnknownInterlaceText = 'This "Portable Network Graphics" image uses ' +
    'an unknown interlace scheme which could not be decoded.';
  EPNGCannotAssignChunkText = 'The chunks must be compatible to be assigned.';
  EPNGUnexpectedEndText = 'This "Portable Network Graphics" image is invalid ' +
    'because the decoder found an unexpected end of the file.';
  EPNGNoImageDataText = 'This "Portable Network Graphics" image contains no ' +
    'data.';
  EPNGCannotAddChunkText = 'The program tried to add a existent critical ' +
    'chunk to the current image which is not allowed.';
  EPNGCannotAddInvalidImageText = 'It''s not allowed to add a new chunk ' +
    'because the current image is invalid.';
  EPNGCouldNotLoadResourceText = 'The png image could not be loaded from the ' +
    'resource ID.';
  EPNGOutMemoryText = 'Some operation could not be performed because the ' +
    'system is out of resources. Close some windows and try again.';
  EPNGCannotChangeTransparentText = 'Setting bit transparency color is not ' +
    'allowed for png images containing alpha value for each pixel ' +
    '(COLOR_RGBALPHA and COLOR_GRAYSCALEALPHA)';
  EPNGHeaderNotPresentText = 'This operation is not valid because the ' +
    'current image contains no valid header.';
  EInvalidNewSize = 'The new size provided for image resizing is invalid.';
  EInvalidSpec = 'The "Portable Network Graphics" could not be created ' +
    'because invalid image type parameters have being provided.';
  {$ENDIF}
  {$IFDEF Portuguese}
  EPngInvalidCRCText = 'Essa imagem "Portable Network Graphics" não é válida ' +
      'porque contém chunks inválidos de dados (erro crc)';
  EPNGInvalidIHDRText = 'A imagem "Portable Network Graphics" não pode ser ' +
      'carregada porque um dos seus chunks importantes (ihdr) pode estar '+
      'inválido';
  EPNGMissingMultipleIDATText = 'Essa imagem "Portable Network Graphics" é ' +
    'inválida porque tem chunks de dados faltando.';
  EPNGZLIBErrorText = 'Não foi possível descomprimir os dados da imagem ' +
    'porque ela contém dados inválidos.'#13#10 + ' Descrição: ';
  EPNGInvalidPaletteText = 'A imagem "Portable Network Graphics" contém ' +
    'uma paleta inválida.';
  EPNGInvalidFileHeaderText = 'O arquivo sendo lido não é uma imagem '+
    '"Portable Network Graphics" válida porque contém um cabeçalho inválido.' +
    ' O arquivo pode estar corrompida, tente obter ela novamente.';
  EPNGIHDRNotFirstText = 'Essa imagem "Portable Network Graphics" não é ' +
    'suportada ou pode ser inválida.'#13#10 + '(O chunk IHDR não é o ' +
    'primeiro)';
  EPNGNotExistsText = 'A imagem png não pode ser carregada porque ela não ' +
    'existe.';
  EPNGSizeExceedsText = 'Essa imagem "Portable Network Graphics" não é ' +
    'suportada porque a largura ou a altura ultrapassam o tamanho máximo, ' +
    'que é de 65535 pixels de diâmetro.';
  EPNGUnknownPalEntryText = 'Não existe essa entrada de paleta.';
  EPNGMissingPaletteText = 'Essa imagem "Portable Network Graphics" não pode ' +
    'ser carregada porque usa uma paleta que está faltando.';
  EPNGUnknownCriticalChunkText = 'Essa imagem "Portable Network Graphics" ' +
    'contém um chunk crítico desconheçido que não pode ser decodificado.';
  EPNGUnknownCompressionText = 'Essa imagem "Portable Network Graphics" está ' +
    'codificada com um esquema de compressão desconheçido e não pode ser ' +
    'decodificada.';
  EPNGUnknownInterlaceText = 'Essa imagem "Portable Network Graphics" usa um ' +
    'um esquema de interlace que não pode ser decodificado.';
  EPNGCannotAssignChunkText = 'Os chunk devem ser compatíveis para serem ' +
    'copiados.';
  EPNGUnexpectedEndText = 'Essa imagem "Portable Network Graphics" é ' +
    'inválida porque o decodificador encontrou um fim inesperado.';
  EPNGNoImageDataText = 'Essa imagem "Portable Network Graphics" não contém ' +
    'dados.';
  EPNGCannotAddChunkText = 'O programa tentou adicionar um chunk crítico ' +
    'já existente para a imagem atual, oque não é permitido.';
  EPNGCannotAddInvalidImageText = 'Não é permitido adicionar um chunk novo ' +
    'porque a imagem atual é inválida.';
  EPNGCouldNotLoadResourceText = 'A imagem png não pode ser carregada apartir' +
    ' do resource.';
  EPNGOutMemoryText = 'Uma operação não pode ser completada porque o sistema ' +
    'está sem recursos. Fecha algumas janelas e tente novamente.';
  EPNGCannotChangeTransparentText = 'Definir transparência booleana não é ' +
    'permitido para imagens png contendo informação alpha para cada pixel ' +
    '(COLOR_RGBALPHA e COLOR_GRAYSCALEALPHA)';
  EPNGHeaderNotPresentText = 'Essa operação não é válida porque a ' +
    'imagem atual não contém um cabeçalho válido.';
  EInvalidNewSize = 'O novo tamanho fornecido para o redimensionamento de ' +
    'imagem é inválido.';
  EInvalidSpec = 'A imagem "Portable Network Graphics" não pode ser criada ' +
    'porque parâmetros de tipo de imagem inválidos foram usados.';
  {$ENDIF}
  {Language strings for German}
  {$IFDEF German}
  EPngInvalidCRCText = 'Dieses "Portable Network Graphics" Bild ist ' +
      'ungültig, weil Teile der Daten fehlerhaft sind (CRC-Fehler)';
  EPNGInvalidIHDRText = 'Dieses "Portable Network Graphics" Bild konnte ' +
      'nicht geladen werden, weil wahrscheinlich einer der Hauptdatenbreiche ' +
	  '(IHDR) beschädigt ist';
  EPNGMissingMultipleIDATText = 'Dieses "Portable Network Graphics" Bild ' +
    'ist ungültig, weil Grafikdaten fehlen.';
  EPNGZLIBErrorText = 'Die Grafik konnte nicht entpackt werden, weil Teile der ' +
    'komprimierten Daten fehlerhaft sind.'#13#10 + ' Beschreibung: ';
  EPNGInvalidPaletteText = 'Das "Portable Network Graphics" Bild enthält ' +
    'eine ungültige Palette.';
  EPNGInvalidFileHeaderText = 'Die Datei, die gelesen wird, ist kein ' +
    'gültiges "Portable Network Graphics" Bild, da es keinen gültigen ' +
    'Header enthält. Die Datei könnte beschädigt sein, versuchen Sie, ' +
    'eine neue Kopie zu bekommen.';
  EPNGIHDRNotFirstText = 'Dieses "Portable Network Graphics" Bild wird ' +
    'nicht unterstützt oder ist ungültig.'#13#10 +
    '(Der IHDR-Abschnitt ist nicht der erste Abschnitt in der Datei).';
  EPNGNotExistsText = 'Die PNG Datei konnte nicht geladen werden, da sie ' +
    'nicht existiert.';
  EPNGSizeExceedsText = 'Dieses "Portable Network Graphics" Bild wird nicht ' +
    'unterstützt, weil entweder seine Breite oder seine Höhe das Maximum von ' +
    '65535 Pixeln überschreitet.';
  EPNGUnknownPalEntryText = 'Es gibt keinen solchen Palettenwert.';
  EPNGMissingPaletteText = 'Dieses "Portable Network Graphics" Bild konnte ' +
    'nicht geladen werden, weil die benötigte Farbtabelle fehlt.';
  EPNGUnknownCriticalChunkText = 'Dieses "Portable Network Graphics" Bild ' +
    'enhält einen unbekannten aber notwendigen Teil, welcher nicht entschlüsselt ' +
    'werden kann.';
  EPNGUnknownCompressionText = 'Dieses "Portable Network Graphics" Bild ' +
    'wurde mit einem unbekannten Komprimierungsalgorithmus kodiert, welcher ' +
    'nicht entschlüsselt werden kann.';
  EPNGUnknownInterlaceText = 'Dieses "Portable Network Graphics" Bild ' +
    'benutzt ein unbekanntes Interlace-Schema, welches nicht entschlüsselt ' +
    'werden kann.';
  EPNGCannotAssignChunkText = 'Die Abschnitte müssen kompatibel sein, damit ' +
    'sie zugewiesen werden können.';
  EPNGUnexpectedEndText = 'Dieses "Portable Network Graphics" Bild ist ' +
    'ungültig: Der Dekoder ist unerwartete auf das Ende der Datei gestoßen.';
  EPNGNoImageDataText = 'Dieses "Portable Network Graphics" Bild enthält ' +
    'keine Daten.';
  EPNGCannotAddChunkText = 'Das Programm versucht einen existierenden und ' +
    'notwendigen Abschnitt zum aktuellen Bild hinzuzufügen. Dies ist nicht ' +
    'zulässig.';
  EPNGCannotAddInvalidImageText = 'Es ist nicht zulässig, einem ungültigen ' +
    'Bild einen neuen Abschnitt hinzuzufügen.';
  EPNGCouldNotLoadResourceText = 'Das PNG Bild konnte nicht aus den ' +
    'Resourcendaten geladen werden.';
  EPNGOutMemoryText = 'Es stehen nicht genügend Resourcen im System zur ' +
    'Verfügung, um die Operation auszuführen. Schließen Sie einige Fenster '+
    'und versuchen Sie es erneut.';
  EPNGCannotChangeTransparentText = 'Das Setzen der Bit-' +
    'Transparent-Farbe ist für PNG-Images die Alpha-Werte für jedes ' +
    'Pixel enthalten (COLOR_RGBALPHA und COLOR_GRAYSCALEALPHA) nicht ' +
    'zulässig';
  EPNGHeaderNotPresentText = 'Die Datei, die gelesen wird, ist kein ' +
    'gültiges "Portable Network Graphics" Bild, da es keinen gültigen ' +
    'Header enthält.';
  EInvalidNewSize = 'The new size provided for image resizing is invalid.';
  EInvalidSpec = 'The "Portable Network Graphics" could not be created ' +
    'because invalid image type parameters have being provided.';
  {$ENDIF}
  {Language strings for French}
  {$IFDEF French}
  EPngInvalidCRCText = 'Cette image "Portable Network Graphics" n''est pas valide ' +
      'car elle contient des données invalides (erreur crc)';
  EPNGInvalidIHDRText = 'Cette image "Portable Network Graphics" n''a pu être ' +
      'chargée car l''une de ses principale donnée (ihdr) doit être corrompue';
  EPNGMissingMultipleIDATText = 'Cette image "Portable Network Graphics" est ' +
    'invalide car elle contient des parties d''image manquantes.';
  EPNGZLIBErrorText = 'Impossible de décompresser l''image car elle contient ' +
    'des données compressées invalides.'#13#10 + ' Description: ';
  EPNGInvalidPaletteText = 'L''image "Portable Network Graphics" contient ' +
    'une palette invalide.';
  EPNGInvalidFileHeaderText = 'Le fichier actuellement lu est une image '+
    '"Portable Network Graphics" invalide car elle contient un en-tête invalide.' +
    ' Ce fichier doit être corrompu, essayer de l''obtenir à nouveau.';
  EPNGIHDRNotFirstText = 'Cette image "Portable Network Graphics" n''est pas ' +
    'supportée ou doit être invalide.'#13#10 + '(la partie IHDR n''est pas la première)';
  EPNGNotExistsText = 'Le fichier png n''a pu être chargé car il n''éxiste pas.';
  EPNGSizeExceedsText = 'Cette image "Portable Network Graphics" n''est pas supportée ' +
    'car sa longueur ou sa largeur excède la taille maximale, qui est de 65535 pixels.';
  EPNGUnknownPalEntryText = 'Il n''y a aucune entrée pour cette palette.';
  EPNGMissingPaletteText = 'Cette image "Portable Network Graphics" n''a pu être ' +
    'chargée car elle utilise une table de couleur manquante.';
  EPNGUnknownCriticalChunkText = 'Cette image "Portable Network Graphics" ' +
    'contient une partie critique inconnue qui n'' pu être décodée.';
  EPNGUnknownCompressionText = 'Cette image "Portable Network Graphics" est ' +
    'encodée à l''aide d''un schémas de compression inconnu qui ne peut être décodé.';
  EPNGUnknownInterlaceText = 'Cette image "Portable Network Graphics" utilise ' +
    'un schémas d''entrelacement inconnu qui ne peut être décodé.';
  EPNGCannotAssignChunkText = 'Ce morceau doit être compatible pour être assigné.';
  EPNGUnexpectedEndText = 'Cette image "Portable Network Graphics" est invalide ' +
    'car le decodeur est arrivé à une fin de fichier non attendue.';
  EPNGNoImageDataText = 'Cette image "Portable Network Graphics" ne contient pas de ' +
    'données.';
  EPNGCannotAddChunkText = 'Le programme a essayé d''ajouter un morceau critique existant ' +
    'à l''image actuelle, ce qui n''est pas autorisé.';
  EPNGCannotAddInvalidImageText = 'Il n''est pas permis d''ajouter un nouveau morceau ' +
    'car l''image actuelle est invalide.';
  EPNGCouldNotLoadResourceText = 'L''image png n''a pu être chargée depuis  ' +
    'l''ID ressource.';
  EPNGOutMemoryText = 'Certaines opérations n''ont pu être effectuée car le ' +
    'système n''a plus de ressources. Fermez quelques fenêtres et essayez à nouveau.';
  EPNGCannotChangeTransparentText = 'Définir le bit de transparence n''est pas ' +
    'permis pour des images png qui contiennent une valeur alpha pour chaque pixel ' +
    '(COLOR_RGBALPHA et COLOR_GRAYSCALEALPHA)';
  EPNGHeaderNotPresentText = 'Cette opération n''est pas valide car l''image ' +
    'actuelle ne contient pas de header valide.';
  EPNGAlphaNotSupportedText = 'Le type de couleur de l''image "Portable Network Graphics" actuelle ' +
    'contient déjà des informations alpha ou il ne peut être converti.';
  EInvalidNewSize = 'The new size provided for image resizing is invalid.';
  EInvalidSpec = 'The "Portable Network Graphics" could not be created ' +
    'because invalid image type parameters have being provided.';
  {$ENDIF}
  {Language strings for slovenian}
  {$IFDEF Slovenian}
  EPngInvalidCRCText = 'Ta "Portable Network Graphics" slika je neveljavna, ' +
      'ker vsebuje neveljavne dele podatkov (CRC napaka).';
  EPNGInvalidIHDRText = 'Slike "Portable Network Graphics" ni bilo možno ' +
      'naložiti, ker je eden od glavnih delov podatkov (IHDR) verjetno pokvarjen.';
  EPNGMissingMultipleIDATText = 'Ta "Portable Network Graphics" slika je ' +
    'naveljavna, ker manjkajo deli slike.';
  EPNGZLIBErrorText = 'Ne morem raztegniti slike, ker vsebuje ' +
    'neveljavne stisnjene podatke.'#13#10 + ' Opis: ';
  EPNGInvalidPaletteText = 'Slika "Portable Network Graphics" vsebuje ' +
    'neveljavno barvno paleto.';
  EPNGInvalidFileHeaderText = 'Datoteka za branje ni veljavna '+
    '"Portable Network Graphics" slika, ker vsebuje neveljavno glavo.' +
    ' Datoteka je verjetno pokvarjena, poskusite jo ponovno naložiti.';
  EPNGIHDRNotFirstText = 'Ta "Portable Network Graphics" slika ni ' +
    'podprta ali pa je neveljavna.'#13#10 + '(IHDR del datoteke ni prvi).';
  EPNGNotExistsText = 'Ne morem naložiti png datoteke, ker ta ne ' +
    'obstaja.';
  EPNGSizeExceedsText = 'Ta "Portable Network Graphics" slika ni ' +
    'podprta, ker ali njena širina ali višina presega najvecjo možno vrednost ' +
    '65535 pik.';
  EPNGUnknownPalEntryText = 'Slika nima vnešene take barvne palete.';
  EPNGMissingPaletteText = 'Te "Portable Network Graphics" ne morem ' +
    'naložiti, ker uporablja manjkajoco barvno paleto.';
  EPNGUnknownCriticalChunkText = 'Ta "Portable Network Graphics" slika ' +
    'vsebuje neznan kriticni del podatkov, ki ga ne morem prebrati.';
  EPNGUnknownCompressionText = 'Ta "Portable Network Graphics" slika je ' +
    'kodirana z neznano kompresijsko shemo, ki je ne morem prebrati.';
  EPNGUnknownInterlaceText = 'Ta "Portable Network Graphics" slika uporablja ' +
    'neznano shemo za preliv, ki je ne morem prebrati.';
  EPNGCannotAssignChunkText = Košcki morajo biti med seboj kompatibilni za prireditev vrednosti.';
  EPNGUnexpectedEndText = 'Ta "Portable Network Graphics" slika je neveljavna, ' +
    'ker je bralnik prišel do nepricakovanega konca datoteke.';
  EPNGNoImageDataText = 'Ta "Portable Network Graphics" ne vsebuje nobenih ' +
    'podatkov.';
  EPNGCannotAddChunkText = 'Program je poskusil dodati obstojeci kriticni ' +
    'kos podatkov k trenutni sliki, kar ni dovoljeno.';
  EPNGCannotAddInvalidImageText = 'Ni dovoljeno dodati nov kos podatkov, ' +
    'ker trenutna slika ni veljavna.';
  EPNGCouldNotLoadResourceText = 'Ne morem naložiti png slike iz ' +
    'skladišca.';
  EPNGOutMemoryText = 'Ne morem izvesti operacije, ker je  ' +
    'sistem ostal brez resorjev. Zaprite nekaj oken in poskusite znova.';
  EPNGCannotChangeTransparentText = 'Ni dovoljeno nastaviti prosojnosti posamezne barve ' +
    'za png slike, ki vsebujejo alfa prosojno vrednost za vsako piko ' +
    '(COLOR_RGBALPHA and COLOR_GRAYSCALEALPHA)';
  EPNGHeaderNotPresentText = 'Ta operacija ni veljavna, ker ' +
    'izbrana slika ne vsebuje veljavne glave.';
  EInvalidNewSize = 'The new size provided for image resizing is invalid.';
  EInvalidSpec = 'The "Portable Network Graphics" could not be created ' +
    'because invalid image type parameters have being provided.';
  {$ENDIF}


implementation

end.

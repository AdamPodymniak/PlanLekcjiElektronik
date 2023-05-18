# Web Scraper Planu Lekcji Elektronika

## Opis projektu

Ten projekt to aplikacja mobilna napisana w Flutterze, która pobiera i wyświetla dane dotyczące planu lekcji dla danej szkoły. Wykorzystuje technikę web scrapingu do ekstrakcji informacji z witryny internetowej szkoły i prezentuje je w czytelnej formie użytkownikowi.

Aplikacja oferuje interfejs użytkownika umożliwiający wprowadzenie danych dotyczących szkoły (np. adres URL strony z planem lekcji, numer klasy itp.) i następnie pobiera i prezentuje harmonogram lekcji w sposób zrozumiały i intuicyjny.

## Wymagania systemowe

Aby uruchomić i korzystać z aplikacji, wymagane są następujące zależności:

- Flutter SDK (wersja X.X.X)
- Dart SDK (wersja X.X.X)
- Inne niezbędne zależności specyficzne dla Fluttera (patrz `pubspec.yaml`)

## Instalacja

Aby zainstalować projekt na swoim urządzeniu, wykonaj następujące kroki:

1. Sklonuj repozytorium projektu na swoje urządzenie:

   ```bash
   git clone https://github.com/NazwaUzytkownika/NazwaProjektu.git
   ```

2. Przejdź do katalogu projektu:

   ```bash
   cd NazwaProjektu
   ```

3. Zainstaluj wymagane zależności przy użyciu narzędzia `flutter`:

   ```bash
   flutter pub get
   ```

4. Skonfiguruj swój emulator urządzenia mobilnego lub podłącz urządzenie fizyczne do komputera.

5. Uruchom aplikację na swoim emulatorze lub urządzeniu:

   ```bash
   flutter run
   ```

   Alternatywnie, aby zbudować pliki binarne aplikacji, wykonaj:

   ```bash
   flutter build <platforma>
   ```

   Gdzie `<platforma>` to system operacyjny, na którym chcesz uruchomić aplikację (np. `apk`, `ipa`, `macos`, `windows`, itp.).

## Konfiguracja

Aby skonfigurować aplikację i dostosować ją do konkretnej szkoły, wykonaj poniższe kroki:

1. Otwórz plik `lib/config.dart`.

2. W pliku `config.dart`, zmodyfikuj odpowiednie zmienne zgodnie z potrzebami twojej szkoły (np. adres URL strony z planem lekcji, numery klas, itp.).

3. Zapisz plik `config.dart` po dokonaniu zmian.

## Użycie

Po zainstalowaniu i skonfigurowaniu aplikacji możesz uruchomić ją na swoim urządzeniu mobilnym lub emulatorze. Po uruchomieniu aplikacji będziesz mógł wprowadzić dane dotyczące szkoły i uzyskać

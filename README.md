# Web Scraper Planu Lekcji Elektronika

Aby pobrać aplikację na swój telefon, trzeba wejść w zakładkę "Releases", wybrać app-release.apk i postępować według instrukcji prezentowanych przez system.


![QR code installer](/assets/qrcode.png)

## Spis Treści

- [Opis projektu](#opis-projektu)
- [Wymagania systemowe](#wymagania-systemowe)
- [Instalacja](#instalacja)
- [Kontrybucja](#kontrybucja)
- [Użycie](#użycie)

## Opis projektu

Ten projekt to aplikacja mobilna napisana w Flutterze, która pobiera i wyświetla dane dotyczące planu lekcji dla danej szkoły. Wykorzystuje technikę web scrapingu do ekstrakcji informacji z witryny internetowej szkoły i prezentuje je w czytelnej formie użytkownikowi.

Aplikacja oferuje interfejs użytkownika umożliwiający wprowadzenie danych dotyczących nazwy klasy, nauczyciela, czy sali i ustawienie danego planu jako głównego. Ponadto daje możliwość ręcznej aktualizacji danych i tworzenia własnej szaty graficznej, dzięki strukturze open-source.

## Wymagania systemowe

Aby uruchomić i korzystać z aplikacji, wymagane są następujące zależności:

- Flutter SDK
- Dart SDK
- Inne niezbędne zależności specyficzne dla Flutter'a (patrz `pubspec.yaml`)

## Instalacja

Aby zainstalować projekt na swoim urządzeniu, wykonaj następujące kroki:

1. Sklonuj repozytorium projektu na swoje urządzenie:

   ```bash
   git clone https://github.com/AdamPodymniak/PlanLekcjiElektronik.git
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

6. Zainstaluj ją przy użyciu mając podłączone urządzenie do komputera:

   ```bash
   flutter install
   ```

## Kontrybucja

Jesteśmy otwarci na kontrybucje do projektu. Jeśli masz pomysły na ulepszenie aplikacji, naprawę błędów lub dodanie nowych funkcji, z przyjemnością przyjmiemy Twoje zgłoszenia. Aby przyczynić się do projektu, postępuj zgodnie z poniższymi krokami:

1. Sklonuj repozytorium projektu na swoje urządzenie:

   ```bash
   git clone https://github.com/NazwaUzytkownika/NazwaProjektu.git
   ```

2. Przejdź do katalogu projektu:

   ```bash
   cd NazwaProjektu
   ```

3. Utwórz nowy branch dla swojej kontrybucji:

   ```bash
   git checkout -b moj_nowy_branch
   ```

4. Wprowadź swoje zmiany i poprawki w kodzie.

5. Wykonaj commit swoich zmian:

   ```bash
   git commit -m "Opis wprowadzonych zmian"
   ```

6. Wyślij swoje zmiany do repozytorium:

   ```bash
   git push origin moj_nowy_branch
   ```

7. Otwórz pull request na GitHubie, opisując swoje zmiany i cel kontrybucji.

Po złożeniu pull requesta zaczekaj na przegląd i feedback od członków zespołu. Po zaakceptowaniu, Twoje zmiany zostaną scalone z głównym branchem projektu.

Zachęcamy również do zgłaszania problemów (issues) w przypadku wykrycia błędów lub sugestii dotyczących ulepszeń. Dziękujemy za Twoją kontrybucję!

## Użycie

Po zainstalowaniu i skonfigurowaniu aplikacji możesz uruchomić ją na swoim urządzeniu mobilnym lub emulatorze.

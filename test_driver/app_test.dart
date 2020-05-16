import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';
import 'utils.dart';
import 'package:screenshots/screenshots.dart';

dynamic searchForText(String searchText, dynamic driver) async {
  await driver.tap(find.byValueKey('searchInput'));
  await driver.enterText(searchText);
}

void main() {
  group('LTA App', () {
    final unselectedFavoriteIcon = find.byValueKey('favoriteIconUnselected');
    final selectedFavoriteIcon = find.byValueKey('favoriteIconSelected');
    final busStopCard = find.byValueKey('busStopCard-0');
    final favoriteIconButton = find.byValueKey('favoriteIconButton');

    FlutterDriver driver;
    final config = Config();
    // Connect to the Flutter driver before running any tests.
    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    // Close the connection to the driver after the tests have completed.
    tearDownAll(() async {
      if (driver != null) {
        await driver.close();
      }
    });

    group('Nearby', () {
      test('Checks that bus stop is present in favorite screen', () async {
        await driver.tap(find.byValueKey('NearbyScreen'));
        await screenshot(driver, config, 'NearbyScreen');
        expect(await isRendered(busStopCard, driver), true);
      });
    });

    group('Search', () {
      test('Checks that bus stop can be searched by description', () async {
        await driver.tap(find.byValueKey('searchScreen'));
        searchForText('Opp Holiday Inn', driver);
        await driver.waitFor(busStopCard);
        await screenshot(driver, config, 'SearchScreen');
        expect(await isRendered(busStopCard, driver), true);
      });

      test('Clicks on bus stop to see a list of bus arrivals', () async {
        await driver.tap(busStopCard);
        await screenshot(driver, config, 'BusArrivalCard');
        expect(await isRendered(find.byValueKey('busArrivalCard-0'), driver),
            true);
      });

      test('Checks that favorite bus can be added and removed', () async {
        expect(await isRendered(unselectedFavoriteIcon, driver), true);
        expect(await isRendered(selectedFavoriteIcon, driver), false);

        await driver.tap(favoriteIconButton);
        await screenshot(driver, config, 'Favoritebus');

        expect(await isRendered(unselectedFavoriteIcon, driver), false);
        expect(await isRendered(selectedFavoriteIcon, driver), true);

        await driver.tap(find.pageBack());
      });

      test('Checks that bus stop can be searched by bus code', () async {
        await driver.tap(find.byValueKey('searchInput'));
        searchForText('01012', driver);
        await driver.waitFor(busStopCard);
        expect(await isRendered(busStopCard, driver), true);
      });

      test('Checks that bus stop can be searched by road name', () async {
        await driver.tap(find.byValueKey('searchInput'));
        searchForText('Victoria St', driver);
        await driver.waitFor(busStopCard);
        expect(await isRendered(busStopCard, driver), true);
      });

      test('Checks that input text can be cleared', () async {
        await driver.tap(find.byValueKey('clearSearchInput'));
        expect(await isRendered(busStopCard, driver), false);
      });
    });

    group('Favorites', () {
      test('Checks that bus stop is present in favorite screen', () async {
        await driver.tap(find.byValueKey('favoriteScreen'));
        await screenshot(driver, config, 'Favoritescreen');
        expect(await isRendered(busStopCard, driver), true);
      });

      test(
          'Checks that bus stop is not present when bus stop is removed from favorites',
          () async {
        await driver.tap(busStopCard);
        await driver.tap(favoriteIconButton);
        await driver.tap(find.pageBack());
        expect(await isRendered(busStopCard, driver), false);
      });
    });
  });
}

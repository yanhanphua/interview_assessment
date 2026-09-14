# Product Browser

A Flutter app that fetches and displays products from the [DummyJSON](https://dummyjson.com/products) API, with search, pagination, and a product detail screen.

## How to run

1. Install dependencies:
   ```
   flutter pub get
   ```
2. Run on a connected device/emulator or Chrome:
   ```
   flutter run
   ```

Requires an internet connection — the app calls the live DummyJSON API directly (no local/mock data).

## Stack

- **Flutter / Dart** (SDK ^3.7.0)
- **http** — REST calls to the DummyJSON API
- **provider** — wiring `ChangeNotifier` ViewModels to the widget tree

## Architecture — MVVM

```
lib/
  core/
    constants/     API base URL and endpoint paths
    errors/        ApiException — the one exception type every layer above the API deals with
  models/          Product, ProductListResult — parse API JSON into typed objects
  services/        ProductApi — raw HTTP calls, translates failures into ApiException
  repositories/    ProductRepository — thin seam between the API and the ViewModels
  viewmodels/      ProductListViewModel, ProductDetailViewModel — all screen state and logic
  views/           ProductListScreen, ProductDetailScreen, and shared widgets
  app/             App shell and route table
```

- **Model** — `Product`/`ProductListResult` (plain data + `fromJson`), plus `ProductApi`/`ProductRepository` as the data-access layer feeding them.
- **ViewModel** — `ChangeNotifier` classes holding all screen state (loading/error/empty/success) and logic (pagination, debounced search, retry). Views never call the repository directly.
- **View** — `StatelessWidget`/`StatefulWidget`s that only read ViewModel state and call its methods; no business logic lives here.

### Features implemented

- Product list fetched from `GET /products`, paginated (infinite scroll, 20 at a time)
- Product detail screen (`GET /products/{id}`), navigated to by tapping a list item
- Search (`GET /products/search?q=`), debounced 400ms so it doesn't fire on every keystroke
- Loading / error / empty / success states, each visually distinct, with a **Retry** button on error
- Image loading placeholder — a fallback icon is shown wherever a product's thumbnail/image is missing or fails to load (`Image.network`'s `errorBuilder`), so a broken URL never shows a blank space or crashes the layout

### Known gaps

- **No automated unit/widget tests.** Everything above was verified by manually running the app, not by an automated test suite.
- **No pull-to-refresh.** The list only refreshes via the initial load, pagination, and the error screen's Retry button — there's no gesture to manually re-fetch the current view.

## AI assistance

I used AI assistance while building this project, specifically:

- The idea of debouncing the search input (waiting ~400ms after typing stops before calling the search endpoint) came from AI advice.
- Researching and settling on the MVVM architecture and folder structure (the `core`/`models`/`services`/`repositories`/`viewmodels`/`views`/`app` split) was also done with AI help.

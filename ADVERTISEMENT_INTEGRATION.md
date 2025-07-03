# Advertisement Banners API Integration

## Overview

This integration provides a complete solution for displaying advertisement banners from the API
endpoint `https://tratri.in/api/advertisement/banners` with intelligent navigation based on ad
categories and related content.

## API Response Structure

```json
{
  "success": true,
  "result": [
    {
      "id": 1,
      "related_id": 1,
      "ad_category": "library",
      "ad_type": "image",
      "content": "https://tratri.in/assets/images/336x280-2.jpg",
      "redirect_link": ""
    },
    {
      "id": 3,
      "related_id": 62,
      "ad_category": "e-book",
      "ad_type": "image",
      "content": "https://tratri.in/assets/images/336x280-2.jpg",
      "redirect_link": ""
    },
    {
      "id": 4,
      "related_id": 0,
      "ad_category": "external",
      "ad_type": "image",
      "content": "https://tratri.in/assets/images/336x280-2.jpg",
      "redirect_link": "https://tratri.in/backend/library"
    }
  ],
  "message": "Ad List",
  "code": 200
}
```

## Smart Navigation Features

### Automatic Content Navigation

The system automatically navigates to relevant content based on the advertisement category and
`related_id`:

#### Navigation Rules:

- **library**: `Navigation.instance.navigate('/library', args: related_id)`
- **e-book/ebook**: `Navigation.instance.navigate('/bookInfo', args: related_id)`
- **e-note/enote**: `Navigation.instance.navigate('/enotesDetails', args: related_id)`
- **magazine**: `Navigation.instance.navigate('/bookInfo', args: related_id)`
- **external**: Opens `redirect_link` in external browser

#### Priority Order:

1. **External Links**: If `redirect_link` is provided, it takes priority
2. **Category Navigation**: If `related_id > 0`, navigates to specific content
3. **Fallback**: Debug logging for unhandled cases

## Files Created/Modified

### 1. Model Classes (`lib/Model/advertisement.dart`)

- **AdvertisementBannersResponse**: Main response wrapper
- **AdvertisementBanner**: Individual banner model with:
    - `id`: Banner ID
  - `related_id`: **NEW** - ID of related content for navigation
  - `adCategory`: Category (library, e-book, e-note, magazine, external)
    - `adType`: Type (image, video, etc.)
    - `content`: Image URL or content
    - `redirectLink`: URL to open when banner is tapped

### 2. API Provider (`lib/Networking/api_provider.dart`)

- **fetchAdvertisementBanners()**: Method to fetch banners from API
- Returns `AdvertisementBannersResponse`
- Includes proper error handling and platform headers

### 3. UI Components (`lib/UI/Components/advertisement_banner.dart`)

Enhanced with intelligent navigation:

- **Smart Tap Handling**: Automatically determines navigation based on category
- **External Link Support**: Opens redirect links in external browser
- **Content Navigation**: Navigates to books, e-notes, libraries, etc.
- **Error Handling**: Graceful fallbacks for all navigation scenarios

### 4. DataProvider (`lib/Storage/data_provider.dart`)

Added new properties:

- `advertisementBanners`: List of `AdvertisementBanner` for easy category filtering
- `advertisements`: List of `Advertisement` for backward compatibility
- `setAdvertisementBanners()`: Method to update banner data

## Usage Examples

### Basic API Call

```dart
final response = await ApiProvider.instance.fetchAdvertisementBanners();
if (response.success ?? false) {
  List<AdvertisementBanner> banners = response.result ?? [];
  // Use banners in your UI
}
```

### Navigation-Enabled Banner

```dart
AdvertisementBannerWidget(
  banner: banner, // Automatically handles navigation
  height: 20.h,
)
```

### Single Banner Widget

```dart
AdvertisementBannerWidget(
  banner: banner,
  height: 20.h,
  width: 80.w,
  onTap: () {
    // Custom tap handler
    print("Banner tapped: ${banner.id}");
  },
)
```

### Banner Section by Category

```dart
AdvertisementBannerSection(
  banners: allBanners,
  category: "library",
  title: "Library Promotions",
  height: 20.h,
)
```

### Category-Specific Sections

```dart
// Show only e-book category banners
AdvertisementBannerSection(
  banners: allBanners,
  category: "e-book",
  title: "Featured E-Books",
  height: 20.h,
)
```

### Multiple Category Integration

```dart
// In your page
Consumer<DataProvider>(
  builder: (context, dataProvider, child) {
    final mixedBanners = dataProvider.advertisementBanners
        ?.where((banner) => 
            banner.adCategory == "e-book" || 
            banner.adCategory == "magazine")
        .toList() ?? [];
    
    if (mixedBanners.isNotEmpty) {
      return AdvertisementBannerSection(
        banners: mixedBanners,
        height: 18.h,
      );
    }
    return const SizedBox.shrink();
  },
)
```

### Integration with DataProvider

```dart
// Add to your DataProvider class
List<AdvertisementBanner> _advertisementBanners = [];
bool _bannersLoading = false;

Future<void> fetchAdvertisementBanners() async {
  _bannersLoading = true;
  notifyListeners();
  
  final response = await ApiProvider.instance.fetchAdvertisementBanners();
  if (response.success ?? false) {
    _advertisementBanners = response.result ?? [];
  }
  
  _bannersLoading = false;
  notifyListeners();
}

List<AdvertisementBanner> getBannersByCategory(String category) {
  return _advertisementBanners
      .where((banner) => banner.adCategory == category)
      .toList();
}
```

## Available Categories

Updated categories from API response:

- **library**: Library-related advertisements → Navigate to library
- **e-book**: E-book promotions → Navigate to book details
- **e-note**: E-note promotions → Navigate to e-note details
- **magazine**: Magazine promotions → Navigate to magazine details
- **external**: External website/service promotions → Open redirect link

## Features

### Automatic URL Handling

- Banners with `redirect_link` automatically open URLs when tapped
- Uses `url_launcher` for external browser opening
- Fallback to custom `onTap` handlers

### Image Loading

- Uses `cached_network_image` for efficient image loading
- Loading placeholders while images load
- Error handling for broken/invalid image URLs
- Fallback UI for non-image ad types

### Responsive Design

- Uses `sizer` package for responsive sizing
- Customizable dimensions and margins
- Adapts to different screen sizes

### Error Handling

- API error handling in responses
- Image loading error handling
- URL launching error handling
- Graceful fallbacks for all error states

## Implementation in Your App

### 1. Add to Home Page

```dart
// In your home page build method
AdvertisementBannerSection(
  banners: context.watch<DataProvider>().advertisementBanners,
  category: "library",
  title: "Featured",
)
```

### 2. Add to Library Section

```dart
AdvertisementBannerSection(
  banners: banners,
  category: "library",
  showTitle: false,
)
```

### 3. Add Individual Banners

```dart
if (banners.isNotEmpty)
  AdvertisementBannerWidget(
    banner: banners.first,
    height: 25.h,
  )
```

## Smart Features

### 1. **Intelligent Navigation**

- Automatically routes to correct content based on `ad_category` + `related_id`
- Handles external links with `redirect_link`
- Fallback handling for invalid/missing data

### 2. **Category-Based Display**

- Different banner types show in appropriate app sections
- Library ads above library section
- E-book ads in book browsing areas
- Magazine ads in magazine sections

### 3. **Content Discovery**

- Users can discover specific books, e-notes, magazines through ads
- Direct navigation to detailed content pages
- External promotional content integration

## Implementation Benefits

### For Users:

- **Seamless Navigation**: Tap any ad to go directly to relevant content
- **Contextual Placement**: Ads appear in relevant app sections
- **Content Discovery**: Find new books, e-notes, magazines easily

### For Developers:

- **Automatic Routing**: No manual navigation coding needed
- **Flexible Placement**: Easy category-based banner filtering
- **Maintainable**: Clean separation of concerns
- **Scalable**: Easy to add new categories and navigation rules

## Customization Options

### Widget Customization

- `height` and `width`: Custom dimensions
- `margin`: Custom spacing
- `borderRadius`: Custom corner radius
- `onTap`: Custom tap handlers

### Section Customization

- `showTitle`: Show/hide section title
- `title`: Custom section title
- `physics`: Custom scroll physics
- `height`: Section height

## Advanced Usage

### Custom Navigation Override

```dart
AdvertisementBannerWidget(
  banner: banner,
  onTap: () {
    // Custom navigation logic
    // Overrides automatic navigation
    Navigation.instance.navigate('/customPage');
  },
)
```

## Best Practices

1. **Load banners early**: Fetch in app initialization
2. **Cache in DataProvider**: Use Provider pattern for state management
3. **Filter by category**: Show relevant ads for each section
4. **Handle errors gracefully**: Always provide fallback UI
5. **Respect user experience**: Don't overwhelm with too many ads

## Testing

See `lib/UI/Components/advertisement_banner_example.dart` for a complete implementation example that
demonstrates all features.

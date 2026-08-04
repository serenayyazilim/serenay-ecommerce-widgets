/// A backend-driven dynamic widget system for e-commerce home screens. Feed
/// it a backend JSON response and a [WidgetCallbacks]
/// implementation; it renders the screen and delegates every navigation,
/// data-fetch and auth/cart decision back to the host app.
library;

// Core
export 'src/core/constants/app_colors.dart';
export 'src/core/constants/app_dimens.dart';
export 'src/core/theme/app_text_styles.dart';
export 'src/core/theme/ecommerce_widget_theme.dart';

// Standalone, reusable building blocks — usable on their own or as the
// pieces WidgetCatalog composes internally.
export 'src/widgets/badges/discount_badge.dart';
export 'src/widgets/buttons/add_to_cart_button.dart';
export 'src/widgets/buttons/favorite_button.dart';
export 'src/widgets/cart/quantity_picker.dart';
export 'src/widgets/catalog/mini_product_tile.dart';
export 'src/widgets/catalog/rich_product_card.dart';

// Data contracts
export 'src/contracts/product_card_data.dart';
export 'src/contracts/product_query.dart';
export 'src/contracts/widget_action.dart';
export 'src/contracts/slide_item.dart';
export 'src/contracts/video_item.dart';
export 'src/contracts/widget_entry.dart';
export 'src/contracts/widget_type.dart';

// Injection layer
export 'src/callbacks/widget_callbacks.dart';

// Entry point
export 'src/widgets/widget_catalog.dart';

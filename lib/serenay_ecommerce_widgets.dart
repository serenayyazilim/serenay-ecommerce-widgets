/// SerBuilder: a backend-driven dynamic widget system for e-commerce home
/// screens. Feed it a backend JSON response and a [SerBuilderCallbacks]
/// implementation; it renders the screen and delegates every navigation,
/// data-fetch and auth/cart decision back to the host app.
library;

// Core
export 'src/core/constants/app_colors.dart';
export 'src/core/constants/app_dimens.dart';
export 'src/core/theme/app_text_styles.dart';

// Data contracts
export 'src/contracts/product_card_data.dart';
export 'src/contracts/product_query.dart';
export 'src/contracts/ser_action.dart';
export 'src/contracts/ser_slide_item.dart';
export 'src/contracts/ser_video_item.dart';
export 'src/contracts/ser_widget_data.dart';
export 'src/contracts/ser_widget_type.dart';

// Injection layer
export 'src/callbacks/ser_builder_callbacks.dart';

// Entry point
export 'src/widgets/ser_widgets.dart';

import 'package:flutter/material.dart';

/// Default color palette used across the e-commerce widget kit.
///
/// All widgets accept color overrides via constructor parameters; these
/// constants are only the fallback values used when no override is given.
class AppColors {
  const AppColors._();

  /// Primary brand color used for calls to action (e.g. "Add to Cart").
  static const Color primary = Color(0xFF1F6FEB);

  /// Secondary accent color used for highlights and selected states.
  static const Color secondary = Color(0xFFFF6B35);

  /// Color used for discount/sale badges.
  static const Color discount = Color(0xfff55145);

  /// Color used for "new" badges.
  static const Color newBadge = Color(0xFF2E7D32);

  /// Color used for "out of stock" badges and disabled states.
  static const Color outOfStock = Color(0xFF9E9E9E);

  /// Color used for star ratings when filled.
  static const Color ratingFilled = Color(0xFFFFB400);

  /// Color used for star ratings when empty.
  static const Color ratingEmpty = Color(0xFFE0E0E0);

  /// Default surface/background color for cards.
  static const Color surface = Color(0xFFFFFFFF);

  /// Default border color for outlined components.
  static const Color border = Color(0xFFE0E0E0);

  /// Default primary text color.
  static const Color textPrimary = Color(0xFF1A1A1A);

  /// Default secondary/muted text color.
  static const Color textSecondary = Color(0xFF757575);

  /// Color used to indicate a favorite/wishlist active state.
  static const Color favoriteActive = Color(0xFFE53935);

  /// Accent color for the FASTREGISTER (WhatsApp quick-register) card.
  static const Color whatsappGreen = Color(0xFF25D366);
}

/// API Endpoints repository for future food startup backend integrations.
/// All endpoint URLs are defined here as static constants.
class ApiEndpoints {
  static const String baseUrl = "https://api.velorafinedining.com/v1";

  // Menu & Dishes Endpoints
  static const String menu = "$baseUrl/menu";
  static const String featuredDishes = "$baseUrl/menu/featured";
  static const String categories = "$baseUrl/menu/categories";

  // Orders & Reservations Endpoints
  static const String orders = "$baseUrl/orders";
  static const String createOrder = "$baseUrl/orders/create";
  static const String trackOrder = "$baseUrl/orders/track";

  // Contact & Inquiries Endpoints
  static const String contact = "$baseUrl/contact";
  static const String cateringInquiry = "$baseUrl/contact/catering";

  // Newsletter Endpoint
  static const String newsletter = "$baseUrl/newsletter/subscribe";
}

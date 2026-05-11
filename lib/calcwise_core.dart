/// Calcwise Core — shared services, theme, and UI components.
/// Services: Firebase/Crashlytics, AdMob, IAP, Freemium
/// UI: CalcwiseTheme (per-app brand colors), PaywallSoft, PaywallHard, InsightCard
library calcwise_core;

// Services
export 'services/crashlytics_service.dart';
export 'services/analytics_service.dart';
export 'services/freemium_service.dart';
export 'services/iap_service.dart';
export 'services/ad_service.dart';
export 'services/theme_mode_service.dart';
export 'services/paywall_session_service.dart';

// Config
export 'config/monetization_config.dart';

// Utils
export 'utils/currency_input_formatter.dart';

// Theme
export 'theme/calcwise_theme.dart';
export 'theme/theme_factory.dart';

// Design Tokens
export 'theme/tokens/tokens.dart';

// Models
export 'models/insight.dart';

// Widgets
export 'widgets/paywall_soft.dart';
export 'widgets/paywall_hard.dart';
export 'widgets/insight_card.dart';
export 'widgets/calcwise_splash.dart';
export 'widgets/page_entrance.dart';

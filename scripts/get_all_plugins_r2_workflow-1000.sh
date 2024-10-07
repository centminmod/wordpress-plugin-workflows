#!/bin/bash

# Base directory (script location)
BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Configurable directories
WORDPRESS_WORKDIR="${WORDPRESS_WORKDIR:-$BASE_DIR/wordpress-plugins}"
PLUGIN_DIR="${PLUGIN_DIR:-$BASE_DIR/wp-content/plugins}"
MIRROR_DIR="${MIRROR_DIR:-$BASE_DIR/mirror}"
LOGS_DIR="${LOGS_DIR:-$BASE_DIR/plugin-logs}"

# Check for CF_WORKER_URL environment variable
if [ -z "$CF_WORKER_URL" ]; then
    echo "Error: CF_WORKER_URL environment variable is not set." >&2
    exit 1
fi

DOWNLOAD_BASE_URL="https://downloads.wordpress.org/plugin"

# Other variables
DOWNLOAD_LINK_API='y'

ADDITIONAL_PLUGINS=(
    "wordpress-seo"
    "elementor"
    "jetpack"
    "wordfence"
    "contact-form-7"
    "woocommerce"
    "akismet"
    "wpforms-lite"
    "google-analytics-for-wordpress"
    "really-simple-ssl"
    "all-in-one-seo-pack"
    "google-site-kit"
    "all-in-one-wp-migration"
    "updraftplus"
    "seo-by-rank-math"
    "optinmonster"
    "litespeed-cache"
    "essential-addons-for-elementor-lite"
    "sg-cachepress"
    "classic-editor"
    "astra-sites"
    "the-events-calendar"
    "limit-login-attempts-reloaded"
    "mailchimp-for-wp"
    "redirection"
    "wp-mail-smtp"
    "wp-smushit"
    "wp-super-cache"
    "insert-headers-and-footers"
    "advanced-custom-fields"
    "siteorigin-panels"
    "wordpress-importer"
    "wp-fastest-cache"
    "w3-total-cache"
    "ninja-forms"
    "mailpoet"
    "google-analytics-dashboard-for-wp"
    "duplicator"
    "instagram-feed"
    "gutenberg"
    "wp-optimize"
    "so-widgets-bundle"
    "nextgen-gallery"
    "google-sitemap-generator"
    "autoptimize"
    "facebook-for-woocommerce"
    "woocommerce-services"
    "ewww-image-optimizer"
    "premium-addons-for-elementor"
    "woocommerce-gateway-stripe"
    "duplicate-post"
    "tinymce-advanced"
    "header-footer-elementor"
    "cookie-law-info"
    "better-wp-security"
    "cookie-notice"
    "duplicate-page"
    "all-in-one-wp-security-and-firewall"
    "woocommerce-payments"
    "ml-slider"
    "newsletter"
    "google-listings-and-ads"
    "mainwp-child"
    "loco-translate"
    "redux-framework"
    "wp-statistics"
    "yith-woocommerce-wishlist"
    "ultimate-addons-for-gutenberg"
    "coming-soon"
    "sg-security"
    "wp-file-manager"
    "wps-hide-login"
    "disable-comments"
    "elementskit-lite"
    "wp-google-maps"
    "loginizer"
    "sucuri-scanner"
    "coblocks"
    "kadence-blocks"
    "formidable"
    "ocean-extra"
    "regenerate-thumbnails"
    "worker"
    "shortcodes-ultimate"
    "creative-mail-by-constant-contact"
    "polylang"
    "mailchimp-for-woocommerce"
    "user-role-editor"
    "meta-box"
    "broken-link-checker"
    "custom-post-type-ui"
    "photo-gallery"
    "accelerated-mobile-pages"
    "smart-slider-3"
    "add-to-any"
    "cleantalk-spam-protect"
    "complianz-gdpr"
    "wp-maintenance-mode"
    "tablepress"
    "one-click-demo-import"
    "popup-maker"
    "leadin"
    "woocommerce-pdf-invoices-packing-slips"
    "ad-inserter"
    "backwpup"
    "woocommerce-paypal-payments"
    "amp"
    "better-search-replace"
    "malcare-security"
    "breadcrumb-navxt"
    "wptouch"
    "shortpixel-image-optimiser"
    "hello-dolly"
    "post-smtp"
    "easy-table-of-contents"
    "wp-user-avatar"
    "wp-seopress"
    "query-monitor"
    "click-to-chat-for-whatsapp"
    "buddypress"
    "imagify"
    "post-types-order"
    "wp-pagenavi"
    "wp-simple-firewall"
    "themeisle-companion"
    "pixelyoursite"
    "creame-whatsapp-me"
    "maintenance"
    "gtranslate"
    "ultimate-social-media-icons"
    "code-snippets"
    "translatepress-multilingual"
    "easy-wp-smtp"
    "redis-cache"
    "email-subscribers"
    "webp-converter-for-media"
    "beaver-builder-lite-version"
    "black-studio-tinymce-widget"
    "under-construction-page"
    "enable-media-replace"
    "kirki"
    "duracelltomi-google-tag-manager"
    "yith-woocommerce-compare"
    "ultimate-member"
    "popup-builder"
    "unlimited-elements-for-elementor"
    "woo-product-feed-pro"
    "megamenu"
    "real-cookie-banner"
    "advanced-ads"
    "svg-support"
    "gdpr-cookie-compliance"
    "hostinger"
    "blocksy-companion"
    "antispam-bee"
    "wpvivid-backuprestore"
    "safe-svg"
    "download-manager"
    "really-simple-captcha"
    "otter-blocks"
    "envato-elements"
    "bbpress"
    "forminator"
    "wp-reviews-plugin-for-google"
    "fluentform"
    "official-facebook-pixel"
    "woocommerce-google-analytics-integration"
    "happy-elementor-addons"
    "wp-reset"
    "disable-gutenberg"
    "cloudflare"
    "give"
    "olympus-google-fonts"
    "ga-google-analytics"
    "taxonomy-terms-order"
    "pretty-link"
    "woo-variation-swatches"
    "wordpress-popular-posts"
    "youtube-embed-plus"
    "breeze"
    "yet-another-related-posts-plugin"
    "custom-facebook-feed"
    "calculated-fields-form"
    "custom-css-js"
    "cartflows"
    "woo-checkout-field-editor-pro"
    "wp-whatsapp-chat"
    "social-networks-auto-poster-facebook-twitter-g"
    "iwp-client"
    "royal-elementor-addons"
    "stops-core-theme-and-plugin-updates"
    "wp-migrate-db"
    "flamingo"
    "jetpack-boost"
    "relevanssi"
    "simple-history"
    "wp-multibyte-patch"
    "gotmls"
    "admin-menu-editor"
    "easy-fancybox"
    "child-theme-configurator"
    "host-webfonts-local"
    "flexible-shipping"
    "wp-slimstat"
    "use-any-font"
    "pagelayer"
    "header-footer-code-manager"
    "templately"
    "paid-memberships-pro"
    "pinterest-for-woocommerce"
    "advanced-access-manager"
    "wp-security-audit-log"
    "envira-gallery-lite"
    "googleanalytics"
    "everest-forms"
    "nextend-facebook-connect"
    "webappick-product-feed-for-woocommerce"
    "sassy-social-share"
    "classic-widgets"
    "featured-image-from-url"
    "vk-all-in-one-expansion-unit"
    "google-captcha"
    "schema-and-structured-data-for-wp"
    "wp-force-login"
    "loginpress"
    "optimole-wp"
    "woo-cart-abandonment-recovery"
    "download-monitor"
    "nginx-helper"
    "yith-woocommerce-quick-view"
    "call-now-button"
    "wp-retina-2x"
    "contact-form-cfdb7"
    "responsive-lightbox"
    "woocommerce-checkout-manager"
    "members"
    "cmp-coming-soon-maintenance"
    "password-protected"
    "powerpress"
    "easy-digital-downloads"
    "foogallery"
    "contact-form-plugin"
    "so-css"
    "cf7-conditional-fields"
    "events-manager"
    "debug-bar-elasticpress"
    "wp-crontrol"
    "mailin"
    "widget-importer-exporter"
    "customer-reviews-woocommerce"
    "themegrill-demo-importer"
    "custom-sidebars"
    "brizy"
    "simple-tags"
    "squirrly-seo"
    "maxbuttons"
    "backupwordpress"
    "form-maker"
    "shareaholic"
    "clever-fox"
    "filebird"
    "health-check"
    "hummingbird-performance"
    "header-footer"
    "import-users-from-csv-with-meta"
    "learnpress"
    "all-404-redirect-to-homepage"
    "page-links-to"
    "profile-builder"
    "siteguard"
    "cmb2"
    "content-views-query-and-display-post-page"
    "mappress-google-maps-for-wordpress"
    "image-widget"
    "essential-blocks"
    "wp-job-manager"
    "pods"
    "event-tickets"
    "woocommerce-square"
    "bulletproof-security"
    "yith-woocommerce-ajax-navigation"
    "custom-fonts"
    "ht-mega-for-elementor"
    "disqus-comment-system"
    "cookiebot"
    "woocommerce-germanized"
    "wp-all-import"
    "wp-asset-clean-up"
    "metform"
    "woocommerce-multilingual"
    "blogvault-real-time-backup"
    "quick-adsense-reloaded"
    "force-regenerate-thumbnails"
    "simple-share-buttons-adder"
    "responsive-menu"
    "iubenda-cookie-law-solution"
    "feed-them-social"
    "onesignal-free-web-push-notifications"
    "theme-my-login"
    "user-switching"
    "chaty"
    "widget-google-reviews"
    "image-optimization"
    "companion-auto-update"
    "pdf-embedder"
    "advanced-woo-search"
    "font-awesome"
    "wp-to-twitter"
    "wp-content-copy-protector"
    "woolentor-addons"
    "addons-for-elementor"
    "tawkto-live-chat"
    "wpcf7-redirect"
    "rvg-optimize-database"
    "autodescription"
    "wpsso"
    "list-category-posts"
    "a3-lazy-load"
    "all-in-one-event-calendar"
    "imsanity"
    "insta-gallery"
    "wordpress-popup"
    "astra-widgets"
    "blog2social"
    "woocommerce-jetpack"
    "white-label-cms"
    "pirate-forms"
    "simple-page-ordering"
    "wp-db-backup"
    "wp-staging"
    "menu-icons"
    "booking"
    "favicon-by-realfavicongenerator"
    "nitropack"
    "quttera-web-malware-scanner"
    "extendify"
    "tiny-compress-images"
    "adrotate"
    "wp-polls"
    "woo-stripe-payment"
    "strong-testimonials"
    "stackable-ultimate-gutenberg-blocks"
    "super-socializer"
    "wpdiscuz"
    "wp-members"
    "recent-posts-widget-with-thumbnails"
    "mollie-payments-for-woocommerce"
    "file-manager-advanced"
    "woocommerce-mercadopago"
    "backup"
    "contact-form-7-honeypot"
    "modula-best-grid-gallery"
    "aryo-activity-log"
    "product-import-export-for-woo"
    "dokan-lite"
    "advanced-nocaptcha-recaptcha"
    "widget-options"
    "xml-sitemap-feed"
    "post-views-counter"
    "fast-velocity-minify"
    "easy-google-fonts"
    "anti-spam"
    "wpcf7-recaptcha"
    "kadence-starter-templates"
    "wp-clone-by-wp-academy"
    "webp-express"
    "google-language-translator"
    "tweet-old-post"
    "templates-patterns-collection"
    "embedpress"
    "kliken-marketing-for-google"
    "backuply"
    "wp-postviews"
    "resmushit-image-optimizer"
    "ai-engine"
    "wp-photo-album-plus"
    "wp-live-chat-support"
    "mystickymenu"
    "copy-delete-posts"
    "bdthemes-prime-slider-lite"
    "table-of-contents-plus"
    "easy-facebook-likebox"
    "simple-social-icons"
    "supreme-modules-for-divi"
    "media-cleaner"
    "simple-custom-post-order"
    "post-grid"
    "wp-sitemap-page"
    "search-and-replace"
    "yith-woocommerce-ajax-search"
    "wd-instagram-feed"
    "capability-manager-enhanced"
    "user-registration"
    "wp-dbmanager"
    "adminimize"
    "colibri-page-builder"
    "auto-terms-of-service-and-privacy-policy"
    "defender-security"
    "the-plus-addons-for-elementor-page-builder"
    "google-calendar-events"
    "yith-woocommerce-zoom-magnifier"
    "wp-recipe-maker"
    "bdthemes-element-pack-lite"
    "vk-blocks"
    "ajax-search-for-woocommerce"
    "social-icons-widget-by-wpzoom"
    "wp-google-map-plugin"
    "master-slider"
    "post-expirator"
    "woosidebars"
    "simple-custom-css"
    "nimble-builder"
    "wp-rss-aggregator"
    "woo-order-export-lite"
    "real-media-library-lite"
    "addon-elements-for-elementor-page-builder"
    "ultimate-tinymce"
    "php-compatibility-checker"
    "convertkit"
    "uk-cookie-consent"
    "visualcomposer"
    "auxin-elements"
    "simple-membership"
    "appointment-hour-booking"
    "burst-statistics"
    "sticky-header-effects-for-elementor"
    "wp-mail-logging"
    "simple-301-redirects"
    "block-bad-queries"
    "wp-rollback"
    "powerpack-lite-for-elementor"
    "simple-lightbox"
    "post-duplicator"
    "tiktok-for-business"
    "media-file-renamer"
    "woocommerce-google-adwords-conversion-tracking-tag"
    "wp-hide-security-enhancer"
    "codepress-admin-columns"
    "wp-piwik"
    "ecwid-shopping-cart"
    "custom-twitter-feeds"
    "flexible-checkout-fields"
    "woocommerce-menu-bar-cart"
    "site-reviews"
    "tidio-live-chat"
    "ssl-insecure-content-fixer"
    "bookly-responsive-appointment-booking-tool"
    "instagram-slider-widget"
    "enhanced-media-library"
    "advanced-responsive-video-embedder"
    "my-calendar"
    "intuitive-custom-post-order"
    "qi-addons-for-elementor"
    "ultimate-social-media-plus"
    "enhanced-e-commerce-for-woocommerce-store"
    "weglot"
    "404page"
    "quiz-master-next"
    "peters-login-redirect"
    "cache-enabler"
    "presto-player"
    "web-stories"
    "foobox-image-lightbox"
    "mashsharer"
    "google-maps-widget"
    "customizer-export-import"
    "ditty-news-ticker"
    "subscribe2"
    "cyr2lat"
    "wp-all-export"
    "sumome"
    "stop-spammer-registrations-plugin"
    "users-customers-import-export-for-wp-woocommerce"
    "theme-check"
    "checkout-plugins-stripe-woo"
    "feedzy-rss-feeds"
    "tutor"
    "soliloquy-lite"
    "seo-ultimate"
    "icegram"
    "add-search-to-menu"
    "tracking-code-manager"
    "sydney-toolbox"
    "woocommerce-direct-checkout"
    "fv-wordpress-flowplayer"
    "link-library"
    "microthemer"
    "slider-wd"
    "quick-pagepost-redirect-plugin"
    "constant-contact-forms"
    "eps-301-redirects"
    "blogger-importer"
    "q2w3-fixed-widget"
    "contextual-related-posts"
    "wp-postratings"
    "custom-permalinks"
    "honeypot"
    "quiz-maker"
    "wp-letsencrypt-ssl"
    "ninjafirewall"
    "the-post-grid"
    "limit-login-attempts"
    "disable-remove-google-fonts"
    "clearfy"
    "amazon-s3-and-cloudfront"
    "printfriendly"
    "admin-custom-login"
    "woo-discount-rules"
    "social-media-widget"
    "mailoptin"
    "wp-review"
    "miniorange-2-factor-authentication"
    "gallery-by-supsystic"
    "media-library-assistant"
    "mailgun"
    "userfeedback-lite"
    "wp-analytify"
    "generateblocks"
    "google-sitemap-plugin"
    "instant-images"
    "fluent-smtp"
    "acf-content-analysis-for-yoast-seo"
    "minimal-coming-soon-maintenance-mode"
    "fast-indexing-api"
    "statify"
    "woocommerce-gateway-paypal-powered-by-braintree"
    "wonderm00ns-simple-facebook-open-graph-tags"
    "performance-lab"
    "perfect-woocommerce-brands"
    "robo-gallery"
    "mailchimp"
    "wp-database-backup"
    "advanced-iframe"
    "enable-jquery-migrate-helper"
    "mobile-menu"
    "async-javascript"
    "admin-site-enhancements"
    "quick-adsense"
    "ajax-load-more"
    "instagram-widget-by-wpzoom"
    "ninja-tables"
    "ultimate-faqs"
    "bold-page-builder"
    "social-media-feather"
    "yith-woocommerce-catalog-mode"
    "wp-nested-pages"
    "kk-star-ratings"
    "mesmerize-companion"
    "weight-based-shipping-for-woocommerce"
    "404-to-301"
    "permalink-manager"
    "media-library-plus"
    "pubsubhubbub"
    "seriously-simple-podcasting"
    "go-live-update-urls"
    "hide-my-wp"
    "seo-image"
    "gallery-plugin"
    "wp-ulike"
    "varnish-http-purge"
    "vaultpress"
    "simple-local-avatars"
    "search-regex"
    "ultimate-post"
    "super-progressive-web-apps"
    "social-warfare"
    "fancybox-for-wordpress"
    "a2-optimized-wp"
    "check-email"
    "speedycache"
    "cost-calculator-builder"
    "yikes-inc-easy-custom-woocommerce-product-tabs"
    "yet-another-stars-rating"
    "woo-advanced-shipment-tracking"
    "siteground-migrator"
    "boldgrid-backup"
    "interactive-3d-flipbook-powered-physics-engine"
    "official-mailerlite-sign-up-forms"
    "wordpress-simple-paypal-shopping-cart"
    "gravity-forms-pdf-extended"
    "visual-portfolio"
    "woocommerce-products-filter"
    "official-statcounter-plugin-for-wordpress"
    "menu-image"
    "variation-swatches-woo"
    "happyforms"
    "wp-meta-and-date-remover"
    "woo-product-bundle"
    "buttonizer-multifunctional-button"
    "woocommerce-currency-switcher"
    "secure-copy-content-protection"
    "ays-popup-box"
    "stripe-payments"
    "visualizer"
    "social-pug"
    "post-type-switcher"
    "page-scroll-to-id"
    "all-in-one-schemaorg-rich-snippets"
    "woo-razorpay"
    "ocean-social-sharing"
    "greenshift-animation-and-page-builder-blocks"
    "facebook-messenger-customer-chat"
    "iframe"
    "custom-registration-form-builder-with-submission-manager"
    "persian-woocommerce"
    "pw-woocommerce-gift-cards"
    "visual-form-builder"
    "kadence-woocommerce-email-designer"
    "login-lockdown"
    "wp-fail2ban"
    "underconstruction"
    "xhanch-my-twitter"
    "woo-product-filter"
    "recent-posts-widget-extended"
    "nav-menu-roles"
    "jeg-elementor-kit"
    "stream"
    "wp-ultimate-csv-importer"
    "mw-wp-form"
    "wp-console"
    "matomo"
    "acf-extended"
    "order-import-export-for-woocommerce"
    "business-directory-plugin"
    "event-organiser"
    "woo-smart-wishlist"
    "wpremote"
    "debug-bar"
    "geodirectory"
    "auto-post-thumbnail"
    "image-slider-widget"
    "ezoic-integration"
    "print-invoices-packing-slip-labels-for-woocommerce"
    "host-analyticsjs-local"
    "visitors-traffic-real-time-statistics"
    "wp-edit"
    "3d-flipbook-dflip-lite"
    "wpdatatables"
    "migrate-guru"
    "security-malware-firewall"
    "easy-media-gallery"
    "category-posts"
    "sticky-menu-or-anything-on-scroll"
    "login-customizer"
    "shortcoder"
    "wpcat2tag-importer"
    "ajax-search-lite"
    "contact-form-to-email"
    "backup-backup"
    "wp-sweep"
    "miniorange-login-openid"
    "safe-redirect-manager"
    "virtue-toolkit"
    "simple-sitemap"
    "insert-php"
    "printful-shipping-for-woocommerce"
    "robin-image-optimizer"
    "genesis-blocks"
    "advanced-gutenberg"
    "post-and-page-builder"
    "wp-force-ssl"
    "wpfront-scroll-top"
    "advanced-database-cleaner"
    "s2member"
    "cms-tree-page-view"
    "zero-bs-crm"
    "betterdocs"
    "popup-by-supsystic"
    "wp-user-frontend"
    "content-aware-sidebars"
    "wp-carousel-free"
    "gpt3-ai-content-generator"
    "facebook-pagelike-widget"
    "advanced-excerpt"
    "woo-smart-compare"
    "easy-appointments"
    "wp-downgrade"
    "custom-post-type-permalinks"
    "contact-form-7-dynamic-text-extension"
    "ultimate-blocks"
    "wordpress-reset"
    "woocommerce-ajax-filters"
    "wc-frontend-manager"
    "speed-booster-pack"
    "folders"
    "rocket-lazy-load"
    "all-in-one-favicon"
    "email-address-encoder"
    "paid-member-subscriptions"
    "options-framework"
    "intelly-related-posts"
    "live-composer-page-builder"
    "simple-banner"
    "ads-txt"
    "wp-external-links"
    "lifterlms"
    "wordpress-database-reset"
    "data-tables-generator-by-supsystic"
    "editorial-calendar"
    "tenweb-speed-optimizer"
    "easy-theme-and-plugin-upgrades"
    "simply-schedule-appointments"
    "file-manager"
    "ele-custom-skin"
    "depicter"
    "stopbadbots"
    "ultimate-responsive-image-slider"
    "athemes-starter-sites"
    "vk-block-patterns"
    "schema"
    "wp-time-capsule"
    "wd-facebook-feed"
    "simple-author-box"
    "addquicktag"
    "woocommerce-shipstation-integration"
    "video-conferencing-with-zoom-api"
    "yellow-pencil-visual-theme-customizer"
    "wp-headers-and-footers"
    "xcloner-backup-and-restore"
    "coming-soon-page"
    "shortpixel-adaptive-images"
    "gutentor"
    "pwa-for-wp"
    "connections"
    "advanced-custom-fields-font-awesome"
    "zopim-live-chat"
    "wpforo"
    "login-recaptcha"
    "timber-library"
    "custom-login"
    "zero-spam"
    "ultimate-product-catalogue"
    "ecommerce-product-catalog"
    "kali-forms"
    "gwolle-gb"
    "jetpack-protect"
    "google-maps-easy"
    "option-tree"
    "wp-file-upload"
    "custom-contact-forms"
    "wp-logo-showcase-responsive-slider-slider"
    "feedwordpress"
    "advanced-import"
    "add-from-server"
    "ibtana-visual-editor"
    "getwid"
    "responsive-add-ons"
    "search-everything"
    "woo-smart-quick-view"
    "comments-from-facebook"
    "wp-store-locator"
    "klarna-payments-for-woocommerce"
    "facebook-button-plugin"
    "edit-author-slug"
    "gamipress"
    "rss-importer"
    "head-footer-code"
    "social-polls-by-opinionstage"
    "buddypress-media"
    "advanced-sidebar-menu"
    "variation-swatches-for-woocommerce"
    "wp-whatsapp"
    "wp-video-lightbox"
    "wp-table-builder"
    "twitter-tools"
    "wc-multivendor-marketplace"
    "antivirus"
    "xserver-typesquare-webfonts"
    "ithemes-sync"
    "simple-social-buttons"
    "participants-database"
    "header-and-footer-scripts"
    "woocommerce-legacy-rest-api"
    "smart-manager-for-wp-e-commerce"
    "wp-lightbox-2"
    "bp-better-messages"
    "mainwp"
    "user-access-manager"
    "like-box"
    "masterstudy-lms-learning-management-system"
    "woocommerce-product-addon"
    "uncanny-automator"
    "connect-polylang-elementor"
    "notificationx"
    "protect-uploads"
    "wp-accessibility"
    "wp-google-places-review-slider"
    "advanced-wp-reset"
    "advanced-google-recaptcha"
    "polldaddy"
    "wp-customer-reviews"
    "activecampaign-subscription-forms"
    "spotlight-social-photo-feeds"
    "jquery-updater"
    "klarna-checkout-for-woocommerce"
    "master-addons"
    "regenerate-thumbnails-advanced"
    "email-encoder-bundle"
    "public-post-preview"
    "facebook-conversion-pixel"
    "phoenix-media-rename"
    "smartcrawl-seo"
    "mainwp-child-reports"
    "thirstyaffiliates"
    "rating-widget"
    "complianz-terms-conditions"
    "custom-field-template"
    "co-authors-plus"
    "responsive-accordion-and-collapse"
    "heartbeat-control"
    "yop-poll"
    "feeds-for-youtube"
    "wp-cloudflare-page-cache"
    "wp-meta-seo"
    "temporary-login-without-password"
    "video-playlist-and-gallery-plugin"
    "string-locator"
    "woo-custom-product-addons"
    "postie"
    "anywhere-elementor"
    "livemesh-siteorigin-widgets"
    "mycred"
    "ip2location-country-blocker"
    "twitter-widget-pro"
    "to-top"
    "better-font-awesome"
    "contact-form-7-image-captcha"
    "accordions"
    "cloudflare-flexible-ssl"
    "top-10"
    "iq-block-country"
    "popup-anything-on-click"
    "genesis-enews-extended"
    "display-posts-shortcode"
    "hcaptcha-for-forms-and-more"
    "age-gate"
    "title-remover"
    "woocommerce-abandoned-cart"
    "pinterest-pin-it-button-on-image-hover-and-post"
    "reveal-ids-for-wp-admin-25"
    "hyper-cache"
    "pricing-table-by-supsystic"
    "usc-e-shop"
    "insert-php-code-snippet"
    "widget-css-classes"
    "ics-calendar"
    "woocommerce-delivery-notes"
    "video-embed-thumbnail-generator"
    "search-exclude"
    "elementor-beta"
    "seo-redirection"
    "login-with-ajax"
    "amazon-auto-links"
    "wp-native-php-sessions"
    "wpglobus"
    "woocommerce-xml-csv-product-import"
    "exploit-scanner"
    "wp-live-chat-software-for-wordpress"
    "imagemagick-engine"
    "exclusive-addons-for-elementor"
    "wpematico"
    "syntaxhighlighter"
    "remove-footer-credit"
    "wp-tab-widget"
    "facebook-by-weblizar"
    "woocommerce-product-price-based-on-countries"
    "sidebar-login"
    "disable-admin-notices"
    "simple-download-monitor"
    "spicebox"
    "bulk-delete"
    "expand-maker"
    "show-current-template"
    "exclude-pages"
    "fileorganizer"
    "wp-maintenance"
    "https-redirection"
    "styles-and-layouts-for-gravity-forms"
    "wp-shortcode"
    "ssl-zen"
    "wordfence-login-security"
    "autocomplete-woocommerce-orders"
    "quick-featured-images"
    "ag-custom-admin"
    "aftership-woocommerce-tracking"
    "wp-editor"
    "hotjar"
    "user-submitted-posts"
    "blocks-animation"
    "shariff"
    "wp-seo-structured-data-schema"
    "shapepress-dsgvo"
    "grand-media"
    "mailchimp-forms-by-mailmunch"
    "wptelegram"
    "learnpress-course-review"
    "duplicate-wp-page-post"
    "blossomthemes-email-newsletter"
    "beautiful-and-responsive-cookie-consent"
    "carousel-slider"
    "testimonial-free"
    "php-code-widget"
    "dynamic-widgets"
    "ooohboi-steroids-for-elementor"
    "if-menu"
    "wp-paginate"
    "facebook-auto-publish"
    "wp-graphql"
    "wp-socializer"
    "simply-static"
    "quadmenu"
    "smtp-mailer"
    "contact-form-lite"
    "astra-import-export"
    "metronet-profile-picture"
    "sidebar-manager"
    "side-cart-woocommerce"
    "subscribe-to-comments-reloaded"
    "blog-designer"
    "atum-stock-manager-for-woocommerce"
    "searchwp-live-ajax-search"
    "affiliates-manager"
    "paypal-donations"
    "meta-tag-manager"
    "newstatpress"
    "woo-mailerlite"
    "ocean-product-sharing"
    "oa-social-login"
    "bnfw"
    "internal-links"
    "restaurant-reservations"
    "yith-woocommerce-request-a-quote"
    "widget-context"
    "upload-max-file-size"
    "advanced-cf7-db"
    "jetformbuilder"
    "wpfront-notification-bar"
    "woo-extra-product-options"
    "wp-add-custom-css"
    "woocustomizer"
    "amoforms"
    "profilegrid-user-profiles-groups-and-communities"
    "surecart"
    "simple-image-sizes"
    "leaflet-maps-marker"
    "advanced-dynamic-pricing-for-woocommerce"
    "fg-joomla-to-wordpress"
    "seo-simple-pack"
    "related-posts-thumbnails"
    "wp-dark-mode"
    "colorlib-login-customizer"
    "g-business-reviews-rating"
    "auxin-portfolio"
    "wp-2fa"
    "contact-form-7-simple-recaptcha"
    "two-factor"
    "wp-useronline"
    "disable-google-fonts"
    "wp-phpmyadmin-extension"
    "ultimate-addons-for-contact-form-7"
    "slim-seo"
    "automatic-translator-addon-for-loco-translate"
    "column-shortcodes"
    "wp-clean-up-optimizer"
    "disable-emojis"
    "image-watermark"
    "restricted-site-access"
    "portfolio-filter-gallery"
    "booking-package"
    "embed-any-document"
    "ozh-admin-drop-down-menu"
    "sportspress"
    "woocommerce-wholesale-prices"
    "wp-responsive-menu"
    "addons-for-visual-composer"
    "widget-countdown"
    "woo-variation-gallery"
    "blossomthemes-toolkit"
    "wp-responsive-recent-post-slider"
    "gmap-embed"
    "woo-multi-currency"
    "portfolio-post-type"
    "groups"
    "yith-woocommerce-badges-management"
    "easy-accordion-free"
    "woocommerce-sendinblue-newsletter-subscription"
    "wp-youtube-lyte"
    "woocommerce-extra-checkout-fields-for-brazil"
    "simple-image-widget"
    "drag-and-drop-multiple-file-upload-contact-form-7"
    "site-offline"
    "shopengine"
    "final-tiles-grid-gallery-lite"
    "tuxedo-big-file-uploads"
    "page-builder-add"
    "fluent-crm"
    "ultimate-dashboard"
    "wp-jquery-lightbox"
    "bj-lazy-load"
    "tumblr-importer"
)

# Define user agents with weights
declare -A USER_AGENTS
USER_AGENTS=(
    ["Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36"]=5
    ["Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/14.1.1 Safari/605.1.15"]=4
    ["Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:89.0) Gecko/20100101 Firefox/89.0"]=7
    ["Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.114 Safari/537.36"]=6
    ["Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.114 Safari/537.36 Edg/91.0.864.54"]=5
    ["Mozilla/5.0 (X11; Linux x86_64; rv:89.0) Gecko/20100101 Firefox/89.0"]=4
    ["Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36 OPR/77.0.4054.277"]=3
    ["Mozilla/5.0 (iPhone; CPU iPhone OS 14_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/14.1.1 Mobile/15E148 Safari/604.1"]=2
    ["Mozilla/5.0 (iPad; CPU OS 14_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/14.1.1 Mobile/15E148 Safari/604.1"]=2
    ["Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36 Vivaldi/4.0"]=1
    ["Mozilla/5.0 (Android 11; Mobile; rv:68.0) Gecko/68.0 Firefox/88.0"]=1
    ["Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/129.0.0.0 Safari/537.36"]=15
    ["Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/129.0.0.0 Safari/534.36"]=12
)

OPENED_PLUGINS_FILE="${WORDPRESS_WORKDIR}/opened_plugins.txt"
CLOSED_PLUGINS_FILE="${WORDPRESS_WORKDIR}/closed_plugins.txt"
LAST_VERSION_FILE="${WORDPRESS_WORKDIR}/last_versions.txt"
PARALLEL_JOBS=1

DOWNLOAD_ALL_PLUGINS='n'
LIST_ONLY='n'
ALL_PLUGINS_FILE="${WORDPRESS_WORKDIR}/wp-plugin-svn-list.txt"
START_COUNT=0
END_COUNT=0

DELAY_DOWNLOADS='n'
DELAY_DURATION=5

FORCE_UPDATE='n'
CACHE_ONLY='n'

mkdir -p "$WORDPRESS_WORKDIR" "$MIRROR_DIR" "$LOGS_DIR"
rm -f "$OPENED_PLUGINS_FILE"
touch "$OPENED_PLUGINS_FILE"
DEBUG_MODE=0

while getopts "p:dalD:t:fcs:e:" opt; do
    case ${opt} in
        p ) PARALLEL_JOBS=$OPTARG ;;
        d ) DEBUG_MODE=1 ;;
        a ) DOWNLOAD_ALL_PLUGINS='y' ;;
        l ) LIST_ONLY='y' ;;
        D ) DELAY_DOWNLOADS=$OPTARG ;;
        t ) DELAY_DURATION=$OPTARG ;;
        f ) FORCE_UPDATE='y' ;;
        c ) CACHE_ONLY='y' ;;
        s ) START_COUNT=$OPTARG ;;
        e ) END_COUNT=$OPTARG ;;
        \? ) echo "Usage: $0 [-p PARALLEL_JOBS] [-d] [-a] [-l] [-D DELAY_DOWNLOADS] [-t DELAY_DURATION] [-f] [-c] [-s START_COUNT] [-e END_COUNT]" 1>&2; exit 1 ;;
    esac
done

debug_log() {
    if [ "$DEBUG_MODE" -eq 1 ]; then
        echo "[DEBUG] $1" >&2
    fi
}

get_random_user_agent() {
    echo "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/129.0.0.0 Safari/537.36"
}

get_latest_version_and_download_link() {
    local plugin=$1
    debug_log "Checking latest version and download link for $plugin"
    
    local api_url="https://api.wordpress.org/plugins/info/1.0/${plugin}.json"
    local user_agent=$(get_random_user_agent)
    local api_response=$(curl -s -H "User-Agent: $user_agent" "$api_url")
    
    if echo "$api_response" | jq -e '.error' >/dev/null; then
        local error_message=$(echo "$api_response" | jq -r '.error')
        if [ "$error_message" = "closed" ]; then
            echo "closed"
            return 2
        else
        echo "Error: $error_message for plugin $plugin" >&2
        return 1
        fi
    fi
    
    local version=$(echo "$api_response" | jq -r '.version // empty')
    local download_link=$(echo "$api_response" | jq -r '.download_link // empty')
    
    if [ -n "$version" ] && [ -n "$download_link" ]; then
        echo "$version $download_link"
        return 0
    else
        echo "Error: Cannot fetch version or download link for $plugin" >&2
        return 1
    fi
}

download_plugin() {
    local plugin=$1
    local version=$2
    local api_download_link=$3
    local output_file="${MIRROR_DIR}/${plugin}.${version}.zip"
    local header_file="${LOGS_DIR}/${plugin}.${version}.headers"
    local constructed_download_link="${DOWNLOAD_BASE_URL}/${plugin}.${version}.zip"
    local download_link

    if [ "$DEBUG_MODE" -eq 1 ]; then
        debug_log "API-provided download link for $plugin: $api_download_link"
        debug_log "Constructed download link for $plugin: $constructed_download_link"
    fi

    if [ "$DOWNLOAD_LINK_API" == 'y' ] && [ -n "$api_download_link" ]; then
        download_link="$api_download_link"
        debug_log "Using API-provided download link for $plugin: $download_link"
    else
        download_link="$constructed_download_link"
        debug_log "Using constructed download link for $plugin: $download_link"
    fi

    debug_log "Downloading $plugin version $version through Cloudflare Worker"

    if [ "$DELAY_DOWNLOADS" == 'y' ]; then
        debug_log "Delaying download for $DELAY_DURATION seconds"
        sleep "$DELAY_DURATION"
    fi

    # Add cache_only parameter if CACHE_ONLY is set
    local cache_only_param=""
    if [ "$CACHE_ONLY" == 'y' ]; then
        cache_only_param="&cache_only=true"
    fi

    local user_agent=$(get_random_user_agent)
    if [ "$CACHE_ONLY" == 'y' ]; then
        curl -s -L -H "User-Agent: $user_agent" -D "$header_file" -o /dev/null "${CF_WORKER_URL}?url=${download_link}&plugin=${plugin}&version=${version}&type=zip${cache_only_param}"
    else
        curl -s -L -H "User-Agent: $user_agent" -D "$header_file" -o "$output_file" "${CF_WORKER_URL}?url=${download_link}&plugin=${plugin}&version=${version}&type=zip${cache_only_param}"
    fi

    if [ $? -eq 0 ]; then
        if [ "$CACHE_ONLY" == 'y' ]; then
            debug_log "Plugin $plugin version $version cached successfully."
            return 0
        fi

        local file_size=$(stat -c%s "$output_file")
        if [ "$file_size" -lt 1000 ]; then
            echo "Error: Downloaded file for $plugin is too small (${file_size} bytes). Possible download issue." >&2
            return 1
        fi

        local source=$(grep -i "X-Source:" "$header_file" | cut -d' ' -f2 | tr -d '\r')
        if [ "$source" == "R2" ]; then
            debug_log "Successfully downloaded $plugin version $version from R2 storage"
        elif [ "$source" == "WordPress" ]; then
            debug_log "Successfully downloaded $plugin version $version from WordPress"
            debug_log "R2 bucket saving for plugin zip occurred"
        else
            debug_log "Skipped download for $plugin $version zip (already exists locally)"
        fi

        return 0
    else
        echo "Error: Failed to download $plugin version $version" >&2
        return 1
    fi
}

save_plugin_info() {
    local plugin=$1
    local version=$2
    local output_file="${LOGS_DIR}/${plugin}.${version}.json"

    debug_log "Saving plugin json metadata for $plugin version $version"

    if [ "$DELAY_DOWNLOADS" == 'y' ]; then
        debug_log "Delaying metadata download for $DELAY_DURATION seconds"
        sleep "$DELAY_DURATION"
    fi

    local force_update_param=""
    if [ "$FORCE_UPDATE" == 'y' ]; then
        force_update_param="&force_update=true"
    fi

    # Add cache_only parameter if CACHE_ONLY is set
    local cache_only_param=""
    if [ "$CACHE_ONLY" == 'y' ]; then
        cache_only_param="&cache_only=true"
    fi

    local user_agent=$(get_random_user_agent)

    if [ "$CACHE_ONLY" == 'y' ]; then
        # When in cache-only mode, output to /dev/null
        curl -s -H "User-Agent: $user_agent" -o /dev/null "${CF_WORKER_URL}?plugin=${plugin}&version=${version}&type=json${force_update_param}${cache_only_param}"
        if [ $? -eq 0 ]; then
            debug_log "Plugin metadata for $plugin version $version cached successfully."
            return 0
        else
            echo "Error: Failed to cache json metadata for $plugin version $version" >&2
            return 1
        fi
    else
        local response=$(curl -s -H "User-Agent: $user_agent" -w "%{http_code}" -o "$output_file" "${CF_WORKER_URL}?plugin=${plugin}&version=${version}&type=json${force_update_param}${cache_only_param}")
        local status_code="${response: -3}"

        if [ "$status_code" = "200" ] && [ -s "$output_file" ]; then
            local source=$(jq -r '.["X-Source"] // empty' "$output_file" 2>/dev/null)
            if [ "$source" = "R2" ]; then
                debug_log "json metadata for $plugin version $version retrieved from R2 bucket"
            elif [ "$source" = "WordPress" ]; then
                debug_log "json metadata for $plugin version $version fetched from WordPress"
                debug_log "R2 bucket saving for plugin json occurred"
            else
                debug_log "json metadata for $plugin version $version saved (json metadata file already exists)"
            fi
            return 0
        else
            echo "Error: Failed to save json metadata for $plugin version $version (HTTP status: $status_code)" >&2
            if [ -s "$output_file" ]; then
                debug_log "Error response: $(cat "$output_file")"
            fi
            return 1
        fi
    fi
}

fetch_and_save_checksums() {
    local plugin=$1
    local version=$2
    local output_file="${LOGS_DIR}/${plugin}.${version}.checksums.json"

    debug_log "Fetching and saving checksums for $plugin version $version"

    if [ "$DELAY_DOWNLOADS" == 'y' ]; then
        debug_log "Delaying checksums download for $DELAY_DURATION seconds"
        sleep "$DELAY_DURATION"
    fi

    local force_update_param=""
    if [ "$FORCE_UPDATE" == 'y' ]; then
        force_update_param="&force_update=true"
    fi
    local cache_only_param=""
    if [ "$CACHE_ONLY" == 'y' ]; then
        cache_only_param="&cache_only=true"
    fi

    local user_agent=$(get_random_user_agent)

    debug_log "Sending request to Worker for checksums: CF_WORKER_URL?plugin=${plugin}&version=${version}&type=checksums${force_update_param}${cache_only_param}"

    if [ "$CACHE_ONLY" == 'y' ]; then
        curl -s -H "User-Agent: $user_agent" -o /dev/null "${CF_WORKER_URL}?plugin=${plugin}&version=${version}&type=checksums${force_update_param}${cache_only_param}"
        if [ $? -eq 0 ]; then
            debug_log "Plugin checksums for $plugin version $version cached successfully."
            return 0
        else
            echo "Error: Failed to cache checksums for $plugin version $version" >&2
            return 1
        fi
    else
        local response=$(curl -s -H "User-Agent: $user_agent" -w "%{http_code}" -o "$output_file" "${CF_WORKER_URL}?plugin=${plugin}&version=${version}&type=checksums${force_update_param}${cache_only_param}")
        local status_code="${response: -3}"

        debug_log "Received response with status code: $status_code"

        if [ "$status_code" = "200" ] && [ -s "$output_file" ]; then
            local source=$(jq -r '.["X-Source"] // empty' "$output_file" 2>/dev/null)
            debug_log "Response source: $source"
            if [ "$source" = "R2" ]; then
                debug_log "Checksums for $plugin version $version retrieved from R2 bucket"
            elif [ "$source" = "WordPress" ]; then
                debug_log "Checksums for $plugin version $version fetched from WordPress"
                debug_log "R2 bucket saving for plugin checksums occurred"
            else
                debug_log "Checksums for $plugin version $version saved (checksums file already exists)"
            fi
            return 0
        else
            echo "Error: Failed to save checksums for $plugin version $version (HTTP status: $status_code)" >&2
            if [ -s "$output_file" ]; then
                debug_log "Error response: $(cat "$output_file")"
            fi
            return 1
        fi
    fi
}

process_plugin() {
    local plugin=$1
    plugin=$(echo "$plugin" | sed 's/^\/\|\/$//g')

    # Check if the plugin is already known to be closed
    if grep -q "^$plugin$" "$CLOSED_PLUGINS_FILE" 2>/dev/null; then
        echo "Plugin $plugin is known to be closed. Skipping."
        return 0
    fi

    echo "Processing plugin: $plugin"

    VERSION_AND_LINK=$(get_latest_version_and_download_link "$plugin")
    local version_check_status=$?
    
    if [ $version_check_status -eq 1 ]; then
        echo "Skipping $plugin due to version fetch error."
        return 1
    elif [ $version_check_status -eq 2 ]; then
        echo "Plugin $plugin is closed. Skipping download and processing."
        echo "$plugin" >> "$CLOSED_PLUGINS_FILE"
        if save_plugin_info "$plugin" "closed"; then
            debug_log "Successfully saved json metadata for closed plugin $plugin."
        else
            debug_log "Failed to save json metadata for closed plugin $plugin."
        fi
        return 0
    fi
    
    LATEST_VERSION=$(echo "$VERSION_AND_LINK" | cut -d' ' -f1)
    API_DOWNLOAD_LINK=$(echo "$VERSION_AND_LINK" | cut -d' ' -f2-)

    debug_log "Latest version for $plugin: $LATEST_VERSION"
    debug_log "API download link for $plugin: $API_DOWNLOAD_LINK"

    STORED_VERSION=$(grep "^$plugin" "$LAST_VERSION_FILE" | awk '{print $2}')
    debug_log "Stored version for $plugin: $STORED_VERSION"

    if [ "$CACHE_ONLY" != 'y' ] && [ "$LATEST_VERSION" == "$STORED_VERSION" ] && [ -f "${MIRROR_DIR}/${plugin}.${LATEST_VERSION}.zip" ]; then
        echo "$plugin is up-to-date and exists in mirror directory. Skipping download..."
    else
        start_time=$(date +%s.%N)

        if download_plugin "$plugin" "$LATEST_VERSION" "$API_DOWNLOAD_LINK"; then
            if [ "$CACHE_ONLY" != 'y' ]; then
                sed -i "/^$plugin/d" "$LAST_VERSION_FILE"
                echo "$plugin $LATEST_VERSION" >> "$LAST_VERSION_FILE"
            fi
            echo "Successfully processed $plugin."
        else
            echo "Error: Failed to process $plugin." >&2
        fi

        end_time=$(date +%s.%N)
        duration=$(echo "$end_time - $start_time" | bc)
        printf "Time taken for %s: %.4f seconds\n" "$plugin" "$duration"
    fi

    if save_plugin_info "$plugin" "$LATEST_VERSION"; then
        debug_log "Successfully saved json metadata for $plugin."
    else
        debug_log "Failed to save json metadata for $plugin."
    fi

    if fetch_and_save_checksums "$plugin" "$LATEST_VERSION"; then
        debug_log "Successfully fetched and saved checksums for $plugin."
    else
        debug_log "Failed to fetch and save checksums for $plugin."
    fi

    if [ $version_check_status -eq 0 ]; then
        echo "$plugin" >> "$OPENED_PLUGINS_FILE"
    fi
}

populate_all_plugins() {
    if [ ! -f "$ALL_PLUGINS_FILE" ] || [ "$LIST_ONLY" == 'y' ]; then
        echo "Fetching list of all WordPress plugins..."
        svn list https://plugins.svn.wordpress.org/ | sed 's/\/$//g' > "$ALL_PLUGINS_FILE"
        plugin_count=$(wc -l < "$ALL_PLUGINS_FILE")
        echo "Plugin list (${plugin_count}) saved to $ALL_PLUGINS_FILE"
    fi
    
    if [ "$LIST_ONLY" == 'n' ]; then
        ALL_PLUGINS=()
        if [ "$DOWNLOAD_ALL_PLUGINS" == 'y' ] && [ $START_COUNT -gt 0 ] && [ $END_COUNT -ge $START_COUNT ]; then
            echo "Processing plugins from line $START_COUNT to $END_COUNT"
            while IFS= read -r line; do
                ALL_PLUGINS+=("$line")
            done < <(sed -n "${START_COUNT},${END_COUNT}p" "$ALL_PLUGINS_FILE")
        else
            while IFS= read -r line; do
                ALL_PLUGINS+=("$line")
            done < "$ALL_PLUGINS_FILE"
        fi
        echo "Loaded ${#ALL_PLUGINS[@]} plugins."
    fi
}

if [ "$LIST_ONLY" == 'y' ]; then
    populate_all_plugins
    echo "Plugin list created. Exiting without downloading."
    exit 0
fi

if [ "$DOWNLOAD_ALL_PLUGINS" == 'y' ]; then
    populate_all_plugins
    COMBINED_PLUGINS=("${ALL_PLUGINS[@]}")
else
    if [ ! -d "$PLUGIN_DIR" ]; then
        echo "Warning: Plugin directory $PLUGIN_DIR does not exist or is invalid."
        PLUGIN_LIST=()
    else
        PLUGIN_LIST=($(ls -d "$PLUGIN_DIR"/*/ 2>/dev/null | xargs -n 1 basename))

        if [ ${#PLUGIN_LIST[@]} -eq 0 ]; then
            echo "No plugins found in $PLUGIN_DIR."
        fi
    fi

    COMBINED_PLUGINS=(${PLUGIN_LIST[@]} ${ADDITIONAL_PLUGINS[@]})
    COMBINED_PLUGINS=($(echo "${COMBINED_PLUGINS[@]}" | tr ' ' '\n' | sort -u | tr '\n' ' '))
fi

if [ ${#COMBINED_PLUGINS[@]} -eq 0 ]; then
    echo "No plugins to download. Exiting."
    exit 0
fi

mkdir -p "$MIRROR_DIR"
touch "$LAST_VERSION_FILE"

if [ "$PARALLEL_JOBS" -gt 1 ]; then
    echo "Running in parallel with $PARALLEL_JOBS jobs..."
    echo "Variables before export:"

    # WordPress-related directories
    echo "WORDPRESS_WORKDIR: $WORDPRESS_WORKDIR"
    echo "PLUGIN_DIR: $PLUGIN_DIR"
    echo "MIRROR_DIR: $MIRROR_DIR"
    echo "LOGS_DIR: $LOGS_DIR"

    # Cloudflare Worker related URLs
    echo "CF_WORKER_URL: $CF_WORKER_URL"

    # Flags and options
    echo "DOWNLOAD_LINK_API: $DOWNLOAD_LINK_API"
    echo "DOWNLOAD_ALL_PLUGINS: $DOWNLOAD_ALL_PLUGINS"
    echo "LIST_ONLY: $LIST_ONLY"
    echo "DELAY_DOWNLOADS: $DELAY_DOWNLOADS"
    echo "DELAY_DURATION: $DELAY_DURATION"
    echo "FORCE_UPDATE: $FORCE_UPDATE"
    echo "CACHE_ONLY: $CACHE_ONLY"

    # File paths
    echo "OPENED_PLUGINS_FILE: $OPENED_PLUGINS_FILE"
    echo "CLOSED_PLUGINS_FILE: $CLOSED_PLUGINS_FILE"
    echo "LAST_VERSION_FILE: $LAST_VERSION_FILE"
    echo "ALL_PLUGINS_FILE: $ALL_PLUGINS_FILE"

    # Parallel job configuration
    echo "PARALLEL_JOBS: $PARALLEL_JOBS"

    # User Agents mapping
    echo "USER_AGENTS: ${USER_AGENTS[@]}"

    # Additional plugins to be processed
    # echo "ADDITIONAL_PLUGINS: ${ADDITIONAL_PLUGINS[@]}"

    # Plugin List (loaded from directory or ALL_PLUGINS_FILE)
    #echo "PLUGIN_LIST: ${PLUGIN_LIST[@]}"
    #echo "COMBINED_PLUGINS: ${COMBINED_PLUGINS[@]}"

    # First, export all variables including USER_AGENTS
    export DOWNLOAD_BASE_URL MIRROR_DIR LAST_VERSION_FILE DEBUG_MODE DOWNLOAD_LINK_API LOGS_DIR ALL_PLUGINS_FILE DOWNLOAD_ALL_PLUGINS LIST_ONLY CF_WORKER_URL DELAY_DOWNLOADS DELAY_DURATION FORCE_UPDATE CACHE_ONLY WORDPRESS_WORKDIR PLUGIN_DIR PARALLEL_JOBS OPENED_PLUGINS_FILE CLOSED_PLUGINS_FILE USER_AGENTS

    # Then, export the functions
    export -f process_plugin get_latest_version_and_download_link download_plugin debug_log populate_all_plugins save_plugin_info get_random_user_agent fetch_and_save_checksums
    printf "%s\n" "${COMBINED_PLUGINS[@]}" | xargs -P $PARALLEL_JOBS -I {} bash -c 'process_plugin "$@"' _ {}
else
    for plugin in "${COMBINED_PLUGINS[@]}"; do
        process_plugin "$plugin"
    done
fi

if [ "$DOWNLOAD_ALL_PLUGINS" == 'y' ]; then
    if [ -f "$CLOSED_PLUGINS_FILE" ]; then
        echo
        echo "Closed Plugin List: $CLOSED_PLUGINS_FILE"
        echo "Total closed plugins: $(wc -l < "$CLOSED_PLUGINS_FILE")"
    else
        echo
        echo "No closed plugins found."
    fi
    if [ -f "$OPENED_PLUGINS_FILE" ]; then
        echo
        echo "Opened Plugin List: $OPENED_PLUGINS_FILE"
        echo "Total opened plugins: $(wc -l < "$OPENED_PLUGINS_FILE")"
    else
        echo
        echo "No open plugins found."
    fi
fi
echo "Plugin download process completed."

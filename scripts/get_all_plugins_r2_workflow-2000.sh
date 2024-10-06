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
    "dc-woocommerce-multi-vendor"
    "asgaros-forum"
    "wpfront-user-role-editor"
    "wp-meteor"
    "wp-smtp"
    "woo-rfq-for-woocommerce"
    "user-menus"
    "rara-one-click-demo-import"
    "bbp-style-pack"
    "insert-pages"
    "wp-auto-affiliate-links"
    "skt-templates"
    "yaymail"
    "independent-analytics"
    "ns-cloner-site-copier"
    "ajax-thumbnail-rebuild"
    "full-site-editing"
    "invisible-recaptcha"
    "woocommerce-customizer"
    "enhanced-text-widget"
    "wc-vendors"
    "wplegalpages"
    "essential-content-types"
    "real-time-find-and-replace"
    "pantheon-advanced-page-cache"
    "wp-product-feed-manager"
    "countdown-builder"
    "cdn-enabler"
    "koko-analytics"
    "echo-knowledge-base"
    "userswp"
    "wp-bulk-delete"
    "pymntpl-paypal-woocommerce"
    "wc-multivendor-membership"
    "categories-images"
    "tabs-responsive"
    "delete-duplicate-posts"
    "real-time-auto-find-and-replace"
    "search-filter"
    "easy-video-player"
    "image-sizes"
    "woocommerce-correios"
    "mega-addons-for-visual-composer"
    "advanced-product-fields-for-woocommerce"
    "genesis-simple-hooks"
    "mp-timetable"
    "timeline-widget-addon-for-elementor"
    "easy-pricing-tables"
    "block-options"
    "snow-monkey-blocks"
    "headspace2"
    "cryout-theme-settings"
    "ip-geo-block"
    "gosmtp"
    "hide-admin-bar"
    "email-log"
    "change-wp-admin-login"
    "amazon-web-services"
    "stop-user-enumeration"
    "wp-redis"
    "woocommerce-products-slider"
    "famethemes-demo-importer"
    "woo-wallet"
    "wp-subscribe"
    "weforms"
    "slideshow-gallery"
    "charitable"
    "movabletype-importer"
    "advanced-custom-fields-table-field"
    "keon-toolset"
    "template-kit-import"
    "two-factor-authentication"
    "boldgrid-easy-seo"
    "easy-social-icons"
    "klaviyo"
    "wp-insert"
    "lead-form-builder"
    "uncanny-learndash-toolkit"
    "youtube-embed"
    "elasticpress"
    "full-customer"
    "manage-notification-emails"
    "wp-image-zoooom"
    "another-wordpress-classifieds-plugin"
    "pw-bulk-edit"
    "acf-frontend-form-element"
    "woo-product-slider"
    "use-google-libraries"
    "disable-wordpress-updates"
    "stripe"
    "ameliabooking"
    "conditional-menus"
    "lightbox-photoswipe"
    "contact-form-entries"
    "advanced-coupons-for-woocommerce-free"
    "simply-gallery-block"
    "wp-import-export-lite"
    "draw-attention"
    "wp-easycart"
    "gallery-custom-links"
    "api-key-for-google-maps"
    "404-solution"
    "gallery-videos"
    "wp-parsidate"
    "no-category-base-wpml"
    "astra-bulk-edit"
    "wp-event-manager"
    "asesor-cookies-para-la-ley-en-espana"
    "spacer"
    "postmark-approved-wordpress-plugin"
    "cool-timeline"
    "acf-to-rest-api"
    "cf7-widget-elementor"
    "plugin-organizer"
    "catch-ids"
    "wp-print"
    "themehunk-customizer"
    "photonic"
    "disable-comments-rb"
    "ocean-custom-sidebar"
    "jquery-pin-it-button-for-images"
    "security-ninja"
    "twitter"
    "advanced-backgrounds"
    "woocommerce-stock-manager"
    "wpide"
    "woo-fly-cart"
    "wp-htaccess-editor"
    "wp-performance-score-booster"
    "wf-cookie-consent"
    "customify"
    "woocommerce-payfast-gateway"
    "ninjascanner"
    "bwp-minify"
    "post-snippets"
    "themify-wc-product-filter"
    "wp-backitup"
    "powerkit"
    "sensei-lms"
    "hide-title"
    "psn-pagespeed-ninja"
    "headers-security-advanced-hsts-wp"
    "disable-json-api"
    "shapely-companion"
    "wp125"
    "woocommerce-conversion-tracking"
    "goodbye-captcha"
    "team-members"
    "wp-post-author"
    "woolementor"
    "blackhole-bad-bots"
    "smart-forms"
    "advanced-cron-manager"
    "swift-performance-lite"
    "animate-it"
    "content-control"
    "yith-woocommerce-brands-add-on"
    "the-events-calendar-shortcode"
    "wp-maximum-upload-file-size"
    "woocommerce-pdf-invoices"
    "arile-extra"
    "filester"
    "secupress"
    "gdpr-framework"
    "password-protect-page"
    "custom-post-widget"
    "wp-travel-engine"
    "meteor-slides"
    "wp-content-copy-protection"
    "jivochat"
    "optimus"
    "page-views-count"
    "calendar"
    "ocean-stick-anything"
    "best-woocommerce-feed"
    "directorist"
    "aweber-web-form-widget"
    "suretriggers"
    "mp3-music-player-by-sonaar"
    "reset-astra-customizer"
    "luckywp-table-of-contents"
    "crisp"
    "cf7-google-sheets-connector"
    "mystickyelements"
    "yith-essential-kit-for-woocommerce-1"
    "flow-flow-social-streams"
    "wowslider"
    "funnel-builder"
    "bp-profile-search"
    "theme-editor"
    "og"
    "wp-ses"
    "h5p"
    "wp-stats-manager"
    "yith-woocommerce-product-add-ons"
    "sina-extension-for-elementor"
    "global-translator"
    "schema-app-structured-data-for-schemaorg"
    "youtube-video-player"
    "gmail-smtp"
    "boxzilla"
    "easy-watermark"
    "persian-elementor"
    "widgets-on-pages"
    "gs-logo-slider"
    "booking-system"
    "easy-login-woocommerce"
    "get-the-image"
    "google-pagespeed-insights"
    "image-hover-effects-addon-for-elementor"
    "fakerpress"
    "google-authenticator"
    "mailjet-for-wordpress"
    "wp-compress-image-optimizer"
    "crop-thumbnails"
    "popups-for-divi"
    "contact-form-7-multi-step-module"
    "wp-html-mail"
    "wp-sms"
    "auto-image-attributes-from-filename-with-bulk-updater"
    "wordpress-mu-domain-mapping"
    "better-click-to-tweet"
    "download-plugins-dashboard"
    "hide-page-and-post-title"
    "wp-scheduled-posts"
    "resize-image-after-upload"
    "bv-cloudways-automated-migration"
    "pz-linkcard"
    "xml-sitemap-generator-for-google"
    "sp-news-and-widget"
    "say-what"
    "wp-popups-lite"
    "html5-video-player"
    "custom-taxonomy-order-ne"
    "userway-accessibility-widget"
    "custom-typekit-fonts"
    "contact-form-7-skins"
    "one-page-express-companion"
    "press-permit-core"
    "salon-booking-system"
    "erp"
    "http-headers"
    "gravity-forms-google-analytics-event-tracking"
    "all-in-one-video-gallery"
    "very-simple-contact-form"
    "futurio-extra"
    "cyr3lat"
    "cf7-grid-layout"
    "customizer-search"
    "acf-better-search"
    "contact-form-by-supsystic"
    "wp-user-manager"
    "multisite-language-switcher"
    "woo-bulk-editor"
    "customer-area"
    "jwt-authentication-for-wp-rest-api"
    "image-hover-effects-ultimate"
    "disable-xml-rpc-api"
    "countdown-timer-ultimate"
    "spiderblocker"
    "new-user-approve"
    "themify-portfolio-post"
    "learnpress-wishlist"
    "compact-wp-audio-player"
    "gutenverse"
    "wp-slick-slider-and-image-carousel"
    "google-apps-login"
    "kubio"
    "orbisius-child-theme-creator"
    "clear-cache-for-widgets"
    "wps-limit-login"
    "wp-sentry-integration"
    "intensedebate"
    "woocommerce-pagseguro"
    "wpjam-basic"
    "gravity-forms-zero-spam"
    "chartbeat"
    "related-posts-for-wp"
    "beaf-before-and-after-gallery"
    "wt-smart-coupons-for-woocommerce"
    "link-whisper"
    "ultimate-addons-for-beaver-builder-lite"
    "piotnet-addons-for-elementor"
    "pie-register"
    "loftloader"
    "blog-designer-pack"
    "loading-page"
    "wordpress-video-plugin"
    "pdf-print"
    "woo-preview-emails"
    "featured-images-for-rss-feeds"
    "acme-demo-setup"
    "wp-megamenu"
    "jetpack-social"
    "wp-show-posts"
    "content-egg"
    "raw-html"
    "html-editor-syntax-highlighter"
    "motopress-hotel-booking-lite"
    "wedevs-project-manager"
    "templatesnext-toolkit"
    "logo-carousel-free"
    "woo-permalink-manager"
    "post-carousel"
    "restrict-user-access"
    "whatshelp-chat-button"
    "download-plugin"
    "catch-infinite-scroll"
    "osm"
    "revision-control"
    "wp-events-manager"
    "woocommerce-mailchimp"
    "express-checkout-paypal-payment-gateway-for-woocommerce"
    "simple-job-board"
    "socialsnap"
    "yml-for-yandex-market"
    "nifty-coming-soon-and-under-construction-page"
    "klarna-order-management-for-woocommerce"
    "enhanced-tooltipglossary"
    "essential-real-estate"
    "yith-woocommerce-order-tracking"
    "back-in-stock-notifier-for-woocommerce"
    "classic-editor-addon"
    "microsoft-clarity"
    "wp-latest-posts"
    "trustpulse-api"
    "what-the-file"
    "flexible-shipping-ups"
    "add-to-cart-direct-checkout-for-woocommerce"
    "subscribe-to-comments"
    "navz-photo-gallery"
    "woocommerce-grid-list-toggle"
    "wp-travel"
    "woo-bought-together"
    "livejournal-importer"
    "wp-add-mime-types"
    "restrict-content"
    "woo-product-gallery-slider"
    "wp-last-modified-info"
    "dhl-for-woocommerce"
    "omnisend-connect"
    "shadowbox-js"
    "wpvr"
    "themify-builder"
    "booking-calendar"
    "sharethis-share-buttons"
    "wp-menu-icons"
    "pwa"
    "error-log-monitor"
    "wp-share-buttons-analytics-by-getsocial"
    "erident-custom-login-and-dashboard"
    "simple-css"
    "saphali-woocommerce-lite"
    "twentig"
    "whmcs-bridge"
    "jquery-colorbox"
    "wck-custom-fields-and-custom-post-types-creator"
    "clean-and-simple-contact-form-by-meg-nicholas"
    "chatbot"
    "rest-api"
    "local-google-fonts"
    "wp-speed-of-light"
    "cyclone-demo-importer"
    "woocommerce-advanced-free-shipping"
    "gn-publisher"
    "insert-html-snippet"
    "wicked-folders"
    "meks-smart-social-widget"
    "theme-test-drive"
    "burger-companion"
    "ultimate-category-excluder"
    "wp-health"
    "export-all-urls"
    "disable-xml-rpc"
    "shopmagic-for-woocommerce"
    "hide-admin-bar-based-on-user-roles"
    "yoast-test-helper"
    "timeline-express"
    "mage-eventpress"
    "lazy-load"
    "widgetkit-for-elementor"
    "email-template-customizer-for-woo"
    "social-media-auto-publish"
    "protect-wp-admin"
    "aruba-hispeed-cache"
    "wp-featherlight"
    "eroom-zoom-meetings-webinar"
    "zapier"
    "multiple-post-thumbnails"
    "wp-email"
    "pojo-accessibility"
    "easy-twitter-feed-widget"
    "yith-woocommerce-subscription"
    "wp-data-access"
    "dynamic-visibility-for-elementor"
    "ultimate-post-kit"
    "advanced-product-labels-for-woocommerce"
    "wp-paypal"
    "geoip-detect"
    "so-clean-up-wp-seo"
    "coschedule-by-todaymade"
    "wpappninja"
    "bm-custom-login"
    "comet-cache"
    "gravity-forms-custom-post-types"
    "wt-woocommerce-sequential-order-numbers"
    "broken-link-checker-seo"
    "wp-social"
    "catch-web-tools"
    "css-javascript-toolbox"
    "starbox"
    "yith-woocommerce-gift-cards"
    "ilab-media-tools"
    "apollo13-framework-extensions"
    "speedien"
    "qubely"
    "publish-to-apple-news"
    "fb-reviews-widget"
    "omnisend"
    "snazzy-maps"
    "wp-media-library-categories"
    "wordpress-beta-tester"
    "wordpress-tooltips"
    "user-photo"
    "wpzoom-elementor-addons"
    "jonradio-private-site"
    "mousewheel-smooth-scroll"
    "display-php-version"
    "metricool"
    "interactive-geo-maps"
    "ultimate-posts-widget"
    "clean-login"
    "dk-pricr-responsive-pricing-table"
    "instapage"
    "pdf-poster"
    "shortcode-in-menus"
    "make-column-clickable-elementor"
    "wp-typography"
    "genesis-simple-share"
    "delete-all-comments-of-website"
    "contact-forms-anti-spam"
    "seamless-donations"
    "payment-gateway-stripe-and-woocommerce-integration"
    "blockspare"
    "re-add-underline-justify"
    "woo-alidropship"
    "awesome-support"
    "custom-share-buttons-with-floating-sidebar"
    "wp-subtitle"
    "twitter-plugin"
    "ssh-sftp-updater-support"
    "pochipp"
    "gt3-photo-video-gallery"
    "flexible-product-fields"
    "reviewx"
    "testimonial-slider-and-showcase"
    "peepso-core"
    "podlove-podcasting-plugin-for-wordpress"
    "genesis-simple-sidebars"
    "inactive-logout"
    "woo-delivery"
    "youtube-channel"
    "login-logo"
    "kiwi-social-share"
    "woocommerce-auto-added-coupons"
    "raratheme-companion"
    "automatorwp"
    "woocommerce-sequential-order-numbers"
    "sierotki"
    "page-or-post-clone"
    "cardoza-facebook-like-box"
    "betterlinks"
    "wp-facebook-reviews"
    "login-sidebar-widget"
    "likebtn-like-button"
    "simple-cloudflare-turnstile"
    "cost-of-goods-for-woocommerce"
    "revisionary"
    "flash-toolkit"
    "float-menu"
    "redirect-redirection"
    "lightweight-social-icons"
    "rate-my-post"
    "wp-tiktok-feed"
    "advanced-woo-labels"
    "nelio-content"
    "appointment-booking-calendar"
    "yourchannel"
    "meks-easy-ads-widget"
    "wpc-composite-products"
    "admin-management-xtended"
    "simple-embed-code"
    "simple-page-sidebars"
    "woocommerce-for-japan"
    "duplicate-menu"
    "page-list"
    "filter-everything"
    "poll-maker"
    "plugins-garbage-collector"
    "gdpr-compliance-cookie-consent"
    "very-simple-event-list"
    "dynamicconditions"
    "afterpay-gateway-for-woocommerce"
    "catch-gallery"
    "wp-to-buffer"
    "rife-elementor-extensions"
    "remove-powered-by-wp"
    "open-external-links-in-a-new-window"
    "auto-install-free-ssl"
    "persian-woocommerce-shipping"
    "really-static"
    "cm-pop-up-banners"
    "woocommerce-gateway-amazon-payments-advanced"
    "any-mobile-theme-switcher"
    "wordpress-easy-paypal-payment-or-donation-accept-plugin"
    "acf-gravityforms-add-on"
    "church-admin"
    "rafflepress"
    "captcha-code-authentication"
    "wp-custom-admin-interface"
    "ecommerce-companion"
    "cryout-serious-slider"
    "export-media-library"
    "flexible-elementor-panel"
    "wp-limit-login-attempts"
    "edit-flow"
    "kt-tinymce-color-grid"
    "twitter-for-wordpress"
    "zarinpal-woocommerce-payment-gateway"
    "simple-full-screen-background-image"
    "hotfix"
    "essential-widgets"
    "sendcloud-shipping"
    "molongui-authorship"
    "melhor-envio-cotacao"
    "email-templates"
    "meeting-scheduler-by-vcita"
    "wp-simple-booking-calendar"
    "phastpress"
    "itro-popup"
    "wp-robots-txt"
    "mailchimp-subscribe-sm"
    "codepeople-post-map"
    "disable-dashboard-for-woocommerce"
    "elegro-payment"
    "indexnow"
    "checkout-field-editor-and-manager-for-woocommerce"
    "wp-chatbot"
    "leaflet-map"
    "classified-listing"
    "wk-google-analytics"
    "optin-forms"
    "merge-minify-refresh"
    "minmax-quantity-for-woocommerce"
    "brave-popup-builder"
    "default-featured-image"
    "remove-category-url"
    "fb-messenger-live-chat"
    "wp-event-solution"
    "wp-scss"
    "advanced-popups"
    "meks-smart-author-widget"
    "shortcode-widget"
    "recipe-card-blocks-by-wpzoom"
    "affiliates"
    "persian-woocommerce-sms"
    "lazy-load-for-videos"
    "the-events-calendar-category-colors"
    "meks-flexible-shortcodes"
    "link-manager"
    "analytify-analytics-dashboard-widget"
    "woo-floating-cart-lite"
    "soundcloud-shortcode"
    "activecampaign-for-woocommerce"
    "ean-for-woocommerce"
    "wpadverts"
    "envothemes-demo-import"
    "pc-robotstxt"
    "search-meter"
    "wp-appbox"
    "pronamic-ideal"
    "fancy-gallery"
    "content-protector"
    "genesis-connect-woocommerce"
    "remove-dashboard-access-for-non-admins"
    "easy-property-listings"
    "videowhisper-live-streaming-integration"
    "transients-manager"
    "leverage-browser-caching"
    "username-changer"
    "yith-infinite-scrolling"
    "wp-forecast"
    "mammoth-docx-converter"
    "woo-ajax-add-to-cart"
    "podcast-player"
    "wp-blog-and-widgets"
    "superb-blocks"
    "bookingpress-appointment-booking"
    "nex-forms-express-wp-form-builder"
    "wemail"
    "coming-soon-wp"
    "wp-embed-facebook"
    "head-meta-data"
    "um-recaptcha"
    "html5-maps"
    "opml-importer"
    "facebook-page-feed-graph-api"
    "portfolio-wp"
    "template-events-calendar"
    "ibtana-ecommerce-product-addons"
    "smk-sidebar-generator"
    "ip2location-redirection"
    "wp-jalali"
    "easy-media-download"
    "icegram-rainmaker"
    "qi-blocks"
    "unique-headers"
    "meks-easy-instagram-widget"
    "taxjar-simplified-taxes-for-woocommerce"
    "watu"
    "simpletoc"
    "order-delivery-date-for-woocommerce"
    "super-rss-reader"
    "visibility-logic-elementor"
    "tutor-lms-elementor-addons"
    "yith-woocommerce-featured-video"
    "rocket-maintenance-mode"
    "disable-xml-rpc-pingback"
    "jonradio-multiple-themes"
    "envo-extra"
    "review-widgets-for-tripadvisor"
    "wp-accessibility-helper"
    "shortcode-ui"
    "twitter-tweets"
    "forget-about-shortcode-buttons"
    "wp-job-openings"
    "analogwp-templates"
    "order-tracking"
    "wise-chat"
    "contact-form-7-paypal-add-on"
    "icyclub"
    "advanced-form-integration"
    "wp-multi-step-checkout"
    "e2pdf"
    "yith-woocommerce-affiliates"
    "wp-job-manager-locations"
    "wp-fb-autoconnect"
    "food-and-drink-menu"
    "woo-photo-reviews"
    "magic-post-thumbnail"
    "dethemekit-for-elementor"
    "meks-simple-flickr-widget"
    "dsidxpress"
    "gutenslider"
    "kraken-image-optimizer"
    "poll-wp"
    "no-right-click-images-plugin"
    "yandex-metrica"
    "fluid-checkout"
    "acf-quickedit-fields"
    "cryptocurrency-price-ticker-widget"
    "microblog-poster"
    "bunnycdn"
    "woo-paystack"
    "bulk-image-alt-text-with-yoast"
    "weaverx-theme-support"
    "woocommerce-dynamic-gallery"
    "action-scheduler"
    "seraphinite-accelerator"
    "term-management-tools"
    "post-grid-elementor-addon"
    "posts-in-page"
    "skyboot-custom-icons-for-elementor"
    "unbounce"
    "cresta-social-share-counter"
    "wp-marketing-automations"
    "rss-for-yandex-turbo"
    "woo-advanced-discounts"
    "pushpress"
    "wow-carousel-for-divi-lite"
    "oh-add-script-header-footer"
    "image-optimizer-wd"
    "nd-shortcodes"
    "flickr-album-gallery"
    "i-recommend-this"
    "contact-form-with-a-meeting-scheduler-by-vcita"
    "supportcandy"
    "loginradius-for-wordpress"
    "gdpr"
    "survey-maker"
    "wp-miniaudioplayer"
    "wp-super-edit"
    "wp-lister-for-ebay"
    "popupally"
    "author-avatars"
    "publishpress"
    "wp-malware-removal"
    "publishpress-authors"
    "sermon-manager-for-wordpress"
    "rewrite-rules-inspector"
    "user-activity-log"
    "email-before-download"
    "woo-thank-you-page-nextmove-lite"
    "fuse-social-floating-sidebar"
    "wp-admin-ui-customize"
    "threewp-broadcast"
    "addons-for-divi"
    "bsk-pdf-manager"
    "scripts-n-styles"
    "easy-paypal-donation"
    "multilingual-press"
    "configure-smtp"
    "media-sync"
    "popup-maker-wp"
    "flowpaper-lite-pdf-flipbook"
    "ultimate-landing-page"
    "fullwidth-templates"
    "woo-payment-gateway"
    "woo-product-slider-and-carousel-with-category"
    "stream-video-player"
    "yotuwp-easy-youtube-embed"
    "real-estate-listing-realtyna-wpl"
    "sem-external-links"
    "export-media-with-selected-content"
    "miniorange-otp-verification"
    "uji-countdown"
    "ts-webfonts-for-sakura"
    "adapta-rgpd"
    "wp-stateless"
    "checkout-fees-for-woocommerce"
    "business-profile"
    "rearrange-woocommerce-products"
    "reading-time-wp"
    "helpie-faq"
    "application-passwords"
    "wp-post-page-clone"
    "advanced-post-block"
    "smart-woocommerce-search"
    "tlp-team"
    "clicky"
    "lara-google-analytics"
    "wp-tripadvisor-review-slider"
    "wp-syntax"
    "print-my-blog"
    "woocommerce-myparcel"
    "shiftnav-responsive-mobile-menu"
    "e-mailit"
    "beeketing-for-woocommerce"
    "url-shortify"
    "woo-save-abandoned-carts"
    "quick-and-easy-faqs"
    "wpshopify"
    "alttext-ai"
    "callrail-phone-call-tracking"
    "idx-broker-platinum"
    "counter-number-showcase"
    "typeform"
    "wpcargo"
    "rollback-update-failure"
    "disable-search"
    "wp-flexible-map"
    "posts-to-posts"
    "wp-hotel-booking"
    "disable-emails"
    "infinite-scroll"
    "cookies-and-content-security-policy"
    "wpfunnels"
    "logo-slider-wp"
    "form-vibes"
    "cbnet-ping-optimizer"
    "thrive-automator"
    "contest-gallery"
    "hurrytimer"
    "jch-optimize"
    "sticky-header-oceanwp"
    "twenty20"
    "wp-migration-duplicator"
    "modal-window"
    "breadcrumb"
    "wp-notification-bars"
    "lockdown-wp-admin"
    "newsletter-optin-box"
    "patchstack"
    "json-content-importer"
    "crelly-slider"
    "optima-express"
    "homepage-control"
    "wp-stats"
    "woo-store-vacation"
    "wpdm-premium-packages"
    "woocommerce-shortcodes"
    "clicky-analytics"
    "simple-lightbox-gallery"
    "yith-pre-order-for-woocommerce"
    "woo-extra-flat-rate"
    "post-to-google-my-business"
    "dynamic-to-top"
    "admin-menu-tree-page-view"
    "simple-map"
    "free-facebook-reviews-and-recommendations-widgets"
    "yith-woocommerce-frequently-bought-together"
    "social-icons"
    "registrations-for-the-events-calendar"
    "multi-step-form"
    "scheduled-post-trigger"
    "wpo365-login"
    "wp-google-analytics-events"
    "woo-product-table"
    "word-balloon"
    "index-wp-mysql-for-speed"
    "cachify"
    "enlighter"
    "meow-gallery"
    "youtube-widget-responsive"
    "pmpro-woocommerce"
    "wysiwyg-widgets"
    "wp-debugging"
    "wp-404-auto-redirect-to-similar-post"
    "options-for-twenty-seventeen"
    "wp-super-minify"
    "html-sitemap"
    "product-variations-swatches-for-woocommerce"
    "simple-facebook-plugin"
    "trustpilot-reviews"
    "wp-ajax-edit-comments"
    "freesoul-deactivate-plugins"
    "miniorange-saml-20-single-sign-on"
    "tabby-responsive-tabs"
    "aurora-heatmap"
    "reviews-feed"
    "woo-product-variation-swatches"
    "rich-table-of-content"
    "login-designer"
    "js-support-ticket"
    "vimeography"
    "ocean-posts-slider"
    "wp-ultimate-exporter"
    "mailmunch"
    "webp-uploads"
    "html5-audio-player"
    "wp-extra-file-types"
    "load-more-products-for-woocommerce"
    "branda-white-labeling"
    "lh-hsts"
    "woocommerce-catalog-enquiry"
    "typekit-fonts-for-wordpress"
    "hivepress"
    "yith-woocommerce-product-slider-carousel"
    "gantry"
    "woocommerce-pos"
    "upi-qr-code-payment-for-woocommerce"
    "illdy-companion"
    "envo-elementor-for-woocommerce"
    "no-self-ping"
    "sendwp"
    "duplicate-post-page-menu-custom-post-type"
    "mailchimp-top-bar"
    "appmysite"
    "elements-plus"
    "pdfjs-viewer-shortcode"
    "geo-my-wp"
    "notification"
    "woo-orders-tracking"
    "throws-spam-away"
    "slider-images"
    "woocommerce-product-sort-and-display"
    "easy-custom-auto-excerpt"
    "wp-ban"
    "makewebbetter-hubspot-for-woocommerce"
    "store-locator"
    "bootstrap-for-contact-form-7"
    "menu-ordering-reservations"
    "welcome-email-editor"
    "http-https-remover"
    "hunk-companion"
    "conditionally-display-featured-image-on-singular-pages"
    "featured-video-plus"
    "custom-order-numbers-for-woocommerce"
    "af-companion"
    "packlink-pro-shipping"
    "wp-ecommerce-paypal"
    "cloudinary-image-management-and-manipulation-in-the-cloud-cdn"
    "superb-helper"
    "spinupwp"
    "mas-static-content"
    "google-website-translator"
    "wp-memory"
    "wp-disable"
    "custom-php-settings"
    "poptin"
    "speakout"
    "mobiloud-mobile-app-plugin"
    "ocean-modal-window"
    "stratum"
    "document-gallery"
    "hootkit"
    "ad-widget"
    "woocommerce-store-toolkit"
    "team-builder"
    "block-visibility"
    "hookmeup"
    "easy-custom-sidebars"
    "google-drive-embedder"
    "gantry5"
    "advanced-category-excluder"
    "wps-cleaner"
    "woo-payu-payment-gateway"
    "wordfence-assistant"
    "wp-job-manager-contact-listing"
    "simple-taxonomy-ordering"
    "buddypress-docs"
    "wp-server-stats"
    "send-pdf-for-contact-form-7"
    "wp-recall"
    "yith-color-and-label-variations-for-woocommerce"
    "wp-contact-slider"
    "invoicing"
    "gdpr-cookie-consent"
    "getgenie"
    "wp-email-capture"
    "cp-multi-view-calendar"
    "persian-gravity-forms"
    "wp-downloadmanager"
    "metronet-reorder-posts"
    "tickera-event-ticketing-system"
    "woo-vipps"
    "devvn-image-hotspot"
    "zipaddr-jp"
    "meks-themeforest-smart-widget"
    "auto-upload-images"
    "cf7-styler-for-divi"
    "woo-min-max-quantity-step-control-single"
    "wp-user-avatars"
    "jquery-lightbox-balupton-edition"
    "seo-optimized-images"
    "woocommerce-product-archive-customiser"
    "wpbase-cache"
    "woocommerce-eu-vat-assistant"
    "login-security-solution"
    "portfolio-elementor"
    "reorder-post-within-categories"
    "woocommerce-pay-for-payment"
    "wcboost-variation-swatches"
    "wp-quiz"
    "gd-bbpress-attachments"
    "http2-push-content"
    "really-simple-csv-importer"
    "ansar-import"
    "woocommerce-all-in-one-seo-pack"
    "premium-blocks-for-gutenberg"
    "clean-image-filenames"
    "sb-elementor-contact-form-db"
    "fancy-box"
    "import-html-pages"
    "yith-maintenance-mode"
    "gourl-bitcoin-payment-gateway-paid-downloads-membership"
    "integracao-rd-station"
    "login-logout-menu"
    "wpzoom-portfolio"
    "order-minimum-amount-for-woocommerce"
    "estatik"
    "tier-pricing-table"
    "wp-extended-search"
    "easy-hide-login"
    "pop-up-pop-up"
    "bing-webmaster-tools"
    "ahrefs-seo"
    "radio-buttons-for-taxonomies"
    "organic-customizer-widgets"
    "wp-rest-api-authentication"
    "cool-tag-cloud"
    "product-enquiry-for-woocommerce"
    "structured-content"
    "image-regenerate-select-crop"
    "wc-fields-factory"
    "block-areas"
    "collapsing-categories"
    "wp-booking-system"
    "top-bar"
    "bulk-page-creator"
    "multi-device-switcher"
    "thesis-openhook"
    "responsive-youtube-vimeo-popup"
    "favicon-rotator"
    "simple-basic-contact-form"
    "custom-404-pro"
    "booking-activities"
    "lazy-blocks"
    "ldap-login-for-intranet-sites"
    "related-posts-by-taxonomy"
    "pixabay-images"
    "country-phone-field-contact-form-7"
    "xili-language"
    "database-cleaner"
    "pushengage"
    "rsvpmaker"
    "wp-menu-cart"
    "zoho-salesiq"
    "one-user-avatar"
    "woocommerce-image-zoom"
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

DELAY_DOWNLOADS='n'
DELAY_DURATION=5

FORCE_UPDATE='n'
CACHE_ONLY='n'

mkdir -p "$WORDPRESS_WORKDIR" "$MIRROR_DIR" "$LOGS_DIR"
rm -f "$OPENED_PLUGINS_FILE"
touch "$OPENED_PLUGINS_FILE"
DEBUG_MODE=0

while getopts "p:dalD:t:fc" opt; do
    case ${opt} in
        p ) PARALLEL_JOBS=$OPTARG ;;
        d ) DEBUG_MODE=1 ;;
        a ) DOWNLOAD_ALL_PLUGINS='y' ;;
        l ) LIST_ONLY='y' ;;
        D ) DELAY_DOWNLOADS=$OPTARG ;;
        t ) DELAY_DURATION=$OPTARG ;;
        f ) FORCE_UPDATE='y' ;;
        c ) CACHE_ONLY='y' ;;    # New option for cache-only
        \? ) echo "Usage: $0 [-p PARALLEL_JOBS] [-d] [-a] [-l] [-D DELAY_DOWNLOADS] [-t DELAY_DURATION] [-f] [-c]" 1>&2; exit 1 ;;
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
        while IFS= read -r line; do
            ALL_PLUGINS+=("$line")
        done < "$ALL_PLUGINS_FILE"
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

if [ -f "$CLOSED_PLUGINS_FILE" ]; then
    echo
    echo "Closed Plugin List:"
    cat "$CLOSED_PLUGINS_FILE" | sort | uniq || true
    echo
    echo "Total closed plugins: $(wc -l < "$CLOSED_PLUGINS_FILE")"
    echo
else
    echo
    echo "No closed plugins found."
    echo
fi
echo "Plugin download process completed."

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
    "user-analysis"
    "engauge-analytics"
    "text-messaging-and-lead-collection-pro"
    "auto-hads"
    "display-shipping-class-in-cart-woo"
    "cf7-reply-manager"
    "wp-admin-quicknav"
    "notice-interceptor"
    "lazy-load-with-base64-for-pagespeed-online"
    "wootalk"
    "normalized-forms-with-captcha"
    "reconews"
    "hiweb-image-orient"
    "super-simple-subscriptions"
    "vatomi"
    "supaz-text-headlines"
    "myform-jp"
    "accesstype"
    "inventory-sync-for-woocommerce"
    "svt-simple"
    "hirstart-feed"
    "minimum-and-maximum-product-quantity-for-woocommerce"
    "wp-photo-montage"
    "power-box"
    "pflegekorb-open-weather"
    "teoola"
    "wpdefaultprivate"
    "unlisted-posts"
    "mappedin-web"
    "gokada-delivery-for-woocommerce"
    "seo-dynamic-pages"
    "add-post-link"
    "wp-egosearch"
    "proshots-for-woocommerce"
    "woocommerce-zooming-image"
    "stunning-post-grids-addon-elementor"
    "media-guide-o-matic-alert"
    "product-widgets-for-elementor"
    "chordchartwp"
    "enter-title-here-changer"
    "lightning-publisher"
    "boost-traffic"
    "integrate-monero-miner"
    "sx-featured-page-widget"
    "site-demo"
    "registration-for-woocommerce"
    "nextend-blv-sociallogin"
    "rebrand-buddyboss"
    "chatmarshal-ai-bot"
    "webuser-all-in-one"
    "duogeek-blocks"
    "yourgood-widget"
    "express-pay-erip"
    "koo-publisher"
    "sp-disable-block-editor"
    "zmp-ai-assistant"
    "wp-enterprise-launch-deploy"
    "bizconnector"
    "wooheat"
    "maptalks-plugin"
    "get-next-article"
    "lity-responsive-lightboxes"
    "lorybot-ai-chatbot"
    "wp-enterprise-extension"
    "mastalab-comments"
    "cga-plugin-helper"
    "wp-flickr-more-images"
    "simple-video-info"
    "json-feeder"
    "wp-blended-images"
    "idpay"
    "simple-wp-events"
    "social-blend"
    "niko-taxonomy-filters"
    "payamito-easy-digital-downloads-sms"
    "geo-ip-library"
    "recent-tweet"
    "stockpulse"
    "wp-pubg"
    "brozzme-colorize"
    "wc-rich-reviews-lite"
    "sm-login-styler"
    "zt-captcha"
    "appifire-for-mobile-apps"
    "data-sync-q-by-wbsync"
    "manage-post-content-links-interlinks"
    "mg-block-slider"
    "webshoplogin-single-sign-on"
    "debug-editor"
    "wc-jibit-payment-gateway"
    "woo-product-coming-soon"
    "json-reader"
    "order-invoice-pdf-for-woocommerce"
    "logic-hop-beaver-builder"
    "html-wp-menu-addon"
    "download-documents-menu"
    "payment-redirect"
    "unipayment-gateway-for-woocommerce"
    "inspiring-shipment-tracking"
    "metype"
    "idanproductive-integration-for-salesforce-elementor"
    "httpcs-validation"
    "liquidpoll-mailerlite-integration"
    "unicard"
    "body-class-by-url-parameter"
    "safeguard-media"
    "woo-based-stock-bar"
    "dot-monetize-polls-quizzes"
    "site-assets"
    "chartplot"
    "pathomation"
    "elsner-ajax-login"
    "cute-mediainfo"
    "autocatset"
    "hammerthemes-portfolio"
    "linkgenius"
    "dagpay-for-woocommerce"
    "ranked-review-widget"
    "woo-jw-simple-localpickup-and-delivery"
    "ee4-quickpay"
    "variation-image-color-switcher-for-woocommerce"
    "easy-way-to-sell-digital-goods-with-payhip"
    "rating-builder"
    "landing-page-for-wc-categories-tags"
    "disable-core-block-patterns"
    "shipping-rates-by-zipcode-woocommerce"
    "1click-grey-mode"
    "whats-in-your-headphones"
    "soundst-seo-search"
    "redirect-single-article-tags"
    "kehittamo-share-buttons"
    "connect-profilepress-and-discord"
    "gw-cf7-modal"
    "ammazza-webar"
    "acf-date-selector"
    "cf7-servicenow-incidents"
    "security-made-easy"
    "digikalascraper"
    "genius-addon-lite"
    "scroll-stop-google-maps"
    "wp-connect-coil"
    "joy-of-plants-library"
    "shabbos-and-yom-tov"
    "mirror-gravatar"
    "cc-id-column"
    "menu-email-antispam"
    "copito-comments"
    "wp-rest-api-v2-isfront"
    "pepperi-open-catalog"
    "simple-history-ngg-loggers"
    "notifier-for-glip"
    "stop-404-guessing"
    "andreadb-google-maps"
    "json-image-resolver"
    "customizable-team-member-elementor-widget"
    "simple-event-list-for-elementor"
    "smart-collections-by-napps"
    "click-to-mail"
    "tobook-hotel-booking-engine"
    "add-tracking-code-to-wc-thank-you-page"
    "fm-debug-meta-data"
    "ryans-payment-button"
    "loopingo"
    "personio"
    "mobile-localhost"
    "acf-processors"
    "metricspot-seo-leads"
    "easy-telefon-bar"
    "acf-overview"
    "wp-filmweb-widget"
    "shopify-leaky-paywall-integration"
    "ssm-xtra-post-info"
    "duplicate-products-report"
    "whereami"
    "faq-elementor"
    "wp-retina-image"
    "custom-google-places-reviews"
    "syntaxhighlighter-evolved-dynamics-nav-cside-brush"
    "cookie-accept"
    "core-files-update-cleanup"
    "sel-staff"
    "cwd-custom-login"
    "xstream-google-analytics"
    "split-order-by-warehouse"
    "sage-slider"
    "tuxx"
    "tag-tarteaucitron-advanced"
    "sendmsg-elementor-addon"
    "trust-reviews"
    "thanks-for-reading"
    "led-tweaks"
    "gist-amp"
    "show-git-branch"
    "wp-historical-weather"
    "toi-news"
    "demo-content-templates"
    "eticoxs-giris-duzenleyici"
    "i-search"
    "explara-lite"
    "slider-matches-results"
    "kashing"
    "c4d-social-locker"
    "amp-mobile-sites-creator"
    "welco"
    "hamecache"
    "fasty"
    "login-by-referer"
    "cnr-performance"
    "remove-all-attachments"
    "sticky-notes"
    "customize-event-google-calendar-for-woocommerce-booking"
    "uvwpintegrations"
    "post-page-sidebar-excerpts-by-maui-marketing"
    "support-hero"
    "realty-workstation"
    "nusagate-woocommerce"
    "getdeals"
    "brunch-wp"
    "bne-vagas"
    "stylish-google-map"
    "slp-extended-data-manager"
    "simple-google-maps-into-posts"
    "pwg-cookies"
    "easy-video-playlist"
    "flamix-bitrix24-and-woo-products-sync"
    "integration-of-caldera-forms-and-paystack"
    "xml-sitemap-for-google"
    "browter-mcq-quiz-question-addon-for-elementor"
    "dn-wc-extra-fields"
    "bbp-like"
    "order-status-notification"
    "woo-invoice-me"
    "emoji-keyboard-in-comment-form"
    "payment-gateway-for-worldcoreeu-and-woocommerce"
    "wp-typography-disable-acf-integration"
    "dynamic-easy-slider"
    "quick-stock-management"
    "topbar-message-free"
    "nt-portfolio"
    "brandy-sites"
    "ymc-states-map"
    "integration-of-zoho-books-and-wc"
    "wp-record"
    "folio"
    "linkylinkerton"
    "latest-users-dashboard-widget"
    "create-content-offers-instantly-from-your-blog-posts"
    "auto-expire-posts"
    "departamentos-y-ciudades-de-colombia-para-contact-form-7"
    "custom-mime-types"
    "smart-service"
    "invoice-gateway-yeshinvoice"
    "custom-importer-exporter"
    "downloadio"
    "mediacommander"
    "edd-card"
    "beautimour-kit"
    "tabbed-code"
    "custom-thank-you-pages-for-woocommerce"
    "bsn-for-gravity-forms"
    "widget-for-parler"
    "wppv-divi"
    "best-testimonial"
    "favorite-links"
    "woocommerce-prices-in-other-currencies-checker"
    "softtech-teachers-list"
    "gmap-filter"
    "curatewp-related-posts"
    "js-currency-converter"
    "hotline-va-zalo"
    "crontrol-hours"
    "inactive-tab-title-changer"
    "smilee-setup"
    "concordpay-for-woocommerce"
    "vantevo-analytics"
    "textile-tools"
    "shipments-via-sendbox"
    "vkshop-for-edd"
    "easyling"
    "power-links"
    "contact-form-arrow"
    "timestamps"
    "muzaara-shopbot-cse-xml-data-feed"
    "mw-wp-form-a8-tracker"
    "shipping-rate-by-zipcodes"
    "property-carousel-for-propertyhive"
    "zenkaku-to-hankaku"
    "acf-media"
    "ledyer-checkout-for-woocommerce"
    "victorious-theme-toolkit"
    "ec-developer-mode-integration-for-cloudflare"
    "woo-customer-feedback-mail"
    "unrive-io-visitor-analytics"
    "4zero4"
    "random-blocks"
    "copy-way"
    "secretary"
    "local-avatars-by-nocksoft"
    "infinite-scroll-in-media-library"
    "woo-print-report"
    "live-blog-wp"
    "shortcode-iota-current-price"
    "snapcall"
    "wp-followme-css"
    "featured-image-extended"
    "enable-wp-debug-toggle"
    "sml-simple-multilingual"
    "erudus-one"
    "disable-custom-post-types"
    "einvoicing-for-woocommerce"
    "viubox-syz"
    "dynamic-elementor-addons"
    "candy-slider"
    "ascend-accessibility"
    "post-likerator"
    "hulvire-slider"
    "super-booking-calendar"
    "ng-lazyload"
    "mockups"
    "like-computy"
    "payment-forms-customblock"
    "ajax-admin-menu-editor"
    "edd-license-activator-notifier"
    "socialn-social-notifications"
    "bulk-comment-deleter"
    "disable-webp"
    "edd-custom-credit-card-icons"
    "simple-post-inserter"
    "tmd-spam-killer"
    "order-status-time-field-for-woocommerce"
    "wpkuaiyun"
    "fruitcake-horsemanager"
    "wp-private-comment-notes"
    "ai-writer"
    "categorized-simple-faq"
    "job-listings-location"
    "admin-authentication"
    "fox009-color-tag-cloud"
    "jg-spam-fighter"
    "compare-plugins-with-latest-version"
    "slideing-pic"
    "digital-board"
    "wc-reporting-by-small-fish-analytics"
    "ap-gist-api-code-insert"
    "share-by-email"
    "marketing-360-payments-for-gravity-forms"
    "case-sensitive-url"
    "app-liberachat"
    "azexo-store-locator"
    "easy-registration-form"
    "hide-cart-price-for-visitors-woocommerce"
    "kernel-booking"
    "jeba-plus-multi-slider"
    "featured-lyth-slide"
    "blu-logistics"
    "gf-rest-api-for-cross-platform"
    "seo-meta-description-ai"
    "silence-is-not-bad"
    "swift-wp-login"
    "nth-order-discount-for-woocommerce"
    "navigation-jhac"
    "svg-featured-image"
    "myshopkit-multi-currency-converter-wp"
    "smartarget-popup"
    "dashboard-organizer"
    "ithstatswp-client"
    "woo-product-hover-popup-image"
    "hello-darling"
    "single-page-faq"
    "localizaciones-fotografia"
    "wp-ip-details-show"
    "woo-bulk-featured-image-replacer"
    "mobikob"
    "helloasso-payments-for-woocommerce"
    "callout-boxes"
    "registre-rgpd-cvmh"
    "simple-feed-widget"
    "developer-portfolio"
    "wc-booster-search-order-by-custom-number-fix"
    "sonar-bangla"
    "overtok"
    "pixelshop-integration"
    "post-in-page-for-elementor"
    "woo-edock-exporter"
    "image-shuffle"
    "bdtaskchatbot"
    "customize-plus"
    "bktsk-live-scheduler"
    "getyourguide-ticketing"
    "leads-for-amo-crm"
    "advanced-contact-form-7-compact-db"
    "seo-external-link"
    "human-bmi-bmr-calculation"
    "nested-comments-unbound"
    "kt-redirect-url"
    "tcbd-remove-meta-version"
    "os3-responsive-slider-for-elementor"
    "simple-post-lists"
    "webtonative"
    "siteselector"
    "ccpa-compliance-tool"
    "mmr-disable-for-visual-composer-editor"
    "pefs-pageloader"
    "confirm-mode-for-contact-form-7"
    "wp-geocaster"
    "calc-read-time"
    "fast-link-shorten"
    "novaonx-landingpage"
    "aspose-image-optimizer"
    "qualetics"
    "dreamapi"
    "tabs-block-lite"
    "full-screen-ad"
    "sitesights-analytics"
    "wc-qvapay"
    "lagden-in"
    "crowdaa-sync"
    "wperrorfixer"
    "accessally-lms-migration-from-zippy-courses"
    "advanced-slug-translate"
    "wp-news-sitemap"
    "customizer-refresh"
    "post-curator"
    "wp-user-notifier"
    "fast-blockcontrol"
    "dynamic-content-for-woocommerce"
    "gp-live-export"
    "multilingual-search-for-wpml"
    "page-cloud-widget"
    "autotweaks"
    "custom-color-picker-on-setting-page-by-dreamkoder"
    "copywriter-robin"
    "podamibe-twilio-private-call"
    "woo-e-pul"
    "dexecure"
    "what-is-today"
    "responsive-iframe-watchdog"
    "remove-widget-title-inventivo"
    "lh-add-roles-to-body-class"
    "neexa-ai"
    "woo-bulk-copy"
    "invoice-payment-method-and-invoice-pdf-for-woocommerce"
    "wootrack-startrack-shipping-for-woocommerce"
    "stedb-forms"
    "tweeteverything"
    "lailo-ai-avatar"
    "page-presentation-shortcode"
    "law-cookie"
    "cc-mu-plugins-loader"
    "blocks-google-map"
    "cellarweb-user-profile-access-control"
    "set-unset-bulk-post-categories"
    "products-and-orders-last-modified-for-wc-rest-api"
    "gdpr-dsgvo-google-maps"
    "csv-export-for-click-post"
    "wp247-extension-notification-client"
    "diffy"
    "advanced-exporter-importer"
    "login-devices"
    "oauth-proxy-service"
    "orderem-online-ordering-for-clover"
    "moodgiver-custom-tabs-fields-for-woocommerce"
    "happy-elementor-card"
    "wdes-user-upload-restriction"
    "wp-post-gallery-fancybox"
    "chatandbot"
    "hubaga"
    "daneshjooyar-post-gallery"
    "as-related-posts-block"
    "product-discount-manager"
    "do-you-want-cookies"
    "hide-admin-topbar"
    "tiny-addons-for-wpbakery-page-builder"
    "sticky-bar"
    "quickform"
    "heimdall"
    "hidden-plugin"
    "qnachat"
    "dropshipping-romania-avex"
    "wp-simple-seo-meta"
    "brand-coupons-for-woocommerce"
    "slaf-polylang"
    "how-your-carbon-impact"
    "hana-widgets"
    "go-exercise"
    "asimov"
    "push-monkey-light-woocommerce"
    "ad5-loyalty"
    "seo-rest-api"
    "azscore"
    "my-medium-article"
    "video-analytics-for-cloudflare-stream"
    "emma-woo-addon"
    "testdrive"
    "insert-verification-and-analytics-code"
    "memories"
    "hidden-contents"
    "kmo-social-shares"
    "healthlynked"
    "azurecurve-icons"
    "kntnts-row-closer-for-beaver-builder-page-builder"
    "sloth-logo-customizer"
    "last-users-dashboard-widget"
    "dbmaker"
    "hide-update-notification"
    "latest-youtube-video"
    "graphic-web-design-inc"
    "marquee-top"
    "excerpt-below-title"
    "link-share"
    "stop-comment-spam-fictive-web"
    "genesis-services-cpt"
    "wp-jam-session"
    "whats-going-on"
    "a11y-buttons"
    "mail-smtp"
    "hint"
    "embed-sweethome3d"
    "patternly"
    "woo-voucher-and-topup"
    "vir2al-options"
    "wp-cowsay"
    "swiftninjapro-comments"
    "wc-payconiq"
    "alt-text-generator"
    "teleadmin"
    "dtc-documents"
    "just-animate"
    "lazy-loading-oembed-iframes"
    "send-email-attachment-to-dropbox"
    "puredevs-gdpr-compliance"
    "wpnotify-notifications-for-woocommerce"
    "automated-usps-shipping-with-shipping-label"
    "wp-qiita"
    "british-member-of-parliament-profile"
    "infugrator"
    "enable-template-editor"
    "incredibledocs"
    "litesurveys"
    "easypay-gateway-checkout-wc"
    "slider-pro-wp"
    "custom-post-avatar"
    "ts-collections"
    "gtm-cookie-consent"
    "count-it"
    "livex-ai-copilot"
    "ai-scribe"
    "admin-menu-filter"
    "easy-woocommerce-zoho-crm-integration"
    "essential-social-share"
    "ym-fast-options"
    "hammerthemes-testimonials"
    "login-monitor"
    "felix-responsive-pinterest-feed"
    "fancybox-multimedia-blocks"
    "youseeme-payment"
    "aibuy-player"
    "kein-produkt-zoom-woo"
    "shortcode-getall-widget"
    "friendly-analytics"
    "wp-post-scheduler"
    "dcj-search-autocomplete"
    "droppa-shipping"
    "author-role-list"
    "woo-product-counter"
    "hammerthemes-team"
    "wp-accordions"
    "awesome-custom-login-url"
    "wpit-easter"
    "reweby"
    "backlinks-taxonomy"
    "gowowo-delivery-elementor"
    "check-youtube-videos"
    "html-shortcodes"
    "wp-subtitle-support-for-better-internal-link-search"
    "woo-officeworks-mailman-shipping-method"
    "moco-smart-search"
    "geolocated-content"
    "captcha-by-yandex-for-contact-form-7"
    "caption-single-product-images"
    "xelion-webchat"
    "simple-spam-blocker"
    "windzfare"
    "wezido-elementor-addon-based-on-easy-digital-downloads"
    "cs-multiple-image-import"
    "wp-gcal-rss"
    "dc-hide-publish-button"
    "lh-buddypress-disable-group-deletion"
    "events-in"
    "adscale-limit"
    "wimple-contact-form"
    "server-side-tagging-via-google-tag-manager-for-wordpress"
    "woo-pulzepay"
    "easy-p5-js-block"
    "order-tracking-for-skroutz"
    "pofw-csv-export-import"
    "iq-asset-datasheet"
    "archive-widget-collapsed-with-css"
    "playing-card-notations-pcn"
    "ty-gia-vang-ngoai-te"
    "one-call"
    "social-media-library"
    "mage-support-online"
    "loadads-monetization-tool"
    "wp-autotagger"
    "custom-fields-to-taxonomies"
    "fonts-to-uploads"
    "badgeos-paid-membership-pro"
    "site-editor-google-map"
    "tilt-photo-hover-effect"
    "wp-tmail-lite-multi-domain-temporary-email-system"
    "wps-mypace-ctt-adapter"
    "taro-nickname-for-woo"
    "mi13-access-by-link"
    "buy-jumpseller"
    "custom-repeater-child-gutenberg-block"
    "boxich"
    "rock-metal-lyrics"
    "erply-integration"
    "trustmeup-connector"
    "generate-dap-license-key"
    "free-booking-system"
    "prodotti"
    "rate-limiting-ui-for-woocommerce"
    "cartloom"
    "covid19-real-time-tracker"
    "wp-developer-support"
    "shift8-ip-intel"
    "kijo-serpbook-api"
    "sacoronavirus-link"
    "creative-progress-bar"
    "vc-extension-hover-image"
    "a11y-kit"
    "thecamels-assistant"
    "sagepay-direct-gateway-for-gravity-forms"
    "nutsforpress-sort-any-posts"
    "press-release-services"
    "pro-polls"
    "kinka-js"
    "super-easy-testimonials"
    "api-cache-pro"
    "split-order-by-weight-for-woocommerce"
    "zs-action-scheduler-optimizer"
    "gf-ir-mobile-add-on"
    "codeless-hotspot-block"
    "woo-feed-slowfashion"
    "accessible-tooltips"
    "petje-af"
    "valuepay-for-givewp"
    "hide-post"
    "syngency"
    "stampd-io-blockchain-stamping"
    "joli-clear-lightbox"
    "allow2"
    "dismiss-wsod-protection"
    "forms-3rd-party-inject-results"
    "asd-cookie-consent"
    "su-gallery"
    "restaurant-for-woocommerce"
    "eu-cookie-policy"
    "afterwoo-order-export-to-afterbuy"
    "brosix-live-chat"
    "motivationstipps-zitate"
    "cartick"
    "better-wishlist"
    "acapela-vaas"
    "frontend-editor-acf"
    "business-profile-extra-fields"
    "subscribe-youtube-button"
    "pdf-office-documents-converter"
    "loginmojo"
    "zaki-notifications-hider"
    "wp-responsive-retina-images"
    "vikoder-posts-block"
    "aps-content-moderator"
    "tweet-it"
    "avasize"
    "brandsoft-team-viewer"
    "probuilder"
    "ai-for-wp"
    "ip-blacklist-cloudflare"
    "thanh-toan-chuyen-khoan-ngan-hang-voi-vietqr"
    "subscribers-members-based-pricing"
    "static-menus-inventivo"
    "media-related-posts"
    "uhmi"
    "network-upgrade-ssl-fixer"
    "undasecure"
    "webfonts2psoft-for-tinymce"
    "wopo-web-torrent"
    "awesome-wp-slider"
    "cs-disable-emojis"
    "custom-field-variables"
    "call-leads"
    "rng-ajaxlike"
    "hao-image-box"
    "user-subscription"
    "ys-fp-md2pd"
    "wp-contents-dynamic-display"
    "db-tagcloud-for-woocommerce"
    "utm-builder-ads-fox"
    "eventi-asiago-it"
    "azurecurve-insult-generator"
    "lh-oembed-white-list"
    "scroll-down-arrow"
    "free-php-version-info"
    "social-links-icons"
    "diviner-archive"
    "eofdsupport"
    "spreebie-barter"
    "simple-social-networking-buttons"
    "category-base"
    "wp-slack-logbot"
    "sidebar-widget-blocks"
    "woo-nations-trust-bank-american-express-payment-gateway"
    "rental"
    "linked-future-posts-widget"
    "youscribe"
    "mbc-smtp-flex"
    "magic-link-login"
    "a-synchronization"
    "trusted-accounts"
    "seo-made-easy"
    "shiip"
    "web3-smart-contracts"
    "text-mutator"
    "e-newsletter-proffix"
    "wp-settings"
    "dl-browser-update"
    "wp-x2crm"
    "review-mode"
    "urubutopay"
    "ttm-before-after-image"
    "perfect-lazy-loading"
    "maintenance-mode-arrowplugins"
    "glomex-oembed"
    "text-message-sms-extension-for-woocommerce"
    "jot-data-manager"
    "vht-sms"
    "track-package"
    "presscheck"
    "related-posts-for-wpml"
    "sitesauce"
    "enhanced-body-class"
    "bulk-categories-assign"
    "ips-auth-bridge"
    "dismiss-server-nag"
    "shift8-zoom"
    "wpinfecscanlite"
    "websand-subscription-form"
    "secure-your-admin"
    "block-fancy-list-item"
    "booking-works"
    "filter-wp-api"
    "connect-eduma-theme-to-discord"
    "simple-wp-mixitup-portfolio"
    "binbucks"
    "boostsite-seo-audit-tool"
    "hidesidebar"
    "admin-goto"
    "advanced-plugin-view"
    "nzymes"
    "edd-securionpay"
    "auto-approve-product-reviews"
    "pattern-wrangler"
    "extend-rank-math"
    "redirect-to-home"
    "oembed-gist-files"
    "wphobby-demo-import"
    "prolo-finder"
    "general-options"
    "entradas-predefinidas"
    "wp-add-custom-css-and-javascript"
    "wc-add-to-cart-redirection"
    "orendapay"
    "display-product-attributes-for-woocommerce"
    "custom-smtp"
    "simple-image-seo"
    "w4-cloudinary"
    "genius-portfolio"
    "easy-category-cloud"
    "page-title-customizer-for-twenty-series"
    "buy-now-button-direct-checkout-quick-checkoutpurchase-button-for-woocommerce"
    "my-templates-thumbnails-for-elementor"
    "remove-try-gutenberg-callout"
    "remove-pages-from-search"
    "linkblog-by-lucy"
    "swt-seo-helper"
    "wp-nanobar-js"
    "appointment-booking-for-salon-and-spa"
    "add-to-cart-button-for-divi"
    "lazycaptcha"
    "az-advanced-custom-scrollbar"
    "wp-pranks"
    "wander"
    "getlead-page"
    "wp-youtube-counters"
    "joggin-agenda"
    "audio-playlist-for-woocommerce"
    "v-player"
    "daily-hadith"
    "yoctopuce-sensors"
    "turnkey-lender-pay-over-time"
    "ultimate-info"
    "gvsoft-photobox"
    "simple-wp-maintenance"
    "customer-notes-for-woocommerce"
    "error-tracker"
    "oembed-my-mitsu-estimation-form"
    "adbase-ai-popup-growth"
    "rest-api-docs"
    "woo-sendle-api"
    "sending-platform-for-getresponse"
    "realtypack-core"
    "connects-tracking"
    "shiptime-discount-shipping"
    "buckydrop-dropshipping-for-woocommerce"
    "per-product-shipping-for-wc"
    "disable-remote-patterns"
    "badgeos-rest-api-addon"
    "payment-method-order-column"
    "wp-vue-by-shaanz"
    "one-liners"
    "survey-reporting-data-analysis-report-add-on-for-gravity-forms"
    "manageremove-version-number-from-css-js"
    "shoppers-mind"
    "moneypenny-live-chat"
    "fac-hosted-page-button"
    "sms-notification-contact-form-with-twilio"
    "set-yoast-to-bottom"
    "wp-leaflet-mapper"
    "eit-scroll-to-top"
    "risk-warning-bar"
    "puppyfw"
    "easy-embed-for-social-media"
    "spridz-widget"
    "wp-stateless-elementor-website-builder-addon"
    "source-input-for-gravity-forms"
    "newpath-wildapricotpress-add-on-iframe-widget"
    "quran-verse-inserter"
    "wp-factcheck"
    "tag-limiter"
    "is-varnish-working"
    "wp-reroute-mandrill"
    "wp-login-logging"
    "enquir3-testimonial"
    "my-wp-photos"
    "gp-toolbox"
    "replicate-widget"
    "change-default-email-sender-name"
    "outgoing-mail-identity-editor"
    "related-posts-with-slider"
    "cookie-consent-autoblock"
    "transler"
    "messageflow"
    "kkg-music"
    "creatus-extended"
    "omnibus-by-ilabs"
    "ai-quiz"
    "selling-commander-connector"
    "unofficial-yektanet"
    "gocrypto-pay"
    "xbar-headline"
    "mandrill-send-from-subaccount"
    "swiftninjapro-smart-search"
    "wp-my-favourites"
    "reusable-admin-panel"
    "chidoo-quizmaster"
    "diet-calorie-calculator"
    "lekirpay-for-woocommerce"
    "wp-responsive-google-map"
    "woo-emoney-payment-gateway"
    "advertising-management"
    "vertically-client-carousel"
    "seo-debug-bar"
    "bugplug-by-omatum"
    "nanokassa"
    "gf-confirmation-page-list"
    "unenroll-for-learndash"
    "cardflow-for-woocommerce"
    "yivic-easy-live-chat-express"
    "shortcode-revolution"
    "easily-integrate-google-analytics"
    "scramble-email"
    "jeba-cute-forkit"
    "octagon-elements-lite-for-elementor"
    "wp-floating-notifications"
    "wolfen-toggle-bar"
    "ourpass-payment-gateway"
    "getsoapy"
    "somali-music"
    "website-trial-version"
    "dynast-admin-panel"
    "timeline-slider"
    "contributor"
    "lisette-cost-calculator"
    "civil-publisher"
    "super-simple-site-alert"
    "simple-font-awesome-icon"
    "wc-sodexo"
    "awesome-carousel-slider"
    "turgenev"
    "pluco-membership"
    "wp-easystatic"
    "custom-invoice-url-for-woo-by-digidopt"
    "4partners"
    "payment-gateway-through-stripe-installments"
    "wonder-login"
    "payplus-gateway"
    "valuepay-for-fluent-forms"
    "maxbooking-booking-widget"
    "validation-error-message-cf7"
    "simple-accordion"
    "integration-cf7-textdrip"
    "woo-paypal-inr-support"
    "promotator"
    "ip-address-shortcode"
    "adcaptcha"
    "gf-msteams"
    "image-flow-gallery-block"
    "auto-product-restock"
    "lh-buddypress-email-or-message-group-members"
    "easy-googleanalytics"
    "minimum-signup-period-for-woo-subscriptions"
    "woo-domain-coupons"
    "teylos-pricing-table-woocommerce"
    "nje-box-title-link-widget"
    "daily-routine-with-google-calendar"
    "users-to-admin-contact-form"
    "nicechat"
    "count-hits"
    "mx-link-shortener"
    "tradetracker-connect"
    "zooza"
    "fullscreen-menu-awesome"
    "auto-insert-content"
    "theme-pages"
    "tracking-revisions"
    "change-responsive-images-rv"
    "member-profile-fields-for-wlm-and-gf-user-registration"
    "brand-my-footer"
    "ach-tag-manager"
    "sg-giftcards"
    "sponsor-banners"
    "etc-mods-bundle"
    "vdpetform"
    "dialogue-layout"
    "geo2wp"
    "netsecop"
    "page-cache-on-cloudflare"
    "email-campaign-user-notifications"
    "cf7-mountstride-crm-integration"
    "wp-url-extension"
    "texte-inclusif"
    "ngo-menu-deactivate"
    "yala-travel-companion"
    "navthemes-landing-pages"
    "waj-links"
    "singlepage"
    "wp-https-redirect"
    "pryc-wp-remove-languages-for-divi"
    "infobox-widget"
    "jumble"
    "olympic-preloader"
    "integreat-search-widget"
    "honey-woocommerce-payments"
    "gp-aws-translate"
    "click-to-call-button-by-converzo-nl"
    "gozen-growth"
    "counter-number"
    "norsani-api"
    "newstream"
    "shop-information-system"
    "insert-update-time"
    "we-stand-with-ukraine-banner"
    "simpact-for-woocommerce"
    "lh-woocommerce-invoicing"
    "sync-posts"
    "email-marketing-and-crm-for-elementor-by-customerly"
    "qiscus-multichannel-widget"
    "infinity-image-gallery"
    "prodlytic"
    "rs-bruce-lee-quotes"
    "forms-3rdparty-submission-reformat"
    "business-listing-manager"
    "awesome-elements-for-elementor"
    "wapuugotchi"
    "recojo-por-otra-persona"
    "gdpr-easycloud"
    "booth-junkie-gallery"
    "tcl-categories-image"
    "auto-prefetch-url-in-viewport"
    "wp-parentcomms-connect"
    "stulab-download-manager"
    "emplois-informatique"
    "last-9-photos-webcomponent"
    "product-puller"
    "wt-analytics"
    "stellarpress-federation"
    "wp-plugin-confirm"
    "winiship"
    "bonusplus"
    "duitku-for-givewp"
    "taxonomy-terms-grid"
    "settings-for-youtube-block"
    "front-connector"
    "wp-shortcut-link"
    "payment-for-lifterlms-2checkout"
    "italkereso-hu-nak-automatikus-arlista-frissites"
    "pz-directhtml"
    "nx-adstxt"
    "custom-instagram-embed"
    "rapid-custom-post-types"
    "multisite-new-user-form"
    "university-quizzes-online"
    "concat-parent-page-slugs"
    "outshifter-embed-commerce"
    "autocorrector-wp-camelcase"
    "integrations-of-zoho-campaigns-with-elementor-form"
    "don-social-widget"
    "greenstory-for-woocommerce"
    "upload-tracker"
    "thinkery"
    "category-post-urls"
    "actify"
    "charla-live-chat"
    "mobile-address-bar-color-changer"
    "autocomplete-for-calculated-fields-form"
    "social-media-icons-wp"
    "gsislogin"
    "woo-1crm-extensions"
    "a-wechat"
    "theme-structure-visualiser"
    "axon-404"
    "dev-land"
    "auto-rotator-for-woocommerce-reviews"
    "cmc-role"
    "ip-vault-wp-firewall"
    "better-post-formats"
    "woo-minimum-order-amount"
    "wp-to-alexa-flash-briefing"
    "therich-woo-frontend-add-product-form"
    "woo-shipping-discount"
    "spot-view-cron-job"
    "wp-redmine-issues"
    "popover-tool"
    "one-step-checkout"
    "rws-enquiry"
    "multi-link-in-bio"
    "vacancy-lab"
    "usersmanager"
    "esign-genie-for-wp"
    "payflexi-lifterlms-installment-payment-gateway"
    "take-note"
    "html5-code-editor"
    "full-screen-preloader"
    "live-copy"
    "missive-live-chat"
    "lgpdy"
    "redirect-non-logged-in-users-to-custom-url"
    "smtp-connector"
    "persian-date-for-codestar-framework"
    "wp-yun"
    "kanoo-payment-gateway"
    "protect-pages-posts"
    "hnb-multi-currency-for-wpml"
    "wp-blog-posts"
    "disable-features"
    "pubperf-analytics"
    "shop-connector-cloudskill"
    "sidebar-block"
    "gf-sendinblue"
    "hiddenbadgerecaptcha"
    "disable-all-update-notifications"
    "boom-fest"
    "hsts-strict-preload"
    "connect-cf-7-freshsales-crm"
    "restless"
    "mouse-and-keyboard-disable"
    "iaf-social-share"
    "user-id"
    "fg-recent-plugins"
    "spritesfeed"
    "consent-to-the-processing-of-personal-data"
    "timeline-simple-elementor"
    "wp-branches-for-post"
    "popup-events-tracker-for-elementor"
    "variation-prices-woocommerce"
    "attach-excel-invoice-wooc-wpshare247"
    "web4x-product-comparison-table"
    "dropp-pay-tipping"
    "custom-field-builder"
    "salah-widget"
    "lazyload-post-gallery"
    "smart-system-eat-delivery-xcloud-pro"
    "juble-it"
    "private-comment"
    "serengeti-builders"
    "dadevarzan-wp-facility"
    "tp-price-drop-notifier-for-woocommerce"
    "easy-free-popup"
    "quotes-and-testimonials"
    "block-class-autocomplete"
    "rss-grabber"
    "post-view-count-and-backend-display"
    "wp-post-store-locator"
    "cp-demo-switcher"
    "validar-for-woocommerce"
    "venobox"
    "site-structure-visualizer"
    "torknado-page-excerpt"
    "epicpay-woocommerce-payment-gateway"
    "contagen-widget"
    "buy-me-coffee"
    "smart-prev-next"
    "edd-omnidesk-support"
    "lendingq"
    "tw-audio-player"
    "rio-photo-gallery"
    "fazacrm-client"
    "delete-all-products"
    "wc-shipmendo-lite"
    "code-block"
    "hngamers-atavism-core"
    "field-block-for-acf-pro"
    "bonaire"
    "wask-marketing"
    "simple-register-users-form"
    "compare-payment"
    "sticky-action-buttons"
    "km-showhide"
    "amazing-neo-icon-font-for-elementor"
    "spoton-live"
    "customers-who-viewed-this-also-viewed-that-woocommerce"
    "wp-rest-api-add-taxnomies"
    "woo-beanstream-hosted-payment"
    "blackwebsite-wp-dark-mode"
    "fast-toc"
    "hamelp"
    "lightweight-slider"
    "noncensible"
    "rich-text-extension"
    "wp-structured-data-schema"
    "wp-push-notifications"
    "danielme-weather"
    "wp-dashboard-quick-search"
    "style-switcher"
    "questionscout"
    "wp-marvelous-debug"
    "export-comment-author-emails"
    "cf7-multi-upload-file"
    "modify-visual-editor"
    "ax-gifs"
    "texttome"
    "iswipe-payment-gateway"
    "coachific-shortcode"
    "badge-for-glotpress"
    "accesswise"
    "videogate"
    "dead-letter-email"
    "very-simple-wp-popup"
    "bakkbone-billing-at-registration"
    "plestar-directory-listing"
    "video-testimonial-slider"
    "hide-admin-bar-front-end"
    "bbmsl-payment-gateway"
    "sales-manager-for-woocommerce"
    "devicons"
    "simplepdf-embed"
    "user-ip-information"
    "product-table-for-elementor"
    "janey-ai"
    "evangelische-termine-for-the-events-calendar"
    "poket-rewards-for-woocommerce"
    "simple-scroll-up-button"
    "sgs-social-sharing-buttons"
    "emails-blacklist-everest-forms"
    "masterbip-regiones-de-chile"
    "redirect-username"
    "auto-size-textarea"
    "extend-search-block"
    "adsimple-vote"
    "popular-post-google-analytics-real-time"
    "reset-post-password"
    "vcx3-heatmap"
    "simsage-search"
    "aidah-livechat"
    "article-status-email-notifications"
    "younitedpay-payment-gateway"
    "pcsd-tag-stripper"
    "scuolasemplice-contacts"
    "stock-level-pricing"
    "cf-email-domain-check"
    "wp-cron-per-action"
    "sort-custom-postspages-by-parent"
    "apoyl-videoctrl"
    "better-wp-admin-post-list"
    "modernquery"
    "scorecard-widget-for-salesforce-trailhead"
    "darkmode-ga"
    "rideshare-importer"
    "curated-query-loop"
    "chat-forms"
    "connect-tutorlms-to-discord"
    "payselection-gateway-for-woocommerce"
    "storelinkr"
    "gf-auto-coupon-generate"
    "list-youtube-channel-videos"
    "attach-font-awesome"
    "instant-contact"
    "multisite-sidebar-widget-duplicator"
    "psupsellmaster"
    "postmark-open-to-edd-customer-note"
    "posts-date-reschedule"
    "download-s3-content"
    "gutenverse-news"
    "cardlesspay-by-cardless-paytech"
    "disallow-png"
    "login-secure"
    "plain-logger"
    "wc-map-guest-orders-and-downloads"
    "id5-pixel-manager"
    "showcase-theme-preview-reloaded"
    "accessibility-task-manager"
    "clickblaze"
    "kiskadi"
    "lc-shortlink"
    "social-media-share-and-widget"
    "moulton-payment-gateway"
    "responsive-checker-real-time"
    "abrestan"
    "wpsurveys"
    "basic-sharer"
    "vimeotheque-debug"
    "woo-admin-filter-by-stock"
    "jiutu-mapmarker"
    "eu-vat-reports-for-woocommerce"
    "cc-server-time"
    "custom-styled-wp-login-page"
    "wp-site-monitor"
    "lvl99-omny-embed"
    "cocart-rate-limiting"
    "marketing-with-divi"
    "crude-menus"
    "zengin-sipa-rich-snippets"
    "share-target"
    "long-toolkit"
    "watermark-pdf"
    "bookyt"
    "autoblog-wpmagic"
    "block-views"
    "moving-image-slider"
    "noti-activity-notification"
    "update-posts-date"
    "formito"
    "ssm-image-import-helper"
    "wc-stripe-hosted-checkout"
    "amader-rsvp"
    "ptpshopy-for-woocommerce"
    "advanced-pricing-table"
    "gwp-captcha"
    "swiss-knife-for-woocommerce"
    "wc-class-based-shipping"
    "lm-easy-slider"
    "wp-recruit"
    "ramadan"
    "swpm-postie"
    "send-ref"
    "text-effect-archive-design"
    "traki-analytics"
    "disable-the-comments"
    "get-remote-posts-list"
    "edd-protect-images"
    "lh-event-tickets-rsvps"
    "wc-net-30-terms-for-woocommerce"
    "linkbot-automated-internal-linking"
    "staging-cdn"
    "widget-for-smule-iframes"
    "reblog-redirect-new-to-old"
    "woomizer"
    "wp-social-importer"
    "b-sharpe-converter-shortcode"
    "ada-tracking-tool"
    "fb-page-attributes-wp-menu"
    "easy-minimal-maintenance-or-coming-soon"
    "nutrition-info-woocommerce"
    "softmogul-booking-engine"
    "elvez-hide-site-header-and-footer"
    "dutch-copyright-shortcode-creator-vict"
    "wp-yt-markdown"
    "wpmk-cache"
    "slideshow-posts"
    "business-rules"
    "easy-language-switcher"
    "cart-product-images-woocommmerce"
    "wpjura-table-of-contents"
    "upurr-store"
    "kije-editor"
    "force-user-ssl"
    "page-navigation-by-menu"
    "echo-date-4-seo"
    "woo-allow-only-one-item-in-cart"
    "better-uptime"
    "wp-bannerized-categories"
    "wc-pagouno-payments"
    "testimonials-slider"
    "easy-iframe"
    "prompty-web-push-notifications"
    "freelancer-sharing-icons"
    "wpflexgrid"
    "product-stock-export-and-import-for-woocommerce"
    "bh-wc-set-gateway-by-url"
    "woo-wepay-payment-gateway"
    "hill-extension"
    "post-bot"
    "123eworld-sms"
    "wp-better-sub-menus"
    "leira-access"
    "chatmetrics"
    "cookiebar-by-beard"
    "byakurai-template-filter"
    "venezuelan-economic-indicators"
    "advanced-hover-effects-image-wpbakery"
    "via-delivery-us"
    "civil-right-defenders-didi"
    "msgsmartly-by-digidopt"
    "quick-image-transform"
    "posts-and-pages-github-backup"
    "arya-switch-theme"
    "videoigniter"
    "syntax"
    "wp-courseware-addon-for-restrict-content-pro"
    "iwsm-customize-background-images"
    "wp-tax-price"
    "rcp-allow-rest"
    "mg-member-control"
    "autoroicalc-for-woocommerce"
    "wp-login-register"
    "rush-seo-tags"
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

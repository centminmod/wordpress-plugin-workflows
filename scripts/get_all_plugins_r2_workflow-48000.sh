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
    "mg-member-control"
    "rush-seo-tags"
    "autoroicalc-for-woocommerce"
    "rcp-allow-rest"
    "wp-code-checker"
    "bibleup"
    "elimina-diacritice"
    "simple-cookie-notification"
    "instascaler-get-traffic"
    "xmlrpc-lockdown"
    "hubrocket-live-chat"
    "target-notifications"
    "companion-for-wp-manager"
    "tapform"
    "dolphy"
    "bamazoo-button-generator"
    "slimcd-payment-gateway"
    "cc-social-buttons"
    "insert-pipefy-form-launcher"
    "memorable-password"
    "select-twitch-team"
    "product-addon-custom-field-for-woocommerce"
    "tenandtwo-xslt-processor"
    "wp-proportion-image-maker"
    "level-system"
    "debullient-post2pdf-pro"
    "easy-read-and-pictograms-blocks-for-gutenberg"
    "sitebrand-customizer"
    "fixed-ip-logins"
    "parse-markdown"
    "multi-branch-for-woocommerce"
    "victorious"
    "product-features-for-woocommerce"
    "bc-quick-add-child-category"
    "ticketing-system"
    "additional-order-costs-for-woocommerce"
    "all-in-all-image-hover-effect"
    "cellarweb-multisite-site-notes-and-site-expire"
    "wpdevhub-dlm"
    "date-updater"
    "multilang-block"
    "woo-remove-shipping-from-cart-totals"
    "wpo-checker"
    "double-knot-security"
    "wp-spykey"
    "autocomplete-orders-for-woocommerce"
    "in6ool"
    "wp-live-messenger"
    "bc-imperial-date"
    "pronamic-pay-with-mollie-for-ninja-forms"
    "magic-coupon-and-deal"
    "lift-trail-status"
    "open-one-on-demand-delivery"
    "stay-alive"
    "creative-news-ticker"
    "syntax-highlighting"
    "mywp-custom-login"
    "wp-prevent-right-click-content-copy"
    "jrm-killboard"
    "scroll-up-cl7"
    "chatnhanh"
    "decentralized-bitcoin-cryptodec-payment-gateway-for-woocommerce"
    "leadtracker"
    "hidepostwp"
    "vma-plus-station"
    "wp-gtm-data-privacy"
    "easybackup"
    "dogorama-gefahrenmeldungen"
    "sms-gateway"
    "custom-boxer-for-userpro"
    "betterbook"
    "cf7-save-my-leads"
    "acf-snippets"
    "merc-theme-mod-import"
    "ploi-cache"
    "disable-featured-image-the-events-calendar"
    "affilicode-tag-setting"
    "simple-contact-bar"
    "custom-contact-details-with-wp-list"
    "material3d"
    "world-news"
    "custom-latest-posts-widget"
    "easy-search"
    "wordsteem"
    "pdq-csv"
    "at-lazy-loader"
    "truebooker-appointment-booking"
    "admin-previous-and-next-order-edit-links-for-woocommerce"
    "cache-using-gzip"
    "mb-portfolio"
    "paysley"
    "wc-hide-other-shipping-options"
    "oktawave-cloud-storage"
    "darkg-simpay"
    "qubik-envios"
    "super-public-post-preview"
    "kmm-metrics"
    "easy-call-to-action"
    "ai-text-to-speech"
    "wha-elementor-counter-up"
    "wp-forms-connector"
    "tabs-cmb2"
    "stylinity-widget"
    "safe-updates"
    "wg-responsive-slider"
    "developer-tools-for-acf"
    "jinx-fast-cache"
    "wphobby-woocommerce-product-filter"
    "what-the-cron"
    "apoyl-badurl"
    "prefetch-visible-links"
    "mailshogun"
    "sel-shortcodes"
    "wp-media-pro"
    "geoareas"
    "motivational-quotes"
    "cc-disable-date"
    "cc-update"
    "embed-brackify"
    "blueera-oberon-export-orders"
    "minitek-slider"
    "better-gdpr"
    "hct-community-database-management"
    "super-seo-content-cloner"
    "product-faq"
    "simply-international-by-ups"
    "import-export-with-custom-rest-api"
    "xonja-woocommerce-product-reorder"
    "bulk-orders-remover-for-woocommerce"
    "product-isotope-filter-for-elementor"
    "resource-management"
    "autoblank-for-link"
    "comments-counter"
    "mansplainer"
    "sticky-review"
    "fonts-typo"
    "roughest-instant-estimate-calculator"
    "woo-paypal-me-payment"
    "filerenamereplace"
    "advision-private-area"
    "wp-responsive-video-gallery"
    "wp-responsive-landing-pages"
    "hide-and-show-admin-bar"
    "color-picker"
    "one-off-emails-for-woocommerce"
    "croct"
    "wp-book-manager"
    "instant-edit-everything"
    "sortter-rahoituslaskuri"
    "wp-composer-sync"
    "koji-block-embed-block-for-koji-apps"
    "redpay-payment-gateway"
    "force-login-pro"
    "va-fast-image-upload"
    "light-live-chat"
    "bangla-nice-slug"
    "mage-carousel"
    "display-realtime-json-data-through-ajax"
    "custom-translation-files"
    "dynamic-product-titles-for-variant-options"
    "checkout-shipping-message-add-on-for-woocommerce"
    "we-disable-fs"
    "tipi-components"
    "rest-api-fns"
    "ship-to-ecourier"
    "wp-contacts-slim"
    "woo-hnb-bank-payment-gateway"
    "role-based-storage-limiter"
    "icoach-motore-di-ricerca-sul-coaching"
    "wp-eu-vat-helpers"
    "bstcm-findio-gateway"
    "kofc-state"
    "importer-from-maxsite"
    "responsive-block-swap"
    "fast-thrivecart"
    "convert-number-in-tibetan"
    "force-collapse-admin-menu"
    "payment-gateway-stripe-for-easy-digital-downloads"
    "woo-payment-highway"
    "melonpan-block-site-title"
    "woo-sms-simple-order-notification"
    "dev-slider"
    "delivery-mail-boxes-etc-for-woocommerce"
    "altra-side-menu"
    "attribute-calculator"
    "cruftless"
    "ovic-pinmap"
    "stripe-tax-for-woocommerce"
    "interactive-cursor"
    "wc-payme-hsbc-payments-by-cartdna"
    "boostmyproducts"
    "wsd-android-and-ios-for-woocommerce"
    "wp-add-cc-email"
    "local-google-analytics"
    "parent-page-link"
    "logos-carousel-slider"
    "chat-spanish"
    "wp-randomize"
    "embed-spider-solitaire-iframe"
    "wp-mail-fix-multiple-send"
    "maptip"
    "my-wp-fast"
    "exchange-paypal-to-satoshi"
    "awesome-hooks"
    "email-id-from-comments"
    "voila-contact-form"
    "wp-group-subscriptions"
    "primary-login-logout-menu"
    "upcoming-for-calendly"
    "call-now"
    "bx-essentials"
    "riaxe-product-customizer"
    "skeerel"
    "awesome-scrollbar-wp"
    "adminbar-drag-hide"
    "copyright-protected"
    "zedna-maintenance-mode"
    "web2store-from-adelya"
    "style-extension-for-open-social"
    "woo-product-add-tab"
    "online-help-sliding-menu"
    "instashare"
    "wink2travel"
    "installus-links"
    "woo-juspay-gateway"
    "secure-admin-access"
    "gallery-recent-posts"
    "block-editor-navigator"
    "azurecurve-breadcrumbs"
    "embed-poll-for-all"
    "discounts-marketpress"
    "content-after-login"
    "eu-cookie-bar"
    "fast-smooth-scroll"
    "insert-body-class"
    "duplicate-post-and-replace-text"
    "woo-hide-attributes"
    "sync-snapp-ecommerce"
    "idaterms-sort-terms-by-id-date"
    "woo-bulk-edit-price"
    "loops-n-slides"
    "easy-and-simple-membership"
    "gif-controller"
    "awesome-tracker"
    "cookie-dunker"
    "mazing-ar-shortcode"
    "rentivo-widgets"
    "instant-conversion-analytics"
    "wp-comments-form-validation"
    "smartpablo"
    "lnd-for-wp"
    "tradecast"
    "focus-sitecall-lite"
    "rest-interface-for-wpforms"
    "wc-premium-checkout"
    "ns-maps-noble-strategy"
    "woo-coolpay"
    "wp-reports"
    "arya-license-manager"
    "technoscore-login-redirection"
    "rayanpay-payment-method-for-woocommerce"
    "cpt-admin-taxonomy-filtering"
    "jcwp-add-quote-button-in-product-page"
    "remove-old-slug-for-postpages"
    "fast-aws"
    "fusion-web-app"
    "mklasens-thumbnail-slider-for-woocommerce"
    "woo-payment-gateway-public-bank"
    "welight-easy-impact"
    "display-ids"
    "image-label-maker"
    "nexty-payment"
    "demoify-blocks"
    "optimize-genie"
    "admin-notices-for-woocommerce"
    "woo-shop-hacker"
    "super-access-manager"
    "copperx"
    "tcbd-calculator"
    "woo-easy-autocomplete-order"
    "wp-simple-slider"
    "sd-live-search"
    "wccontour"
    "doc8"
    "admin-chat-box"
    "author-bind"
    "shoplic-payment-gateway"
    "phototools"
    "autocontent"
    "create-categories-for-pages-only"
    "multislot-business-hours-for-dokan-vendor"
    "shipping-vendesfacil-woocommerce"
    "warpsteem"
    "wc-order-test-for-all"
    "really-rich-results"
    "shipyaari-shipping-managment"
    "ng-mail2telegram"
    "posttype-widget"
    "analytics-in-the-footer-titibate"
    "modify-comment-fields"
    "shipping-methods-by-classes"
    "c-web-analytics"
    "orabox-theme"
    "widgets-for-social-post-feed"
    "wp-clickable-background"
    "blueocean-woo-order-map"
    "nashaat-activity-log"
    "atelier-scroll-top"
    "pf404-for-petfinder"
    "card-for-github"
    "provide-forex-signals"
    "wp-amp-helper"
    "weight-and-balance"
    "wp-master-business-menu"
    "smartarget-contact-us-all-in-one"
    "ya-pricing-table"
    "ddelivery-woocommerce"
    "hosting-stability-meter"
    "leadboxer-gravityforms"
    "woo-upload-bulk-files"
    "robera"
    "melonpan-block-images"
    "recent-posts-ultimate"
    "custom-lorem-ipsum-generator"
    "wp-logger-tenbulls"
    "gochat247-live-chat-outsourcing"
    "ciaook-share"
    "erp-shortlinks"
    "threatpoint-email-validator"
    "lead-generation-website-analyzer-tool"
    "super-simple-google-analytics-lite"
    "ds-directory"
    "dozwpsecure"
    "unreal-themes-switching"
    "share-computy"
    "labtheme-companion"
    "social-photo-feed-for-elementor"
    "rankingman"
    "woo-astropay-card-payment"
    "country-details"
    "covid-19-live-stats-lite"
    "wpmk-block"
    "ikol-business"
    "ultra-responsive-slider"
    "integration-toolkit-for-beehiiv"
    "order-timeline-for-woocommerce"
    "paiementpro-for-give"
    "kindred-installer"
    "user-post-collections"
    "orders-track-parcel"
    "pigeon"
    "randpost-random-post-widget"
    "badad"
    "woo-paymentsgy"
    "wp-survey-manager"
    "edd-variable-defaults-update"
    "dmimag-faqs"
    "forma"
    "unitizr"
    "wc-yabi"
    "lmp-pregnancy-calculator"
    "apidae-insertion-widget"
    "translation-pro"
    "module-for-gravity-forms-in-divi-builder"
    "wp-optinjeet"
    "vcp-events"
    "budbee-shipping"
    "altoshift-woocommerce"
    "brexit-countdown"
    "ezgmaps"
    "obotai"
    "engage-buddy"
    "telecube-ringy"
    "ajax-shop-loop-quantity-for-woocommerce"
    "smart-recaptcha"
    "os-shortcode-detector"
    "platformly-for-woocommerce"
    "turnclick"
    "load-your-site-url-in-any-page"
    "gdpr-ready-advice"
    "awesome-sms-for-woocommerce"
    "search-amazon-products"
    "search-excel-csv"
    "tgen-template-generator-for-tnew"
    "counten-sale-counter-advanced"
    "wp-media-metadata-fix"
    "pz-frontend-manager"
    "wp-site-screenshot"
    "fast-aweber"
    "forms-3rdparty-post-again"
    "notwiz-ruby-text"
    "showmb"
    "js-responsive-iframes"
    "airfieldhub"
    "ienterprise-crm"
    "task-runner"
    "agenda-in-cloud"
    "zidithemes-text-image"
    "contact-manager-for-sendgrid"
    "touching-comments"
    "publir-ump"
    "pushvault-push-notifications"
    "user-profile-picture-social-networks"
    "parknav-wp"
    "fakeblock"
    "conversion-tracking-for-woocommerce-and-google-ads"
    "email-fields-for-woocommerce"
    "wc-paxum-gateway"
    "sm-post-duplicator"
    "fast-tagcredit"
    "lasting-sales"
    "member-authorisation-for-sheep-crm"
    "formulario-de-inscricao-grupo-prominas"
    "cf7-zohocampaigns-extension"
    "smart-appointment-booking"
    "bibot"
    "woo-chippin-payment-gateway"
    "boardea-storyboard-integration"
    "bridhy-addons-for-contact-form-7"
    "ascendoor-metadata-manager"
    "positive-affirmations"
    "sapphire-popups"
    "boldwallet-mycred"
    "easy-ads-or-text"
    "edd-ytaskpayments-gateway"
    "deliveryplus-by-invisible-dragon"
    "recaptcha-for-salon-booking-system"
    "paysover"
    "bitnob"
    "gm-html-carousel"
    "bitform"
    "contributors-with-post"
    "multiple-shipping-options-for-woocommerce"
    "wp-custom-image-widget"
    "funbutler-booking"
    "wp-restricted"
    "simple-visitor-registration-form"
    "wooshop-piraeus-bank-gateway"
    "ai-product-categories-woocommerce"
    "ev-ead"
    "disable-reset-password"
    "app-log"
    "hatom-missing-fields"
    "woo-addon-product"
    "woo-email-admin-on-completed-order"
    "safan-enable-svg"
    "cb-order-save-wc"
    "form-send-blocks"
    "minimal-search-term-highlight"
    "cf7-woocommerce-product-list-dropdown"
    "platform-notification-for-woocommerce"
    "socialplus"
    "elearnify-widget"
    "xenial-divi-schema-menu"
    "shopinext-for-woocommerce"
    "exploded-view-filter"
    "wb-mail-logger"
    "bbwp-custom-fields"
    "website-texting"
    "sksoftware-speedy-for-woocommerce"
    "network-post-duplicator"
    "streamweasels-kick-integration"
    "devinlabs-length-and-distance-converter"
    "news-and-blog-designer-bundle"
    "lazy-dm-roleplaying-session-planner"
    "elegantui-social-media-icons"
    "novarum-json-importer"
    "pulseshare"
    "more-color-schemes"
    "switch-login-uri"
    "wp-editor-with-uploader"
    "refresh"
    "wpyoutube-post"
    "network-database-search"
    "extra-product-options-pro"
    "fonts-manager"
    "non-latin-attachments"
    "thai-fonts-for-elementor"
    "faculty-weekly-schedule"
    "open-graph-headers-for-wp"
    "another-simple-image-optimizer"
    "virtual-shop-for-woocommecre"
    "coffee-cup-widget"
    "table2excel"
    "woo-seo-content-randomizer-addon"
    "registration-form-eu"
    "kads-slider"
    "zone-pandemic-covid-19"
    "bookinglive-connect-integration"
    "continue-shopping-from-cart-page"
    "masterbip-pesos-chilenos"
    "asynchronous-emails"
    "ni-show-product-name-in-orders-tab-of-my-account-page-for-woocommerce"
    "mini-preview"
    "alias-pay-woocommerce-gateway"
    "the-wp-tracker"
    "category-banner-management-for-woocommerce"
    "cm-multisite-lite"
    "add-categories-to-pages"
    "pf-timer"
    "presswell-publication-schedule"
    "wp-niche-products"
    "assign-related-posts"
    "wp-plc-swissknife"
    "multisite-author-bio"
    "modern-portfolio"
    "writegen"
    "annotation-by-country"
    "bubbles-name"
    "jsonld-semantic-tags"
    "icon-footnote"
    "block-scripts-a"
    "simple-schema-reviews"
    "sticky-admin-menu"
    "simple-tabs-luna"
    "medyum-burak-gunluk-burc"
    "refericon"
    "alceris-analytics"
    "2performant-for-woocommerce"
    "bubble-critic"
    "variation-gallery-simplified"
    "digital-signature-for-gravity-forms"
    "weekly-shabbat-times"
    "qonnex-finance-spread-payment-option-for-woocommerce"
    "wp-simple-mouring"
    "my-wp-faqs-list"
    "rexly-toolbox"
    "lianamailer-wpf"
    "wc-inecobank-payment-gateway"
    "bleumi-payments-for-woocommerce"
    "responsive-cropped-yummy-images-pictures-and-thumbnails"
    "local-business-booster"
    "paymentiq-checkout"
    "active-users-list"
    "simple-woocommerce-wishlist"
    "new-page-comments"
    "bomb-sms-notifier"
    "airim"
    "my-company-files-login"
    "viet-nam-affiliate"
    "wp-slack-updates-notifier"
    "lndr-page-builder"
    "products-clearance-sale-for-woocommerce"
    "the-real-time-chat"
    "better-hints"
    "jvh-woody-snippets-helper"
    "dp-th-helper"
    "thsa-quotation-generator-for-woocommerce"
    "crs-post-title-shortener"
    "wp-attend"
    "wp-dealer-map"
    "notyf"
    "hide-wp-upgrade-message"
    "real-protection-otp"
    "vivio-swift"
    "badgeos-lifterlms-integration"
    "relic-sales-motivator-woocommerce-lite"
    "7star-pay"
    "resize-image-before-upload"
    "webico-maps-embed-flatsome-addons"
    "archive-bot-blocker"
    "embed-audiobakers"
    "master-shipping-for-woocommerce"
    "neuwo"
    "thirukkural"
    "woosite"
    "rememberall"
    "apostle-social-wall"
    "wp-translate-shortcode"
    "pix-pay-easy-for-woocommerce"
    "puchi-ab-testing"
    "word-reading-time-counter"
    "beans-simple-shortcodes"
    "filterable-showcase-for-woocommerce-products"
    "accessally-lms-migration-from-wp-courseware"
    "wp-trigger-github"
    "tracking-code-for-pinterest-pixel"
    "vat-ust-id-checker-validator-eu-for-woocommerce"
    "easy-employee-management"
    "funnelflare"
    "featured-category-widget"
    "muc-luc"
    "wp-widget-cloner"
    "yeahpop"
    "wp-social-link"
    "awesome-wc"
    "promo-referral-urls-generator-coupons-auto-apply-for-woo-free-by-wp-masters"
    "products-boxes-slider-for-woocommerce"
    "wp-quotpedia"
    "customer-care"
    "ssv-users"
    "git-snippets"
    "wm-secure-and-optimize"
    "wc-filter-orders-by-payment-method-in-admin-order-list"
    "posts-search"
    "file-uploader-tektonic-solutions"
    "burd-delivery-shipping"
    "glossary-by-arteeo"
    "wp-cartonbox"
    "vindi-konduto-connect"
    "woo-wechat-crossborder"
    "registration-wall"
    "advanced-faq-creator-by-category"
    "mailrush-io-forms"
    "better-rest-apis-for-mobile-apps-by-sapricami"
    "rapidly-load-youtube"
    "usmsgh-wc-sms-notification"
    "pangu-js"
    "effortless-custom-fields"
    "exit-popup-advanced"
    "salam"
    "sp-clients-carousel"
    "comment-word-blacklist-manager"
    "monwoo-web-agency-config"
    "sms-to-sms-add-on-for-salon-booking"
    "keep-category-list-order"
    "cometleads-contact"
    "e-customer-emails"
    "wp-mail-rest-api"
    "auto-summarize-post-content"
    "widget-github-profile"
    "product-teaser"
    "tasador-de-autocaravanas"
    "deniz-primary-category"
    "rb-post-views-widget"
    "bs-faq"
    "wpg2mod"
    "weheartit-image-embed"
    "qinvoice-sisow-ideal-for-gravity-forms"
    "material-sidebar-posts"
    "it-idol-woo-import-export"
    "easy-product-delivery-date"
    "wp-scroll"
    "g-structured-data"
    "dai-seobomb"
    "cart-gateway"
    "crmio"
    "brevwoo"
    "rebel-slider"
    "td-multiple-roles"
    "restrict-content-for-wp-bakery"
    "feature-add-ons-for-booked"
    "qr-code-login-admin"
    "upload-add-on-for-woocommerce"
    "simple-sermon-media-podcast"
    "hides-product-variations-without-stock"
    "elite-testimonials-slider"
    "ambi-products"
    "beans-simple-edits"
    "cyoud-first-paragraph"
    "gvs-jcarousellite"
    "redirect-countdown"
    "rebrand-leadconnector"
    "kokku-cookie-banner"
    "smartarget-get-followers-teaser"
    "myworks-design-signpost-sync"
    "url-image-uploader"
    "diff-domain-new-tab"
    "snapwizard"
    "rental-goods-manager"
    "manage-discount-in-admin-orders-for-woocommerce"
    "loading-screen-by-imoptimal"
    "code-to-post"
    "easy-feedback"
    "cache-file-management-for-wp-super-cache"
    "wp-tweet-walls"
    "awesome-custom-scrollbar"
    "remove-try-gutenberg-dashboard-notification"
    "equibles-stocks"
    "greeting-by-day-time"
    "wp-slugify"
    "wpblogsync"
    "hide-my-wp-version"
    "sixth-station-category-search-box"
    "ooyyo-car-search"
    "loft-postreorder"
    "quantum-addons"
    "surmetric-surveys"
    "awesome-wp-team-member"
    "floating-adminbar"
    "post-grid-module-for-divi"
    "rewrite-image-url"
    "remove-version-number"
    "editors-note"
    "snipp-net"
    "login-with-wallet"
    "fix-google-newsstand-missing-images"
    "lock-my-woocommerce"
    "ele-hover-addon"
    "surpriseme"
    "woo-blocks"
    "eashortcode"
    "font-resize-accessibility-compliance"
    "base-angewandte-portfolio-showroom"
    "dbpcloudwp"
    "deltadromeus-email-checker"
    "mtpl-insurance"
    "easy-email-customizer-for-woocommerce"
    "emldesk-subscription-forms"
    "genius-marketo-form-prefill"
    "tigris-flexplatform"
    "better-share-buttons"
    "void-woo-cart-restrictor"
    "woo-postnord-tracking-form"
    "wp-audio-book"
    "summary-box-for-wikipedia-links"
    "product-content-generator-with-chatgpt"
    "fancy-slider"
    "content-by-role"
    "gerador-de-certificados-devapps"
    "itzultzailea"
    "find-and-remove-orphaned-learndash-content"
    "front-end-managed-files-block"
    "theme-yaml"
    "bulk-product-price-change"
    "wcd-portfolio"
    "devnex-addons-for-elementor"
    "lebianch-lista-tus-urls"
    "network-rest-site-list"
    "sdz-table-of-contents"
    "vg-block-rest-api"
    "term-featured-image-fallback"
    "send-cf7-data-to-active-campaign"
    "giftoin-for-woocommerce"
    "wp-safepassword"
    "login-page-editor"
    "gestor-de-google-analytics-facil"
    "rng-shortlink"
    "certegy-ezipay-payment-gateway"
    "penguinet-gripeless"
    "we-google-map-block"
    "aurifox"
    "featured-image-for-pressbooks"
    "my-htpasswd-generator-widget"
    "golf-society"
    "bloginfo"
    "wp-user-sentry"
    "ficoo-smart-connector-core"
    "kirilldan-lotinga"
    "aura-thumb-site"
    "trail-manager"
    "wc-unlink-downloadable-product-title"
    "domainers-delight-search-widget"
    "mc-w3tc-minify-helper"
    "edd-google-customer-reviews"
    "cf-contact-form"
    "everything-accordion"
    "who-delete-my-posts"
    "wpscolor"
    "simple-acf-gallery-slider"
    "hide-priceless-products"
    "anyform"
    "reservation-system"
    "xlogin"
    "equallyai"
    "happy-texting"
    "extend-acf-acf-json-directory"
    "fuelprice-australia"
    "list-video-youtube"
    "cp-scroll-to-top"
    "woo-shop-product-review-popup"
    "ucm-files-manager-ucm-fm"
    "improve-bot"
    "swaysmart"
    "asc-bio"
    "yaurau-ip-blocker"
    "remove-meta-genrators"
    "no-comments-please"
    "master-pdf-viewer"
    "quick-edit-posts"
    "prouptime"
    "greetings-bygosh"
    "wp-quick-notes"
    "qnotsquiz"
    "hexreport-sales-analytics-for-woocommerce"
    "imgturk"
    "survais"
    "wp-hotell-managed"
    "geo-target-dragon-radar"
    "detabess"
    "check-server-mail-smtp"
    "cs-gallery"
    "woo-autocomplete"
    "mif-wp-customizer"
    "polkadot-palette"
    "for-your-eyes-only"
    "lcpay-payment-gateway"
    "booster-blocks"
    "text-filtering"
    "lana-sso"
    "invoice-creator"
    "unclickable-featured-image"
    "hidewpbar"
    "web3-wp"
    "media2post"
    "splitter-orders-for-woocommerce"
    "application-download-banner"
    "lh-email-queue-and-log"
    "hi-deas-website-dialer"
    "graphjs"
    "galaksion-tag-manager"
    "sidebar-menu"
    "edd-discord-notifications"
    "doacao-para-fansubs-com-br"
    "enhanced-captions"
    "simple-calltoaction-popup"
    "igefilter"
    "tool-tips-for-contact-form-7"
    "wp-custom-code"
    "doviz-cevirici-widget"
    "cdn-modal-enabler"
    "wp-faq-builder"
    "rhinopaq-shipping"
    "advatix-oms-sync"
    "xpressium-image-limit"
    "jms-url-rewrite-rule"
    "ean-upc-and-isbn-for-woocommerce"
    "bs-spam-protector"
    "block-editor-taxonomy-description"
    "wp-callisto-migrator"
    "shortener-simple"
    "currency-rates-of-the-russian-ruble"
    "wp-social-proof"
    "elegant-catalogs-for-woocommerce"
    "master-image-feed-elementor"
    "brikshya-map"
    "super-background"
    "create-restaurant-menu"
    "every-page-shopify-cart"
    "slideup-social"
    "image-studio"
    "wptd-chart"
    "recommend"
    "cherittos-importer"
    "error-establishing-db-connection-monitor"
    "raw-html-modal-window"
    "x-extensions-for-woocommerce"
    "emercury-for-woocommerce"
    "easy-analytics-for-google"
    "post-words-counter"
    "cds-maps-wp"
    "wp-which-fonts"
    "madtek-entrusans"
    "wc-products-to-external-websites"
    "all-in-box"
    "wegfinder"
    "conditional-taxonomy-option"
    "kargo-entegrator"
    "template-path"
    "waypanel-heatmap-analysis"
    "core-settings"
    "filter-comments"
    "sopay-gateway-for-woocommerce"
    "priority-order"
    "mailbul"
    "creative-fa-and-bs-icons-shortcode"
    "submit-content"
    "hide-editor-for-page-templates"
    "simple-google-reviews"
    "tru-utm-generator"
    "spamscout"
    "dynamic-password"
    "gn-customize-post-list"
    "webdesign-ugurcu-dhl-manager"
    "add-social-buttons"
    "shorturls"
    "custom-share-button"
    "tg-connector"
    "haq-tabed-slider"
    "atec-system-info"
    "sticky-postbox"
    "learning-objects-lms"
    "track-logins"
    "mo-slider"
    "comment-crusher"
    "isms-2-factor-authentication"
    "usmsgh-contact-form-7-sms-notification"
    "snoka-shortcode-for-canadahelps"
    "print-console-template-uri"
    "wp-custom-styling"
    "shift8-security"
    "sm-google-maps"
    "guest-author-affiliate"
    "3d-scene-viewer"
    "woo-d2i"
    "the-publisher-desk-read-more"
    "api-car-trawler"
    "external-featured-image-from-bing"
    "4-level-slider"
    "faculty-cpt"
    "taxonomies-sortable"
    "wp-studio-tabs"
    "better-business-reviews"
    "woo-payxpert-gateway"
    "tg-instantview"
    "image-taxonomify-for-learndash"
    "carbonbalance-for-woocommerce"
    "payment-gateway-for-idbank"
    "viralkit"
    "wp-custom-posts-widgets"
    "qreatmenu-restaurant-qr-menu-for-woocommerce"
    "real-time-title-checker"
    "easy-paypal-buttons"
    "pdf-invoicespacking-slip-and-shipping-label-free-for-woocommerce"
    "th23-subscribe"
    "popbot"
    "related-post-slider-block"
    "my-analytics-code"
    "wp-lightning-comments"
    "database-audit"
    "views-counter"
    "restrict-payment-methods-for-woocommerce"
    "purchase-button"
    "award-on-click-for-gamipress"
    "absolute-2fa-for-woocommerce"
    "intense-kargo-kurtarma-modu-for-woocommerce"
    "heslo-login"
    "youme-id"
    "russian-currency-chart"
    "formester"
    "swe-product-360-degree-view"
    "contexto"
    "styling-default-post-flipbox"
    "webiots-testimonials"
    "air-quality-mk"
    "xlocate"
    "light-bakso"
    "wordai"
    "video-conferencing-daily-co"
    "redirection-page-hit-counter"
    "image-and-media-byline-credits"
    "mstw-schedule-builder"
    "wise-kpis"
    "product-explode"
    "omnitags"
    "recover-abandoned-cart-for-woocommerce"
    "q-shortcodes"
    "imagebase642file"
    "wordform"
    "simple-coupon-import"
    "klyp-contact-form-7-to-hubspot"
    "vize-tests-basic"
    "wc-integration-to-nettix"
    "simple-removal-of-posted-images"
    "awesome-random-post"
    "get-out-dashboard"
    "getreview"
    "login-page-customizer"
    "wp-hummingbird-purger"
    "wp-slide-in-widget"
    "wp-environment-label"
    "export-users-to-pdf"
    "pithywp-templates"
    "todo-by-aavoya"
    "simple-plugin-selector"
    "open-admin-view-site-in-new-tab"
    "admin-loaded-display"
    "project-sync-for-github"
    "random-alan-partridge-quote-widget"
    "waj-scripts"
    "dadevarzan-wp-subcompany"
    "table-builder-for-csv"
    "purpleads-ads-txt-manager"
    "mixed-content"
    "formmemory"
    "webcam-gallery"
    "ip2content"
    "payment-gateway-for-evocabank"
    "lr-services"
    "moka-word-count"
    "unmask"
    "faqs-made-easy"
    "woo-per-product-per-qty"
    "wp-date-search"
    "auto-aliexpress-dropshipping"
    "icecred-preloader"
    "vietnam-social-proof-toaster"
    "la-crm-integration-with-contact-form"
    "postpone-posts"
    "mobile-action-bar"
    "coinwaypay-gateway-for-woocommerce"
    "lr-youtube-grid-gallery"
    "indexreloaded"
    "param-iframe-generator"
    "easy-stock-featured-image"
    "escape-to-edit-for-divi"
    "sp-framework"
    "triangle-email-template"
    "taugun"
    "ignite-online-google-tag-manager"
    "wp247-extension-notification-server"
    "estrx-payu-purchase"
    "really-simple-testimonials"
    "wpac-sticky-admin-widgets"
    "ada2go-mark-your-old-articles"
    "table-of-contents-generate-easily"
    "stampaygo-checkout-payment-gateway-for-woocommerce"
    "simple-md5-generator"
    "home-animation-slider"
    "intento"
    "paone-personalization"
    "if-block-visibility-control-for-blocks"
    "mailsend"
    "wikiloops-track-player"
    "simple-customize-scrollbar"
    "disable-sslverify"
    "majestictheme-widgets"
    "hilp"
    "snorkel"
    "personalized-shortcode-pro"
    "mucl-distributor-extension"
    "intelli-content"
    "ctanfor-anti-spam"
    "galleriomjs-wp-gallery"
    "admin-menu-creator"
    "rosko-visual-editor"
    "gtm-consent-mode-banner"
    "persian-font-manager"
    "emote"
    "openpath-payment-gateway-for-woocommerce"
    "miaotixing"
    "mam-amp-slider"
    "aiaibot"
    "scarcity-jeet"
    "cf7geogle"
    "wp-post-notification"
    "cuboh-storefront-button"
    "wp-showcase-for-github"
    "technoscore-wc-category-carousel"
    "medma-matix"
    "bonafidetech-google-recaptcha"
    "wp-auto-update-plugins"
    "simple-redirect-contact-form-7"
    "thumb"
    "single-euro-payments-area-qr-generator"
    "woo-customer-order-status"
    "wp-instasass"
    "lh-better-slugs"
    "eva-email-validator"
    "simple-database-backup-wp"
    "css-page-ancestors"
    "text-moderation-system"
    "vonic-voice-assistant-for-woocommerce"
    "wp-sitemap-computy"
    "remote-post-swap"
    "davidson-domains-tagger"
    "products-slider-wpbakery"
    "5sterrenspecialist-wc-invites"
    "before-after-image-slider-amp"
    "share-that-cart"
    "yektanet-affiliate"
    "posts-filter"
    "taklink"
    "comment-analyzer"
    "blog-image-sitemap"
    "shortcodes-for-rumble"
    "fudugo-schema"
    "server-mail-check"
    "wp-sendy-newsletter-generator"
    "frontend-dashboard-easy-digital-downloads"
    "easy-restaurant-menus"
    "zip-news"
    "quick-chat-buttons"
    "all-the-same-variations-for-woocommerce"
    "rd-add-palecolors"
    "an-creatives"
    "chatbot-widget-opulent"
    "paged-post-list-shortcode"
    "post-visit-count"
    "payment-options-per-product"
    "sort-pages-by-date"
    "umba-payment-gateway-free-for-woocommerce"
    "wpct-drag-drop-recent-posts"
    "w2-slider"
    "hello-darkness"
    "smart-protect"
    "reset-gravity-forms-views"
    "auto-social-meta-tags-asmt83"
    "simple-variation-swatches"
    "nf-ux-enhancements"
    "goon-plugin-control"
    "maths-calculator"
    "wp-awesome-timeline"
    "options-management"
    "projects-showroom"
    "alert-box-for-comments"
    "wp-awesome-quotes"
    "backwards-compatible-permalinks"
    "smart-language-select-disabler-for-polylang"
    "vizaport-ai-chat"
    "stop-automatic-updates"
    "profile-link-generator-for-buddypress"
    "star-addons-for-elementor"
    "mce-searchreplace-buttons"
    "posts-per-page-changer-ui"
    "wp-rest-api-post-page-custom-fields"
    "minimalist-editor"
    "change-mail-sender"
    "hello-programmer"
    "mipl-cf7-crm"
    "opensug"
    "ng-wp-endpoints"
    "api-key-manager"
    "easy-copyright"
    "fotobuck-compressor"
    "easy-google-analytics-tracking-code"
    "monitor-chat"
    "ccavenue-payment-button-by-bluezeal-labs-in-elementor"
    "lr-responsive-slide-menu"
    "product-revenue-chart"
    "woo-earn-sharing"
    "identibyte-for-contact-form-7"
    "wpaudit"
    "virtual-jquery-keyboard"
    "simple-url-tracker"
    "environment-info"
    "product-display-for-bigcommerce"
    "used-media-identifier"
    "webigraph-addons-for-elementor"
    "random-quote-generator"
    "pluginops-advanced-shipping"
    "yesh-invoice-invoices-for-woocommerce"
    "use-cmb2-markdown"
    "php-year-auto-updater"
    "indi-tuts"
    "hideremove-text"
    "zebchat-live-chat"
    "woo-each-add-to-cart"
    "jobswidget"
    "can-i-use-cookies"
    "s2-woocommerce-ean"
    "woo-direct-buy"
    "payflexi-instalment-payment-gateway-for-gravity-forms"
    "autopopulate-checkout-for-woocommerce"
    "shape-size-calculator"
    "dpiordie"
    "wp-sso-server"
    "wdv-add-services-events-rooms"
    "l-squared-hub-wp-virtual-device"
    "gdpr-notification"
    "cart-limiter"
    "um-content-locker"
    "secure-chatsystem-io"
    "woo-custom-product-call-for-price"
    "ultra-menu-remove"
    "limit-login-attempts-security"
    "easy-location-map"
    "gwent-cards"
    "wow-scroll-up"
    "logicrays-team-membres"
    "did-someone-clone-me"
    "bb-extra-conditional-logic"
    "cf7-slack-integration"
    "ultimate-portfolio"
    "livewords-translation"
    "woo-purchased-products"
    "dd-attachments"
    "instant-search-using-ajax-for-xt-woo-floating-cart"
    "outaigate-webchat-installer"
    "wp-author-bio-wedo"
    "cyke-logistics"
    "laboratory-menu-rest-endpoints"
    "gimme-filter"
    "photosynth"
    "ai-contents-generator-wp"
    "integration-for-listmonk-mailing-list-and-newsletter-manager"
    "tracking-code-for-google-tag-manager"
    "contact-form-by-fulfills"
    "quick-analytics"
    "profpanda-custom-dashboard-widget"
    "my-own-shortcodes"
    "whook-testimonial"
    "ai-color-palette-generator"
    "wpmk-portfolio"
    "easy-dexter-lightbox"
    "subscriptionflow-integration-for-woocommerce"
    "admin-allow-by-ip"
    "wp-meta-repeater"
    "slovak-post-eph-export"
    "wp-delete-comments"
    "integration-for-baazarvoice"
    "parane-font-manager"
    "woo-csv-price"
    "botjuggler"
    "paypro-gateways-easy-digital-downloads"
    "annytab-code-prettify"
    "raml-console"
    "envy-custom-post-widget"
    "technoscore-google-tracking"
    "gf-borgun-add-on"
    "hm-woocommerce-coming-soon"
    "wp-multi-task"
    "gallery-with-bootstrap-for-elementor"
    "avelon-network"
    "kursolino"
    "zone-redirect"
    "content-freshness"
    "attachment-filter-by-hocwp-team"
    "sv-press-permit-converter-member-groups-to-roles"
    "floating-button-call-to-action"
    "css-animation-retrigger-for-wpbakery"
    "belingo-antispam"
    "wp-htaccess-edit"
    "categorized-cart-page-for-woocommerce"
    "hb-audio-gallery"
    "convert-emoticons-font-awesome"
    "screeney"
    "dvk-conf"
    "fast-and-responsive-youtube-vimeo-embed"
    "pipfrosch-jquery"
    "aspl-dropbox-file-upload"
    "disable-wp-5x-update-nag"
    "remove-yellow-bgbox"
    "insert-tags"
    "login-registration-redirects-manager"
    "prevent-all-updates"
    "smntcs-nord-admin-theme"
    "manual-related-products-for-woo"
    "morphii"
    "watupay"
    "hiflow-billder-connect"
    "aspl-product-quotation"
    "uplexa-woocommerce-gateway"
    "scblocks"
    "simplemailer"
    "weconnect"
    "current-date-free"
    "safetymails-forms"
    "counts-section"
    "payflexi-instalment-payment-gateway-for-easy-digital-downloads"
    "bulk-plugin-toggle"
    "backend-user-count"
    "multi-emails-for-woocommerce"
    "fotkipress"
    "joinup-recruiting-bot"
    "contact-form-made-easy"
    "xunsearch"
    "clicksco-offerstack"
    "talkm-chat-widget"
    "spam-to-blacklist"
    "disable-all-updates"
    "webvriend-wp-login"
    "simple-json-ld-header-adder"
    "coworks-membership-request"
    "incompatibility-status"
    "scc-seo-tool"
    "mos-testimonial"
    "custom-reviews-and-ratings-for-woocommerce"
    "coexist-with-gutenberg"
    "display-popular-post"
    "steeplyref-affiliate-referral"
    "translations-for-pressbooks"
    "apoyl-aliyunoss"
    "diystyle"
    "subnet-info"
    "thematic-maps"
    "plugin-information-card"
    "useresponse-live-chat"
    "saksh-text-to-voice-system"
    "notify-bot-woocommerce"
    "explicit-width-and-height"
    "maha-copyright-date"
    "nice-faqs-from-nit"
    "wp-comment-form-js-validation"
    "analytics-breakingpoint"
    "dynamic-step-pricing"
    "echoza"
    "resq-fr"
    "posts-visitors"
    "scoby-analytics"
    "update-alerts"
    "newest-posts"
    "woo-moeda-pay"
    "pusher-pushing-mobile-notifications-with-fcm"
    "lh-no-cache-shortcode"
    "info-toggle"
    "ajaxify-wc-shopping"
    "read-more-wp"
    "bulk-page-maker-light"
    "reservation-studio-widget"
    "post-emoji"
    "grassblade-xapi-sensei"
    "brand-center-connector"
    "full-trust"
    "lh-comment-form-shortcode"
    "push-agent"
    "pinpoint-free"
    "wis-scrapper"
    "want-flirty-leads"
    "tiengvietio"
    "blotout-edgetag"
    "wp-contact-me"
    "kantoniak-about-me"
    "woo-dhl-auto-complete"
    "framestr"
    "hel-online-classroom"
    "mi13-glossary"
    "avid-elements"
    "fotepo"
    "vossle"
    "tkt-contact-form"
    "gn-product-and-image-remover"
    "omplag"
    "export-to-epp"
    "job-application-form"
    "wp-like-comment-share"
    "ajax-add-to-cart-on-hover"
    "ai-title-generator"
    "sistemex-inbound"
    "codecorun-product-offer-rules"
    "limit-taxonomy-term-count"
    "emercury-for-gravity-forms"
    "advanced-block-controls"
    "image-block-zoom-on-hover"
    "solpress-login"
    "simple-drm"
    "custom-author-box"
    "mc2p-gravityforms-addon"
    "wc-tbc-installments"
    "idt-testimonial"
    "woo-checkout-quick-scroll"
    "connected-web"
    "team-view-by-innvonix-technologies"
    "venjue-widget"
    "copyright-notice"
    "simple-eliminate-render-blocking-css"
    "r-s-contact-form"
    "2coders-integration-mux-video"
    "wp-mega"
    "back-to-normal-widgets"
    "visibility-viewer"
    "heyrecruit"
    "header-and-footer-snippets"
    "saturn-tables"
    "indianwebs-pideme-cambios"
    "mango-contact-form"
    "mk-adblock"
    "loginbox-widget"
    "tips-donations-at-checkout"
    "footer-contact-form"
    "fix-gutenberg-style"
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

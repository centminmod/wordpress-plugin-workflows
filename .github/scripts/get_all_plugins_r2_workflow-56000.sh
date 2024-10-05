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
    "exchangerate-api"
    "xtoool-product-feed"
    "vy-bildbank"
    "config-email-smtp"
    "tdmrep"
    "payyed-gateway-for-woocommerce"
    "xeppt-card-payment"
    "thekua-banner-for-offer-coupon"
    "customization-for-woocommerce"
    "doltics-validator"
    "hippoo-ticket"
    "imgtorss"
    "ai-bulk-post"
    "famtree"
    "year-remaining"
    "just-test-email"
    "cobru-for-wc"
    "display-all-in-one-urls"
    "edd-template"
    "juicer-io-the-best-social-photo-feed-posts-reels-stories-and-more"
    "piforge-ai-generation-blog-image"
    "ultimate-seo-image"
    "digiteal-payments"
    "greek-newspapers"
    "future-shop"
    "wpsysinfo"
    "journalist-ai"
    "app-redirect"
    "cm-update-history"
    "auto-post-for-twitter"
    "mediatypes"
    "isibia-dashboard-messages"
    "latest-news-posts"
    "taxonomies-slug-fixer"
    "login-magician"
    "simple-toolkit"
    "near-access"
    "skittybop"
    "model-trains-data"
    "langle-addons-for-elementor"
    "ukey-pay"
    "aktualna-data"
    "mohu-product-grid"
    "automation-for-wpforms"
    "wc-pratkabg-shipping"
    "smart-search-and-product-finder"
    "tida-url-screenshot"
    "custom-page-routes"
    "slider-x-woo"
    "ecommerce-banner-and-gallery"
    "easy-gallery-lightbox"
    "insert-codes"
    "donation-or-tip-for-woocommerce"
    "ship-discounts"
    "oneship"
    "eforms-pdf"
    "chatwith"
    "error-logs-emailer-for-woocommerce"
    "notifyvisitors-net-promoter-score"
    "resources-wp"
    "guttypress"
    "wc-purchase-orders"
    "shorturl-tracker"
    "visibility-control-for-masterstudy"
    "project-agora"
    "stoic-quotes"
    "diyassist"
    "tours"
    "yep-pay"
    "photoberry-studio"
    "kicklander"
    "email-verification-elementor-forms"
    "smart-cost-builder-with-google-sheets"
    "easy-gigawallet-dogecoin-gateway"
    "api-for-cb-app"
    "nfc-events"
    "taxoclean"
    "themes-assistant"
    "accessibility-menu-pro"
    "maxart-csv-product"
    "gmap-block"
    "seopic-intelligent-seo-images"
    "printshopcreator-api-connect"
    "customize-wp-login-page"
    "conexteo"
    "import-qiita2wp"
    "eth-fundraiser"
    "runthings-wc-coupons-role-restrict"
    "studio99-wp-monitor"
    "opi-security-boost"
    "thirdweb-wp"
    "posts-from-phpbb"
    "pattern-box"
    "recent-posts-columns-block"
    "spampatrol"
    "verbalize-wp"
    "notify-slack-bot"
    "free-weather"
    "dequeue-jquery"
    "floship-insurance"
    "wps-safe-logout"
    "shiftt-notify"
    "awesome-posts"
    "maintenance-mode-by-juraj-hamara"
    "simple-markers-map"
    "esir-win-fiskal-fiskalna-kasa"
    "solo-blocks"
    "core-a11y-for-elementor"
    "analyzati-website-visitor-tracking"
    "stale-content-notifier"
    "pagepulse"
    "post-page-reaction"
    "integrate-jira-issue-collector"
    "wphd-posts-addon"
    "strict-security-headers"
    "click-to-speak-fonvirtual"
    "oembed-streamlike"
    "ingenidev-cashondelivery-shield"
    "typesense-wp-vector"
    "ajaxy-instant-search"
    "site-health-tools"
    "squawk-forms"
    "comdev-downloads"
    "staylogged"
    "pointnxt"
    "my-custom-taxonomy"
    "contact-form-to-brevo"
    "datafeedwatch-connector-for-woocommerce"
    "drcaptcha"
    "ves-payment"
    "payment-gateway-pix-for-givewp"
    "save-cf7-entry"
    "hide-shipping-fields-for-local-pickup"
    "xdc-datachain-gateway"
    "swiftsales"
    "tematres-wp-integration"
    "dashboard-scratch-pad"
    "staff-training"
    "digital-signature-for-wpforms"
    "synchrony-payments"
    "ebi-ai"
    "advanced-checkout-for-woo"
    "visibility-control-for-wpcourseware"
    "promaker-slider"
    "tabchat"
    "tt-discount-option-for-woocommerce"
    "german-posting-filter"
    "plug-in-monitor"
    "metatext"
    "disable-emails-per-product-for-woocommerce"
    "dappayments"
    "wpc-role-based-payment-methods"
    "dynamic-iframe-for-wp"
    "dark-mode-toggle-block"
    "quick-chat-betterhalf-social-chat"
    "mailbuzz"
    "like-dislike-for-wp"
    "personal-design-of-forms"
    "bizappay"
    "justbaat"
    "gigago-partner"
    "disable-services-manager"
    "native-maintenance"
    "media-attached-filter"
    "banner-image-for-woocommerce"
    "cloudbridge-2fa"
    "ingenidev-code-widget-for-elementor"
    "ocamba-hood"
    "beyond-identity-passwordless"
    "reserveereenvoudig"
    "checkaim-ai-anti-fraud-protection"
    "send-message-google-chat-cf7"
    "rock-maps-for-divi"
    "k-previous-next-edit-button"
    "reset-custom-post"
    "super-rollback"
    "dynamic-mockups"
    "wappi"
    "w3v-xml-rpc-security"
    "physio-cloud-software"
    "change-sender-id"
    "guest-order-sync"
    "blockchyp-payment-gateway"
    "pushrocket"
    "registration-and-authorization"
    "masterlms"
    "talkee"
    "site-cookie-setting"
    "open-brain-gateway"
    "newcallcenter-webtocall"
    "wikilms"
    "simple-short-link"
    "wabaapi-alerts-for-woocommerce"
    "flodesk-for-elementor-pro"
    "skeedee-booking-widget"
    "billbrd-io"
    "netsmax-gateway-for-woocommerce"
    "ocasa-ecommerce"
    "dream-coming-soon"
    "checkout-guard"
    "pestoai"
    "myclub-groups"
    "protoc-by-saur8bh"
    "simple-post-views"
    "correct-image-orientation"
    "tid-custom-login-page"
    "elite-kit"
    "post-count-shortcode"
    "semlinks"
    "easy-menu-icons"
    "cdntr"
    "aitrillion-engage"
    "exclude-files-for-aio-wp-migration"
    "no-results-for-elementor"
    "scb-qrcode-payment-gateway"
    "payper"
    "xampweb-elementor-slider"
    "payment-for-gccpay"
    "wordsmtp"
    "simple-editor-control"
    "carnet-de-vols"
    "postcrafts"
    "smart-portfolio-manager"
    "fapshi-payments-for-woocommerce"
    "rd-wc-enhanced-order-notes"
    "user-tour-guide"
    "auto-import-products-cart-dragdropfile"
    "professional-payment-portal-for-woocommerce"
    "display-post-reading-time"
    "lytics-wp"
    "sim-site-maintenance"
    "auto-image-seo"
    "rss-xml-feed-display-with-images"
    "omnimind"
    "heichat"
    "woot-ro"
    "webvizio"
    "classic-scroll-to-top"
    "fsd-simple-banner"
    "revlifter"
    "product-view-tracker"
    "really-simple-featured-audio"
    "web-archive"
    "flexyconsent"
    "happy-wp-options"
    "custom-css-option-for-elementor"
    "incuca-helper"
    "enhanced-user-search"
    "comment-emojis-for-wp"
    "findabookclub-reading-list"
    "flamix-bitrix24-and-forminator-integration"
    "wp360-invoice"
    "star-rating-field-for-gravity-form"
    "utm-manager"
    "wyseme-giftcard-by-saara"
    "pressburst-news-feed"
    "awesome-designs-for-woocommerce"
    "promaker-dashboard"
    "gaali"
    "wprunway-for-divi"
    "whatsiplus-order-notification-for-woocommerce"
    "usercheck"
    "light-weight-wa-chatting"
    "mugglepay"
    "media-carousel-for-guten-blocks"
    "nachrichten"
    "superbuzz"
    "builderglut"
    "default-posts-slider-addon"
    "intellidraft"
    "mher-list-subpages"
    "desku-livechat-ai-chatbot"
    "logo-per-page"
    "clientpoint-customeros"
    "custom-css-inoculate"
    "popups-for-easy-digital-downloads"
    "self-check-in"
    "centrex-smart-web-form-builder"
    "bizbaby"
    "export-posts-to-csv"
    "linxo-connect"
    "blogify-ai"
    "advance-payment-wc"
    "content-curation-tool-by-curatora-io"
    "text-to-audio-with-ads"
    "ecu-remapping-performance-calculator"
    "recent-purchased-items"
    "filter-bounce-email-verifier"
    "another-read"
    "trustistecommerce"
    "chimpxpress"
    "picklejar-live-for-artists-venues"
    "sofk-air-conditioning-calaculate"
    "paychangu-payment-gateway-for-givewp"
    "acymailing-integration-for-acf"
    "panafacturas-factura-electronica"
    "stock-control"
    "ai-sidekick"
    "clarifyip-geo-blocking"
    "build-it-for-me-ai-creator"
    "apoyl-aicomments"
    "spm-show-colors-for-elementor"
    "klikpay-secure"
    "wpplugz-shoppable-image"
    "rkg-membership-level"
    "page-marker"
    "flexitype-lite"
    "frequent-quran-words"
    "quicksnap"
    "post-type-management"
    "bulk-delete-all-in-one"
    "bictorys-payment-gateway-for-woocommerce"
    "login-form-elementor"
    "brosh-crm"
    "lazytasks-project-task-management"
    "email-user-cleaner"
    "abcbiz-reviews"
    "keep-sabbath"
    "plot-beam"
    "coresocial"
    "smart-answer"
    "expedico"
    "canny-armadillo"
    "turbo-video"
    "count-pagination-fix"
    "bulk-woo-discount"
    "quick-view-popup-woo"
    "foxtips"
    "tiqq-shop-integration"
    "smtp-mailer-override"
    "son-secure-content-guard"
    "import-wp-rentals-listings"
    "wc-quantity-price-limit-for-cart"
    "record-for-contact-form-7"
    "order-tags-code-wp"
    "fix-htaccess-wpml-language"
    "financial-loan-calculator"
    "product-demand-tracker"
    "yas-counter-for-elementor"
    "restrict-json-rest-api"
    "superelements-elementor-addons-widgets-templates"
    "bulletproof-checkout-lite"
    "wpmozo-addons-lite-for-elementor"
    "adminpass-password-bypass-display"
    "allagents-review"
    "skeps-pay-over-time"
    "doc-mitayo"
    "ranking"
    "phases"
    "palacify"
    "qe-ultimate-blocks"
    "open-source-software-contributions"
    "checker"
    "turn-on-classic-editor"
    "lazy-load-ga4"
    "spaces-engine"
    "retail-media-network-onet-ads"
    "faqs-buddy-product-faq"
    "accessibility-uuu-widget"
    "flamix-bitrix24-and-fluent-form-integration"
    "wh-bulk-price-update-for-woocommerce"
    "chat-skype"
    "aplinkos-ministerijos-norway-grants"
    "change-add-to-cart-all-text"
    "gutenwise"
    "quote-blocks"
    "rankworks-ai-behavioral-analytics-platform"
    "media-to-imprint"
    "payping-donation"
    "awesome-lightbox"
    "wc-payment-infinpay"
    "latest-content-by-anything"
    "ssl-expiration-notifier"
    "iron-gforce-lite"
    "post-count-tracker"
    "wpappsdev-gsheet-order-automation"
    "numeric-captcha-for-woocommerce"
    "pretty-rss-feeds"
    "quick-products-details-for-woocommerce"
    "secure-forms"
    "nofollow-external-outbound-link"
    "rfs-email-verification-for-gravity-forms"
    "cryptopay-integration-for-mycred"
    "ai-site-search"
    "product-ticket-system-for-woocommerce"
    "eliza-chatbot"
    "pronamic-pay-with-rabo-smart-pay-for-woocommerce"
    "insytful"
    "bullmessage"
    "simple-login-custom"
    "featured-images-in-admin-panel"
    "open-admin-links-in-new-tab"
    "my-post-stats"
    "calculated-custom-fields"
    "simple-file-upload-limiter"
    "post-extra"
    "ada-feed-link-decoder-for-google-news"
    "ar-ad-manager"
    "clean-post-content"
    "ultimate-product-options-for-woocommerce"
    "multipurpose-point-of-sale-for-woocommerce"
    "bluefield-identity"
    "products-compare"
    "accepted-payment-methods"
    "freecharge-pay-woo"
    "new-custom-order-columns"
    "sheepy-for-woocommerce"
    "giantcampaign"
    "admin-backend-color-coded-post-notes"
    "ultimate-testimonials-rotator"
    "born-creative-cart-view"
    "miguel"
    "ty-project-player"
    "universal-blocks"
    "bookster-paypal"
    "qanswer-chatbot"
    "star-collector-review-widgets"
    "cryptocadet"
    "vtiger-webform-to-gravity-forms-converter"
    "quick-assist-ai"
    "perfect-portal-widgets"
    "cookiego"
    "postcode-checkout-postcode-validation"
    "cdl-checkout-for-woocommerce"
    "redirection-pro"
    "data-collector-insights"
    "current-year-date"
    "nice-select-for-wp"
    "csvmapper"
    "saksh-wp-hotel-booking-lite"
    "require-auth-users-rest-endpoint"
    "ai-seo-wp"
    "uniweb-for-wp"
    "midi-synth"
    "live-story-short-code"
    "demandhub"
    "duplicate-page-post"
    "pack-send-live-shipping-rates"
    "payping-gravityforms"
    "temperature-note-for-woocommerce"
    "disable-comments-entire"
    "bud-coder"
    "posten-post-blocks"
    "flowheel-integrator"
    "packaging-fit"
    "settimize"
    "flamingo-by-mailbird"
    "fx-currency-converter"
    "payment-gateway-for-fastshift"
    "dashboard-admin-theme"
    "order-management-woo"
    "order-restriction"
    "changeloger"
    "mobile-link-page"
    "eeat-wp"
    "simple-star-rating-block"
    "quantity-calculator-for-woocommerce"
    "member-status-for-memberpress"
    "align-widgets-horizontally"
    "5-ways-ustawienia-widgetu-chatu-formularza"
    "tatrapay-payment-gateway"
    "staging-prevent-indexing"
    "suggest-404-links"
    "simple-click-collect-for-woocommerce"
    "moowp"
    "safelayout-brilliant-buttons"
    "icon-blocker"
    "yayforms"
    "custom-captcha-field-for-fluent-forms"
    "airticle-flow"
    "custom-ai-chatbot-with-your-data-integrating-chatgpt-by-resolveai"
    "rest-api-extender"
    "easy-toolbar-visibility"
    "world-clocks"
    "particles-extension-for-elementor"
    "shaicon-block"
    "smoother-chat-based-on-chatgpt"
    "force-sells-for-variations"
    "live-demo-sandbox"
    "wingipay-payment-gateway"
    "breezepay"
    "easy-duplicate-woo-order"
    "vit-sitemap"
    "eventmobi-registration"
    "webiwork-per-product-shipping"
    "ovoform"
    "trivialy"
    "advance-voice-search"
    "creditable-paywall"
    "textomap"
    "fontcat"
    "brainybear-ai-chatbot"
    "defendium-checker"
    "button-shortcode"
    "min-max-for-woocommerce"
    "afa-submission-manager"
    "haendlerbund-api"
    "approve-new-user"
    "advanced-login-page-customizer"
    "rate-the-site-experience"
    "image-classify"
    "security-checker-for-themes"
    "wpayo"
    "cloud-uploads-pro"
    "force-add-to-cart"
    "ym-fast-seo"
    "webkew-image-dominant-color-generator"
    "proweblook-phone-validator"
    "affiliamaze-amazon-affiliate-linker"
    "dmn-security-centre"
    "wc-ultimate-notification-sender"
    "yu-story"
    "hidden-price-for-unregistred-users"
    "cns-login-master"
    "jometo-ir-fashion-designer"
    "nswp-product-inquiry-form"
    "advanced-captcha-hub"
    "wholesale-market-suite-for-woocommerce"
    "sales-tax-hero"
    "career-explorer"
    "gotoviar"
    "opengraphmagic"
    "block-all-emails"
    "boost-bricks-builder"
    "awp-disallow-root-control"
    "yumitpay"
    "advanced-email-domain-restriction"
    "cognix-ai-bots"
    "clone-pages-posts-cpt-wooprod"
    "delete-inactive-themes-and-extensions"
    "awareid-wc-integration"
    "atomica-vision"
    "defai"
    "ai-news-poster"
    "chatspark"
    "kliken-ads-pixel-for-meta"
    "cointopay-com-cc-only"
    "embed-block-figma"
    "smooth-scroll-to-top-button"
    "digitalpilot"
    "sms-mobile-api"
    "callcontact"
    "givingx"
    "flizpay-for-woocommerce"
    "bridal-live-appointment"
    "smart-wishlist-for-woocommerce"
    "simple-link-checker"
    "chat-app-brasil"
    "cargoflux"
    "gutenverse-themes-builder"
    "webglobe-purge-cache"
    "spam-email-domain-exclusion-cf7"
    "charts-for-divi"
    "wizevolve-min-max-quantities"
    "wpsc-ultimate-testimonials"
    "picpoints"
    "bvnode-wpf-pdf-generator"
    "bookingtime-appointment"
    "responsive-visibility"
    "easy-resource-hub"
    "all-social-share"
    "squawk-media"
    "omniwebsolutions-simple-calendar"
    "hierarchy-pages-nav"
    "ai-eshop-optimizer"
    "shuffle-random-image-gallery"
    "unlimited-pricing-table-for-elementor"
    "zinrelo"
    "postify"
    "wp-stateless-divi-theme-addon"
    "tish-pricing-table"
    "tp-advanced-search-for-woocommerce"
    "fr-read-more"
    "turbo-addons-elementor"
    "telinfy-messaging"
    "terrareach-sms-for-woocommerce"
    "the-code-registry-code-backup-intelligence"
    "db-price-converter-woocommerce"
    "smart-alt-generator"
    "trustedlogin-connector"
    "dew-blocks"
    "link-attributes-for-publishers"
    "auto-post-io"
    "sheetlink"
    "cleandesk-ai"
    "templazee"
    "member-mail-drop"
    "aceprensa-posts"
    "uptimemonster-site-monitor"
    "product-import-and-export-csv-for-woocommerce"
    "seonte-ai-content"
    "rappibank-gateway"
    "custom-accordion"
    "meta-author-box"
    "tubapay-v2"
    "fastcron"
    "show-posts-shortcodes"
    "cognitiveai-widget-chat-ai"
    "hiveify"
    "yatmo-map"
    "dynamic-post-title-for-cf7"
    "dropchat"
    "portfolio-and-custom-posts"
    "free-bulk-delete-all-comments-with-without-hyperlink"
    "mvp-affiliate"
    "send-zap"
    "ninja-workspace"
    "pattern-friend"
    "quizbit"
    "showcase-social-media-icons"
    "html-tags-on-post-title"
    "responder-integration"
    "comments-subscriber"
    "dynamic-draft-post"
    "logichat"
    "writerx"
    "beepxtra-payment-gateway"
    "enhanced-addon-for-contact-form-7"
    "webp-conversion"
    "shake-add-to-cart-button-animation-for-woocommerce"
    "esri-map-view"
    "copy-page-post"
    "ai-review-scanner"
    "smile-block"
    "gutenito-blocks-addon"
    "elite-elementor-addons"
    "intasend-pay-button"
    "funkitools"
    "smc-quiz"
    "permanent-user-password"
    "affiliatize-me"
    "simple-contact-button"
    "eservecloud-ai-chat-bot"
    "ai-product-content-creator-for-woocommerce"
    "onchat"
    "embed-blocks"
    "hebrew-date-jewish"
    "norton-shopping-guarantee"
    "timeline-with-block"
    "restrict-payment"
    "all-in-one-utilities"
    "snowflurry-live"
    "image-ticker"
    "strictly-auto-parts-for-woocommerce"
    "chat-data"
    "delete-items-from-woo-card"
    "wpost-still-fresh"
    "ovoads"
    "performance-monitor"
    "glueup"
    "sort-pages-set-categories"
    "vite-coupon"
    "postdates"
    "sa-swatches"
    "docodoco-geotargeting"
    "lito-blogcard"
    "th23-gallery"
    "block-finder"
    "fsdpcfl-contact-form-lazyload"
    "jmvstream"
    "arena-scheduler"
    "troubleshooting"
    "businessonbot"
    "autocep"
    "blank-page"
    "filter-bar-custom-post-type"
    "messymenu"
    "h5-additional-product-to-cart"
    "accessiweb-widget"
    "advanced-shortcodes"
    "webbersai-product-content-generator"
    "auto-alt-text-for-images"
    "wptelmessage"
    "cub-cf7db"
    "mareike"
    "apoyl-autotop"
    "zajel-shipment-delivery"
    "rss-image"
    "ai-scrape-protect"
    "promaker-chat"
    "no-translation-block"
    "crypto-price-table"
    "digital-service-provider-crm"
    "xml-rss-guardian"
    "posts-block-lite"
    "order-reminder-for-woo"
    "ticket-tailor-event-list"
    "dashboard-reader"
    "db-gradient-text-block"
    "zru-for-woocommerce"
    "hnp-openstreetmap"
    "dsgvo-leaflet-map"
    "integration-for-cf7-pardot-form-handlers"
    "ai-graid"
    "hi-heat-map"
    "blog-posts-organizer-browse-sidebar-blog-categories-and-blog-titles-easily"
    "ws-price-history"
    "cw-ai-gpt-chatbot"
    "nepal-payments-hub-nabil"
    "rabbit-seo"
    "menu-tooltip"
    "rmdm-barra-brasil"
    "april-payment-gateway-for-woocommerce"
    "pause-sales-on-woo"
    "thumbnail-remover"
    "carbonara-online-reservation"
    "content-revalidation-tracker"
    "advanced-rule-based-shipping"
    "bin-tracker-online"
    "gdpr-extensions-com-youtube-2clicksolution"
    "convert-rank-math-faq-to-accordion"
    "toret-manager"
    "faq-info-instigator"
    "custom-action-block"
    "related-posts-neural-network"
    "hello-green-click-by-green-aureus"
    "huxloe-shipping"
    "mailbob"
    "gift-card-wooxperto-llc"
    "activity-ninja"
    "api-reviews-and-testimonials-for-elementor"
    "emplibot"
    "wpapps-table-collapser"
    "mauve"
    "advance-order-form"
    "sticky-list"
    "embedx"
    "single-user-content"
    "hide-price-and-add-to-cart-for-woocommerce"
    "shipi"
    "utm-gclid-catcher"
    "entercheck-company-search"
    "seemax-sidebar-resize"
    "payping-donate"
    "customizer-login-ui"
    "sima-feedback"
    "wanpay-payment-for-woocommerce"
    "smart-heading"
    "omnisend-for-lifterlms-add-on"
    "envifast-shipping"
    "webot-chatbot"
    "orbi-blocks"
    "scalooper-traffic-insights"
    "barestho"
    "mpaqt-for-woocommerce"
    "simple-login-page-styler"
    "flamix-integration-bitrix24-and-gravity-forms"
    "mybotchat"
    "opal-estimated-delivery-for-woocommerce"
    "brainstation-lms"
    "deckbird-ai-webshow-button"
    "seo-meta-description-generator"
    "qualityhive"
    "thumbs"
    "aichatbot"
    "pdf-embedder-scrollable"
    "escala-servico"
    "opal-upsale-quantity-for-woocommerce"
    "archive-nbp"
    "wot-elementor-widgets"
    "social-media-one-click"
    "affiliate-ads-for-vacation-rentals"
    "slickpress"
    "wph-recipes-manager"
    "custom-floating-social-buttons"
    "streak-wp"
    "role-based-dashboard-notices"
    "booking-appointment"
    "advanced-campaign-monitor-integration"
    "mega-navify"
    "shipshap"
    "igw-memory-usage-info"
    "shipment-tracking-ddt-for-woocommerce"
    "plover-toc"
    "rich-text-editor-tinymce-for-woocommerce"
    "post-from-rss-feeds"
    "pdf-invoices-for-gravity-forms"
    "kickscraper"
    "hubon-local-pickup"
    "expirepress"
    "wpsmegamenu"
    "gdpr-consent-manager"
    "wsd-search-by-slug"
    "quantity-multiples"
    "oneclickcontent-titles"
    "simple-sc-gallery"
    "seo-metrics-helper"
    "integrate-cf7-to-aurastride"
    "vayapin"
    "phlush-permalinks"
    "wp-stateless-siteorigin-css-addon"
    "echoai"
    "holiday-home-vacancy"
    "advanced-menu-icons"
    "duplicator-post-page"
    "writer-strict-requirements"
    "boomfi-crypto-payments"
    "wisechats"
    "cw-comment-elementor-addon"
    "bulk-export-import-images-seo-attributes"
    "checkout-file-upload-for-woocommerce"
    "sms-manager"
    "pekemd"
    "sort-posts-by-latest-update"
    "date-picker-for-gravity-form"
    "auto-product-restock-for-woo"
    "add-social-media-share-buttons"
    "bulk-delete-users-by-keyword"
    "ingenidev-ksa-sar-currency-symbol-changer"
    "ajax-portfolio"
    "image-filter"
    "product-catalog-mode-for-woocommerce"
    "monek-checkout"
    "student-discount-for-woocommerce"
    "screen-sharing-system"
    "websiteoptimizer-ai"
    "easy-post-gallery"
    "taager-addon"
    "sidetalk-ai"
    "free-bulk-woo-price-update"
    "scotty"
    "pakistan-tax-calculator"
    "x-addons-elementor"
    "hbagency"
    "cq-bancamiga-gateway-for-woocommerce"
    "trustifi-smtp-mailer"
    "netweb-ask-a-question"
    "old-post-notice"
    "cropilot-ai-tracking"
    "blocks-custom-css"
    "retack-ai"
    "auto-anchor-links-list"
    "chatbot-faq"
    "seo-bulk-admin"
    "amazingaffiliates"
    "connect-wpform-to-any-api"
    "stryker-smtp"
    "colorful-fields-for-gravity-forms"
    "recipe-master"
    "pactic-connect"
    "gutendraw"
    "old-comment-cleaner"
    "fortguard"
    "sales-health-monitor-for-woocommerce"
    "chat-floating-button-by-xd"
    "price-guard-for-woocommerce"
    "storia-toimitus"
    "ipospays-gateways-wc"
    "shipping-account-capture"
    "usedeli"
    "email-customizer-for-contact-form-7"
    "advanced-data-table-for-elementor"
    "tickethub"
    "sidobe-notification"
    "flex-fields"
    "hamzaban"
    "integration-of-icecat-live"
    "easy-reports-for-learndash"
    "payler-payment-gateway"
    "openedx-commerce"
    "cs-element-bucket"
    "kilho-simple-avatar"
    "billie-for-woocommerce"
    "gutenverse-companion"
    "highlight-magic"
    "moolre-payment-gateway"
    "easy-block-editor"
    "ebook-store-affiliate"
    "getdave-responsive-navigation-block"
    "product-recommendations-addon-for-woocommerce"
    "bookify"
    "changelog-extend"
    "search-hero"
    "digital-humans-nevronixai"
    "fc-loan-calculator"
    "videojs-hls-player"
    "ajax-load-more-for-searchwp"
    "display-sermonnet"
    "tracking-la-poste-for-woocommerce"
    "freedom-permalinks"
    "better-recurring-coupons"
    "uikit-blocks"
    "bt-ipay-payments"
    "edit-term-group"
    "acf-galerie-4"
    "ath-movil-pay-button-payment-gateway"
    "renesse-aan-zee"
    "product-sales-analytics-report-for-woocommerce"
    "wp-create-shortcode"
    "snap-tales"
    "swissphone-select-for-gravityforms"
    "sepa-qr-code-for-woocommerce"
    "email-customizer-for-wpforms"
    "clean-htaccess-tool"
    "webp-image-optimization"
    "astrolabe"
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

    debug_log "Sending request to Worker for checksums: ${CF_WORKER_URL}?plugin=${plugin}&version=${version}&type=checksums${force_update_param}${cache_only_param}"

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
    # First, export all variables including USER_AGENTS
    export DOWNLOAD_BASE_URL MIRROR_DIR LAST_VERSION_FILE DEBUG_MODE DOWNLOAD_LINK_API LOGS_DIR ALL_PLUGINS_FILE DOWNLOAD_ALL_PLUGINS LIST_ONLY CF_WORKER_URL DELAY_DOWNLOADS DELAY_DURATION FORCE_UPDATE CACHE_ONLY USER_AGENTS

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

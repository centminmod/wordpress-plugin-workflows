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
    "saledash"
    "nic-duplicate-post-page"
    "force-protocol-less-links"
    "block-engine"
    "imagebox-block"
    "skyrise-hide-wp-admin"
    "manage-folders-and-labels-gravity-forms"
    "dh-site-vital-monitoring"
    "notification-customizer"
    "captisa-forms-shortcode"
    "artifact-form-saver"
    "wp2act"
    "codedrill-single-image-upload"
    "show-id"
    "wooref"
    "ssv-mailchimp"
    "bomond-event"
    "fee-recovery-for-givewp"
    "the-publisher-desk-ads"
    "iframe-responsive-lazy-load"
    "qualpay-payment-for-gravity-forms"
    "easymanage-orders-sync"
    "hello-dolly-guarana"
    "pivotway-leads-generator"
    "remove-more"
    "simpler-syntax-highlighter"
    "lingmo-translator"
    "wds-themes-manager"
    "your-simple-slider"
    "published-posts-locked-url"
    "featherlight-html-minify"
    "share5s"
    "mzd-recent-posts"
    "wp-assistance"
    "pick-n-post-quote"
    "swiftpic"
    "css-magician"
    "timeline-for-elementor"
    "wp-sharex"
    "papion-ajax-regvalidation"
    "wpadlock"
    "ps4l-pond-calculator"
    "different-publisher"
    "mango-ssl"
    "journy-io"
    "simple-goto-top-button"
    "flip-block"
    "custom-socials-share"
    "hw-default-payment-gateway-for-woocommerce"
    "categorized-tagged-pages"
    "organized-contacts"
    "webp-image-block"
    "innovation-list-shortcode"
    "addresswise"
    "balcao-balcao"
    "external-links-advertisement-note"
    "underdev"
    "ice-chat"
    "anhlinh-thuoc-lo-ban"
    "remove-comment-url"
    "minical"
    "holy-day-off"
    "jpeg-quality"
    "post-category-fcm-notifications"
    "natterly"
    "b2-sync"
    "contentstream"
    "snippet-flyer"
    "testimonial-moving"
    "word-switcher"
    "wp-events-hooks-listeners"
    "vendreo-card-gateway"
    "wp-cb-fontawesome"
    "sync-wechat"
    "wp-security-master"
    "awesome-post-views-counter"
    "bottom-stack"
    "cyoud-aio"
    "zsquared-connector-for-zoho-crm"
    "easy-analytics-for-wp"
    "smart-notification-bar"
    "widgetbird"
    "animated-pixel-marquee-creator"
    "wp-disable-console-logs"
    "conversions-popup-widget"
    "omi-live-talk"
    "rusty-top-bar"
    "queerify"
    "vrodex-booking-widget"
    "available-url"
    "wpo-enhancements"
    "add-newest-post-link-after-content"
    "ticker-pro"
    "hide-toolbar"
    "whelp-live-chat"
    "woo-xcart-migration"
    "regiondo-widgets"
    "browser-fullscreen-button"
    "compygo-social-feed"
    "basic-protected-lightbox"
    "wp-adposts"
    "shop-the-posts"
    "op-custom-api"
    "wiloke-ai-text-to-speech"
    "trashmail-contact-me"
    "promote-apex"
    "disable-telemetry"
    "typetura"
    "address-autocomplete-google-places"
    "loan-calculator-with-chart"
    "3veta"
    "wp-social-share-2"
    "polmo-lite-demo-importer"
    "autooffice"
    "navthemes-employee-ratings"
    "favo"
    "one-click-maintenance-mode"
    "woo-synchronizer"
    "kotowaza"
    "wp-general-purpose-shortcodes"
    "clustercs-clear-cache"
    "honey-coinhive-locker"
    "random-quote-zitat-service"
    "digital-clock-block"
    "viator-integration-for-wp"
    "show-thumbnail-image-in-admin-post-page-list-stiap"
    "error-log-file-viewer"
    "d3gb"
    "elements-ocean"
    "upsells-for-learndash"
    "bullet-comments"
    "cleverconnected-user-role-by-subscription"
    "admin-notes-wp"
    "wp-post-contributor"
    "qe-fid-id"
    "wp-argon2-password-hashing"
    "japanese-lorem-block"
    "vg-accordion"
    "mona-qtranslate-x-oembed-support"
    "dropdown-smu-style"
    "forty-two-blocks"
    "awesome-latest-tweets"
    "branded-sharebox"
    "ultrablocks"
    "miso"
    "motordesk"
    "project-donations-wc"
    "beta-flags"
    "dl-ultimate-custom-scrollbar"
    "softmixt-relations"
    "term-based-dynamic-post-templates-for-total"
    "pattern-editor"
    "sticky-one-many"
    "sf-autosuggest-product-search"
    "woo-firemni-udaje"
    "search-tools"
    "buybot-notifications"
    "append-user-id"
    "wtools"
    "category-limit-for-woocommerce"
    "lh-display-default-category"
    "dataclermont-bootstrap-widgets"
    "lightpost"
    "mc-web-notes"
    "search-wpml-algolia"
    "8-disable-right-click"
    "wp-vereinsflieger"
    "zij-career-builder-jobs"
    "saleztalk"
    "emercury-add-on-for-elementor-pro"
    "core-vitals-monitor"
    "kassa-at-for-woocommerce"
    "lh-response-handler"
    "microchat"
    "wp-ajax-loadmore"
    "pmpro-nganluong-gateway"
    "advance-wp-user-exportimport"
    "vipdrv-vip-test-drive"
    "dokiv-sharing"
    "simple-save-redirect-button"
    "sepordeh-woocommerce"
    "direct-password-reset-link"
    "ctcl-floating-cart"
    "ys-simple-google-analytics"
    "date-post-title"
    "gdpr-consent-lite"
    "woo-switcher-of-variants"
    "from-kart-to-basket"
    "postamp"
    "simple-easy-youtube-embed-video"
    "asset-finder"
    "wp-typetalk"
    "custom-hyperlinks"
    "draggable-images-block"
    "preloader-quotes"
    "rng-postviews"
    "dnetwo-bot"
    "simple-google-analytics-by-st"
    "wpcf7-twaddress"
    "fw-integration-for-emailoctopus"
    "easy-javascript-analytics-goals"
    "labelbaker"
    "ultimate-feed-youtube"
    "mk-custom-title"
    "admin-icons-manager"
    "content-attacher"
    "postqueue-feeds"
    "token-login"
    "ultra-coupons-cashbacks"
    "racydev-linky"
    "exit-popup-free"
    "gf-disable-storing-entry"
    "foxdell-folio-bec-theme-rain-forest"
    "jhe-ignitiondeck-widget"
    "growpro-widgets"
    "niftyflow"
    "press-release-reviews"
    "admin-setting"
    "fix-api-url"
    "myscrollbar"
    "chp-nepali-date-converter"
    "wafi-payment-for-woocommerce"
    "synergy-press"
    "doms-search"
    "customizer-ex"
    "cb-news-ticker"
    "splashpopup"
    "octagent"
    "bought-product-tab-for-woocommerce"
    "simple-reading-progress-bar"
    "color-changer-elementor"
    "extended-trial-coupon-for-wc-subscription"
    "resonline-booking-gadget"
    "optix-calendar"
    "horoscope-calculator"
    "ipay-manual-payment"
    "nodeless-for-woocommerce"
    "lxb-staging-reminder"
    "good-loop-ad-widget"
    "gf-unique-list"
    "exclude-post-types-for-weglot"
    "zplmod-faq-lite"
    "vk-popup-for-youtube-and-video"
    "villoid-brand-integration"
    "mobile-call-to-action"
    "category-reverse-order"
    "auto-title-case"
    "lh-rss-shortcode"
    "any-cpt-listing-block"
    "wt-smooth-scroll"
    "dn-sitemap-control"
    "theme-creator-with-bootstrap"
    "easy-car-rental-custom-backend"
    "prices-by-roles-for-woocommerce"
    "linkgreen-product-import"
    "yaspfp-yet-another-security-patch-for-pingback"
    "interview"
    "import-vk-comments"
    "emailplatform-woocommerce"
    "simple-cookie-consents"
    "chatster"
    "multiple-and-single-gallery"
    "bs4wp-component"
    "lh-404s-for-static-resources"
    "accordion-awesome"
    "referralyard"
    "wpcdnkoloss"
    "disable-lightning-headfix"
    "payway-custom-payment-gateway"
    "enable-maintenance-page"
    "developer-firewall"
    "dn-shopping-discounts"
    "update-customer"
    "wishlink-pixel"
    "floating-product-category-for-woocommerce"
    "online-cinema"
    "jm-gdpr"
    "website-backups"
    "fale-conosco"
    "formmakerformviewer"
    "vitaledge-pixel"
    "sdk-wp-smtp"
    "plataya-pagos-gateway"
    "ascendoor-logo-slide"
    "push-message-to-wechat"
    "wp-cross-term-seo"
    "easy-custom-theme-options"
    "mail-switcher-for-developer"
    "eros"
    "wg-compareo"
    "h7-tabs"
    "blackice-order-queues"
    "core-web-vitals-monitor"
    "real-buddha-quotes"
    "ad-auris"
    "test-post-generator"
    "auto-table-scroll"
    "wp-remove-yoast-seo-comments"
    "woo-orders-calendar"
    "junglewpultimo"
    "formulario-de-logueo"
    "annytab-photoswipe"
    "smtp-email-mod"
    "galleries-markers"
    "effata-widget-areas"
    "password-requirements"
    "brain-pod-ai-writer"
    "simple-money-button"
    "safeshop"
    "wp-globalinput-login"
    "ajax-woosearch"
    "conditional-popup-creator"
    "events-optimizer"
    "supo-talk-widget"
    "grapetrees-sitemap"
    "custom-php-codes"
    "hosted-jft"
    "session-save-user"
    "swifno-merchant-api"
    "product-category-discounts-for-woo"
    "um-bootstrap-carousels"
    "simple-header-footer-scripts"
    "videos-for-woocommerce"
    "vestorly-contact-form-7-integration"
    "nepalify"
    "busha-pay"
    "mfa-photo-editor"
    "offer-out-stock"
    "king-ftp"
    "simple-testimonial-slider-and-grid"
    "custom-dolly"
    "flussonic-media"
    "add-to-cart-button-customizer"
    "r3w-instafeed"
    "woo-shippings-payments-restrictions"
    "responsive-tab-blocks"
    "wp-ano-atual"
    "change-payment-description-for-woocommerce"
    "cf7-hidden-widget"
    "simple-emzon-links"
    "say4u"
    "lh-display-posts-shortcode"
    "conversion-helper"
    "clipboard-with-title-content-ivd"
    "material-faq-manager"
    "lukas-tripster"
    "lite-wp-logger"
    "recrm"
    "ss-bar"
    "precisobid-smartformerchant"
    "auranet-recent-photos"
    "report-for-woocommerce"
    "scrolling-overlays"
    "tiny-pictures-image-cdn"
    "wp-current-subcategories"
    "plugin-organiser"
    "reset-button-for-acf"
    "zip-code-based-product-price"
    "helpninja"
    "wc-shop-title"
    "recent-popular-comment-tag-widget"
    "zimrate"
    "best-wp-testimonial"
    "usability-feedback"
    "last-scheduled-post-time"
    "wp-terms-filter"
    "as-memberpress-campaign-monitor-integration"
    "orkestapay"
    "woo-frontpage-blog-roll"
    "wp-notice-bar"
    "wc-phoenixgate-payment-gateway"
    "hk-payment-gateway-for-converse"
    "woo-coupons-by-role"
    "support-email-dashboard-widget"
    "tend"
    "html-suffix"
    "register-sidebar-by-admin"
    "servicepublic"
    "simple-menu"
    "geek-mail-blacklist"
    "central-florida-idx"
    "ps-lms"
    "course-completed-for-learndash"
    "connect-cf7-to-hubspot"
    "get-php-version"
    "pppt"
    "elvez-control-access"
    "flex-gold-for-woocommerce"
    "advanced-embed-for-youtube"
    "future-aim-social-comment-system"
    "gboy-custom-google-map"
    "product-type-in-the-table"
    "corona-virus-live-ticker"
    "more-privacy-for-comments"
    "last-edited-posts"
    "the-connectome"
    "ms-registration"
    "reusable-blocks-user-interface"
    "use-bunny-dns"
    "integrate-aweber-and-contact-form-7"
    "colour-smooth-maps"
    "embed-freecell-solitaire-iframe"
    "rb-simple-faqs"
    "auto-coupons-for-woocommerce"
    "klaive"
    "wp-plugin-showroom"
    "devto-articles-on-wp"
    "psyco-maps"
    "very-simple-contact-us-form"
    "obfuscate-admin"
    "glmall"
    "fam-gmap-shortcode"
    "eduadmin-sveawebpay"
    "four-nodes-random-post"
    "wp-custom-access-lite"
    "clc-products"
    "hello-phil"
    "ngg-image-search"
    "one-click-buy-button-for-woocommerce"
    "innovade-learndash-activities"
    "tg-testimonials"
    "smartarget-tiktok-follow-us"
    "redirects-for-wp"
    "lyntonweb-scribe-integration"
    "optimator"
    "track-your-writing"
    "sw-post-views-count"
    "website-password-protection"
    "wcsociality"
    "nightly"
    "easy-dark-mode-on-one-click"
    "aspl-contact-form"
    "add-ld-courses-list-in-wc-account-page"
    "wpz-payments-free"
    "acf-ionicon-field"
    "ajax-single-add-to-cart-for-woocommerce"
    "modern-ctt"
    "super-simple-xml-image-sitemap"
    "adtrails-utm-grabber"
    "najva-commerce"
    "hide-show-admin-bar"
    "nnsmarttooltip"
    "acf-media-cluster"
    "multisite-landingpages"
    "easy-user-data"
    "wp-spam-protecter"
    "box-now-delivery-croatia"
    "ithemeland-bulk-variation-editing-for-woocommerce"
    "tracktastic"
    "simple-pictures-slider"
    "disable-next-step-with-enter-in-elementor-forms"
    "multi-vendor-campaign"
    "dvs-quick-hotline"
    "wp-simple-faqs"
    "french-accents"
    "wp-senpy"
    "simple-faq-by-lukask"
    "blogsend-io"
    "invoicing-for-economic"
    "bani-payments-for-woocommerce"
    "remove-update-notification"
    "projecthuddle-website-script"
    "gs-wc-bulk-edit"
    "user-role-management"
    "acf-for-gridsome"
    "wpspx-login"
    "zestard-cookie-consent"
    "motivation-for-woocommerce"
    "outdr-booking-widget"
    "gf-real-time-validation"
    "custom-coupon-messages"
    "jvh-css-classes"
    "mbm-ipak"
    "gallery-openseanft"
    "vicidial-call-me"
    "wp-call-response"
    "redirection-graphql-extension"
    "tp-restore-categories-and-taxonomies"
    "wp-applicantstack-jobs-display"
    "flashspeed"
    "simple-ses-mail"
    "tagesmenue"
    "shopcode-menu-horizontal-woocommerce"
    "steel-hardness-calculator"
    "wen-post-expiry-notification"
    "wp-mailscout"
    "lh-log-queries"
    "qanva-time-controlled-display"
    "altoshift"
    "faqizer"
    "weightloss"
    "range-slider-addon-for-acf"
    "hrappka-pl"
    "sitetran"
    "antoniolite-yandex-metrica-json-ld-schema"
    "package-update-server-for-woocommerce"
    "kneejerk-menu-swapper"
    "enhanced-search"
    "posts-rss-feeds"
    "magnipos"
    "woo-send-csvs-to-your-fullfillment-partner"
    "superfrete"
    "orders-chat-for-woocommerce"
    "wc-confetti"
    "ois-bizcraft-checkout-gateway"
    "new-nepali-calendar"
    "webiots-teamshowcase"
    "woo-slideshow-extension"
    "wp-web-maps"
    "univerwp"
    "disable-complete-wp-updates"
    "wp-frontend-helper"
    "netbookings-shortcodes"
    "cartara"
    "rz-job-application-form"
    "rollerads"
    "wp-disable-lazy-load"
    "alphapay-gateway-brazil"
    "magic-schema"
    "bulk-woocommerce-tag-creator"
    "integrar-hop-con-woo"
    "maximum-comment-length-to-1500"
    "hidden-field-to-comments"
    "repeated-blocks"
    "swaypay-woocommerce"
    "qualzz-design"
    "adaptive-login-action"
    "ignite-aws-ses"
    "matrixian-address-validator"
    "ahime-image-printer"
    "paymentasia-gateway"
    "remove-deleted-pages-from-search-index"
    "close-shop"
    "kirilkirkov-spotify-search"
    "ultimate-social-share-buttons"
    "woo-price-in-text"
    "woo-minimum-order-limit"
    "newsletter-chat"
    "instasport-calendar"
    "gp-automatic-variants"
    "know-co-app-integration-forms"
    "post-and-page-protect-azure"
    "kopi-chat"
    "slp-extenders"
    "select-primary-category"
    "rex-ad-cards"
    "s2-donation-using-stripe"
    "resize-control"
    "busonlineticket-search-box"
    "hide-admin-bar-by-wp-all-support"
    "negarara"
    "time-zone-converter"
    "icecream-elementor-addon"
    "kargom-nerede-kargo-takip"
    "acme-coming-soon"
    "progress-bar-ecpay-gateway"
    "essential-performance"
    "gdpr-tool-by-wsd"
    "authenticate-sponsorware-videos-via-github"
    "zt-ajax-mini-cart"
    "rate-this-site"
    "starrating-feedback-automatic"
    "plugin-compatibility-info"
    "spider-elements"
    "better-redirects-for-gravity-forms"
    "edd-robokassa-lite"
    "kloudymail-lead-generation"
    "moneyme-payments-for-woocommerce"
    "sports-booking-slot"
    "cooking-recipe-block"
    "contact-form-by-tech-c-net"
    "triple"
    "muscula"
    "themepaste-secure-admin"
    "dh-is-coming-soon"
    "blogcard-for-wp"
    "poll-survey-form-builder-by-zigpoll"
    "imagepilot"
    "kjrocker-cookie-consent"
    "ps-ads-pro"
    "yt-api-avoid-conflicts"
    "woo-combined-reviews"
    "advance-shipping-for-woocommerce"
    "cut-down-uploads-size"
    "javascript-disposable-email-blocker"
    "best-wp-lightweight"
    "athenic-ai"
    "experitour-search-widget"
    "technoscore-pardot-tracking"
    "fastcgi-cache-purge-and-preload-nginx"
    "remove-woocommerce-product-related"
    "dream-gallery"
    "ip-geolocation-info"
    "easy-poll"
    "xoo-sort"
    "precisionpay-payments-for-woocommerce"
    "order-export-to-lexware-opentrans-for-woocommerce"
    "featured-image-customizer"
    "enviromon"
    "strong-testimonials-migrate-from-easy-testimonials"
    "bps-splide-slider-block"
    "interactive-offers-co-registration"
    "wp-lean-analytics"
    "mj-term-meta-box"
    "hide-login-errors"
    "qr-links"
    "boz-prod-woocommerce-hipay-wallet-pro"
    "user-local-date-and-time"
    "wpmissioncontrol"
    "change-cart-word-for-woocommerce"
    "vntestimonial"
    "wmf-mobile-theme-switcher"
    "spinitron-player"
    "testimonials-wp"
    "wplauncher"
    "oppia-integration"
    "wp-dc-slider"
    "lisa-popup"
    "fix-error-404-permalinks"
    "user-login-plus"
    "front-editor-for-woocommerce"
    "wp-context-for-getsitecontrol"
    "cf7-google-sheets"
    "wxy-tools-stickyscroll"
    "wc-booking"
    "disable-new-user-registration-admin-emails"
    "logo-by-conditions"
    "wp-personalizer"
    "scroll-back-to-top-button"
    "single-page-booking-system"
    "tagelin-rota"
    "offadblock-wp"
    "flippa-estimate-your-business"
    "mw-auto-download"
    "sortable-tags"
    "ecommerce-table"
    "sa-woo-smart-chatbot"
    "display-stellar-lumens-price"
    "enweby-pretty-product-quick-view"
    "simple-fixed-contact"
    "block-patterns-ui"
    "wp-best-analytics"
    "simple-speech-bubble"
    "curlest"
    "bootitems-core"
    "sequence-animation"
    "very-fresh-lexicon"
    "edd-product-faq"
    "affiliate-graphicriver-widget"
    "envydoc"
    "house-ads"
    "disable-block"
    "customer-list"
    "order-reviews-for-woocommerce"
    "walili-pricing-table"
    "tarot-reading"
    "speisekarte"
    "sku-for-woocommerce-bookings"
    "regcheck"
    "wooctopus-flying-cart"
    "wc-sales-up"
    "prebook-appointment-booking"
    "lead-overview"
    "smart-delivery-shippings-and-returns"
    "top-button"
    "loanbylink"
    "customize-fb-share"
    "simple-related-products-for-woocommerce"
    "wholesale"
    "mz-mobilize-america-interface"
    "woo-search-company-for-orders"
    "tracking-code-for-linkedin-insights-tag"
    "mediapal-publisher"
    "datelist"
    "permalinks-shortcode"
    "simple-minmax"
    "ai-enabler"
    "ignite-online-social-share"
    "wp-dixa-chat"
    "wc-hkgov-address-autofill"
    "user-panel-lite"
    "iq-fulfillment"
    "causalfunnel-datascience"
    "stapp-divider"
    "mediamodifier-for-woocommerce"
    "remote-media-upload"
    "connections-to-directorist-migrator"
    "financial-reporter"
    "pvdnet"
    "ssl-for-buddypress"
    "login-form-in-restricted-message-for-ultimate-member"
    "wp-profile-picture"
    "clone-page-or-post"
    "maillister"
    "hubalz"
    "frequently-bought-together-product-for-woocommerce"
    "aspl-product-badges"
    "wpxp-background-media"
    "cf7-submit-animations"
    "wcone"
    "logicrays-wp-product-count-down"
    "demomentsomtres-woocommerce-default-price"
    "activation-add-on-for-gamipress"
    "hexagonal-reviews"
    "setup-default-feature-image"
    "clean-unused-shortcodes"
    "super-stage-wp"
    "manually-reduce-stock-for-woocommerce"
    "wopo-notepad"
    "lh-buddypress-woo"
    "remove-unwanted-p-tags"
    "ultimo-woocommerce-email"
    "kurator"
    "wc-dlocal-payments"
    "auto-change-post-title"
    "razorpay-payment-button-for-siteorigin"
    "slippy"
    "automated-remote-reposting-source"
    "stop-words"
    "ai-kotoba"
    "simplest-post-image-gallery"
    "css-url-argument"
    "opal-woo-custom-product-variation"
    "hms-rezervasyon"
    "lai-suat-ngan-hang-by-mecode"
    "fashion-slider"
    "deel-op-leesmee"
    "motionmagic"
    "alt-tags-for-gravatar"
    "ele-digital-clock"
    "tms-descricao-curta-dos-produtos"
    "lat-affiliate-tool"
    "s2-subscription-for-woocommerce"
    "visit-site-from-customizer"
    "zverejnit-sk"
    "wp-cloud-shell"
    "wc-product-videos"
    "order-feedback-woo"
    "isizer"
    "woo-gateway-payger"
    "apetail"
    "wpc-mystery-box"
    "myposeo"
    "wp-ajax-subscribe"
    "extra-settings-for-rocketchat"
    "turbo-sms"
    "michigan-marketing-firm"
    "iys-panel-wp-form"
    "monkee-boy-wp-essentials"
    "extensions-for-pressbooks"
    "hello-webchuck"
    "spirit-liturgicky-kalendar"
    "smsvio-pro-woocommerce"
    "wc-order-metadata-check"
    "wpadminmenuaccess"
    "sukellos-enable-classic-editor"
    "custom-checkbox-for-posts"
    "foxdell-folio-bec-disable-core-blocks"
    "calcinss"
    "wp-admin-view"
    "kgr-cookie-duration"
    "cellarweb-instant-comment-management"
    "cpj-calendar-appointment-scheduler"
    "golomt-bank-payment-gateway"
    "woo-call-for-price"
    "sms-on-order-place-and-order-status-change"
    "move-email-to-top-of-woocommerce-checkout"
    "all-in-one-smart-features-woocommerce"
    "nftndx-io-embed"
    "easy-car-rental-custom-lightslider"
    "copyright-info-for-child-theme"
    "nice-accordion"
    "list-images"
    "affinidi-login"
    "wp-letterpot"
    "s2-animate-siteorigin-pagebuilder"
    "timedlinks"
    "securiti-privacy-policy-generator-notice-management"
    "pagadera-for-woocommerce"
    "bangnam-wp"
    "forum-qa-discussion-board"
    "encode-shortcode"
    "pj-contact-form"
    "doopinio"
    "custom-order-status-for-woocommerce"
    "smartarget-contact-form"
    "ultimate-block-patterns-builder"
    "anysearch"
    "page-map"
    "material-testimonials"
    "hide-wc-categories-products"
    "payment-gateway-givewp-asoriba-businesspay"
    "quantity-field-for-gravity-form"
    "facturis-online-sync"
    "wage-conversion-calculator"
    "wp-easy-metrics"
    "listing-smart-shopping-campaign-for-google"
    "toret-product-stock-alert-lite"
    "toric"
    "wpm-simple-calendar"
    "smartarget-click-to-call"
    "phil-tanners-emailer"
    "clickperf"
    "dustid-integration-kit"
    "wp-stack-connect"
    "hide-wp-admin-wp-login-php"
    "image-hover-effects-mbengue"
    "moortak-ephe"
    "goodpix-content-share"
    "brandapp"
    "lana-email-logger"
    "ep-widgets-search"
    "wen-cookie-notice-bar"
    "better-kits"
    "primary-cat"
    "jtpp-share-buttons"
    "sitemap-ui"
    "disableremove-howdy"
    "ivorypay"
    "magnifi-widget"
    "oncustomer-livechat"
    "forced-auto-updates"
    "woo-one-product-per-category"
    "generate-audiogram-block"
    "mambrum"
    "sb-scroll-to-top"
    "easy-speed-optimizer"
    "wc-wholesale-manager"
    "indexic-areservation"
    "mappedin"
    "drag-drop-featured-image-improved"
    "mir-ad-network"
    "simple-captcha-wpforms"
    "kpis-cta-buttons"
    "optimization-tools-itnyou"
    "sp-custom-post-widget"
    "eventpeak-channel"
    "responsive-accordion-tabs"
    "easy-cookie-optin"
    "api-improver-for-woocommerce"
    "wp-news-photo-gallery"
    "schema-integration"
    "rw-recent-post"
    "dynamic-connector-block"
    "wp-help-desk"
    "multiple-gift-product"
    "tape"
    "imeow-18plus"
    "product-attribute-global-order-and-visibility"
    "monthly-subscription"
    "tkt-maintenance"
    "modern-fonts-stacks-for-font-library"
    "navthemes-export-single-order-data-woo-commerce"
    "jsl-exit-intent-popup"
    "eorthopod-patient-education-materials"
    "seo4cms"
    "form-styler-for-divi"
    "denade-translate"
    "chartnerd"
    "quick-popup-anything"
    "fs-store-locator"
    "st-slider"
    "redirection-io"
    "randomad"
    "menu-iconset"
    "yt-cookie-nonsense"
    "custom-post-type-add-on-for-gamipress"
    "post-right-there"
    "askbox"
    "publisher-common-id"
    "embed-salesvu"
    "dynamic-ctr"
    "real-estate-agencies"
    "wp-open-graph-protocol"
    "wp-post-has-archive"
    "essential-chat-support"
    "newstick-ultra"
    "ultra-slideshow"
    "very-basic-google-fonts"
    "the-taste-of-ink"
    "fumen"
    "alpona"
    "rss-feed-podcast-by-categories"
    "exs-gdpr"
    "zarincall"
    "add-image-file-sizes-to-table-list-view"
    "justawesome-woocommerce-redirect"
    "career-section"
    "woo-okosugyvitel-integration"
    "scroll-fast-to-top-button"
    "allow-html-in-terms"
    "disable-woo-analytics"
    "ultra-excerpts"
    "ai-image-seo-toolkit"
    "logpress"
    "customer-reports-woocommerce"
    "buffer-flush-fix"
    "lh-log-sql-queries-to-file"
    "admin-topbar-visibility"
    "heraldbee"
    "ampry-pixel"
    "change-my-login"
    "miso-ai"
    "readefined-com-troll-filter"
    "microslider"
    "c-h-robinson-shipping"
    "easy-analytics-tracking"
    "airchat"
    "responsetappr"
    "rebrand-learndash"
    "upload-multiple-media-by-api"
    "in-stock-widget"
    "events-manager-customization"
    "woo-weight-based-shipping-for-statesregionscities"
    "futura"
    "tg-visitors-ip-display"
    "aspl-email-pdf-invoice"
    "fetch-meditation"
    "sespress"
    "wp-desklite"
    "vg-protocol-removed-not-secure-connection"
    "easy-caller-with-moceanapi"
    "awesome-gst-calculator-widget"
    "exs-alphabet"
    "know-co-platform-base"
    "simple-stats-total"
    "lazy-embeds"
    "xaigate-crypto-payment-gateway"
    "cookies-for-leadhub"
    "chauhan-comments"
    "xoo-disable-update-notifications"
    "zedna-cookies-bar"
    "clayful-thunder"
    "g-social-buttons"
    "auto-update-wp"
    "rsv-pdf-preview"
    "username-editor"
    "gdpr-ccpa-compliance"
    "tabs-accordion"
    "video-metabox-aoc"
    "easy-lead-generation"
    "simplest-cookie-notice"
    "wc-bayonet"
    "helpinator-quick-publish"
    "social-counts-youtube"
    "tieq-viet"
    "verify-id-tokens-firebase"
    "medyum-burak-burc-bulma"
    "featured-circles"
    "doms-social-links"
    "integrate-osm-with-wp-job-manager"
    "launchpad-popular-posts"
    "bonboarding"
    "promesas-de-dios-al-dia"
    "browserly"
    "robohash-default-avatar"
    "ai-assistant-gpt-chatbot"
    "propertyshift"
    "convertizerfr"
    "scm-gateway"
    "nubocoder-beaver-builder-carousel"
    "auglio-try-on-mirror"
    "reviews-for-easy-digital-downloads"
    "easy-animated-popup"
    "database-analyzer"
    "hmh-woocommerce-quick-view"
    "frm-qpaypro"
    "kaboom-send-secrets"
    "reserve-post-board"
    "gecko-theme-parts"
    "notify-comment-reply"
    "thank-you-nhs"
    "affiliate-marketing"
    "enweby-custom-redirection-after-add-to-cart"
    "smetlink"
    "pdf-invoices-and-packing-slips"
    "gf-add-on-by-click5"
    "easy-cpt-maker"
    "cam-call"
    "wcf-widget"
    "badgeos-affiliatewp"
    "nofollow-adder"
    "content-management-control"
    "cashlesso-payment-gateway-for-woocommerce"
    "nepali-media"
    "totals-for-sponsorkliks"
    "sms-club-messages"
    "invitation-codes-gravityforms-add-on"
    "shortcode-content"
    "wp-question-answer"
    "yumjam-one-off-special-products-for-woocommerce"
    "cartes"
    "okcom-sort-and-show-id-slug-thumbnails"
    "nutsforpress-duplicate-any-posts"
    "zone-cookie"
    "oberon-wpaddin"
    "virgool"
    "am-wishlist"
    "disable-updates-comments"
    "simple-autopop"
    "post-title-custom-link"
    "launchpage-app-importer"
    "quotation-manager"
    "minimal-dashboard-by-wss"
    "shipping-rd"
    "post-id-optimizer"
    "embed-link"
    "roam-block"
    "content-checklist"
    "swissqr"
    "last-login-on-dashboard"
    "code-snippets-in-comments"
    "rocketdeliver"
    "restaurant-solutions-checklist"
    "gp-ux-optimized-mobile-menu"
    "kingbot-payment-getway-for-woocommerce"
    "easy-coming-soon-and-maintenance-mode"
    "greenlet-booster"
    "restrict-woocommerce-reports-status"
    "add-to-order"
    "racar-one-account-per-cpf"
    "resultat-finans-betallosning"
    "heliumpay-payment-gateway"
    "categories-as-folders"
    "honkify"
    "parcel-tracker-ecourier"
    "beautyalist-login"
    "shipping-price-modifier"
    "ngx-image-resizer"
    "custom-status-for-wc-orders"
    "exsile-sms-gateway"
    "buzzer-button"
    "liturgical-day-of-the-week"
    "filter-sorter"
    "winddoc-no-profit"
    "variable-product-price-option-for-woocommerce"
    "category-popular-tags"
    "pagtur-woocommerce"
    "geoedge-ad-security"
    "fa-shortcode"
    "urubutopay-for-woocommerce"
    "infinity-simple-faq"
    "interface-for-geniki-taxydromiki-and-woo"
    "contact-form-lead-export"
    "page-popup"
    "world-property-journal-real-estate-news-free"
    "related-links-inside-content"
    "custom-taxonomies-for-blocks"
    "wpss-cookies"
    "adbirt"
    "motiontactic-seopress-acf-content-finder"
    "biscotti"
    "ideta-livechat-chatbot"
    "dreamfox-helpspot-live-lookup"
    "layoutist"
    "multi-album-video-library"
    "popnotifi"
    "geargag-advanced-shipping-for-woocommerce"
    "movider-sms-notifications"
    "ecomdy-pixel"
    "inovio-payment-gateway"
    "disable-jpeg-image-compression"
    "predikarens-bibelreferenser"
    "affiliate-products-list-by-conicplex"
    "advanced-media-offloader"
    "passwordless-entry"
    "lyrics-by-eminem"
    "tezropay-checkout-for-woocommerce"
    "easy-price-calculator"
    "login-alert-by-e-mail"
    "via-crm-forms"
    "wp-true-copy-protection"
    "wp-webpnative"
    "typofixer"
    "thingstogetme-gift-list-maker"
    "debugly"
    "wp-mobi"
    "wp-search-username"
    "badgeos-restrict-content-pro-integration"
    "simple-recipe"
    "wp-super-form"
    "navthemes-lazy-load"
    "super-simple-social-tags"
    "rewp"
    "simple-menu-order-column"
    "ekiline-block-collection"
    "wp-signals"
    "woodiscontinued"
    "disable-classic-editor-and-widget"
    "no-js-social-sharing"
    "custom-thumbnail-size-on-admin"
    "simple-reading-time"
    "bigradar"
    "javascript-css-accordion"
    "hello-saban"
    "universal-package-systems-shipping-extension"
    "notifications-for-serverchan"
    "imagus"
    "millionchats"
    "relentlosoftware"
    "wpapps-show-post-id"
    "flows"
    "yame-linkinbio"
    "url-shortener-4eq"
    "projects-gallery"
    "nuton-text-share"
    "shipping-method-for-ups-and-wc"
    "sukellos-image-formats"
    "mh-pusher"
    "quick-search-wp-woo-admin"
    "woo-categories-list-in-footer"
    "hide-admin-bar-from-frontend-no-setting-required"
    "sliderx"
    "pomelo-payment-gateway"
    "wp-sightmap"
    "minchu-api-manager"
    "woo-extended-settings"
    "improved-search"
    "scan2pay-alertco-woo"
    "th23-upload"
    "custom-field-tab-for-woocommerce-product"
    "call-center-online"
    "nk-sidebar"
    "mw-team-gallery"
    "my-wp-sitemap"
    "product-faq-for-woocommerce"
    "tipalti-payee-iframe"
    "best-wp-blocks"
    "dynamic-cpr"
    "intelli-tv-video"
    "wp30-sky-bar"
    "ecommerce-smart-survey"
    "wp-gratify-socialproofing"
    "dastyar-wp"
    "beautiful-image-card"
    "skrumpt-lead-form"
    "go-wagon"
    "solace-extra"
    "clocks"
    "taxonomy-pages"
    "nord-sub-news"
    "per-page-headers-and-footers-code"
    "email-trap"
    "dynamic-tracker"
    "semtoo"
    "disable-woocommerce-categories"
    "wp-easy-notices"
    "nonaki-email-template-customizer"
    "url-param-to-cookie"
    "shortener-url-redirect"
    "signal-flags"
    "traking-goals"
    "open-cart-after-add-to-cart"
    "tags-limit-wp-and-woocommerce"
    "seraphconsulting-monitor"
    "onebip-mobile-payment"
    "taxonomy-order-hierarchically"
    "woocompany015"
    "wc-multiple-cart-items-delete"
    "omniship-rates-and-shipping-for-woocommerce"
    "tablacus-maps"
    "polylang-wp-job-manager-companies"
    "wedding-calendar"
    "bc-crowdox-widget"
    "lh-inclusive-private-pages"
    "simple-news-list-and-slider"
    "testimonialx-block"
    "submission-history-contact-form-7-addon"
    "zoom-image-simple-script"
    "woo-domain-coupon"
    "text-order-for-woocommerce"
    "notice-manager"
    "custom-post-type-multiroutes"
    "shop-page-manager-for-woocommerce"
    "ht-request"
    "ahadis-imam-ali"
    "nexweave"
    "search-and-menu-popup"
    "strong-password-maker"
    "wp-tinymce-editor-slider-shortcode"
    "dynamic-coupon-generator"
    "aakron-personalization"
    "ipdata"
    "widget-specific-posts"
    "lodgify-booking-engine"
    "resource-not-found-placeholder"
    "wp-contact-form-shortcode"
    "pomo-uploader"
    "rsg-compiled-libraries"
    "recruitment-manager"
    "recent-posts-markdown"
    "wp-ticket-ultra-recaptcha"
    "user-role-blocker"
    "centangle-team"
    "drag-up-order-post"
    "municipal-boundaries"
    "simple-livetex"
    "eventscout"
    "handy-custom-fields"
    "newspaper-columns"
    "cache-xml-sitemap"
    "disable-block-completely"
    "wp-search-include-meta-fields"
    "wp-iframe-geo-style-for-amazon-affiliates"
    "simple-error-pages"
    "image-seo"
    "hey-jude"
    "adzapier"
    "woo-collecta-payment-gateway"
    "create-temporary-login"
    "nilly"
    "proton-reviews"
    "deiknumi"
    "dark-mode-for-wp"
    "dnwd-feedback"
    "minimal-profile-widget"
    "mama-addons-for-elementor"
    "prodii-presentation-for-teams-and-organisations"
    "wp-clean-head"
    "wp-update-checklist"
    "ads-pixel"
    "simple-scroll-to-top-rubsum"
    "disable-core-lazy-loading"
    "individual-item-description-and-price-for-wp-invoices"
    "wp-super-team"
    "gnu-taler-payment-for-woocommerce"
    "category-listing-hierarchical-order"
    "page-and-post-description"
    "easy-social-shares"
    "site-toolkit"
    "wpminds-growth-blocks"
    "nordic-shipping"
    "show-apache-and-php-version"
    "fa-icons-picker"
    "variation-stock-inventory"
    "kapow-image-recommendation"
    "woo-add-to-cart-notifications"
    "joblister"
    "menuthroughjson"
    "ygvideo"
    "fresh-cookie-bar"
    "category-notices-for-woocommerce"
    "agile-cdn"
    "webfluential-for-woocommerce"
    "import-items-from-csv-to-existing-orders"
    "condition-injection"
    "wp-login-form-with-recaptcha"
    "influenet"
    "html-api-debugger"
    "extras-order-pro"
    "mail-sender"
    "adnkronos-feed-importer"
    "gift-vouchers-for-woocommerce"
    "bd-buttons"
    "so-called-air-quotes"
    "payment-pro-direct-payment-hosted-paypal"
    "reviewmenow"
    "quantity-changer-on-checkout-for-wc"
    "mapplanner"
    "redaction-io"
    "dark-code"
    "all-in-one-ai"
    "wc-improved-guest-checkout"
    "kiss-feedback"
    "pressmodo-onboarding"
    "markdown-display-by-logic-hop"
    "wp-sarahspell"
    "servicio-de-tutopic"
    "woo-phone-field"
    "bp-activity-comment-like-dislike"
    "wp-admin-reviews"
    "draggable-post-order"
    "tishfy-slider"
    "optinmate"
    "orangepay-payment-gateway"
    "newmoji"
    "deau-api"
    "remove-website-field-from-comment-form"
    "devstage"
    "website-screenshots"
    "simple-restrict-content"
    "lm-easy-maps"
    "ninja-countdown"
    "block-conditions"
    "brader-kits"
    "wp-login-admin-redirect"
    "all-in-one-reservation"
    "etd-dynamic-shortcodes"
    "as-blacklist-customer"
    "floatysocial-awesome-social-floating-sidebar"
    "smart-search-stellenanzeigen"
    "mementor-core"
    "emojise"
    "shuuka-social-links"
    "stats-for-wp"
    "add-customer-in-dashboard"
    "woo-basic-wishlist"
    "bfpc-image-cropper"
    "simply-event-blog"
    "ki-twitter-analytics"
    "download-renewals-for-woocommerce"
    "admin-posts-list-tag-filter"
    "product-dropdown-for-contact-form-7"
    "rig-elements"
    "content-protection"
    "rentme-woo"
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

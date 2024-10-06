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
    "my-desktop"
    "digirisk-dashboard"
    "dispongo"
    "wordforce-lead"
    "wpapper"
    "disable-cookbook-ratings"
    "blanked"
    "free-widgets-for-elementor"
    "volunteer-registration"
    "woo-disposable-emails"
    "wp-grid-sorter"
    "jp-download-button-shortcode"
    "trigger-warning-deluxe"
    "webgains-ads-widget"
    "show-user-name"
    "real-voice"
    "order-meta-editor-for-woocommerce"
    "all-in-one-captcha"
    "ashch-scroll-top"
    "query-loop-block-extensions"
    "advanced-video-player-with-analytics"
    "wplms-courseware-migration"
    "superblocks"
    "super-buttons"
    "token2-hardware-tokens"
    "custom-inquiry-form"
    "usetada"
    "taxonomy-meta-ui"
    "shipping-option-conditions-wc"
    "category-posts-shortcode"
    "search-by-post-id"
    "advanced-skins-for-social-media-feather"
    "wp-tax-wysiwyg"
    "um-navigation-menu"
    "admin-pro"
    "top-visited-post"
    "treggo-shipping-for-woocommerce"
    "sitemessages"
    "wp-easy-guide"
    "kiwiz-invoices-certification-pdf-file"
    "botonbanesco-internet-banking-payment-gateway"
    "iksweb-git"
    "gol-ibe-search-form"
    "mail-newsletter"
    "get-different-menus"
    "laiser-tag-insights"
    "pryc-wp-force-protocol-relative-to-uploaded-media"
    "master-ids"
    "millvi-wp"
    "wp-cron-viewer-and-manager"
    "private-password-posts"
    "report-bad-buyers-and-screen-new-ones"
    "bigmarker-action-for-elementor-pro-forms"
    "gratifypay"
    "audio-on-every-block"
    "advanced-media-manager"
    "hls-player"
    "my-links"
    "variation-swatches-and-gallery"
    "wpcom-crosspost"
    "code-view"
    "gofer-seo"
    "code-syntax-highlighter"
    "wp-sequential-page-number"
    "external-link-modifier-easy"
    "basepress-migration-tools"
    "map-store-location"
    "project-guide"
    "sv-media-library"
    "ukrainian-currency"
    "grid-googlemaps-box"
    "wstoolsnl-chat"
    "honnypotter"
    "pre-tag-for-wp-editor"
    "genesis-sermons-cpt"
    "auto-update-cache"
    "scrollbar-supper"
    "nwmc-login-and-support"
    "neeed-dynamic-websites"
    "shipping-method-dropdown-for-woocommerce"
    "wp-inifileload"
    "eventsframe-connector"
    "ot-woocommerce-brands"
    "customers-loyalty-program-points-and-rewards"
    "feature-list-slider"
    "multilingual-import"
    "quote-of-the-day-by-libquotes"
    "meetergo"
    "wp-to-weibo"
    "gp-random-post-widget"
    "wp-image-color-palette"
    "webcam-cima-grappa"
    "parsedown-importer"
    "filtering-post"
    "ultimate-activity-bbpress"
    "wp-taxonomy-tab"
    "role-based-bulk-quantity-pricing"
    "mxp-pchome2wp"
    "lieu-city"
    "wp-amp-website"
    "frontend-file-upload"
    "optimize-youtube-video"
    "jetpack-widget-visibility-additional-fields-query-args"
    "anchor-highlighter"
    "coon-google-maps"
    "mml-booking-calendar"
    "sso-flarum"
    "ranktool"
    "faq-zyrex"
    "azurecurve-theme-switcher"
    "parex-bridge-for-quickbooks-xero"
    "purchase-redirect-for-woocommerce"
    "email-template-customizer-for-woocommerce"
    "pandora-fms-wp"
    "custom-post-type-genarator"
    "fernet-encryption"
    "wp-guifi"
    "simple-columnizer"
    "boot-dashbaord"
    "s3-spaces-sync"
    "tabbed-cats"
    "waj-image"
    "zephr"
    "countdown-timer-event"
    "books-library"
    "last-video-youtube"
    "panthermedia-stock-photo"
    "fahad-hsbc-integration-for-woocommerce"
    "billplz-for-contact-form-7"
    "cookiegenie"
    "acf-post-object-elementor-list-widget"
    "localist-calendar"
    "remove-empty-p-tag"
    "dismiss-update-nag"
    "gh-members-showoff"
    "wp-book"
    "restrict-purchase-with-category"
    "wp-iclew"
    "ticktify"
    "remove-google-captcha-in-divi"
    "spotmap"
    "schedule-revisions"
    "poolito-wc-payment-gateway"
    "logic-shortcodes"
    "woo-product-options"
    "cc-auto-activate-plugins"
    "customizer-user-interface"
    "word-to-html"
    "zij-indeed-jobs"
    "mayuko-footer-tag-manager"
    "simple-content-upload-by-csv"
    "woo-prometheus-metrics"
    "banner-hover-list"
    "multiple-user-post"
    "nx-portfolio-slider"
    "disable-gif-resizing"
    "awesome-footnotes"
    "emergency-alert"
    "sel-church-sermons"
    "wopzen2"
    "content-art-direction"
    "wp-post-html-to-blocks"
    "sms-for-woo"
    "tracking-code-manager-google-analytics"
    "previewoneditor"
    "woo-globkurier-shipping-method"
    "remote-post-manager"
    "photoroulette"
    "form-for-contact"
    "planleft-contact-camo"
    "demowolf-video-tutorial-importer"
    "gf-add-on-salesforce"
    "random-happiness"
    "stormpath"
    "postpone"
    "trove"
    "add-customizer"
    "ads-into-post"
    "inbox-forms"
    "order-approval-for-wcfm"
    "icarry-in-shipping-tracking"
    "userguiding"
    "age-restriction-18-for-checkout-fields"
    "list-latest-tagged-posts"
    "paris-attacks-mc"
    "teamlinkt-sports-league-club-and-association-manager"
    "quick-links-woocommerce"
    "rest-importer"
    "camptix-automatic-gravatar-fetch-and-export"
    "social-tools"
    "ty-gia-ngoai-te"
    "gna-crawling-errors"
    "wysiwyg-comments-trix"
    "parcello"
    "notification-woocommerce"
    "open-links-in-sl"
    "webeki-basketball-widgets-basketball-results-rankings"
    "sewn-in-post-delete"
    "postical"
    "bonjour"
    "ip-login"
    "c4d-woo-filter"
    "inspect-block-data"
    "photoframes-and-art-for-woocommerce"
    "single-product-total"
    "fancy-roller-scroller"
    "mc-protected-page-upgrade"
    "sky-systemz"
    "instant-payment-receipts-in-woocommerce-for-bacs"
    "simple-accessible-forms"
    "wp-slim-gallery"
    "pixer-necessary-addons-for-elementor"
    "no-cc-attack"
    "smart-addons-for-elementor"
    "service-tracker-stolmc"
    "arlen-woo-freecharge"
    "simple-like-dislike-posts"
    "om-dusupay-gateway-woocommerce"
    "social-buttons-floating-share-me"
    "wprs-data-transporter"
    "covid-19-live-updates"
    "table-data-wp"
    "sync-ac-with-wp"
    "grumft-amp"
    "sticky-images-for-elementor"
    "remove-post-type-slug"
    "view-published"
    "mmr-disable-for-divi"
    "1crm-customer-connection"
    "fast-gallery-lite"
    "smart-arrow-shortcodes"
    "tielogremover"
    "nofollow-doctor-wp"
    "yabe-kokoro"
    "easy-syntax-highlighter"
    "liquidpoll-funnelkit-integration"
    "rundizable-wp-features"
    "woo-simple-payment-discounts"
    "cf7-thank-you-page"
    "taxonomy-tree-toggler"
    "postage-tracking-code-sms"
    "goodbye-block-editor"
    "mortgage-calculator-free"
    "newest-replies-first-in-bbpress"
    "wp-get-keywords"
    "just-headline"
    "roadmap-wp"
    "woo-shop-front-customizer"
    "frontend-posts"
    "ez-and-simple-google-map"
    "feuerball3d-360deg-animations"
    "computy-view-percent"
    "translate-gravity-forms-x-polylang"
    "careersitespro"
    "better-category-selector-for-woocommerce"
    "easy-back-to-top"
    "purchase-orders-for-catablog"
    "wp-custom-menu"
    "elderlawanswers-content-terminal"
    "doubledome-resource-link-library"
    "iz-block-editor-tooltips"
    "dive-sites-manager"
    "wp-google-maps-integration"
    "wp-audit"
    "woo-price-updater"
    "rename-post-labels-by-wowdevshop"
    "posts-maps"
    "floating-form-button"
    "flixy-review-product-boxes-for-affiliate-pages"
    "client-logo-carousel"
    "causality"
    "rahrayan-wp-sms"
    "widget-social-share"
    "interactive-table"
    "wp-rest-api-helper"
    "server-response"
    "bulk-edit-for-learndash"
    "schedule-builder-online"
    "wc-basic-slider"
    "chatpress-ai"
    "ziggeo-video-for-job-manager"
    "smartservices-chimp-mail-list-by-woo-product"
    "vietnamese-clean-url"
    "gist-button"
    "editor-profile"
    "cvshout-resume"
    "how-to-wp"
    "carbon-icons"
    "download-magnet"
    "bizaopay-for-woocommerce"
    "day-counter"
    "veritaspay-hosted-checkout"
    "masoffer-dynamic-link"
    "richlist-widget"
    "cubecolour-caboodle"
    "wp-login-register-flow"
    "seznam-doporucuje-rss"
    "appconsent-cmp-sfbx"
    "future-monitor"
    "wp-gist-embed"
    "give-me-answer-lite"
    "wp-twitter-cards-shop"
    "zerowp-oneclick-presets"
    "azurecurve-timelines"
    "wegetfinancing-payment-gateway"
    "quick-floor-planner"
    "disable-default-lazy-loading"
    "kaleidoscope-playlist"
    "alexa-siralamasi"
    "attachment-url-version"
    "tomi-page-tagging"
    "wp-content-personalization"
    "wg-live-chat"
    "chess"
    "newsletter-for-contact-form-7"
    "woo-genie-checking"
    "fetch-some-tweets"
    "automatic-wp-posts-summarizer"
    "interactive-map-of-new-york"
    "sparkloop"
    "best-seller-for-woocommerce"
    "easy-subscribe"
    "tutsup-simple-modal"
    "wpp-easy-child-generator"
    "couponfun"
    "edd-recent-downloads"
    "ultimate-testimonials"
    "flush-opcache-with-varnish"
    "spruce-api-extension"
    "content-attachments"
    "pretix-widget"
    "live-auto-refresh"
    "wp-auto-alt-image-tag"
    "auto-deselect-uncategorized"
    "insert-text-symbols"
    "olycash-for-woocommerce"
    "docs-to-wp-pro"
    "be-shortcodes"
    "3d-webviewer-by-arty"
    "genesis-email-headers"
    "wp-html-imports-helper"
    "talkify-text-to-speech"
    "wp-aiwis"
    "responsive-bold-navigation"
    "verified-pay-credit-card-payments"
    "meta-ranker"
    "reoon-email-verifier"
    "easy-elements-hider"
    "emarketplaceservices-live-shipping-rate"
    "at-wp-require-login"
    "simply-auto-seo"
    "edd-steem"
    "hero-posts-lite"
    "measuresquare-calculator-widget-for-floors"
    "wp-show-id-list"
    "prakiraan-cuaca"
    "birttu-medios"
    "nirror"
    "taknod"
    "request-a-quote-for-woocommerce"
    "queensberry-workspace-blog-interface"
    "typhoon-slider"
    "woocommerce-ksini-com-item-cost"
    "uni-custom-logo-link-changer"
    "wp-count-down-timer"
    "freshworks-forms"
    "post-type-archive-pages-and-permalink-settings"
    "easy-flexslider"
    "edd-paypal-payment"
    "distributionlist"
    "simple-post-manager"
    "wpbackupessentials"
    "child-pages-tabs"
    "onhover-link-preview"
    "wp-keyword-finder"
    "ivendpay-payments"
    "codefence-io"
    "vk-plugin-beta-tester"
    "pilllz-avatars"
    "hookie-woocommerce"
    "google-plus-name-link-popup-badge"
    "customize-search-results-order"
    "multilingual-polylang"
    "advanced-angular-contact-form"
    "sync-dukan"
    "delete-old-comments"
    "simple-mortgage-calculator"
    "smartaipress"
    "new-users-monitor"
    "wp-timeliner"
    "winsome-nice-scrollbar"
    "fancy-github-activity"
    "allinpayintl"
    "sadad-payment"
    "batch-translate-independently"
    "instant-google-analytics"
    "authors-as-taxonomy"
    "comment-form-tinymce"
    "bootstrap-carousel-rg"
    "lcs-image-nolink"
    "control-post-modified-date"
    "search-cloud-one"
    "ape-auto-popup-expiry"
    "nigerian-naira-for-gravity-forms"
    "tfl-widgets"
    "wp-magnific-lightbox"
    "cron-staticpress"
    "apoyl-qiniukodo"
    "simple-editorial-guidelines"
    "ss-posts-by-category"
    "page-modified"
    "edd-version"
    "discount-rules-by-napps"
    "indexhibit2-importer"
    "copy-permalink-to-clipboard"
    "st-demo-importer"
    "mail-control"
    "easymap"
    "reviewstap"
    "insert-shortcode-pattern"
    "mobalize-online-appointment-bookings"
    "hagakure"
    "control-v"
    "kopa-xmax-toolkit"
    "push-notification-worldshaking"
    "web-disrupt-wp-assistant"
    "wp-link-to-playlist-item"
    "uvisualize"
    "naveed-post-types"
    "mailvat"
    "draft-concluder"
    "nowon"
    "run-my-accounts-for-woocommerce"
    "media-defaults"
    "multi-level-menu-for-ecwid"
    "tuna-payments-para-woo"
    "bp-delegated-xprofile"
    "pb-star-rating-block"
    "user-generator"
    "simplify-firstname-as-nickname-for-buddyboss"
    "vejret-widget"
    "european-school-radio-widget"
    "remove-checkout-fields"
    "atec-dir-scan"
    "remove-invalid-menu-items"
    "robust-user-search"
    "gna-woo-coupons"
    "saaspass-two-factor-authentication-2fa"
    "form-print-pay"
    "hotel-spider"
    "playable-video"
    "bulk-sort-attributes-for-woocommerce"
    "create-flipbook-from-pdf"
    "cookie-meddelande"
    "payment-addons-for-woocommerce"
    "set-a-time-appointment-scheduling"
    "wc-securionpay"
    "kontrolwp"
    "automizy-lead-generation"
    "dresslikeme"
    "remove-login-shake"
    "kmo-slideshow"
    "dobsondev-weather"
    "geo-hcard-map"
    "lightbox-pdf-viewer-by-csomor"
    "wplg-default-mail-from"
    "juicenet-gdpr"
    "mytracker"
    "quick-preloader"
    "userbot-chat"
    "whitelabel-wp-setup"
    "wp-novo-tempo"
    "personal-library"
    "wp-video-baker"
    "basketin"
    "acf-field-name-copier"
    "embed-react-build"
    "i-divi-advanced-audio"
    "advanced-multiple-image-upload"
    "run-route"
    "galdget"
    "geeky-bot"
    "page-template-column"
    "css-to-footer"
    "fields-and-file-upload"
    "mfloormap"
    "custom-thank-you-for-woo"
    "heartland-management-terminal"
    "maldita-inflacion"
    "wp-save-hijack"
    "drop-down-cities-for-woocommerce"
    "easy-affiliate-products"
    "simple-cyclos-leaflet-map"
    "tdt-lazyload"
    "hints"
    "sagepay-direct-gateway-for-easy-digital-downloads"
    "gym-master-components"
    "quarantinewp"
    "browsers-need-to-be-updated"
    "wp-videodesk"
    "freezy-stripe"
    "popup-shraddha"
    "wp-jade-template"
    "save-single-file"
    "c4d-woo-grid-product"
    "crypto-cart-lite-by-wprobo"
    "acs-advanced-search"
    "nofollow-jquery-links"
    "chroma-google-analytics"
    "yacp"
    "ss-uikit"
    "db-mailchimp-api"
    "embed-can-i-use"
    "prev-next-meta-header"
    "ajax-comment-form-cst"
    "taxonomies-essentials"
    "uk-portfolio"
    "woo-links-to-product"
    "orion-data-merge"
    "demo-content-for-blocks"
    "expanding-widgets"
    "hw-override-default-sender"
    "coming-soon-page-splashpage-max"
    "ff-posts-pages-and-cpt-field-type"
    "wp-kuchikomi"
    "hhd-flatsome-vertical-menu"
    "show-weather-get-msn-com"
    "restrict-content-pro-getresponse"
    "foodspace-recipe"
    "allowed-routes"
    "iweblab-hosting-manager"
    "trash-fail-safe"
    "ue-tracker-utm-track-and-analyze-leads-for-elementor"
    "references-for-wikidata"
    "slithy-web"
    "tag-counter"
    "ifelsend-go-top"
    "cc-list-posts"
    "share-decentral"
    "yasothon-blocks"
    "fix-missing-app-id"
    "universal-wp-lead-tracking"
    "gtmpluswp"
    "auto-bulb-finder-for-wp-wc"
    "header-footer-with-elementor"
    "wp-head-footer"
    "disable-wp-auto-formatting"
    "adtoniq-express"
    "mmm-fancy-captcha"
    "offerte-internet"
    "gntt-post-title-ticker"
    "wp-flickr-images"
    "tablecloth"
    "mpress"
    "taro-series"
    "supportai"
    "woocommerce-title-split-test"
    "easywebsite-custom-welcome-message"
    "ferret"
    "goqmieruca"
    "add-stripe-payments-for-contact-form-7"
    "next-step-for-learndash"
    "patterns"
    "number-to-bangla"
    "grit-taxonomy-filter"
    "dx-webp-picture-tag-image-wrapper"
    "sms8-io"
    "dental-education-videos"
    "stardate"
    "turkish-lottery"
    "tm-islamic-helper"
    "listings-for-buildium"
    "kpi-integration"
    "nonprofit-board-management-files"
    "reckoning"
    "saffire-frequently-bought-together-learndash"
    "seedx-video-gallery-for-woocommerce"
    "360crest-themeone-tinymce-shortcodes"
    "advanced-dashboard-cleaner"
    "random-look"
    "hipaa-gauge"
    "wc-show-tax"
    "brozzme-change-username"
    "extend-co-authors-plus-for-facetwp"
    "customtables"
    "seznam-fulltext"
    "awesome-addons"
    "fluid"
    "opal-social-login"
    "liverecover-woocommerce"
    "xdebug-output-handler"
    "iq-posting-lite"
    "simple-site-rating"
    "sidebars-blocks"
    "bcc-all-emails"
    "autocomplete-google-places"
    "driveworks-shortcode-form-embed"
    "utm-generator"
    "visual-authors-page"
    "lh-prefetch-and-render"
    "elemenda"
    "all-in-one-wp-preloader"
    "insight-metrics"
    "acclaim-cloud-platform"
    "disable-plugin-update-emails"
    "cocoonnoticeareascheduler"
    "remove-spam-links"
    "rwc-team-members"
    "mseurorates-lite"
    "woo-delivery-rider-management"
    "greymode"
    "adforum-oembed"
    "unload-by-st-pagede"
    "files-fence"
    "restrict-file-access"
    "assign-staff-as-author-for-total"
    "del-post-rev"
    "youtube-dev-facile"
    "inqwise-shortcode"
    "bp-user-information"
    "site-name-for-google-search"
    "dashy"
    "orimon-chatbot"
    "hide-uncategorized-from-category-sidebar-widget"
    "myd-delivery-integration-sumup"
    "server-host-name"
    "entity-viewer"
    "font-resizer-with-post-reading-time"
    "payon-paymentgateway"
    "shop-extra"
    "multiple-content-types"
    "hmh-footer-builder-for-elementor"
    "link-qr-code"
    "actus-xfields"
    "lcmd-tracking-codes"
    "fast-getresponse"
    "softech-wp-clock"
    "krakenfiles-com-audio-player"
    "associatebox-for-amazon"
    "remember-cf7-entries"
    "ot-testimonial-widget"
    "ux-tracker"
    "wolfeo-pushy"
    "pywebdev-autotag"
    "rss-feed-link-to-post"
    "azurecurve-shortcodes-in-comments"
    "bangla-converter"
    "import-wizard-blogspot"
    "summary-and-details"
    "simple-loan-mortgage-calculator"
    "json-post-type"
    "micrometrics"
    "lh-favicon"
    "woo-opay-payment"
    "blaze-css"
    "anura-io"
    "payzah-payment-gateway-for-woocmmerce"
    "custom-glotpress-source"
    "qqworld-woocommerce-assistant-lite"
    "offline-updater"
    "ip-blocker-wp"
    "complete-twitter-solution"
    "mowomo-google-reviews"
    "edit-image-thumbnails-separately"
    "returnless-api"
    "registration-form-for-woocommerce"
    "zibal-payment-learnpress"
    "content-hubs"
    "post-title-furigana"
    "wp-conference"
    "amazing-portfolio"
    "reset-the-net-splash-screen"
    "order-coupon-field-for-woocommerce"
    "paylolly-payment-gateway-addon"
    "utopia70cart-scheduling"
    "lh-css-dates-and-times"
    "load-web-components"
    "embed-page-facebook"
    "nias-course"
    "advance-importer"
    "instant-search"
    "safe-cookies"
    "hcgroup-shipping-for-woocommerce"
    "wp-vbulletin-sso"
    "wp-scap"
    "cutzy-url-shortener"
    "gallery-from-regex-matches"
    "ddt-tracking"
    "insert-reference"
    "bannerbear"
    "yagla"
    "gf-total-amount-shortcode"
    "hls-crm-form-shortcode"
    "securepay-for-paidmembershipspro"
    "jeba-wp-preloader"
    "istokmedia"
    "fruitware-woocommerce-oplatamd"
    "pmr-google-social-profiles-in-search-results"
    "dental-focus"
    "auto-coupon-for-woocommerce"
    "custom-waimao-welcome-dashboard"
    "whole-cart-enquiry"
    "smart-gallery-dbgt"
    "artesans-search-redirect"
    "dxtag-auto-listings"
    "cc-deploy"
    "scrollr"
    "comparison-table-elementor"
    "machool-for-woocommerce"
    "express-pay-card"
    "ez-coming-soon"
    "enable-shortcodes-in-widgets-by-mstoic"
    "slickpay-payment-gateway"
    "nettle-pay"
    "super-share"
    "social-share-by-asphalt-themes"
    "dynamic-plugins"
    "modal-terminos-y-condiciones"
    "skynet-malaysia"
    "stop-war-stop-putin"
    "schedule-tags"
    "mhm-lazyloadvideo"
    "ethereum-donation"
    "orderforms"
    "ai-text-enhancer"
    "awp-placeholder-variable"
    "wp-posts-password-batch-manager"
    "wc-ticket-manager"
    "simple-csv-importer"
    "hq60-fidelity-card"
    "smartarget-line-chat-contact-us"
    "controllercons"
    "relative-links-for-content"
    "sales-countdown-for-woocommerce"
    "sowprog-events"
    "benchmark-hero-quick-site-audit-for-your-ecommerce"
    "spacento"
    "simple-custom-login-page"
    "heat-chatfuel-integration"
    "trs-sales-count-down"
    "embedai"
    "log-in-out"
    "the-void"
    "default-media-view"
    "variable-product-swatches"
    "simple-urls-legacy"
    "my-country-states-for-woocommerce"
    "yapsody-events-calendar"
    "preview-everywhere"
    "glavpunkt"
    "gf-dynamic-fields"
    "womoplus"
    "apoyl-keywordseo"
    "new-order-popup"
    "ascend-marketing-tools"
    "jurassic-login"
    "gnupay-lguplus"
    "kill-em-all"
    "smart-recent-comments"
    "just-related"
    "generate-amazon-contacts"
    "ajax-message"
    "persian-fake-contents"
    "post-half-life"
    "neox-payments-for-woocommerce"
    "my-maps"
    "post-generator-from-idml"
    "quote-of-the-day-tellmequotes"
    "access-fotoweb-media"
    "html5-youtube-player"
    "sirportly-forms"
    "fg-testimonials"
    "optimizer-shortcodes-phone-number"
    "wc-payu-payment-gateway"
    "woo-gateway-mc2p"
    "wp-tuning"
    "pos-virtual"
    "kaira-site-chat"
    "wp-custom-post-type"
    "dadevarzan-wp-course"
    "variations-select-menu-for-woocommerce"
    "media-used-search"
    "youtube-video-recording"
    "wc-tabs-and-custom-fields"
    "aitosocial"
    "easy-pricing-table-wp"
    "simple-coherent-form"
    "wp-advanced-posts-widget"
    "acf-flexible-content-layout-thumbnail"
    "seon-fraud"
    "scrapme-advance-contact-form"
    "amazing-search"
    "all-in-one-metadata"
    "rbs-remote-dashboard-welcome-control"
    "post-url-redirect"
    "simply-documents"
    "stomt-instant-feedback-button"
    "rss-feed-canceller"
    "set-wp-email-headers"
    "wp-anchor-tab"
    "pollfish-for-wp"
    "bf-wpo-dequeuer"
    "web3-wallet-login"
    "protect-my-content"
    "plain-social-sharing-buttons"
    "easy-resources-page"
    "wptd-image-compare"
    "data-subject-access-request-form-dsar-sar-ccpa-seers"
    "backup-extension"
    "fleeps"
    "vistawp"
    "crush-counter-discordapp"
    "bp-default-user-notifications"
    "ic-importer"
    "block-layouts"
    "meta-tags-io-generator"
    "emailsystem"
    "ad-builder-for-adrotate"
    "custom-posttype-listing-block"
    "gdpr-cookie-banner"
    "paykassa"
    "pud-generator"
    "monthly-data-sheets"
    "post-updated-messages"
    "crisp-slider"
    "easy-referral-for-woocommerce"
    "phoenix-folding-at-home-stats"
    "wp-github-buttons"
    "lcb-portfolio"
    "easy-modules"
    "block-new-admin"
    "storerocket-store-locator"
    "wp-author-box"
    "real-archive-and-category"
    "simple-filterable-portfolio"
    "woo-product-design"
    "dadevarzan-wp-recipe"
    "brocardi"
    "disc-golf-metrix"
    "fifthestate"
    "koddostu-panel"
    "analytics-tracking"
    "getinchat"
    "talash"
    "monitor-login"
    "verifyne"
    "lianaautomation-sitetracking"
    "double-slash-domains"
    "go-to-post-id"
    "soundst-hidden-text"
    "wiasano"
    "s2-extensions"
    "c4d-category-image"
    "dragcheck-admin-rows"
    "my-simple-feedback"
    "disable-permanently-rest-api"
    "plugin-notes-label"
    "cm-fipe"
    "simple-xml-rpc-disabler"
    "pieeye-gdpr-cpra-cookie-consent-dsr"
    "chartsbeds"
    "eloquent"
    "lh-personalised-content"
    "add-tag-to-woocommerce-products"
    "eorzea-time"
    "trainingpress"
    "superdocs"
    "hide-gtm-code"
    "display-stock-status-for-woocommerce"
    "bears-woocommerce-product-quick-view"
    "no-login-user-enumeration"
    "imod-social"
    "sws-responsive-sliders"
    "eduadmin-analytics"
    "fixed-bar"
    "fan-page"
    "measuring-ruler"
    "mindspun-responsive-blocks"
    "mythic-smooth-scroll"
    "ultimate-image-hover-effects-css3-photo-gallery-pro"
    "simple-bible-verse-via-shortcode"
    "simple-product-type-only"
    "terror-alert-level-widget"
    "nextpage-link"
    "sentence-to-seo"
    "wp-skype-live-chat"
    "token-field-for-advanced-custom-fields"
    "pikkolo"
    "zu-contact"
    "coming-soon-counter-page-maintenance-mode-lacoming-soon"
    "wysiwyg-calculator-block"
    "page-detector"
    "companies-house-integrator"
    "bp-xml-sitemap-generator-by-shift1"
    "b2binpay-payments-for-woocommerce"
    "lytex-pagamentos"
    "hello-stranger-things"
    "wp-mailinglijst"
    "sprojectprogress"
    "spoken-search"
    "easy-inputs"
    "cool-media-filter"
    "customize-editor-control"
    "hide-out-of-stock-by-category"
    "payex-woocommerce-payments"
    "sortable-dashboard-to-do-list"
    "gbi-to-print"
    "sas-web-ads-banner-video"
    "onlineafspraken-wordpress-plugin"
    "sbs-oembed-service"
    "app-banner"
    "c9-variables"
    "sparkle-2co-digital-payment-lite"
    "fast-blocks"
    "random-image-light-box"
    "shortcode-anywhere-for-contact-form-7"
    "hydravid-content"
    "my-restaurant-reviews"
    "sky-remove-attached-files-and-featured-images-automatically"
    "font-blokk-integration"
    "asemt-leadform-hook"
    "collect-reviews"
    "highlight-search-terms-results"
    "teamshowcase"
    "wp-github-sync-meta"
    "custom-post-styles"
    "testimonial-king-light"
    "admin-sticky-notes"
    "progressive-images"
    "move-wc-category-description-below-products"
    "hotspot-addon-for-elementor"
    "katisoft"
    "whois-xml-api-whois"
    "cf7-woocommerce-memberships"
    "urwa-for-woocommerce"
    "easy-sitemap-page"
    "build-a-house"
    "woo-racoon"
    "yandexid"
    "accessibility-widget-by-adally"
    "acf-flexible-content-layout-previews"
    "embedded-posts"
    "cf-preview-fix"
    "simply-featured-video"
    "bpwp-set-homepages"
    "ai24-assistant-integrator"
    "pdf-for-woocommerce"
    "simple-mailchimp"
    "ref-code-generator-access-gate"
    "web-push-notification"
    "orbisius-support-tickets"
    "remove-emoji-styles-scripts"
    "feesable-fee-calculator"
    "capital-s-dangit"
    "local-navigation"
    "templates-add-on-woo-onepage"
    "easy-slidebox"
    "custom-thank-you-page-for-woocommerce-product"
    "wanapost-several-social-sharing"
    "bc-advance-search"
    "quick-save"
    "ezfunnels"
    "fs-testimonials"
    "wp-cedexis"
    "karrya-field-service-management-system"
    "aopush"
    "yasp"
    "simplest-contact-form"
    "job-listings-package"
    "azores-gov-banner"
    "advanced-theme-search"
    "control-panel-for-soundcloud"
    "user-roles"
    "fence-url"
    "homey"
    "pcf-thanksgiving-countdown"
    "hdtasks"
    "imagebrico"
    "business-matchup"
    "campaign-archive-block-for-mailchimp"
    "elvez-edit-powered-by"
    "pagemagic-page-lists"
    "quran-in-text-and-audio"
    "tiny-search-logger"
    "easynewsletter"
    "fizen-pay-woocommerce"
    "azurecurve-get-plugin-info"
    "product-tab-manager"
    "mondiad"
    "master-kit"
    "wp-html5-outliner"
    "nudge-publisher"
    "zidithemes-jumbotron-block"
    "speedly"
    "loystar-woocommerce-loyalty-program"
    "ve-ads-manager"
    "api-fetch-twitter"
    "easy-tube"
    "aweos-admin-login"
    "wp-direct-login-link"
    "qos-payment-gateway"
    "plugin-sample-shortcode"
    "rexadz-monetization"
    "taylors-debug-toggle"
    "card-elements-for-beaver-builder"
    "synchronize-wechat"
    "cubit-calculator"
    "wc-coupon-restriction-for-backorder"
    "rebrand-fluent-forms"
    "rentalbuddy-car-rental-management"
    "wp-fpo"
    "breezetactfreemium"
    "show-media-widget-pdf-support"
    "horizontal-slider-for-your-tweets"
    "jibber-chat"
    "customizeme"
    "simplepay"
    "goodlayers-blocks"
    "wc-qpay-gateway"
    "lm-cf7-lead-manager-addon"
    "flyout-menu-awesome"
    "wp-easy-mail-smtp"
    "wp-code-pre"
    "navigation-toggle-4-divi"
    "lite-google-map"
    "contact-ajax-form"
    "notification-sms"
    "np-posts-bulk-actions"
    "set-corporate-paygateglobal"
    "quote-calculator-constructor"
    "streamsend-sign-up-form"
    "xkcd-embed"
    "exec-external-links"
    "partybook-widget"
    "maaq-website-manager"
    "quick-learn"
    "wc-dynamic-payment-gateways-tcs"
    "efrontpro"
    "sheerid-for-woocommerce"
    "tz-zoomifywp-free"
    "aritize-3d"
    "canvas-portfolio"
    "tz-guard"
    "openpublishing"
    "wpcontactus"
    "sipexa-flow"
    "counterespionage-firewall"
    "author-bio-ultimate"
    "live-agent-call"
    "athena-search"
    "single-post-export"
    "thrive-esig-gen"
    "wordlift-add-on-for-wp-all-import"
    "developer-project-portfolio"
    "marque-blanche-negoannonces"
    "woo-shop-opening-hours"
    "wappoint-payment-gateway"
    "admin-bar-manager"
    "woo-service-plan"
    "adop-amp"
    "zestatix"
    "wp-envybox"
    "helloleads-cf7-form"
    "zip-jp-postalcode-address-search"
    "contentbox"
    "app-service-assistant"
    "app-service-info-for-azure"
    "wp-bongabdo-date"
    "bouncehelp"
    "plainmail"
    "dark-mode-block"
    "simison-wikimedia-commons-potd-wp-login"
    "rd-fontawesome"
    "wp-polr"
    "autocomplete-post-search-dashboard"
    "glindr"
    "loginizr"
    "edd-enhanced-ecommerce"
    "omni-contact-form"
    "world-city-events-ixyt"
    "fantastic-restaurant-menu"
    "elog"
    "logic-hop-personalization-for-gravity-forms-add-on"
    "custom-field-search"
    "shabat-clock"
    "import-current-rms"
    "boostools"
    "self-made-store"
    "force-to-terms-conditions"
    "fortrader-informers"
    "mobpress"
    "wp-fix-search-function-search-only-pages"
    "jmitch-tinylytics"
    "exifwidget"
    "lazyload-preload-and-more"
    "fast-etsy-listings"
    "tracking-for-fedex-usps"
    "super-simple-tracking-codes"
    "bp-pinned-feed-notices"
    "wp-black-ribbon"
    "tk-bbpress-stats"
    "lh-fresh-content"
    "hotel-booking-by-xfor"
    "bring4you"
    "sw-contact-form"
    "wp-oauth-integration"
    "embed-animatron"
    "r3df-copyright-message"
    "wp-click-to-call-calledin"
    "coupon-helper-for-woocommerce"
    "gf-auto-populate-country-state-city-ward-dropdown-addon"
    "show-temperature-for-switchbot-meter"
    "nmi-payment-gateway-for-woocommerce"
    "cev-addons-for-woocommerce"
    "kumihimo"
    "easy-options-empty-cart-per-product-wc"
    "zibal-payment-gateway-for-contact-form7"
    "mo-rss-feed"
    "em-social-media"
    "lemonwhale-video"
    "trail-status"
    "sponsorship-disclaimer"
    "cf7-mailgun-domain-validation"
    "find-tweets"
    "mapple"
    "theme-wing"
    "theme-canary-demo-import"
    "plugin-bundles"
    "write-time"
    "wp-news-desk-dashboard-feed"
    "streamio"
    "sponsered-link"
    "anxious-client-shield"
    "enquiry-for-website"
    "developer-tool"
    "wpc-external-variations"
    "ai-mortgage-calculator"
    "notify-woosms"
    "featured-background-image-free"
    "knr-player"
    "automatic-translate-slug"
    "c4d-woo-category-carousel"
    "3pay-co-payment-gateway-for-woocommerce"
    "dynamic-cta"
    "remove-core-editor-google-font"
    "medicare-quote-widget"
    "automated-dhl-parcel-shipping-labels"
    "cf7-jlocator"
    "bollettino-neve-asiago-it"
    "signature-field-with-contact-form-7"
    "anhlinh-call-button"
    "wp-meetfox"
    "onedesk"
    "add-html-javascript-and-css-to-head"
    "treggo-shipping"
    "set-featured-attachment"
    "wowpi-guild"
    "psalm-119"
    "wp-fast-search"
    "full-post-teaser"
    "sky-seo"
    "taf-widget"
    "newer-tag-cloud"
    "easy-content-lists"
    "wc-sendy"
    "fast-activecampaign"
    "wp-rwd-capture"
    "wedn"
    "serp-tool"
    "slurv-sync"
    "sc-to-top"
    "custom-tabs-shortcodes"
    "auto-scheduling"
    "css-chat-button"
    "simplest-under-construction"
    "houzez-respacio-import"
    "business-model-canvas"
    "wp-steps"
    "crsms-contact-form-7-sms-notification"
    "slug-translator"
    "nossl-protect-your-website"
    "iq-inhead-analytics"
    "bg-btime"
    "discount-patreon-connect"
    "voucherme-for-woocommerce"
    "awp-booking-calendar"
    "ecomail-elementor-form-integration"
    "no-format-shortcode"
    "cinema-catalog"
    "email-media-import"
    "filter-for-jetpack-site-stats"
    "content-permissions-for-pages-posts"
    "standard-deviation-calculator"
    "chatbot-for-easy-digital-downloads"
    "check-permission-dialogue"
    "twp-email"
    "advanced-rating-block"
    "isee-products-extractor"
    "nhrrob-hide-admin-notice"
    "wpum-newsletter"
    "wadmwidget"
    "autocompletamento-indirizzo-contact-form-7"
    "user-product-count-woocommerce"
    "simplified-content"
    "woo-additional-fee"
    "caleb-contact-form"
    "export-stripe-csv"
    "remove-wp-admin-bar"
    "gosign-multi-position-text-with-quote-block"
    "acf-pro-show-fields-shortcode"
    "advanced-sidebar-nav"
    "firmao-callback"
    "4cgandhi"
    "social-icons-by-demoify"
    "islamic-duood-sharief"
    "dezo-tools"
    "mp-customize-login-page"
    "beecommerce-free-product"
    "dpt-dbadmin"
    "blacklist-whitelist-domains"
    "figpii"
    "puredevs-any-meta-inspector"
    "remove-olympus-digital-camera-from-caption-and-title-by-image-upload"
    "meu-astro-horoscopo"
    "wp-support-by-theitoons"
    "coastal-factoid"
    "sx-easy-going-smtp"
    "abyssale"
    "tyxo-monitoring"
    "wc-ozow-gateway"
    "reviews-tutor-lms"
    "wp-geo-search"
    "dynamic-shortcode"
    "motiforms"
    "monetate"
    "reposidget-for-coding"
    "alumnionline-reunion-website"
    "voicexpress"
    "wc-show-orders-shortcode"
    "quicker"
    "socialmedia-gallery"
    "daily-quotes-kural"
    "msit-corona-virus-live-update-widgets"
    "simple-job-manager"
    "wooaddons-for-elementor"
    "wp-custom-data"
    "world-clock-with-drop-down-shortcodes"
    "gntt-timezone-clock"
    "aesirx-analytics"
    "simple-adblock-redirect"
    "rexpay-payment-gateway"
    "monetize-me"
    "blogpatcher-seo"
    "wc-uni5pay-payment-gateway"
    "product-cost-price"
    "disco"
    "events-manager-booking-payments-with-woocommerce"
    "nucuta-password-protect"
    "explara-membership"
    "dmo-spacer-gif-generator"
    "ltl-freight-quotes-tql-edition"
    "smoove-elementor"
    "academy-divi-modules"
    "temporary-access"
    "apicheck-contact-form"
    "pd-helper"
    "business-schema-json-ld"
    "custom-posts-for-product"
    "woo-mensagia"
    "article-read-time-lite"
    "selectable-post-and-page"
    "hover-effects-bundle-visual-composer-addon"
    "hidden-content-post"
    "wptimhbw-tools"
    "shop-metrics-report"
    "advanced-plugin-search"
    "amazing-related-post"
    "simple-multi-currency-for-woocommerce"
    "overengineer-gasp"
    "planyo-woocommerce-integration"
    "sync-remote-images"
    "right-click-menu-hayati-kodla"
    "oewa"
    "rcp-disable-subscription-upgrades"
    "eas-sitemap-generator"
    "stay-home-stay-safe-notice"
    "wp-one-tap-google-sign-in"
    "epitome-gallery"
    "event-master"
    "posts-2-posts-relationships"
    "partner-manager"
    "mediahawk-call-tracking"
    "wp-query-engine"
    "json-api-delete-user"
    "vamwp"
    "eino-tuominens-google-maps"
    "savodxon"
    "wpblocks"
    "gtm-code-visibility"
    "valuepay-for-woocommerce"
    "integration-allegro-woocommerce"
    "affilio-integration"
    "personalbridge"
    "interval-stock-price-refresher"
    "non-cache-ppp"
    "mam-image-and-video-accordion"
    "kalimah-dashboard"
    "viking-bookings"
    "wp-admin-menu-wizard"
    "imagecare"
    "harrix-markdownfile"
    "display-music"
    "simple-child-theme-creator"
    "annoto"
    "comapi-webchat"
    "pryc-wp-users-id"
    "connect-badgeos-to-discord"
    "pinq-inquiry-management-solution"
    "tracksend-for-woocommerce"
    "utm-for-woocommerce"
    "donation-forms-by-givecloud"
    "gloria-assistant-by-webtronic-labs"
    "category-collapser-seo-for-woocommerce"
    "searchable-accordion"
    "user-block-visibility"
    "interactive-longform-articles"
    "zenpost"
    "wplms-academy-migration"
    "rumailer"
    "socialproofus"
    "taxonomy-extra-fields"
    "ttt-loadmore"
    "password-confirm-action"
    "charge-anywhere-payment-gateway-for-woocommerce"
    "text-messaging-and-lead-collection-pro"
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

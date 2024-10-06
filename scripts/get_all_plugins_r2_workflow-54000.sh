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
    "easy-theme-plugin-switcher"
    "default-featured-image-themed"
    "recover-fees-for-gravity-forms"
    "fleetgo-bijtelling-calculator"
    "traveler-payhere"
    "tabs-for-woocommerce"
    "mezar-quick-view"
    "easy-addons"
    "multisite-plugin-controller"
    "shared-vision"
    "email-attachment-by-order-status-products"
    "custom-help"
    "syno-author-bio"
    "automated-emails"
    "full-detail-from-email"
    "hide-acf-layout"
    "arman-responsive-email-style"
    "wr-allow-modern-images"
    "md-block"
    "dob-field-for-cf7"
    "random-quotes-generator"
    "simple-eu-vat-number-for-woocommerce"
    "custom-login-uk"
    "wp-multirow-slider"
    "jskeleton"
    "site3d-configurator"
    "puredevs-wp-locker"
    "user-role-counter"
    "popup-lead"
    "upcoming-subscription-reports"
    "onedash"
    "super-simple-events-list"
    "fiizy-pay-later-multi-lender-payment-gateway-for-woocommerce"
    "emoji-guard"
    "rees-real-estate-for-woo"
    "scpo-wp-rocket-integration"
    "commenze-comment-sections"
    "slide-img"
    "inlexa"
    "max-slider"
    "enhanced-embed-block"
    "posts-carousel"
    "time-and-date-shortcodes"
    "travel-buddy"
    "simpli-image-carousel"
    "simple-social-media-preview"
    "shorturl-to-random-url"
    "post-raw-viewer"
    "scheduler-widget"
    "edit-and-manage-product-for-woocommerce"
    "candescent"
    "logo-slider-ninetyseven-infotech"
    "replicant"
    "real-estate-directory"
    "mailroad-switch"
    "bitoony-free-seo-checker-tools"
    "optimwp"
    "map-in-each-post"
    "tamkeen-tms-integration"
    "plug-payments-gateway"
    "wc-gateway-payburner"
    "disable-menu-links-with-children"
    "deluxe-shop-as-a-customer-for-woocommerce"
    "change-category-name"
    "widget-citation"
    "store-booster-lite"
    "pyts-count"
    "fenix-express"
    "media-search-plus"
    "virtual-hdm-for-taxservice-am"
    "foreign-keys-pro"
    "chocolate-rain"
    "riotd-reddit-image-of-the-day"
    "getcost"
    "wovax-crm"
    "sharect-wp"
    "wp-inline-cacher"
    "hornbills-myi"
    "wagering-requirement-calculator"
    "sb-sms-sender"
    "product-side-cart-for-woocommerce"
    "envelope-challenge"
    "my-buzzsprout-podcasts"
    "botmate"
    "ovn-category-list-widget-for-elementor"
    "only-schema-product-reviews"
    "recaptcha-js-alert"
    "fs-lazy-load"
    "salon-manager-widgets"
    "flyyer-previews"
    "codeless-cloud-starter-sites"
    "nyzo-tip"
    "block-theme-color-switcher"
    "payzoft-woo-payment-gateway"
    "ellypos-pay"
    "hurtownia-budio-pl"
    "seamless-schedule-free"
    "gps-tracking-roi-calculator"
    "additional-subscription-intervals"
    "wp-widget-styler"
    "advanced-customer-account"
    "supervisor-com"
    "ct-divi-acf-object-loop"
    "wc-invoice-manager"
    "switch-polylang-to-ukrainian-language"
    "123ezbiz-ecommerce-store-connector-a"
    "winddoc"
    "sx-site-rating"
    "post-search"
    "user-first-kit"
    "womens-refuge-shielded-site"
    "fouita-smart-widgets"
    "flamix-bitrix24-and-wpforms-integration"
    "linvo-time-your-marketing"
    "rest-api-explorer"
    "no-more-bots"
    "post-author-switcher"
    "video-stream-embed"
    "disable-settings-for-wp"
    "my-superb-testimonials"
    "web3-coin-gate"
    "admin-posts-manager"
    "bananacrystal-payment-gateway"
    "bitcoin-blockheights"
    "drag-and-drop-file-upload-for-elementor-forms"
    "rest-wp"
    "media-size-control"
    "referall-123"
    "amzft"
    "appify-side-cart"
    "social-feed-ez"
    "featured-content-block"
    "easy-custom-post-type-ui"
    "magical-mouse"
    "snvk-media-gallery"
    "dtravel-booking"
    "simple-video-background-block"
    "wc-blackbox-integration"
    "user-sync-for-klaviyo"
    "nines-snowstorm"
    "nova2pay"
    "oceanpayment-klarna-gateway"
    "uppercase-titles"
    "xhe-quicktags"
    "the-simplest-optional-shipping-by-products"
    "disable-default-post-type"
    "events-connector-event-on"
    "re-trigger-scheduled-posts"
    "tryst-member"
    "zhu-development-tools"
    "social-link-groups"
    "sepal"
    "diskhero"
    "custom-fields-missing-when-acf-is-active"
    "bizappay-for-givewp"
    "ecommerce-menu"
    "wc-minimum-price-required-to-checkout"
    "simple-stripe-button"
    "tailored-swiper-carousel"
    "zedna-301-redirects"
    "nixwood-grid-for-elementor"
    "meta-counter-groundhogg"
    "dreevo-for-woocommerce"
    "appsy"
    "cta-builder"
    "debug-using-ngrok"
    "mangofp"
    "begruessung-nach-der-tageszeit"
    "wc-sms-order-notification"
    "work-time-allocator"
    "wpdevhub-recipes"
    "simple-virtu-widget"
    "digital-humans"
    "highlight-multiple-quantities-in-order"
    "hide-user-fields"
    "isolation-flow-manager"
    "semonto-website-monitor"
    "html5-videochat"
    "liststrap"
    "sft-related-products-woocommerce"
    "project-target-connector"
    "product-quote-cart-for-wc"
    "notch-pay-for-give"
    "b2-analytics"
    "dn-shipping-by-price"
    "mybizna-pods-migration"
    "dn-wc-ordine-minimo"
    "postcode-eu-address-validation"
    "insim"
    "raisely-donation-form"
    "gfit-virtual-tryon"
    "dca-calculator"
    "shopboost-surprise-hesitating-visitors"
    "rts-product-showcase"
    "netbilling-for-woocommerce"
    "taro-lead-next"
    "taly-shop-now-pay-later"
    "niche-hero"
    "private-ad"
    "promote-mobile-app-on-website"
    "appearancetools"
    "xlarksuite"
    "lianaautomation-wpf"
    "tcd-classic-editor"
    "delloop4woo"
    "calculator-u"
    "ascode-woo-calculator"
    "voice-mail"
    "onepipe-payment-gateway-for-woocommerce"
    "wcc-zillow-reviews-free"
    "connect-wp-posthog-com-integration"
    "blogcopilot-io"
    "wp-stateless-gravity-forms-addon"
    "common-ninja-audio-player-for-woocommerce"
    "animated-forms"
    "wc-separated-category-widget"
    "vouchkick"
    "aithenticate"
    "ecommerce-reports-exporter"
    "auto-generate-coupon-for-woocommerce"
    "post-search-and-order"
    "display-post-link"
    "falang-wpml-importer"
    "maakapay-invoice-payer-for-woocommerce"
    "rabbit-hole"
    "different-menu-in-different-pages-and-posts"
    "order-dropdown-contact-form-7-for-woocommerce"
    "lana-tags-manager"
    "upsy-for-woocommerce"
    "simple-tooltipfy"
    "osa-content"
    "monogram"
    "addon-stripe-with-contact-form-7"
    "script-filter-for-contact-form-7-google-recaptcha"
    "tx-responsive-slider"
    "mesajkolik"
    "secqure-login"
    "compare-table"
    "enstract-seo"
    "gev-email-validator"
    "mwb-gf-integration-for-hubspot"
    "tied-pages"
    "contact-form-user-to-mailchimp-audience"
    "copyright-year-update"
    "swiperevert-columns-on-mobile-for-wpbakery-builder"
    "free-image-cdn"
    "gtp-suite-ai-content-engine"
    "covid19-ampel"
    "hyperswitch-checkout"
    "qr-code-zukesepay-for-woocommerce"
    "tbd-events"
    "at-a-glance-widget-plus"
    "lokalyze-schedule-a-meeting"
    "my-social-media"
    "identitat-digital-republicana"
    "fox009-recent-comments-widget"
    "requestlogic"
    "xolo-widgets"
    "e-transfer-gateway"
    "serasend-email-settings"
    "wopo-sound-recorder"
    "simple-pdf-coupon-for-woocommerce"
    "riskcube-von-creditreform-schweiz"
    "ai-chat-with-pages"
    "aistore-contest-system"
    "arvand-post-grid"
    "amazing-testimonial-slider"
    "get-acf-field-label-from-name"
    "wc-maps"
    "smallcase-oembed-provider"
    "parceladousa-payment-gateway-for-woocommerce"
    "swipe-for-gravity-forms"
    "quill-smtp"
    "visual-wp-collections-for-wc"
    "deploy-webhook-github-actions"
    "front-end-error-monitoring-with-bugsnag"
    "sales-countdown-discount-timer"
    "thalaivarin-sinthanai"
    "spam-ip-export"
    "wc-variation-limit"
    "mipl-wp-user-forms"
    "scroll-to-top-by-towkir"
    "maintenance-mode-based-on-user-roles"
    "pdfl-io"
    "product-specific-email-content-for-woocommerce"
    "forumpay-crypto-payments"
    "custom-ajax-search-results"
    "webchecker"
    "zippy-form"
    "zeptomail-woocommerce"
    "expert-html-section"
    "chip-for-paymattic"
    "flat-shipping-rates-by-eniture-technology"
    "geoapps"
    "widgetmax-for-elementor"
    "show-descriptions-for-woocommerce"
    "search-report"
    "visibility-control-for-lifterlms"
    "ds-dashboard"
    "jfa-social-media-post"
    "wiki-styled-editing"
    "ofek-nakar-ils-rates"
    "noactive-for-gravityforms"
    "flexipress"
    "comments-disclaimer"
    "ai-proposal-builder"
    "carmo-copy-to-clipboard"
    "supersearch"
    "paycall-multisend-sms-tts-support-66-languages"
    "sortable-tag-count"
    "wc-currency-pesetas"
    "k-dev-widget-shortcode"
    "paygw-cashflow-boost-calculator"
    "paycall-analytics"
    "material-board"
    "verbato"
    "scorpion-ppf-product-extension"
    "pentryforms"
    "easy-attendance"
    "sms-connect-woo-unify-sms-gateway-center"
    "dryleads"
    "conversion-and-tracking-codes"
    "wc-billie-io-payment-gateway"
    "lazy-youtube"
    "nvv-debug-lines"
    "wpnakama"
    "molly-theater"
    "newer-not-better"
    "email-via-emailjs-blocks"
    "custom-buttons-buy-from"
    "rg-popup"
    "advanced-cookies"
    "menu-item-editor"
    "simons-framekiller"
    "social-share-image"
    "pixelo"
    "teduca-palettes"
    "pixobe-cartography"
    "alibi-tech-series-embedder"
    "surprise-post-grid"
    "boxful-fulfillment-hk"
    "overblocks"
    "rakam-link-tracking"
    "page-title-description-open-graph-updater"
    "sheet-to-wp-table-for-google-sheet"
    "recurring-daily-countdown"
    "wc-fill-cart-automatically"
    "spring-dance"
    "zwk-order-filter"
    "protectmedia"
    "wc-klarna-payments-via-stripe-payment-gateway-by-cartdna"
    "nic-app-stock"
    "change-login-page"
    "email-subscription-form-widget"
    "f13-recaptcha"
    "social-share-like"
    "music-press-member"
    "joyn-for-woocommerce"
    "lhl-environment-indicator"
    "alojapro-comments"
    "wzm-json"
    "starpay-wpp"
    "replace-words-with-jawn"
    "better-load-spinner"
    "product-page-builder-woo"
    "recursive-shortcode"
    "simple-yandex-metrika"
    "super-easy-stock-manager"
    "mailtree-log-mail"
    "first-graders-toolbox"
    "truefy-embed"
    "gpt-content-generator"
    "khaz-fr"
    "mi13-comment-user-edit"
    "do-we-have-testing-kits"
    "iprom-integration-for-woocommerce"
    "payment-gateway-for-swish-givewp"
    "orkestapay-card"
    "kineticpay-for-gravityforms"
    "webcompro"
    "simple-social-menu"
    "image-converter-webp"
    "one-stop-seo"
    "qr-code-bonus-card"
    "chargely-free-subscriptions-for-woocommerce"
    "indicadores-economicos-chile"
    "novalnet-payment-add-on-for-gravity-forms"
    "simple-photo-album"
    "tourmix"
    "era-autoplay-turn-sound-on"
    "fitnessbliss-calculators"
    "hide-related-posts"
    "unifiedsmb-for-woocommerce"
    "ecommerce-product-slider-gallery"
    "login-awp"
    "team-buider-showcase"
    "f13-wp-plugin-shortcode"
    "infinite-moving-cards"
    "facturozor"
    "ip-informant-logger"
    "integrations-of-zoho-crm-and-forminator-form"
    "best-selling-in-category"
    "cycle-online-payment-gateway"
    "glass-it-price-tracker"
    "elitsms"
    "remove-capslock"
    "categories-for-gravity-forms"
    "era-digital-clock"
    "best-bootstrap-widgets-for-elementor"
    "qube-tools"
    "hitshipo-dhl-global-mail-shipping"
    "luzuk-testimonials"
    "honeybadger-it"
    "post-meta-view-and-export"
    "most-wanted-login-page-styler"
    "website-visitor-converter-by-lead-liaison"
    "hide-sku-category-tags"
    "wolfram-notebook-embedder"
    "recurpay"
    "uxp-flatsome-gallery"
    "dropship-sell-your-art"
    "ss-nano-contact"
    "my-post-time"
    "saksh-course-system"
    "my-social-reach"
    "wc-sales-tax-calculator"
    "redlaxia"
    "danp-bitly-urls"
    "product-purchase-notifications"
    "ingenico-server-for-woocommerce"
    "fast-order-list-for-woocommerce"
    "aistore-bhagavad-gita"
    "shopex"
    "http-requests-tracker"
    "content-to-product"
    "send-sms-in-pakistan"
    "product-swatches-light"
    "wopo-web-screensaver"
    "cart-favicon"
    "rating-block-layouts"
    "mainjobs-admin"
    "css-class-manager"
    "radio-unlock-code-calculator-for-m-v-serials"
    "aryel-ar-3d-product-viewer-try-on"
    "wc-total-price-with-tax"
    "stop-auto-update-emails"
    "dpa-ai-assistant"
    "knowhalim-remove-duplicates"
    "webp-format-permission"
    "singleproduct"
    "web-theme-space-demos"
    "wc-active-payment-discount"
    "luway-seo-checker"
    "rapidcents-payment-gateway"
    "mdsco-sms"
    "roman-rivera-business-consulting"
    "happy-wp-anniversary"
    "janio-store-connector"
    "climbing-cartboard"
    "ticketbai"
    "ethereum-price-tooltip"
    "lilicast"
    "openai-content-assistant-via-chatgpt-markupus"
    "auto-image-from-title"
    "track718-for-woocommerce"
    "ls-wp-currency-byn"
    "bulk-product-price-update-for-woocommerce"
    "download-mobile-app-widget"
    "product-base-order-for-woocommerce"
    "pataa-address-autofill"
    "recently-viewed-products-for-woocommerce"
    "smartpaylive"
    "magicway-payment-gateway"
    "shift8-push"
    "remove-revision-dummy-content-wp"
    "dashboard-signature"
    "my-preferences-woo"
    "deema-affiliate-link-generator"
    "radinapp"
    "flexoffers-conversion-tracking"
    "customer-details-easy-digital-downloads"
    "inperium-sell"
    "publisharebot-api-endpoint"
    "clickable-blocks"
    "svg-color-changer"
    "enable-gravity-forms-confirmation-anchor"
    "emogics-tarot-reader-for-wp"
    "vinvin-force-email"
    "wc-restrict-stock"
    "swe-easy-orders-export"
    "wp-seo-redirect-edit"
    "fish-map"
    "about-post-author"
    "postsquirrel"
    "wp-publication-manager"
    "astro-sticky-buttons"
    "viper"
    "wc-iban-checker"
    "tracking-customers-and-product-recommendations"
    "kgr-login-with-google"
    "advance-faq-block"
    "jazzypay"
    "posts-contributors"
    "liquidpoll-groundhogg-integration"
    "edupix"
    "cybro-wp-easy-dark-mode"
    "superoffice"
    "hide-cart-by-condition"
    "product-attribute-on-cart"
    "replace-sale-text-with-percentage"
    "ship-safely"
    "vgc-for-givewp"
    "ngaze-order-gateway"
    "poppable"
    "owcc-payment-gateway"
    "alt-text-generator-ai"
    "wc-vpay"
    "easy-merge"
    "adirectory"
    "content-restriction"
    "last-activity"
    "web-chat-client-for-on-platform"
    "birthday"
    "wolfe-candy-tree-view"
    "direct-to-checkout-for-woocommerce"
    "hairspaces-around-dashes"
    "liquid-edge-editor-customisations"
    "hover-highlights-editor-highlighting"
    "posts-navigation-links-for-sections-and-headings-free-by-wp-masters"
    "course-product-type-only"
    "apoyl-aiarticle"
    "chili-piper"
    "sooon-page-site-under-construction"
    "wards-print-designer-lite"
    "blast-sms-broadcast"
    "appcraftify"
    "cf7-email-template-builder"
    "sqlog"
    "shping-reviews-widget"
    "balcomsoft-elementor-addons"
    "vk-adnetwork"
    "show-only-free-shipping-when-available-wc"
    "ultimate-toc"
    "ha-css-background-generator"
    "postlay-automatic-blog-post-layout-addon"
    "admin-custom-description"
    "background-color-changer"
    "giao-hang-sieu-toc"
    "crm-pro"
    "vitt-attribute-hierarchy-for-woocommerce"
    "delete-comments-on-a-schedule"
    "easy-team-builder"
    "the-garuda-express"
    "weeve-official-integration"
    "wc-zonos-hello-integration"
    "simple-login-with-social"
    "sw3-wc-purchase-history-grid"
    "ourwebseo"
    "near-pay"
    "couriersx-shipping"
    "customize-discount"
    "dbviewer"
    "sitewatcher"
    "wpdevs-classic-editor-widgets"
    "wc-sn-zone"
    "realtime-visitor-counter"
    "btb-full-width-section"
    "show-paybright-mdp"
    "scroll-widget-for-eventprime"
    "exportex"
    "quick-back-to-top-button"
    "pricena"
    "sqa-vulnerability-discovery-toolkit"
    "cylist"
    "feedback-button"
    "remove-and-rearrange-menu"
    "postmoon"
    "course-booking-platform"
    "maalipay-for-woocommerce"
    "camweara-virtual-try-on"
    "tavakal-admin-columns"
    "wploadgraph"
    "easy-custom-cursor"
    "world-gift-card-gateway-for-woocommerce"
    "employees-details-slides"
    "giftshop-airtime"
    "easy-slider2"
    "petmatchpro"
    "jc-ajax-search-for-woocommerce"
    "image-bridge"
    "aion-assists"
    "helpdesk-contact-form"
    "back-in-stock-notifications-for-woocommerce"
    "404-to-301-for-woo-products-url"
    "ia-magic-galleries"
    "permissionsplus"
    "mrkv-nova-post"
    "redirect-after-logout"
    "pdf-for-ninja-forms"
    "ois-bizcraft-checkout-gateway-plus"
    "extend-revisions-for-custom-fields-and-taxonomies"
    "jla-antispam"
    "sepordeh-payment-gateway-for-easy-digital-downloads-edd"
    "pdf-embedder-fay"
    "tunl-payment-gateway"
    "widget-2x2forum"
    "resourcemanager"
    "ezcontent"
    "sc-tableofcontents"
    "zesty-custom-post-types-for-paid-memberships-pro"
    "virtuaria-jamef-woocommerce"
    "wc-best-selling-products-lite"
    "vandapardakht-payment-for-woocommerce"
    "guest-user"
    "product-delivery-date-time-for-woocommerce"
    "inpost-italy"
    "company-posts-for-linkedin"
    "real-time-order-notify"
    "bux-digital-gateway"
    "set-featured-images-for-individual-posts"
    "chatbot-inteliwise"
    "t-data-payment-gateway"
    "memberglut"
    "page-charts"
    "extra-product-options-lite-for-woocommerce"
    "oceanpayment-alipay-gateway"
    "fellow-yrityslasku-for-woocommerce"
    "mantiq-integration-for-woocommerce"
    "simple-scss-compiler"
    "tryst-invoice"
    "materializor"
    "lbyt-lb-youtube"
    "edebit-direct-ach-gateway"
    "promotional-product-for-subscription"
    "outdoor"
    "block-common-crawl-via-robots-txt"
    "remote-dashboard-widget"
    "hb-line-button-tiny"
    "edd-bizappay"
    "soukapay-for-woocommerce"
    "loyalty-reward-points-for-hubspot"
    "same-user-credentials"
    "edit-recent-edited-posts"
    "lazy-map"
    "hashtags-for-wp"
    "wolfe-candy-tag-cloud"
    "insites-analytics"
    "eventonai"
    "add-sweetalert-to-elementor-form"
    "iotecpay"
    "42videobricks"
    "onclick-to-top"
    "oceanpayment-wechatpay-gateway"
    "kultur-api-for-wp"
    "oxyplug-proscons"
    "frontend-view-for-headless-cms"
    "ai-speaker-yomiage-kun"
    "dcs-digital-guides"
    "mb-divi-integrator"
    "maia-mechanics-pro-web-widget"
    "instant-answers-chatbot"
    "bet-sport-free"
    "yts-floating-action-button"
    "nobesho"
    "message-toastr-contact-form-7"
    "statistics-123"
    "talkbe-notification-api-for-woocommerce"
    "mycred-for-totalsurvey"
    "all-user-login-status"
    "bankingbridge"
    "trendyol-entegrasyon"
    "safeguard-drm"
    "oceanpayment-fps-gateway"
    "dataplans-esims-for-woocommerce"
    "vremenska-prognoza"
    "pausepay-gateway-for-woocommerce"
    "addresser-autocomplete-and-address-validation"
    "wplife-woo-s"
    "simple-product-tabs-for-woocommerce"
    "monkey-in-silk"
    "shopizi"
    "lytics-topics"
    "order-status-per-product-for-woocommerce"
    "user-signin-signup"
    "sw-wp-track-user-referer"
    "show-user-ip"
    "image-overlay-cues"
    "inkreez"
    "content-automation-toolkit-cat"
    "track-lk-notification-for-woocommerce"
    "codex-team-widgets"
    "quickcreator"
    "codex-testimonials-addons-for-elementor"
    "wc-easy-quick-view"
    "twosides"
    "style-genre"
    "bleumi-payments-for-cancel-abandoned-order"
    "dynamic-sticky-header"
    "digikala-affiliate"
    "niche-first-time-buyers-mortgage-calculator"
    "avacy"
    "lianaautomation-contact-form-7"
    "radical"
    "embed-spanish-wordle"
    "scroll-top-aps"
    "registered-user-dashboard-widget"
    "flip-and-win"
    "fiscal-solution-for-e-commerce"
    "remove-address-from-e-commerce"
    "netscore-rental-products"
    "xym-price-block"
    "vgc-for-edd"
    "show-post-by-location"
    "tools-for-color-variations"
    "vgc-for-gravity-forms"
    "utreon-embed"
    "poll-creator"
    "wplog"
    "navu-conversions"
    "cart-notify"
    "give-nfts"
    "verse-of-the-day-widget-for-wp"
    "debrandify"
    "qode-compare-for-woocommerce"
    "repeater-for-contact-form-7"
    "nuclia-search-for-wp"
    "environment-displayer-for-pantheon"
    "slide-blocks"
    "hfa-spxp-support"
    "restropress-menu-cart"
    "count-of-products-in-one-category"
    "klementin-woo-infinite-shopping"
    "zifera"
    "local-structured-schema-data-for-articles"
    "windycoat"
    "thinkstack"
    "home-sweet-home"
    "preload-featured-image"
    "smart-customizer-for-woocommerce"
    "mixplat-gateway-for-woocommerce"
    "ma-teyahch"
    "reng-player"
    "emailwish"
    "global-e-cross-border-for-woocommerce"
    "smart-copyright-year"
    "agegate-by-agechecker-net"
    "usb-qr-code-scanner-for-woocommerce"
    "title-year-shortcode"
    "cryptopay-gateway-for-memberpress"
    "ems-jetpack-crm"
    "blueodin"
    "post-word-counter-and-thumbnail-checker"
    "website-chat-button-kommo-integration"
    "onix-helper-cpt-cmb-taxonomies"
    "yunits-for-wp"
    "wc-scheduled-catalog-mode"
    "payamito-core"
    "pinkbridge-wp-tool"
    "make-range-slider-for-contact-form-7"
    "tooltip-label-icon-addon-for-wpforms"
    "targetsms-ru-contact-form-7"
    "crystal-ball-insight"
    "enjaneb"
    "backorder-custom-description"
    "show-post-latest-by-category"
    "ibehroozir"
    "login-page-tailor"
    "entire-blocks"
    "disable-updates-by-cv"
    "wl-import-demo"
    "php-version-display"
    "edxapay-for-woocommerce"
    "yourllp-affiliate"
    "adminimal-bar"
    "wcc-google-analytics"
    "itech-hide-add-cart-if-already-purchased"
    "remove-product-data-tabs"
    "customize-checkout-and-buttons-for-woocommerce"
    "sight-pay"
    "san-thumbnail-posts"
    "w2dc-mail"
    "snoobi-id-checker"
    "attachmentav"
    "hipporello-form-viewer"
    "nohackme-defender"
    "favorite-toots"
    "wpconcierges-hyperfair-registration"
    "apoc-viewer"
    "at-search-console"
    "sy-mailer"
    "alb-block-theme-type-1-banner"
    "image-modal"
    "simple-html-search"
    "cross-upsell-popup-for-woocommerce"
    "remotemonkey"
    "publisher-analytics-npaw"
    "auto-update-image-attributes-from-filename"
    "widgets-for-google-reviews-and-ratings"
    "sm-easy-duplicator"
    "content-workflow-by-bynder"
    "truncate-text"
    "juvo-ws-form-login"
    "pis-tag-manager"
    "hywd-tools-manager"
    "login-with-token"
    "react-wp-admin"
    "mandarin-payment-integration"
    "viapay-checkout-gateway"
    "gbo-modules-reviews"
    "wpwing-sticky-block"
    "dashcommerce"
    "quick-edit-acf-content"
    "dynamic-blocks"
    "ec-links"
    "leadtrail"
    "user-wise-email-disable"
    "wc-polo-payments"
    "featured-listing-for-locatepress"
    "simple-sale-countdown-by-13node"
    "scout-checkr"
    "stopwords-for-comments"
    "salesmate-messenger"
    "accept-pay-payment-gateway-for-woocommerce"
    "visualwp-restrict-rss-feeds"
    "food-truck-locator"
    "thinkalink-yeardata"
    "xpress-legend-logistic"
    "monthly-events-calendar"
    "cf7-style-for-elementor"
    "basic-google-analytics-4-for-wp"
    "nexmind"
    "value-topup"
    "open-brain"
    "system-usability-scale"
    "check-external-login"
    "lova-payment-gateway"
    "next-accordion-block"
    "speedwapp"
    "short-url-fe"
    "ultimate-pricing-addon-for-elementor"
    "martins-analytics"
    "post-by-weekday"
    "flowpoint-analytics-tracking-code"
    "ingenious-advertiser-tracking"
    "ifocus-sk-link-nest-lite"
    "zesty-emails-custom-template-designer-for-woocommerce"
    "voicemailtel-meet"
    "dmn-hush"
    "propeller-ecommerce"
    "ada-seo-by-adaptify"
    "user-verification-and-discounts"
    "bookster-search-form"
    "r2b2-monetization"
    "cellarweb-chatbot-blocker"
    "qomon"
    "webhook-configuration-cf7"
    "vite-rewards"
    "upgrade-store"
    "lti-tool-learndash"
    "oceanpayment-oxxo-gateway"
    "ipanema-film-reviews"
    "shoplic-integration-for-naver-maps"
    "hilfe"
    "personalised-gift-supply-listing-tool"
    "webtoapp-design"
    "maanstore-api"
    "honrix-addons"
    "nblocks"
    "jijianyun"
    "payje-for-woocommerce"
    "oceanpayment-unionpay-gateway"
    "code-sample-contact-form"
    "brankas-payment-for-woocommerce"
    "huckabuy"
    "encycloshare"
    "cta-shortcodes-in-post"
    "wopo-web-crawler"
    "wpnice-accordion"
    "rb-theme-helper"
    "backup-snippets"
    "brand-master"
    "oms-coupon"
    "expert-bitpay-gateway-for-lifterlms"
    "suprementor"
    "eyezon"
    "module-pager"
    "simple-map-with-shortcode"
    "mintships"
    "tmd-wc-delivery-date-time"
    "netservice-reseller"
    "cafe-api"
    "click-to-call-sticky-mobile-button-lite"
    "tabs-sliders-by-bestaddon"
    "integrate-instamojo-with-gravity-forms"
    "wpmh-clone-menu"
    "racar-message-me"
    "dev-share-buttons"
    "meta-preview"
    "unofficial-braille-institute-founder-font"
    "product-testimonial"
    "ahmeti-wp-helpers"
    "easy-buy-button"
    "hb-customer-send-atmcode-to-administrator-for-woocommerce"
    "ticket-buttons-for-the-events-calendar"
    "chat-on-desk"
    "estimate-read-time"
    "fyvent"
    "simple-customizations-for-woocommerce"
    "posts-short-link"
    "kurocoedge"
    "mantiq-integration-for-slack"
    "meu-astro-sinastria"
    "apoyl-grabdouyin"
    "renoon-tracking-for-woocommerce"
    "ehw-random-bible-verse"
    "ad-shortcodes"
    "trackbee-connect"
    "metizpay-payment-gateway-for-woocommerce"
    "uws-real-time-sales-ticker"
    "maan-elementor-addons"
    "x3p0-progress"
    "paysepro-for-woocommerce"
    "marquee-block"
    "media-tracker"
    "omnicommerce-integracion-para-dragonfish"
    "easy-album-gallery"
    "latest-posts-block"
    "easy-product-exporter"
    "jhk-faq"
    "easy-woo-shortlink-manager"
    "wb-partial-cod-for-woocommerce"
    "file-limits-uploads"
    "sticky-blue"
    "nuu-contact"
    "playground-embedder"
    "cookies-privacy-policy"
    "delete-control-by-firework"
    "linkly-for-woocommerce"
    "text-summarizer"
    "store-finder"
    "gpt-ai-saas"
    "banana-newsletters"
    "sms-media4u-login"
    "ibryl-switch-user"
    "oceanpayment-sofortbanking-gateway"
    "flexlab-google-analytics-for-woocommerce"
    "boxo-return"
    "easy-business-hours"
    "ipint-payments-gateway"
    "tag-manager-by-rocketcode"
    "coming-soon-for-products"
    "caloriea-calculator"
    "yours59-responsive-spacings-for-core-blocks"
    "plain-event-calendar"
    "pricewell"
    "custom-block-pattern-builder"
    "remove-pesky-site-icon"
    "checkout-redirect"
    "ugc-creator"
    "clear-cloudfront-cache"
    "divit-extension-evaluator"
    "pwr-ads"
    "cybrosys-post-counter"
    "gf-to-bf"
    "advance-nav-menu-manager"
    "dynamic-price-reduction"
    "future-ticketing"
    "ar-viewer"
    "datapeeps"
    "sadhguru-quotes"
    "maker-badge"
    "kd-post-tile-listview"
    "common-ninja-product-blobs-for-woocommerce"
    "custom-login-page-logo"
    "master-query-loop"
    "web-slider"
    "bloglive-online-live-blogging"
    "rst-awesome-team-widget"
    "tt-one-page-checkout-for-woocommerce"
    "charts-and-graphs-manager"
    "kit-product-for-woocommerce"
    "make-me-static"
    "sppx-offerings"
    "ai-translator-for-polylang"
    "simple-employee-list"
    "visitor-content-wall"
    "premiuum-content-monetization"
    "sovratec-return-exchange"
    "resprovis"
    "project-portal"
    "wfk-menu-importexport"
    "athlos-assistente-digitale"
    "lpcode-flutuante-btn"
    "simple-limited-access"
    "barrierefrei-helper"
    "auto-ms-creator-id"
    "atol-pay-gateway"
    "better-quick-login"
    "colbass-read-aloud-player"
    "paychangu-gateway-for-woocommerce"
    "affiracle-affiliate-marketing"
    "crypto-payments"
    "fulcrum"
    "games-lantern"
    "shipment-addon-for-woocommerce"
    "post-date-range-filter"
    "remove-unused-files-of-contact-form-7"
    "commentor"
    "relario-pay"
    "metapic-advertiser"
    "welcart-exclude-from-delivery-day"
    "mosne-dark-palette"
    "formico"
    "igniterauth"
    "what-singular-template"
    "next-tiny-db"
    "page-preview"
    "user-profile-tabs"
    "lap-api"
    "keyboard-nav-wp"
    "useful-snippets"
    "stacks-access"
    "dashboard-system-info"
    "wc-sms-notification"
    "chat-support"
    "the-courier-guy-shipping-for-sovtech"
    "move-orders-on-hold-to-processing-if-successfull-authorize-net-payment"
    "backlink-day-counter"
    "show-product-review-and-ratings"
    "wc-remove-reply-to"
    "bizfirst-pay"
    "email-re-validator"
    "game-application-form-cloudsgoods"
    "wamate-confirm"
    "quickcep"
    "postal-server-integration-for-mailster"
    "netuy-email-marketing"
    "filename-randomizer"
    "banners-for-product-categories"
    "payos"
    "wraiter-light-ai-assisted-autocontent-elementor-support-light-version"
    "wp-cloudsync-master"
    "swipe-for-givewp"
    "broadnet-sms-services"
    "metrepay"
    "wetail-shipping"
    "parafrasear"
    "lipad-checkout"
    "quetext"
    "customer-list-export-for-woocommerce"
    "zior-lightbox"
    "security-headers-caching"
    "ober-player"
    "aquagates-payments-for-woocommerce"
    "rocketfront-connect"
    "streamweasels-twitch-blocks"
    "pop-breadcrumb-shortcode"
    "php-version-fay"
    "bindusms"
    "ach-invoice-app"
    "webp-convert"
    "components-for-learning"
    "really-remove-category-base"
    "post-reaction"
    "business-contacts-authentic-verifiable-business-leads"
    "speed-checker"
    "stop-confusion"
    "dos-dialog"
    "material-box"
    "smtp-for-wp"
    "vendreo-open-banking-gateway"
    "embed-consent"
    "auto-parts-4-less-marketplace-sync"
    "addon-elementor-container-link"
    "rao-forms"
    "access-by-nft"
    "polling-by-alex-lundin"
    "holiday-notifications"
    "scroll-highlighter"
    "popup-anywhere"
    "parvin-poems"
    "rhx-post-grid"
    "nerdcom-chat"
    "featured-image-in-all-posts"
    "rhx-woo-product-carousel"
    "pidex"
    "wpfts-addon-for-avada-theme"
    "business-kpi-reporting-dashboard"
    "product-auto-release-with-upvote-countdown"
    "envision-page-builder"
    "majestic-widgets-for-elementor"
    "suyool-payment"
    "banana-user-profiles"
    "image-alt-setter"
    "acj-mongodb-sync"
    "tida-quotes"
    "topbar"
    "bulk-manager"
    "summaraize"
    "sohis-sri-modal"
    "rapaygo-for-woocommerce"
    "ritziexport"
    "product-search-for-woocommerce"
    "forward-attribution"
    "rss-cors-enable"
    "optinmagic"
    "tabdil-app-persian-weight-converter"
    "reshark-pdb"
    "marcomgather"
    "xelation"
    "landline-remover"
    "ecover-builder-for-dummies"
    "spendino"
    "smartpoints-lockers-acs"
    "is-there-a-problem"
    "videoo-manager"
    "template-max-shortcodes"
    "denmed-core"
    "leutonpay-gateway-for-woocommerce"
    "calorie-deficit-calculator"
    "testing-elevated"
    "storyficator"
    "webby-maps"
    "simple-task-list"
    "captcha-contact-form"
    "lightweight-countdown-timers"
    "sync-gravity-forms-hubspot"
    "trivia-adapter-pack"
    "easy-youtube-automate"
    "postpeek"
    "easy-simple-faq"
    "wptrove"
    "my-feed"
    "custom-post-count-at-a-glance"
    "picsmize"
    "mvx-cointopay-gateway"
    "ils-indian-logistics-services"
    "tt-donation-checkout-for-woocommerce"
    "easiio"
    "mediebank"
    "brand-carousel"
    "cw-step-two-verification"
    "easy-chat-button"
    "comment-but-not-seo"
    "common-ninja-info-labels-for-woocommerce"
    "geo-deals"
    "order-barcode-for-wc"
    "lianaautomation-login"
    "dalfak-video-widget"
    "access-guard"
    "paytiko"
    "dialog-e-sms"
    "saoshyant-element"
    "webyn"
    "allcontactorgv"
    "delighted-integration"
    "team-member-slider-block"
    "web39-step-by-step-questionnaire"
    "poll-and-vote-system"
    "hipl-assets"
    "elitepayme-pg-for-woocommerce"
    "recommat"
    "bstd-wc-zcrm"
    "virtue-for-woocommerce"
    "lwn-recipe"
    "osom-block-visibility"
    "query-loop-load-more"
    "video-play-on-image"
    "lupovis-prowl-security"
    "generate-security-txt"
    "ai-ban-spam-comment"
    "lightag-lightweight-google-tag-manager"
    "product-coming-soon"
    "easy-related-random-posts-errp"
    "payment-gateway-through-unifiedpost"
    "warpdriven-gpt-copywriting"
    "noindex"
    "connect-contact-form-7-to-telegram"
    "instock-products-for-woocommerce"
    "restropress-address-auto-complete"
    "newsletter-for-sendcloud"
    "thekua-product-categories-on-shop"
    "search-replace-for-block-editor"
    "calculate-customers-savings"
    "ovo-product-table-for-woocommerce"
    "na-e-commerce-egypt-cities-states"
    "check-update-servers"
    "switchere-com-crypto-gateway"
    "hide-admin-bar-by-rocketcode"
    "wp-adpt"
    "xpay-payment-gateway"
    "outdated-post-label"
    "tron-login-protect"
    "iq-referral-program-for-woocommerce"
    "post-slider-widget-for-elementor"
    "categories-status"
    "marketing-automation-suite"
    "wc-apc-overnight-shipment-tracking"
    "peer-publish"
    "blue-infinity-blocker"
    "formsdeck"
    "adaptive-backgrounds"
    "simple-blurb"
    "imagy-wp"
    "lineone-one"
    "api-for-htmx"
    "chat-support-button"
    "ctrllogin"
    "rank-expert"
    "swellenterprise"
    "hardened-clean"
    "wdesk"
    "nuropedia"
    "d3-data-fields"
    "mwhp-for-woocommerce"
    "post-word-count-in-admin"
    "easy-slider-for-elementor"
    "wonder-wc-checkout-review"
    "addon-custom-fee-in-cart-wc"
    "wc-sort-advanced"
    "rwp-companion"
    "grasshoppers-cod"
    "learnie"
    "pause-shop"
    "payment-gateway-for-strowallet-on-woo"
    "tooltipper-by-akos"
    "nf-finnish-ssn-field"
    "easynostr-nip05"
    "simple-wp-smtp"
    "pko-leasing-online"
    "custom-post-list"
    "dc-forms"
    "carbon-blocks"
    "acf-block-generator"
    "sirdata-cmp"
    "wc-plus"
    "yoplanning-booking-engine"
    "ai-text-block"
    "whatcx-widget"
    "title-hide"
    "gtchatpro"
    "wall-by-mindspun"
    "repo-showcase"
    "allfactors"
    "post-content-word-count"
    "iflair-pwa-app"
    "form-refresher-for-gravity-forms"
    "pnp-pick-and-pay-payment-gateway"
    "accountsbuddy-simple-accounting"
    "greencharts"
    "edh-shop-categories"
    "solid-data-summary"
    "pro-teams"
    "cf7orderstatusswitcher"
    "product-call-for-price-for-woocommerce"
    "payment-gateway-through-payletter"
    "product-code-button"
    "teezily-plus-shipping-method"
    "d3-cpts"
    "lupon-media-prebid-header-bidding"
    "public-form-leads"
    "post-word-counter"
    "new-brand"
    "plebeian-market"
    "smart-disable-right-click-on-website"
    "hide-and-block"
    "font-fa"
    "blendee-mos"
    "enudge"
    "reaction"
    "easy-menu-manager"
    "flamix-bitrix24-and-divi-contact-form-integration"
    "wiflydemofeedbackcomposer"
    "product-color"
    "ccg-quickly"
    "runthings-secrets"
    "scwriter"
    "widgets-for-youtube-video-feed"
    "memory-usage-monitor"
    "top-down-scroll"
    "esms-notify"
    "advance-review-manager"
    "te-recluta-trabajos"
    "glassmorphic-admin-ui"
    "marquee-carousel"
    "happy-cart"
    "super-simple-shortcodes"
    "chat-without-contact"
    "moneda-libremente-convertible-mlc-cuba"
    "metadata-viewer"
    "post-qr-code-generator"
    "passwordlessi"
    "shortcuts-for-admin-bar"
    "hide-or-toggle"
    "category-count-shortcode"
    "zs-social-chat"
    "tracking-number-for-woocommerce"
    "sparki"
    "finest-blocks"
    "recent-posts-easy"
    "regular-posts-element-for-elementor"
    "bunu-kopyala"
    "customerclub"
    "sendpulse-popups"
    "libize"
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

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
    "simple-testimonial"
    "4blit"
    "payment-gateway-groups-for-woocommerce"
    "version-switcher"
    "wp-database-session-handler"
    "pryc-wp-disable-self-trackback"
    "woo-mycelium-gear"
    "onecrm"
    "upcoming-ticketsolve-shows"
    "page2widget"
    "bobs-custom-login"
    "featured-image-from-content"
    "wp-dropkick"
    "delivery-date-checkout-for-woocommerce"
    "jimmo-wp-loan-repayment-calculator"
    "desire-page-widget"
    "sprintcheckout"
    "hide-google-recaptcha-logo"
    "marketing-360-payments-for-woocommerce"
    "media-carousel-video-logo-and-image-slider-for-elementor"
    "itg-rztka"
    "wp-term-metadata"
    "wp-custom-field-chart"
    "bigboss-recent-post-widget"
    "apa-register-newsletter-form"
    "team-feed"
    "ni-woocommerce-stock"
    "doubledome-wordcount-details-dashboard"
    "browsee"
    "meritocracy"
    "daily-bible-readings"
    "upladobe"
    "hubpages-widget"
    "halloween-woocommerce"
    "order-audit-log-for-woocommerce"
    "secwurity-wp-login"
    "ff-block-advanced-columns"
    "blogsqode-posts"
    "product-tagger"
    "images-asynchronous-load"
    "celumconnect"
    "hello-elecolor-change-hello-elementor-link-color"
    "ap-background"
    "wikimotive-clickup-task-forms-free"
    "cookie-alert"
    "really-simple-affiliate-program"
    "ajax-table-with-custom-crud-api"
    "wp-content-generator-blog-planner-free"
    "financial-ratio"
    "gs-acf-icons"
    "nevobo-api"
    "headless"
    "pipeline"
    "custom-products-fields-woo"
    "color-changer"
    "syntaxhighlighter-amplified"
    "doi-helper"
    "emailable"
    "autopostcode"
    "lequiz"
    "wc-upsell-and-order-bump"
    "prixchat"
    "getotp-otp-verification"
    "football-club-logo-shortcode"
    "swidget-for-cmp"
    "filter-post-types-by-taxonomy"
    "free-download-manager"
    "mview"
    "ss-find-post-with-password"
    "c4d-woo-carousel"
    "post-lock"
    "vesicash-escrow-plugin-for-woocommerce"
    "graph-commons"
    "host-header"
    "responsive-controls"
    "d7sms"
    "give-as-you-live"
    "one-login"
    "trustap-payment-gateway"
    "mihdan-yandex-dialogs"
    "amazon2smile-affiliate-links"
    "social-media-buttons-with-privacy"
    "bytecoder-news-ticker"
    "passclip-auth-for-wordpress"
    "amp-with-postlight-mercury"
    "bob-ai"
    "user-last-modified"
    "wp-imap-authentication"
    "meta-age"
    "company-vacancies"
    "advanced-post-widget"
    "ics-nested"
    "fast-news-ticker"
    "cultivate-for-woocommerce"
    "shtml-on-pages"
    "chip-for-gravity-forms"
    "edd-paytr-payment-gateway"
    "convert-image-to-media"
    "color-and-label-variations-for-woocommerce"
    "auto-delete-system-status-logs"
    "unified-meta-box-order"
    "content-runner-importer"
    "create-members"
    "mailgun-post-notifications"
    "post-featured-image"
    "sn-scroll-to-up"
    "stylish-real-estate-leads"
    "cobranca-u4crypto"
    "mobile-pages"
    "grassblade-xapi-masterstudy"
    "upscale"
    "js-banner-rotator"
    "awesome-google-maps"
    "webolead"
    "wp-notices"
    "livejournal-shortcode"
    "aspexi-login-audit"
    "portfolio-builder-elementor"
    "super-simple-age-gate-beta"
    "gpt3-ai-content-writer"
    "processors-for-caldera-forms"
    "ay-term-meta"
    "wp-link-to-this-post"
    "product-sold-count"
    "woo-dynamic-pricing-and-discounts"
    "wp-sacloud-ojs"
    "login-page-customize"
    "reader-mode"
    "memorizer"
    "kolorweb-log-manager"
    "deals"
    "wp-opensearch-advance"
    "custom-post-type-manager"
    "popular-tags"
    "woo-ripple-gateway"
    "twitter-mentions-in-posts"
    "eve-dynamic-prerender"
    "wp-webhooks-easy-digital-downloads"
    "view-pingbacks"
    "nextplugins-woocommerce-ask-question-tab"
    "freebieselect-daily-free-content"
    "pbs-gateway"
    "pipefy-public-form"
    "clear-opcache"
    "simple-discord-sso"
    "ratify"
    "ratingcaptian"
    "branding"
    "child-order"
    "calendar-to-events"
    "makenewsmail-widget"
    "mg-pinterest-strips-widget"
    "hello-lyrics"
    "awsslideshow"
    "wp-light-captcha"
    "iabtechlab-adstxt-generator"
    "editable-recipe"
    "output-buffer-tester"
    "kmm-hacks"
    "hearme-ai"
    "smntcs-show-sale-price-date-for-woocommerce"
    "skipcash-payment-gateway"
    "ship-to-a-different-address-unchecked"
    "integration-for-elementor-theme-builder"
    "auto-populate-image-alt-tags-from-media-library"
    "addscript"
    "dadi-breadcrumb"
    "simpleshare"
    "display-attached-file-size"
    "social-gallery-block"
    "question-generator"
    "top-sites-url-list"
    "podcast-searcher-by-clarify"
    "iorad-editor"
    "mousestats-tracking-script"
    "crm2go-for-woocommerce"
    "kinfo"
    "images-to-div-converter"
    "quizy"
    "external-markdown"
    "wpbatch-icons-shortcode"
    "timelimit-add-on-for-badgeos"
    "be-lazy"
    "easy-popular-posts-widget"
    "edd-user-admin-purchases-column"
    "generate-wpgraphql-image-dataurl"
    "litepay"
    "depublish-posts"
    "wp-shortlinker"
    "simple-latest-posts-shortcode"
    "webrtc-softphone"
    "wasp-anti-spam"
    "mexpago-pasarela-de-pago-para-wc"
    "otherboard"
    "export-wpseo"
    "idenfy"
    "import-products-to-ozon"
    "partners-dynamic-badge"
    "wpqrcode"
    "logic-hop-google-analytics-add-on"
    "routed-actions"
    "simple-top-bar"
    "geo-tools"
    "a-note-above-wp-dashboard-notes"
    "amuga-ajax-log"
    "date-filter"
    "coopcycle"
    "wooebay"
    "wpadmin-backup-to-aws4"
    "mesnevi-i-manevi"
    "wp-posts-showcase"
    "kin-direcciones"
    "salsa-gravity-forms"
    "direct-logout"
    "take-the-lead"
    "order-thumbnail-for-woocommerce"
    "son-of-gifv"
    "addonskit-for-elementor"
    "simple-schedule-notice"
    "woo-shipping-tracker-customer-notifications"
    "banner-info-effect"
    "linkrocker"
    "simple-media-taxonomy-galleries"
    "calendi"
    "floorplans-lite"
    "wp-lazy-spotify"
    "essential-script"
    "viet-contact"
    "bookalet"
    "wp-utz"
    "email-dns-verification"
    "surbma-minicrm-shortcode"
    "ibexpay-payment-gateway"
    "beautiful-login-page"
    "mt-tabs"
    "pronosticos-apuestas-tap"
    "layer-maps"
    "viralism"
    "wc-fastpaynow-by-fave"
    "profile-master"
    "status-exporter"
    "einsatzverwaltungeu"
    "rankriskindex"
    "flytedesk-digital"
    "wpjm-jooble-feed"
    "err-our-team"
    "dual-size-responsive-slider"
    "daovoice"
    "kmm-timeshift"
    "woo-manual-orders"
    "clip-path-maker"
    "users-list"
    "exit-intent-conversion-rate-optimisation-popups-by-bouncezap"
    "meta-optimizer"
    "eliot-pro"
    "newsletter-subscriptions"
    "acf-sidebar"
    "walti"
    "postnl-address-validation-for-woocommerce"
    "osi-affiliate"
    "creativesignal-testimonial"
    "bolcom-seller-widget"
    "plugin-mover"
    "recent-tracks-lastfm"
    "embed-roomshare-japan"
    "churchope-theme-icalendar-generator"
    "surbma-gdpr-multisite-privacy"
    "embed-notion-pages"
    "progress-planner"
    "duplicate-me"
    "fense-block-vpn-proxy"
    "youtube-new-generation"
    "user-social-fields"
    "wui-lightbox"
    "wc-bulk-add-custom-related-products"
    "neptune-business"
    "dynco-toolkit"
    "cf7-dinamic-vars"
    "browser-scroll-bar"
    "noindex-by-path"
    "orgabird-kalender"
    "gauderio"
    "all-in-one-must-have"
    "suspended-lists-for-sportspress"
    "cosmic-normalizer"
    "jebe-cute-social-slide"
    "wb-embed-code"
    "awesome-gallery-singsys"
    "reveal-box"
    "advamentor"
    "easy-text-to-speech"
    "my-askai"
    "clicklease-buttons"
    "wpkmkz-tweet-blockquotes"
    "bijbelteksten"
    "edd-quickpay"
    "mm-content-manage"
    "user-register-filter"
    "printy6-print-on-demand"
    "gp-require-login"
    "lh-image-renamer"
    "esb-testimonials"
    "recent-categories"
    "simple-history-cards"
    "post-to-mailchimp"
    "planet-blockchain-coin-explorer"
    "qode-variation-swatches-for-woocommerce"
    "newor-media"
    "automatic-product-categories-for-woocommerce"
    "shalom-world-media-gallery"
    "beyondcart"
    "cpt-descriptions"
    "social-share-by-7span"
    "acf-slick-slider"
    "https-force"
    "woo-order-pending-to-cancelled-email"
    "woo-delivery-club-export"
    "instant-seo"
    "multiple-files-for-contact-form-7"
    "wizardsoft-wp-job-manager-recruit-wizard-add-on"
    "wp-infeed-post"
    "show-ip-info"
    "open-schema-data"
    "display-posts-shortcode-current-page-custom-field-add-on"
    "alidani-contact-form"
    "sentiment-analysis"
    "smntcs-show-symlinked-plugins"
    "greencon"
    "option-page-addon-for-acf"
    "live-photos"
    "optimize-redis-post-views"
    "comment-limiter"
    "data-captia"
    "share-tamil"
    "zaki-sitemap"
    "blipfoto-importer"
    "zamen"
    "affiliate-booster"
    "blue-sky-chat"
    "ni-daily-sales-report-for-woocommerce"
    "aitrillion"
    "wp-petfinder"
    "pakke"
    "smart1waze-floating-widget"
    "valuecommerc-registration"
    "sponsored-article-content"
    "invoicebox-payment-gateway"
    "quickorder"
    "zippem"
    "connections-cestina"
    "wp-tag-magic"
    "breezeview"
    "simple-smtp-mailer"
    "amazing-linker"
    "sp-blog-designer"
    "as-english-admin"
    "themeregion-companion"
    "curved-text"
    "mhstudio-hubspotform"
    "make-email-customizer-for-woocommerce"
    "easy-addons-for-elementor"
    "hello-security"
    "full-twitter-integration"
    "wp-clean-up-deo"
    "newsmax-article-widget"
    "remove-special-characters"
    "c4d-image-widget"
    "mtg-tutorde-cardlinker"
    "sb-random-posts-widget"
    "map-categories-to-attachment"
    "shortcode-query-posts-by-selected-category"
    "open-platform-gateway"
    "dr-affiliate"
    "balfolk-tickets"
    "addressbar-meta-theme-color"
    "spiritual-gifts-test"
    "chatzi"
    "newsletter-composer"
    "seo-copywriting"
    "automatic-login"
    "snillrik-restaurant-menu"
    "wp-truncate-content"
    "epim-api-importer"
    "advanced-product-table-for-woocommerce"
    "back-to-the-theme"
    "recent-logins"
    "ace-social-chat"
    "better-oembed-video"
    "dataqlick-inventory-sales-sync-to-accounting"
    "image-gallery-vertical-bar"
    "lemon-hive-modules-for-beaver-builder"
    "international-phone-number-format"
    "jpress-archive"
    "knock-on-wood-redirect"
    "custom-color-popup"
    "admin-ajax-php-no-thank-you"
    "dental-optimizer-patient-generator-app"
    "qreuz"
    "mc-server-status"
    "data-soap-validation"
    "dev-theme"
    "disable-admin-bar-for-non-admins"
    "region-generation-by-fuel-type-widget"
    "checkout-styler-for-easy-digital-downloads"
    "tao-form-ajax"
    "pixelbeds-channel-manager-booking-engine"
    "search-taxonomy-gt"
    "rs-simple-category-selector"
    "like-and-read"
    "gh-profile-widget"
    "author-posts-shortcode"
    "dont-stage-me-bro"
    "split-back-order"
    "wp-disable-right-click"
    "simple-social-sharing-buttons"
    "onclick-scroll-to-top-button"
    "bwtf-waterquality"
    "woo-masterway"
    "gallery-of-animated-posts"
    "css-selectors"
    "css-js-query-string-remover"
    "wp-request-callback"
    "last-post-edited-author"
    "blockprotocol"
    "sx-bootstrap-carousel"
    "fundamine-inline-comments-highlights"
    "users-box"
    "another-steempress"
    "ninja-van-my"
    "save-button"
    "kotobee"
    "comment-admin-notifier"
    "skt-paypal-for-woocommerce"
    "gf-binder"
    "smart-featured-image"
    "mysitesmanagercom-updates-checker"
    "tivwp-dm-development-manager"
    "swrei-review-exim"
    "awesome-social-media-icons"
    "guavapay-gateway"
    "post-tags-widget"
    "extended-shortcodes-for-ultimate-membership-pro"
    "pop-up-homepage"
    "rating-writing"
    "light-modal-block"
    "validar-rut-chile-con-cf7"
    "unofficial-polldaddy-widget"
    "mail-ru-fix"
    "video-popup-block"
    "clicksendsms"
    "back-to-top-up"
    "role-based-hide-adminbar"
    "wp-login-customize"
    "wp-footnotes-to-yafootnotes"
    "microplugins"
    "core-updates-permission"
    "ilannotations"
    "dokan-kits"
    "dadevarzan-wp-download"
    "dashamail"
    "publishers"
    "q2w3-screen-options-hack-demo"
    "most-liked-posts"
    "confirm-js-for-contact-form-7"
    "email-mentioned"
    "twpw-roll-over-gallery"
    "kolorweb-access-admin-notification"
    "covermanager"
    "invelity-sps-connect"
    "wp-link-list"
    "football-grid-squares"
    "gti-factura"
    "smart-popup"
    "full-screen-zoomer"
    "demomentsomtres-wc-cadeau"
    "woo-admin-licenses"
    "wc-order-splitter"
    "referrer-analytics"
    "formspammertrap-for-contact-form-7"
    "contact-form-zero"
    "we-client-logo-carousel"
    "collabim"
    "wp-circliful"
    "skins"
    "recent-sales-popup-for-web-hosting-companies-and-whmcs-users"
    "imagen-del-dia"
    "wpnibbler"
    "on-pandora"
    "clickskins"
    "always-show-excerpts"
    "optinable"
    "bbp-post-first"
    "find-unused-images"
    "mosaic-gallery-by-widgetic"
    "bbp-bulk-unsubscribe"
    "depict"
    "edit-registration-date"
    "simple-excerpt-generator"
    "icaal-quoting-engine"
    "better-wp-search"
    "wcpscr-product-search-category-redirect"
    "widget-compostelle-info"
    "liquidpoll-fluent-crm-integration"
    "bible-buddy"
    "ux-ultimate"
    "advanced-sequential-order-number-for-woocommerce"
    "aio-contact-lite"
    "simple-pinterest-feeds"
    "sell-esim"
    "agile-crm-landing-pages"
    "ab-post-to-email"
    "sadded-by-sadad"
    "binary-job-listing"
    "insert-image-alt-text"
    "wp-amember-login"
    "email-not-required"
    "api-video"
    "wprs-shortcodes"
    "page-translator"
    "metro-share-social-fonts"
    "wc-rcp-level-pricing"
    "userchat"
    "mc-service-worker-cache"
    "block-chat-gpt-via-robots-txt"
    "visibility-for-siteorigin"
    "lbstopattack"
    "ippopay-for-woocommerce"
    "disable-rest-api-wp-json-and-oembed"
    "import-emails-to-gmail-contacts"
    "change-logo-login"
    "wp-static-cache"
    "wp-gap-notification"
    "ai-data-science-templates-for-elementor"
    "peppercan-mailing-list"
    "tr-all-shortcodes"
    "callsheet"
    "change-from-address"
    "language-notice-for-multilanguage-site"
    "morpcs-air-quality-widget"
    "formidable-select-optgroup"
    "free-forms-and-college-search-widget"
    "scoreboard-ui"
    "gsy-ajax-recent-posts"
    "responsive-grid-quick-view-posts"
    "no-more-enclosures"
    "wg-bootstrap-carousel"
    "flowdust"
    "term-pages"
    "pubjet"
    "generatore-pagine-seo"
    "applause"
    "envynotifs"
    "ws-jobvite"
    "rsv-google-maps"
    "coded-hero-image-lite"
    "agile-crm-newsletter"
    "placeholder-content"
    "debt-countdown-clock"
    "denk-internet-solutions"
    "affiliate-reviews"
    "custom-post-accordion"
    "gmo-social-connection"
    "pipwave-woocommerce"
    "boleto-sicoob-facil-cnab-240"
    "quicktwitterlink"
    "show-next-upcoming-post-snup-widget"
    "meta-box-gallerymeta"
    "techopialabs-backups"
    "hide-generator-version"
    "export-import-for-woocommerce"
    "contact-address-with-google-map-location"
    "better-adsense"
    "ks-ads-widget"
    "eacsoftwareregistry-software-taxonomy"
    "pwa-by-intelvue"
    "monri-payments"
    "simple-clean-content"
    "paygine"
    "latest-posts-with-restful-api"
    "razorpay-subscription-button-elementor"
    "sendapi-net"
    "staatsverschuldung-schuldenuhr-brd"
    "category-title-prefix"
    "woocommerce-add-shipping-address-to-addressbook"
    "contact-from-product-tab-woocommerce"
    "wp-game-of-life"
    "one-click-lightbox"
    "kmm-flattable"
    "snow-time"
    "special-promotion-and-support"
    "faq-accordion-by-widgetic"
    "technoscore-bing-conversion-tracking"
    "cornell-notes"
    "maintenance-activator-elementor"
    "simplepostlinks"
    "pyxis-mobile-menu"
    "wp-inside"
    "marijuana-menu-by-wheres-weed"
    "bubuku-post-view-count"
    "e-commerce-shipping-insurance"
    "blocks-for-discogs"
    "capitalized-wp-titles"
    "wp-weixin-broadcast"
    "sales-trends-analysis-for-woocommerce"
    "did-you-mean-by-serverlin"
    "locatorlte"
    "frontkit"
    "career-page-by-vivahr"
    "nearby-now-reviews"
    "mysql-query-cache-stats"
    "ablocks"
    "c4d-woo-category-product-perpage"
    "force-textxml-as-mime-type-in-the-feed"
    "hiilite-creative-group-branding"
    "titan-elements"
    "payarc-payment-gateway"
    "fast-beavercontrol"
    "gumroad-shortcode"
    "schema-shortcode"
    "responsive-ads-generator-lite"
    "dm-contact-form-7-db"
    "sifalo-pay"
    "wowholic-core"
    "consumer-loans-payments-via-saltpay-for-woocommerce"
    "lzd-skyway-webrtc"
    "myopenid-delegation"
    "image-gallery-custom-post-type"
    "blighty-pluginator"
    "atticthemes-likes"
    "hide-cart-when-empty"
    "img-fluid"
    "pilotpress-custom-redirect"
    "return-excerpt"
    "pdf-invoice-and-more-for-woocommerce"
    "optimizely-project-snippet-embedder"
    "vl-cloudflare-cache-purge"
    "ispring-learn-jwt"
    "killer-further-reading"
    "eacsimplecdn"
    "advanced-team-block"
    "woo-price-display"
    "integrate-ticket-master"
    "vp-scroll-to-top"
    "givewp-toolbar"
    "edd-discounts-by-time"
    "shortcode-express"
    "gravity-forms-fancy-select"
    "any-posts-widget"
    "singsys-responsive-slider"
    "windup"
    "post-likedislike"
    "ai-mind"
    "empik-for-woocommerce"
    "product-support-now"
    "delay-load-any-content"
    "go-top"
    "isset-video"
    "mklasens-dynamic-widget"
    "wpm-only-one-buy-by-all-time-free-by-wp-masters"
    "authorized-digital-sellers-txt"
    "bp-block-member-posting"
    "disposable-email-blocker-gravityforms"
    "jreferences"
    "wp-stardate"
    "fasta-credit-for-checkout"
    "rs-user-access"
    "easy-seo-toolbox"
    "jvm-protected-media"
    "multiple-range-slider-for-gravity-form"
    "flusso-ai-generated-content"
    "bulk-remove-users"
    "rafa-tinymce-iframe"
    "wp-lessn"
    "post-type-url-changer"
    "rs-google-analytics"
    "resources-review"
    "search-terms-cloud"
    "wp-tech-lookup"
    "restrict-date-for-elementor-forms"
    "simple-gallery-with-filter"
    "gutenstrap-blocks"
    "integration-for-elementor-forms-asana"
    "code-cleaner"
    "media-recode-custom-modules"
    "personal-authors-category"
    "redirectto"
    "awesome-alert-blocks"
    "block-registered-usernames"
    "simple-tel-tracking"
    "wp-featured-image-widget"
    "price-per-unit-for-wc-product"
    "simple-social-share-block"
    "showcase-your-team"
    "trialfire"
    "it-popups"
    "cinda-citizen-science"
    "list-of-users-posts-widget"
    "tips-shortcode"
    "shortcache"
    "advanced-post-password"
    "automatic-copyrights-shortcode"
    "press-release-template"
    "pygment-it"
    "image4io"
    "tides"
    "random-block"
    "sexbundle"
    "wats-latest-tickets-widget"
    "tagmaker"
    "social-sharer-for-woo"
    "book-author-bio"
    "fluid-customizer"
    "limit-quantity-for-woocommerce"
    "tw-shortcodes"
    "wp-user-summary"
    "wp-post-status-notifications"
    "code-monitor"
    "hide-related-products"
    "slogan-rotator"
    "irdinmo-para-inmovilla"
    "omnisend-for-ninja-forms-add-on"
    "furikake"
    "plot-over-time-extended"
    "wp-mp3-embed"
    "booking-chatwing"
    "postgenerator"
    "safe-block-editor"
    "social-profile-icons"
    "social-custom-share"
    "gdp-social-overlay"
    "limesquare-tweaks"
    "awesome-slider-block"
    "elastik-addons-for-wpbakery"
    "sticky-posts-dashboard-widget"
    "woo-products-coming-soon"
    "post-editing-toolbar"
    "postmatic-for-gravity-forms"
    "visual-slider"
    "nadaft-kpr-simulation"
    "fix-and-flip-calculator"
    "easy-icon-grid"
    "woo-jet-integration"
    "ep-woocommerce-checkout-address-autocomplete"
    "keyboard-scroll"
    "wp-aceeditor"
    "create-meta-tags"
    "dashboard-for-beginer"
    "pb-addons"
    "atensiq-connector-for-woocommerce"
    "sales-order-report-for-woocommerce"
    "wp-slider-images-from-posts"
    "simple-random-posts-shortcode"
    "wpb-circliful"
    "shortcode-mastery-lite"
    "auto-import-coupons-from-vcommission"
    "multisite-blog-ids"
    "icontact-forms"
    "surf-conditions"
    "responsive-twitter-feeds"
    "wp-helper"
    "first-picture-as-featured-image"
    "twitter-tags"
    "medianova-cdn"
    "om-stripe"
    "answerforce"
    "qrlogin"
    "kitab"
    "wpdevdesign-browser-detect-for-oxygen"
    "daily-bible-verse"
    "boost-yoast-analysis-cfs"
    "logic-hop-personalization-for-divi-add-on"
    "wp-spatial-capabilities-check"
    "schedule-disponibilities"
    "ipost"
    "schedule-content"
    "gdpr-visitor-consent"
    "wp-publisher"
    "va-excerpt-from-content"
    "hierarchical-bookmark-system"
    "advance-news-ticker"
    "avoid-linkback-abuse"
    "fast-woo-order-lookup"
    "bang-vulnerability-scanner"
    "wp-display-faq"
    "jifiti-buy-now-pay-later"
    "fast-fancy-filter-3f"
    "psmailer"
    "easy-bruteforce-protect"
    "customize-drag-n-drop-system-limitless"
    "my-social-widgets-with-shortcode"
    "showcase-payment-options-icons"
    "dpepress"
    "servicepress"
    "commenter-ignore-button"
    "inhouse-tutorials-rss-feed-dashboard-widget"
    "currency-code"
    "mandegar-feed"
    "advanced-s3-uploads-config"
    "change-add-to-cart-text"
    "goal-tracker"
    "simply-change-author-url"
    "affiliate-product-ads-for-amazon-associates"
    "advanced-hotjar"
    "cf7-shortcode-finder"
    "fp-front-end-login-form"
    "comment-tweaks"
    "wp-page-builder"
    "wp-emoticon-rating"
    "what-im-currently-reading"
    "ds-woocommerce-next-previous-category-products"
    "curator-studio-youtube"
    "klump-wc-payment-gateway"
    "privacy-notice"
    "rj-quick-empty-trash"
    "getcontentfromurl"
    "woo-erc20-payment-gateway"
    "edd-promo"
    "dynamic-pricing-for-woocommerce"
    "simpleform-akismet"
    "wp-users-login-history"
    "flexible-subscriptions"
    "js-injector"
    "content-author-accessibility-preview"
    "integration-for-beaver-themer"
    "show-var-dump"
    "seeder"
    "formataway"
    "wc-filter-by-multiple-tax"
    "bspb-progressbar"
    "loginout"
    "mipl-wc-checkout-fields"
    "wireless-butler"
    "digital-signature-checkout-for-woocommerce"
    "healthengine-online-booking-widget-installer"
    "table-builder"
    "external-posts"
    "testimonial-carousel-block"
    "wp-recreate-thumbnails"
    "wp-custom-comments"
    "timeline-diagram"
    "maxtarget"
    "reddicomments"
    "home-improvement-companion"
    "content-audit-exporter"
    "geargag-toolkit"
    "qwebmaster-ai-auto-tagger"
    "outbound-links-monetization"
    "bcorp-slider"
    "sms-verification-pars"
    "docus"
    "multisite-logout-all-users"
    "invelity-gls-parcelshop"
    "wpessential"
    "ringgitpay"
    "simple-buddypress-notifications"
    "wp-fragmention"
    "right-intel"
    "wp-export-db-sql-file"
    "moveup"
    "wp-sms-vatansms-com"
    "hngamers-atavism-user-verification"
    "any-custom-field"
    "idnich"
    "block-carbon-code"
    "rubytabs-lite"
    "beam"
    "prihlasovanie-na-svate-omse"
    "wp-super-network"
    "postless"
    "time-since-shortcode"
    "hotspot-ai"
    "my-tables"
    "ot-social-icons"
    "better-gravatar-generated-icons"
    "embeds-for-proven-expert"
    "discuss-on-twitter"
    "performance-checker"
    "spamassassin-preferences"
    "kl-debug"
    "wp-iletimerkezi-sms"
    "virtual-queue"
    "comment-mention-notifications"
    "disable-unused-features"
    "remove-social-id"
    "gst-for-woocommerce"
    "rng-refresh"
    "woo-invoice-online-rechnungen-de"
    "comment-closer"
    "frais-pro"
    "wordpress-writing-tips-plugin"
    "christmas-effect"
    "moving-banner"
    "santo-do-dia"
    "topbible"
    "video-player-pro"
    "wpseokit"
    "farbige-boxen-shortcodes-by-mediaoase"
    "show-some-love-kikicoza"
    "aircraft-builders-log-time-tracker"
    "remove-query-arg-from-media"
    "gdpr-cookie-notice"
    "automatic-updates"
    "adminsanity"
    "ziggeo-video-for-bbpress"
    "cool-like-dislike"
    "nm-google-map"
    "writers-block"
    "unhide-contact-form-7-mouse-over"
    "rigorous-social-share"
    "customized-login"
    "hatch"
    "flex-qr-code-generator"
    "special-characters-remove"
    "mc-annual-upcounter"
    "wp-developers-toolbox"
    "image-alt-fixer"
    "wp-protect-admin-login"
    "za-my-favorite-plugins-installer"
    "single-posts-ext"
    "cf7-israeli-phone-validation"
    "signalzen"
    "make-featured-image-link-to-blog-post"
    "massive-addons-for-wp-blocks"
    "multireplace"
    "easyverein"
    "advance-category-posts-widget"
    "mb-simple-user-avatar"
    "simple-pricing-table"
    "edd-product-table"
    "easy-responsive-slider"
    "wp-spam-ip"
    "mailchimp-subscribe-for-food-cook-theme"
    "linkrex-monetizer"
    "rebel-cookies-notification"
    "agile-crm-webrules"
    "nf-conditional-actions"
    "paragon-profile"
    "ha-banners"
    "hlc-sql-window"
    "sensitive-chinese-words-scanner"
    "point-tracker"
    "90-in-90"
    "zoom-img"
    "eso-hub"
    "tungtop-quick-preview-post"
    "dokan-product-validation"
    "wp-atomic-content"
    "reviewdrop"
    "pablo-career"
    "ciusan-simple-statistics"
    "multistep-checkout-for-woocommerce-by-codeixer"
    "mobile-cost-control-automated"
    "includer"
    "ultimakit-for-wp"
    "manage-user-avatar"
    "gist-for-elementor"
    "pramadillo-priceline-partner-network"
    "agenturbo-google-remarketing"
    "dmg-text-widget"
    "wp-pears"
    "affiliate-videohive-widget"
    "versatile-jquery-slider"
    "phc-fx-woocommerce"
    "media-tags-gallery"
    "cmc-hook"
    "pro-addons-for-elementor"
    "404-to-search"
    "disable-automatic-updates-and-theme-editors"
    "product-qa-for-woocommerce"
    "project-adv-inserter"
    "benefits"
    "admin-speedo"
    "foureyes"
    "presscode"
    "blog-blocks"
    "tidekey"
    "comments-deletion"
    "mail-next"
    "dadevarzan-wp-resume"
    "egenius-goup"
    "ultimate-sms"
    "after-order-discounts-for-woocommerce"
    "dexs-counter"
    "woo-question"
    "wplms-sensei-migration"
    "statistinator"
    "panda-reviews"
    "bdtask-booking365"
    "wp-password-protect-publication"
    "loginator"
    "wp-mail-manager"
    "payment-gateway-for-m-pesa-open-api"
    "convertkit-membermouse"
    "manage-upcoming-release"
    "ripple-effect-background"
    "write-jquery"
    "easy-options-redirect-to-checkout-per-product-wc"
    "htm-customareas"
    "space-checker"
    "dai-pho-keywords-generator"
    "simple-share-sticky"
    "elementwoo"
    "next-page-caching"
    "turtle-ad-network"
    "amitabh-bachchan-songs"
    "price-alert-woocommerce"
    "contentify-ai"
    "pryc-wp-sanitize-file-name-when-upload"
    "epic-addons-for-elementor"
    "admin-edit-comment"
    "autoads-premiere"
    "avangpress"
    "quote-of-the-day-by-forameal"
    "shubaloo"
    "bangla-font"
    "simple-contacts-manager"
    "last-email-address-validator"
    "accordion-title-for-elementor"
    "serwersmspl-widget"
    "pxp-press"
    "duamatik"
    "creative-socials"
    "digthis-action-filters"
    "gotcha-user-centric-analytics-triggers-driven-by-micro-surveys"
    "shopgate-connector"
    "nsa-update-database-urls"
    "wp-recipe-manager"
    "acf-beautiful-flexible"
    "innvonix-testimonials"
    "mis-leads-contact-form-7"
    "gna-send-post"
    "suresms"
    "zoomph"
    "ivysilani-shortcode"
    "admin-events-extended"
    "second-default-language"
    "deshi-news-aggregator"
    "4nton-accordion"
    "float-gateway"
    "wp-archive"
    "kulinarian-recipe-embed"
    "visitors-info"
    "netnovate-salessurvey"
    "ab-show-thumbs-on-post"
    "advanced-footnotes"
    "wp-admin-notification"
    "frontend-as-any-user"
    "dream-agility-tracking-pixel"
    "online-consultant"
    "fancy-fiter"
    "follow-bbpress"
    "wp-stock-sync"
    "freeinvoice-api"
    "simply-slider"
    "dao-login"
    "formatting-extender"
    "enblocks"
    "cool-admin-theme-lite-for-wp"
    "nice-latest-news-ticker"
    "paperview-publisher"
    "post-useful"
    "my-timeline-blog"
    "rich-meta-in-rdfa"
    "syncro-web-chat-2-text"
    "woo-photo-tags"
    "partnerize-partner"
    "metabox-creator"
    "payments-stripe-gateway"
    "robots-noindexfollow-meta-tag"
    "my-wp-accordion"
    "shoutcodes-lite"
    "profpanda-hidden-things"
    "instacontact"
    "post-listing"
    "tori-ajax"
    "appy-pie-connect-for-woocommerce"
    "inc-compound-interest-calculator"
    "forms-3rdparty-gravity-forms"
    "cf7-add-to-page"
    "sugester-for-woocommerce"
    "crm-salesforce-learndash-integration"
    "acf-db-field"
    "agile-crm-campaigns"
    "username-update"
    "preferabli-for-woocommerce"
    "cip-dtac-for-give"
    "fbc-latest-backup-for-updraftplus"
    "activecampaign-newsletter-subscription"
    "image-sizes-in-admin-dashboard"
    "woo-send-email"
    "wp-slup-md5code"
    "tip-my-work-hostjane-payments"
    "scroll-to"
    "embed-google-photos"
    "wp-pinboard"
    "oauth-client-muloqot"
    "pk-spam-registration-blocker"
    "simpaisa-ibft-payment-services"
    "blog-coach"
    "woocommerce-notices-fix"
    "sendpulse-live-chat-and-chatbot"
    "neznam-atproto-share"
    "light-weight-cookie-popup"
    "pay-io-payment-gateway"
    "soapberry"
    "rc-geo-access"
    "wp-download-counts"
    "plug-and-play"
    "freecaster"
    "mystem-edd"
    "windpress"
    "nafeza-coming-soon"
    "wp-courseware-convertkit-addon"
    "simple-payoneer-offsite-gateway-for-woocommerce"
    "purge-black-hat-seo"
    "unicef-tap-project-banner"
    "dl-uptocall"
    "eliteprospects-tooltips"
    "credits-system-for-woocommerce"
    "tietuku-avatar"
    "note-for-posts"
    "acclectic-lightbox"
    "check-php-memory-peak"
    "cointopay-gateway-for-easy-digital-downloads"
    "ainoblocks-patterns"
    "wc-westpac-payway-with-recurring"
    "tap-cookies"
    "dsdownloadlist"
    "hc-buy-now-button-for-woocommerce"
    "wplightbox"
    "wallet-login"
    "dealspotr-woocommerce-tracking"
    "wplo-survey"
    "purgebox"
    "tiny-simple-adblock-detector"
    "wp-wrap-images"
    "social-media-sidebar-icons"
    "mmbrs"
    "ltl-freight-quotes-day-ross-edition"
    "content-upgrade"
    "wp-admin-remote"
    "sectionly"
    "super-simple-cookie-bar"
    "custom-content"
    "editor-beautifier"
    "bp-profile-field-duplicator"
    "ia-map-analytics-basic"
    "files-inspector"
    "mobile-pay-bd"
    "foundation-shortcodes"
    "blaze-online-eparcel-for-woocommerce"
    "dotix"
    "aklamator-infeed"
    "wp-keyboard-style-key-symbol"
    "myshopkit-product-badges-wp"
    "easy-country-spam-blocker"
    "ledyer-order-management-for-woocommerce"
    "wparchivestree"
    "catag"
    "loft404"
    "climate-content-pool"
    "simple-ajax-search"
    "theme-to-browser-control-ie-pack"
    "samo-forms"
    "modern-photo-gallery"
    "vote-smiley-reaction"
    "mh-osoitekortti"
    "sarvarov-lazy-load"
    "get-replytocom-back"
    "exchange-rate-privatbank"
    "auto-product-after-upload-image"
    "ac-change-login-logo"
    "leadsource-tracker"
    "my-custom-style-css-manager"
    "stackla"
    "voice-shopping-for-woocommerce"
    "ithoughts-html-snippets"
    "jeba-filterable-portfolio"
    "jl-login-logo"
    "zeitstrahler"
    "woo-autoload-cart"
    "samurai"
    "magic-buttons-for-elementor"
    "member-directory"
    "luzuk-team"
    "list-item-filter"
    "easy-popups"
    "birch-layered-nav"
    "addressbar-theme-color"
    "page-keys"
    "random-blog-description"
    "wp-switch-util"
    "blinds"
    "wp-c5-exporter"
    "urwa-for-bbpress"
    "cashback"
    "block-email-formidable-form"
    "multi-level-pop-menu-addons"
    "kagoya-typesquare"
    "wp-show-category-id"
    "hiecor-divi-modules"
    "wp-file-word-counter"
    "post-format-block"
    "erana-icons-font-for-visual-composer"
    "drim-share"
    "ga-google-analytics-by-esteem-host"
    "covid-19-corona-virus-report"
    "collectionpress"
    "nepali-chrono-craft"
    "multilingual-template-hierarchy"
    "bp-profile-field-repeater"
    "everyscape-viewer"
    "c4d-related-post"
    "bx-carousel-ultimate"
    "shiborikomi-alpha-premium"
    "wpufile-ucloud"
    "unified"
    "block-collections"
    "sango"
    "update-privacy"
    "super-simple-spam-stopper"
    "remind-me-to-change-my-password"
    "sc-simple-seo"
    "chatplusjp"
    "panelhelper"
    "allergens-for-woocommerce"
    "cyrillic-to-latin"
    "mailflatrate"
    "omnicommerce-connector-for-woocommerce"
    "c4d-social-share"
    "site-sitemap"
    "drafty-in-here"
    "hellobox"
    "fake-admin"
    "fresh-podcaster"
    "kundgenerator"
    "video-expander"
    "sales-metrics-for-easy-digital-downloads"
    "zaki-push-notification"
    "andreadb-coin-slider"
    "lr-faq"
    "shiga-custom-login-by-corelabs"
    "modern-qr-code-generator"
    "inline-shortcodes-for-bootstrap"
    "dashboard-posts-label-to-articles"
    "simplexis-woocommerce-backordered-products"
    "wp2tianyas"
    "scroll-me-up"
    "easy-pagination-control"
    "machine-learning-antispam"
    "dev-con-form"
    "maxi-bg"
    "wp-webdoctor"
    "noindex-author"
    "wp-sha1"
    "lightweight-html-minify"
    "smart-categories"
    "page-identifier-column"
    "powerpress-getid3"
    "zoospas-project-for-hakaton"
    "mindbody-access-management"
    "faq-schema"
    "randomtips"
    "mail-deactivation"
    "cb-default-content"
    "cv-menu"
    "pluginspired-login-customizer"
    "acquaintsoft-sidebar-generator"
    "football-preloader"
    "hello-obi-wan"
    "gm-variations-radio-buttons-for-woocommerce"
    "wc-hkdigital-acba-gateway"
    "wp-shapes"
    "social-network-widget"
    "job-listings-job-alert"
    "eps-cart-toggle-attributes"
    "ht-social-share"
    "soivigol-post-list"
    "wp-fix-search-function-search-only-posts"
    "toolbar-jch-optimize"
    "woo-banorte"
    "debianfix"
    "dismiss-browser-nag"
    "wordcast"
    "whook-security"
    "digilan-token"
    "super-sitemap-for-seo"
    "w3sc-elementor-to-zoho"
    "cd-nutritional"
    "uk-vehicle-data-api"
    "wp-iconics"
    "woocommerce-free-shipping-to-the-lower-48-states"
    "xcid-beans-rewards-for-woocommerce"
    "mhr-post-ticker"
    "usher"
    "native-wp-excerpt"
    "ultimate-3d-testimonial-slider"
    "custom-labels-for-wp-posts"
    "light-ab-testing"
    "read-more-read-less"
    "spam-blocker-s1"
    "scouttroop"
    "rdp-pediapress-embed"
    "optimized-product-photos"
    "section-posts"
    "ggcategoryautoupdate"
    "lh-add-id-columns"
    "wp-recent-posts"
    "sirve"
    "enquiry-woo"
    "user-post-on-social-network"
    "remove-post-attachment"
    "grid-avoid-doublets"
    "woobytes-gateway"
    "super-simple-quiz"
    "ultimate-product-tab"
    "remind101"
    "posts-and-products-statistics-for-woocommerce"
    "cyba-advanced-search"
    "musician-press"
    "tc-visitors-tracker"
    "voice-search-for-woocommerce"
    "unity-users-birthday-email"
    "capitalize-title"
    "gntt-date-time"
    "broadcast-call-to-actions"
    "simple-custom-admin"
    "okupanel"
    "print-basic-facts"
    "wp-login-control"
    "addons-espania"
    "blog-reading-progress-bar"
    "mono-checkout"
    "product-stock-alert-woocommerce"
    "acf-rest"
    "embed-pdf-wpforms"
    "breview"
    "vulners-scanner"
    "e-billing-moyen-de-paiement-woocommerce"
    "multilang-comment"
    "wp-brightcove-portal"
    "rewrite-slug-before-publishing-a-post"
    "password-generators"
    "mindvalley-hispano-any-page-embed"
    "password-reset-enforcement"
    "display-content-length"
    "healthcare-review-master"
    "add-google-analytics-to-wp"
    "hot-offer-text-add-for-woocommerce"
    "recommendations"
    "large-images-uploader"
    "woosearch"
    "yml-for-snippets-new-webstudio"
    "i9-idxpress"
    "multiupload-field-for-contact-form-7"
    "wp-mini-admin-bar"
    "coffeeblack-bbpress-extended"
    "square-candy-tinymce-reboot"
    "livechatoo"
    "native-image-lazy-loading"
    "add-exif-and-iptc-meta-data-to-attachment"
    "hello-star"
    "gitple"
    "simple-alert-for-old-post"
    "ambassador"
    "summary-page"
    "my-desktop"
    "seedtag"
    "wish-to-go"
    "total-simple-contact-form"
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

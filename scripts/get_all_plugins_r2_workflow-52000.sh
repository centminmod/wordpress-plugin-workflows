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
    "rentme-woo"
    "embed-javascript-file-content"
    "shape-master"
    "hide-admin-bar-or-toolbar"
    "email-domain-validator-for-woocommerce"
    "wp-best-sitemap-generator"
    "makis-events"
    "dn-popup"
    "keybe-abandoned-cart"
    "appture-pay"
    "power-abm"
    "widgets-olakala"
    "merchantx"
    "content-slider-with-tiny-slider"
    "kupay-for-woocommerce"
    "devgirl-reviews-slider"
    "happymap"
    "category-assign-in-post"
    "zt-mailchimp-subscribe"
    "sig-ga4-widget"
    "liquid-edge-login-page"
    "wp-change-logo"
    "rsg-retrieve-google-drive-spreadsheet"
    "js-post-filter"
    "recoverexit-for-woocommerce"
    "responsive-team-showcase"
    "sm-recent-posts"
    "infinity-tnc-divi-modules"
    "comment-form-validation-and-customization"
    "svg-heroicons-block"
    "youcam-makeup"
    "grid-masonry-for-guten-blocks"
    "feedier-go-beyond-feedback"
    "product-price-markup-for-woocommece"
    "tma-signature"
    "epic-popup-creator"
    "schedule-notice-banner"
    "word-security"
    "wp-extended-data-to-rest-api"
    "subject-registration-addon"
    "ajax-comments-refueled"
    "wp-inspire"
    "frenchmap"
    "apithanhtoan-ty-gia-ngan-hang"
    "payhow"
    "nw-company-profile"
    "wpik-wordpress-basic-ajax-form"
    "tkt-tree-view"
    "itg-amazon-feed"
    "online-results-cookie-manager"
    "woo-app-sms-server"
    "mowomo-no-default-fullscreen-mode"
    "start-my-review"
    "lightbox-ga"
    "simple-yt-widget"
    "global-bootstrap-banner"
    "wp-live-post-search"
    "ordering-system-ord-to"
    "seo-generator"
    "fight-on"
    "antylaykaua"
    "yourcareeverywhere"
    "jalil-toolkit"
    "update-the-excerpt"
    "sanitize-db"
    "best-youtube-video-lazyload"
    "low-key-toolbar"
    "free-of-charge-badge"
    "simple-export-page"
    "insert-post-block"
    "zedna-contact-form"
    "abe-caf-donate"
    "progremzion-wootext-change"
    "top-rank-content-checker"
    "wp-easy-fibos-pay"
    "titlebar-effect"
    "smart-address-autocomplete-for-woocommerce"
    "wcik-pennsylvania-shipping"
    "dm-visitor-location-notification"
    "wp-mobile-content"
    "extended-widgets-addon-kit-for-elementor"
    "saint-of-the-day"
    "apoyl-captcha"
    "ppc-masterminds"
    "address-autocomplete-using-nextgenapi"
    "random-post-redirect-also-with-shortcode"
    "webico-security-setting"
    "social-photo-blocks"
    "dynamically-display-posts"
    "advanced-composer-blocks-for-newsletter"
    "ncm-api"
    "fusion-faqs-schema"
    "sso-freshdesk-support-integration"
    "jinx-block-renderer"
    "woo-transact-io-gateway"
    "custom-admin-login-logo"
    "crypto-price-ticker-coinlore"
    "awsa-quick-buy"
    "ele-ui-color-scheme-restoration"
    "stax-payments"
    "docodoco-store-locator"
    "redirect-thank-you-page"
    "simple-log-viewer"
    "edit-profile-fields"
    "limit-login-sessions"
    "lh-javascript-error-log"
    "splashmaker"
    "zedna-twitter-quotes"
    "custplace-widgets"
    "add-html-after-url"
    "reusable-block-count"
    "blowhorn-logistics-same-day-delivery"
    "enico-micropagos"
    "secure-message"
    "psx-daily-quotes"
    "wui-widgets-user-interface"
    "st-social-feed"
    "defer-media"
    "today"
    "casia-blocks"
    "pi-forms-s3-upload"
    "kontxt"
    "simplificar-menu-de-administracion"
    "real-estate-property"
    "openhousevideo"
    "bw-coronavirus-banner"
    "extraction-of-products-and-categories-for-mazzaneh-official"
    "wc-key-manager"
    "screenshot-to-media"
    "disable-sitemap"
    "digital-product-support-for-woocommerce"
    "wp-search-exclude-categories-and-tags"
    "really-simple-feedback"
    "share-theme"
    "job-listings-from-remoteok-io"
    "ee-simple-file-list-media"
    "social-proof-for-woocommerce"
    "conpay-checkout"
    "next-purchase-discount-for-woocommerce"
    "dividelo"
    "extreme-search-suggestion-for-woocommerce"
    "wp-violet"
    "membership-management"
    "dfb-form"
    "woo-with-zoho-crm-integration"
    "lenxel-core"
    "wskr-posts"
    "she-lotusscript-brush"
    "exit-popups"
    "wc-z4money"
    "lead2team"
    "hide-blocks"
    "wcookie"
    "traum-captcha"
    "wooflare"
    "sb-latest-posts"
    "virtual-downloadable-only-products-for-woocommerce"
    "cloudburst-messenger-bubbles"
    "cleandash"
    "wp-rouble-rate"
    "our-google-map"
    "dapre-custom-fields-tools"
    "image-align-addon"
    "n-letters-send-newsletters-to-your-websites-users"
    "notifications-bearychat"
    "wpmk-faq"
    "letitplay-widget-loader"
    "glossary-tooltip"
    "cartcount-for-woocommerce"
    "hide-expiry-warning-for-elementor"
    "whoframed"
    "junior-shopable-social-feed"
    "woo-sunaj-ccaavenue-payment-gateway"
    "testrobo-safe-update"
    "taxonomies-widget"
    "background-gradient-color"
    "simple-video-post"
    "martkit"
    "mail2many-registration"
    "smart-coming-soon-mode"
    "icon-widget-with-links"
    "category-post-list"
    "feecompass-rankings"
    "static-maps-editor"
    "sendsms-dashboard"
    "plugin-last-updated-warning"
    "mesa-mesa-reservation-widget"
    "rssunssl"
    "edd-integrapay"
    "shortfundly"
    "simple-customer-crm"
    "quick-admin-launcher"
    "wikidata-query-service-embeder"
    "wp-admin-two-factor-authentication"
    "html-block-with-highlighting"
    "test-content-generator"
    "websitez-com"
    "kantbtrue-content-bottom-ads"
    "featured-image-from-external-sources"
    "odk-call-action"
    "safer-wp-admin-login"
    "ut-wordpress-shortcodes"
    "worais-login-protect"
    "smartarget-button-builder"
    "protect-login"
    "flow-fields"
    "woo-extended"
    "ringotel-webchat"
    "wp-quick-update-featured-image"
    "canon-carepak-plus"
    "js-latest-new-updates"
    "verification-sms-targetsms"
    "wc-fettario"
    "wp-hide-add-new-theme"
    "questpass"
    "meu-cv-desafio21dias"
    "woo-points-manager"
    "clickable-featured-image"
    "daily-maxim-365"
    "widget-for-social-page"
    "e2u-ajax-subscribe-newsletter"
    "redbrick"
    "show-theme-style"
    "multiple-images-field"
    "webdome-cleaner-for-woocommerce"
    "gs-jwt-auth-and-otp-varification"
    "hide-dokan-promotional-banner"
    "shishi-odoshi"
    "acfist"
    "tomikup-wishlist"
    "howdy-to-salam"
    "wptao-app"
    "ajax-floating-cart"
    "renewable-energy-cpt"
    "virtuaria-pagbank-split"
    "robots-txt-extender"
    "static-mail-sender-configurator"
    "flickzee-where-to-watch-widget"
    "sb-related-posts"
    "zedna-load-more-posts"
    "container-fix-for-wp-visual-editor"
    "pacific-payment-gateway"
    "discount-for-woocommerce"
    "cover3d"
    "simple-post-counter-display"
    "editor-box"
    "casia-opening-times"
    "unloct"
    "yumjam-simple-map-shortcode"
    "krankenkassentest"
    "openapp-payment-gateway"
    "vforce-extensions"
    "blog-by-email-with-otto"
    "refpress"
    "limopay"
    "whitepay-for-woocommerce"
    "woo-product-fee"
    "heckler"
    "product-filter-addon-for-woocommerce"
    "wp-plc-connect"
    "mtasku-payment-for-woocommerce"
    "grit-portfolio"
    "pitchhub-embed"
    "aspl-quick-view-for-woocommerce"
    "espresso-diagnostics"
    "slashpress"
    "sublimetheme-advanced-addons-for-elementor"
    "exportyourstore"
    "skeps-review-widget"
    "egps-easy-sell-for-google-photo"
    "elvez-slim-site-header"
    "eacobjectcache"
    "niz-ajax-load-more-products-for-woocommerce"
    "infinity-testimonilas"
    "syscoin"
    "savage-note"
    "gholab"
    "wp-social-feed-gallery"
    "wp-realiable-cookie-bar"
    "woo-shipping-notifications"
    "chat-button-for-isl-pronto"
    "seo-friendly-ga"
    "postaga"
    "mylastminutes-api"
    "simple-webstats"
    "ai-moderator-for-buddypress-and-buddyboss"
    "messagemedia-for-woocommerce"
    "admin-todotastic"
    "webpage-view-count"
    "integration-qr-code-payment-gateway"
    "ss-map-md-streets-suggestions"
    "shortcode-directives"
    "imager"
    "paccofacile-for-woocommerce"
    "visibility-control-for-tutorlms"
    "verticalresponse-marketing-suite"
    "errandlr-delivery-for-woocommerce"
    "smartarget-message-bar"
    "easy-content-analysis"
    "drive-wp"
    "holiday-logo-switcher"
    "ultimate-post-recipe-light"
    "monster-one-sticky"
    "cwm-stylish-author-widget"
    "lz-accordion"
    "spamjam"
    "article-generator"
    "cf7woo"
    "pineparks-acf-auto-export-to-php"
    "vaeret"
    "unofficial-frill-sso"
    "service-tracker"
    "dastra"
    "lamboz-latest-post-widget"
    "ua-list-pages"
    "intrinsic-images-for-woo"
    "zweb-social-mobile"
    "wha-area-charts"
    "senpex-on-demand-delivery"
    "display-sale-percentage-value"
    "custom-content-elementor"
    "general-slider"
    "dvk-env-dev"
    "live-search-for-post"
    "yadore-widget"
    "wc-auto-coupon"
    "wc-prabhu-pay"
    "hylsay-email-smtp"
    "wp-system-snapshot"
    "responsive-calendar-widget"
    "wp-scroll-top"
    "captcha-for-comments-form"
    "tg-sms-notify"
    "smart-png-gif-and-jpeg-compression-and-manipulation-in-the-cloud-cdn-4eq"
    "photostack-slider"
    "jvh-wp-all-import-extender"
    "world-map-hd-interactive-maps-of-the-world"
    "sm-testimonial-slider"
    "onlim"
    "casia-counter-number"
    "disabling-user-enumeration"
    "pricing-table-addon-for-elementor"
    "odyssey-resumes"
    "gamification-email-collector-mikehit"
    "tonder-payments-gateway"
    "czater-pl"
    "wp-social-feeds"
    "demomentsomtres-order-shortcodes"
    "open-linked-event-data"
    "secure-login-captcha"
    "tn-gateway-for-woocommerce"
    "wpapi-prev-next-post"
    "easy-spinner"
    "tw-quickly"
    "kh-chatgpt-frontend-fun"
    "zwk-add-to-cart-button-label"
    "typewriter-anywhere"
    "wc-mqtt-alerts"
    "woo-telehooks-sms-notifications"
    "bulk-actions-for-product-feed-for-google"
    "howdy-to-assalamualaikum-converter"
    "buglog"
    "guild-raid-progression-for-wow-and-raider-io"
    "single-sign-on-into-talentlms-user-sync-integration"
    "wavesurfer-audio-player-block"
    "ssbd-contact-from"
    "monitoscope"
    "seo-assistant"
    "eukapay-cryptocurrency-payment-gateway-for-woocommerce"
    "user-activation-validate"
    "fastseen-lazyloading"
    "zestpush-web-push-notifications"
    "wp-ai-manager"
    "category-labels-block"
    "tariffuxx"
    "cryptocurrency-support-box"
    "wp-robots-warning"
    "sukellos-login-style"
    "irecord-form"
    "wp-remove-version-number"
    "wc-carte-cultura"
    "easy-timeline"
    "tweetific"
    "clear-comments"
    "admintosh"
    "easy-tag-and-tracking-id-inserter"
    "preeco-widgets"
    "wp-mapgrip"
    "clean-meta-descriptions"
    "subthree-link"
    "ship-to-multiple-addresses"
    "pawnbat-module"
    "privacy-embed"
    "superstore"
    "pay-invoices-with-amazon"
    "cdekfinance"
    "structured-data-google"
    "lh-clear-debug-log-by-cron"
    "enhanced-youtube-embed"
    "dblocks-codepro"
    "monetizer"
    "liquid-assets-for-woocommerce"
    "xlsjuice"
    "imaq-core"
    "ai-editor"
    "pressenter"
    "content-promoter"
    "woo-product-discount-flyer"
    "focus-keywords-pro"
    "skytake"
    "steply"
    "brief"
    "widget-navasan"
    "liane-form"
    "plugin-deactivation-notice"
    "badgeos-learndash-gateway"
    "quick-age-verification"
    "lynked-loyalty"
    "mchat"
    "chartlocal"
    "ouzayyts"
    "easy-banner"
    "scroll-top-pro"
    "easy-bricks-navigation"
    "tinet-vn-chat-buttons"
    "wc-products-coming-soon"
    "create-cached-wp-header-and-footer"
    "woo-greenlight-payments-gateway"
    "orange-smtp"
    "universal-link-in-bio"
    "pbrain"
    "responsive-pros-and-cons-block"
    "product-quantity-settings"
    "ai-knowledgebase"
    "zipline-smart-avatars"
    "feedback-fish"
    "vatansms-net"
    "orderbee"
    "o3-cli-services"
    "hooknotifier"
    "dg-announcer"
    "simple-point-quiz-for-woocommerce"
    "poll-dude"
    "total-reading-time-of-wp-post"
    "sellbery"
    "lien-he-nhanh"
    "wallnament"
    "search-products-pro"
    "edd-pdf-invoices-bulk-download"
    "better-customizer-reset"
    "limecall-widget"
    "fellow-lasku-for-woocommerce"
    "embed-code-for-woo"
    "vern-responsive-video"
    "as-zippy-courses-sendfox-integration"
    "emercury-extension-for-contact-form-7"
    "sample-content-for-acf"
    "posit-pos-integration-for-woocommerce"
    "smartarget-information-message"
    "ts-webfonts-for-iclusta"
    "simple-reuseblock-widget"
    "gf-entries-date-range-filter"
    "pagfort-boleto"
    "get-answer"
    "firepro"
    "amarkets-affiliate-links"
    "wp-deactivate-features"
    "related-posts-on-404-page"
    "gf-quorum-addon"
    "popular-posts-views"
    "proscores-live-scores"
    "post-read-unread-floating-sticky-button"
    "wp-post-visits-wizard"
    "rcp-view-limits"
    "sort-me-this"
    "easy-quick-order"
    "custom-post-list-order"
    "hello-positivity"
    "wp-ugc-comments"
    "stock-tracking-reporting-for-woocommerce"
    "nm-favourites"
    "mm-social"
    "isms-contact-form-with-2-factor-authenticator"
    "woo-customers-mail-list"
    "enable-automatic-update-for-all-plugins"
    "cf7-inbound-organizer"
    "dodebug"
    "scroll-up-iron-man"
    "sa-post-author-filter"
    "leadrebel"
    "blocks-scanner"
    "swipe-for-woocommerce"
    "video-bottom-tab-qr-embed-share"
    "ss-share"
    "simple-show-ids-column"
    "hadepay"
    "gibbertext"
    "pend-project"
    "gw-database-backup"
    "admin-bar-site-id"
    "woo-price-from-in-variable-products"
    "takepayments-ipp-payment-gateway"
    "payhelm-for-woocommerce"
    "pepper-connector"
    "yld-server-information"
    "blocktree"
    "get-by-taxonomycategory-parent-for-wp-rest-api"
    "simple-streamwood"
    "smartarget-social-sales"
    "woo-redshepherd-payment-gateway"
    "atelier-create-cv"
    "truvisibility-all-in-one-marketing-suite"
    "relevanzz"
    "do-not-display-my-password"
    "campwire"
    "wc-upress-gw"
    "analytics-tickera"
    "startend-subscription-add-on-for-gravityforms"
    "wpematico-rss-feed-reader"
    "chat-plus"
    "cart-update-without-button"
    "simple-gallery-lightbox"
    "ne-alt-tag"
    "front-tool-bar"
    "cs3lider"
    "pushdy-notifications"
    "wcspots"
    "force-default-variable"
    "under-construction-for-specific-pages"
    "link-with-note"
    "post-type-taxonomy-debug"
    "woo-mobikwik"
    "aspl-advance-report-for-woocommerce"
    "remove-post-using-ajax-in-admin"
    "org-departments"
    "data-track"
    "exchange-rate-belarusbank-by-atlas"
    "automatic-update-google-business-profile-reviews"
    "duitku-for-vik"
    "transportadora-zapex-woocommerce"
    "ajax-sendy-newsletter"
    "pcaviz"
    "sequential-invoice-numbers"
    "export-users-csv-records"
    "wp-logged-in-only-basic"
    "helpdeskwp"
    "peoplepress"
    "dh-rename-login-url"
    "block-pattern-maker"
    "focusable"
    "edusharing"
    "sales-map-for-woocommerce"
    "tracking-for-ups"
    "product-swiper-slider-gallery-for-woocommerce"
    "observo-monitoring"
    "better-search-and-replace"
    "wpgmap"
    "lore-owl-subcat-for-wc"
    "covid-19-toscana"
    "remove-xml-rpc-pingback"
    "loko-payment-gateway"
    "show-repos"
    "suggestion-toolkit"
    "ultimate-blog-layouts"
    "award-on-click-add-on-for-badgeos"
    "boffo"
    "fontflow-custom-icons-for-elementor"
    "oneai"
    "webp-attachments"
    "coronastatics"
    "property-management-software-unitconnect"
    "russian-post-for-dokan-marketplace"
    "ipauth"
    "shrtfly-integration"
    "fizzy-popups"
    "top-cta-bar"
    "ultimate-wp-multimedia-gallery"
    "rent-of-angry-cats"
    "inprosysmedia-likes-dislikes-post"
    "lana-text-to-image"
    "share-mxh"
    "woo-free-pricing"
    "webgoias-float-freeshipping-button-for-woocommerce"
    "wp-power-calculator"
    "post-templator"
    "mobile-wp-security"
    "wp-plc-tag"
    "likes-and-share-system-free"
    "flywire-payment-gateway-multicurrency-add-on"
    "ezdate"
    "avalon23-extension-pack"
    "uikar-registration"
    "wp-reviews-lite"
    "synchronize-editor-and-acf-color-pickers"
    "posts-to-sender-net"
    "hide-posts-by-category"
    "et-woo-product-price"
    "woo-2checkout-payment-gateway"
    "justnow-user-friendly-date-time"
    "shipsmart"
    "light-and-smart"
    "roosium-info"
    "seothemes-core"
    "persian-password"
    "woo-litego"
    "hsforms"
    "wp-search-include-meta-data"
    "wp-edit-redirect"
    "e-connector-for-woocommerce"
    "identify-headings"
    "wpm-schema"
    "outpace-seo"
    "passe-partout"
    "skynet-shipping"
    "mycn-stock-manager"
    "sukellos-login-wrapper"
    "pyrfekt-cat"
    "trados"
    "wide-angle-analytics"
    "airpay-v3"
    "tokenbacon"
    "byrst-3d-for-woocommerce"
    "oauth-for-gap-messenger"
    "sayonara"
    "power-captcha-recaptcha"
    "mega-giga-gallery-slider"
    "cision-modules"
    "d-elementor-widgets"
    "sdi-scarcity-timer"
    "quick-sms-by-route-mobile"
    "fcp-posts-by-search-query"
    "easy-search-replace"
    "lunasolcal-sun-info-widget"
    "phongmy-push-anything-to-social"
    "appview"
    "mail-grab"
    "player-for-web-pure-data-patches"
    "web-tools"
    "visitors-right-now-uk"
    "rest-query-monitor"
    "media-folders-codingdude"
    "sample-images"
    "admin-tailor"
    "folder-to-category-link"
    "facture-pay-wc-payment"
    "seemymodel"
    "timeline-module-for-divi"
    "spreadsheet-block"
    "randomrss"
    "restore-classic-widgets-and-classic-post-editor"
    "recurring-donations-moneris-gateway-give"
    "tech-radar"
    "toolbar-links"
    "karlog-it-simple-ssl"
    "click-2-share"
    "tweeker"
    "opening-block"
    "slider-text-scroll"
    "social-post-embed"
    "mobile-responsive-spacers"
    "citypay-for-woocommerce"
    "better-ajax-live-searchwp"
    "identitypass-verification"
    "custom-disable-feeds"
    "embed-twitter-timeline"
    "instaview-for-woocommerce"
    "pagecrumbs"
    "regisy"
    "footer-post-cyclic-rotation"
    "wc-give-a-coupon"
    "my-elementor-addons"
    "niz-products-carousel-for-woocommerce"
    "nexlogiq-amazon-s3-links-generator"
    "widget-for-google-map"
    "simply-bootstrap"
    "products-missing-featured-image"
    "rhx-news-ticker"
    "flaver-cbd-calculator"
    "korta"
    "custom-post-type-layout"
    "basic-gdpr-alert"
    "plugin-elimination"
    "your-custom-post-type"
    "iflair-woo-product-filters"
    "kiwi-reviews"
    "line-wp"
    "import-export-menu"
    "contact-manager-for-pipedrive"
    "fat-live-fixed"
    "oneday-transport-links"
    "click5-crm-add-on-to-ninja-forms"
    "cp24-wp-tools"
    "latest-post-widget"
    "title-keywords-seo"
    "additional-featured-images-and-media-uploader-anywhere"
    "wc-delayed-orders"
    "plugin-status-export-and-import"
    "zeek-addons-for-elementor"
    "wbg-opcao-de-cancelar-na-listagem-de-pedidos-woo"
    "cost-centre-gateway-for-woocommerce"
    "fs-product-inquiry"
    "admin-post-notifier"
    "gambling-quiz"
    "custom-x-pro-elements"
    "auto-replace-broken-links-for-youtube"
    "ai-reply"
    "user-switching-for-woocommerce"
    "cpt-single-redirects"
    "wysistat-mesure-daudience"
    "sobelz-map-for-woocommerce"
    "ltucillo-fixed-notices"
    "rubsum"
    "youmbrella"
    "pathshala"
    "ithabich-limit-registration-by-email-domain"
    "werbewolke-login"
    "follow-the-stars-iviz"
    "wp-dashboard-widgets-disable"
    "woo-paylot"
    "union-addons"
    "disable-floc-easily"
    "locatepress"
    "save-for-later-like-amazon"
    "orens-unsplash-widget"
    "version-compare"
    "location-for-wp-event-manager"
    "fish-tail"
    "stranger-questions-faq"
    "add-noopener-noreferrer"
    "seobrrr"
    "send-plain-mail"
    "slide-it-slider-for-woocommerce"
    "smobilplay-edd-gateway"
    "allpay-payment-gateway"
    "mighty-review-for-discount"
    "hivepay-woo-payment-gateway"
    "image-viewer"
    "wp-admin-help-videos"
    "ninja-live-chat"
    "sports-bench-lite"
    "jda-login-page"
    "lamboz-registration-link-on-checkout-page"
    "gwirydd"
    "cart-suggestion-for-woocommerce"
    "accordion-addon-for-acf"
    "order-status-customizer-for-woocommerce"
    "vmv-preloader"
    "custom-admin-notice"
    "simplified-contact-form"
    "grs-lnd-for-wp"
    "alpus-core"
    "clictopay-for-woocommerce"
    "xeet-wp"
    "eenvoudigfactureren-for-woocommerce"
    "air-download-attachments"
    "development-assistant"
    "rimplates"
    "eswp-popup-notifications"
    "link-to-popup"
    "writers-pro"
    "photu"
    "acnoo-flutter-api"
    "xshare"
    "chat-lite"
    "wp-redirect-404s-to-homepage"
    "pure-php-pagination"
    "edel-budget-book"
    "damedia-cpt-show-custom-fields"
    "wc-cart-automation"
    "backend-qr-code-post-link"
    "wl-nordpool"
    "magicbox"
    "saksh-callback-request-form"
    "colombia"
    "toolkit-for-woocommerce"
    "qooqie-leads"
    "beautify-excerpt"
    "wc-order-analytics-add-on"
    "gtg-product-blocks"
    "text-scrambler-for-elementor"
    "beacon-payment-gateway"
    "b-forms"
    "sc-lending-widget"
    "sprucejoy-membership"
    "software-news"
    "wp-dynamic-ads"
    "kineticpay-for-givewp"
    "this-call-button"
    "fast-mailchimp"
    "wemake-chat"
    "salequick-payment-gateway"
    "whiteboard-marketing-dashboard-widget"
    "product-countdown"
    "sebastian"
    "qr-payment-gateway-interface-for-woocommerce"
    "champis-net"
    "k2-woo-custom-payment-gateway"
    "webcare-scrollbar"
    "custom-content-for-invoices"
    "custom-post-widget-by-betlace"
    "bucksbus"
    "cannaffiliate-advertiser-setup"
    "products-slider-block"
    "wpglobus-multilingual-comments"
    "tid-scroll-to-top"
    "pixx-io"
    "webparex"
    "chargeback-order-status-for-woocommerce"
    "eis-online-ordering"
    "flaver-nicotine-shot-calculator"
    "get-blog-posts"
    "block-styling"
    "simple-pagesposts-specific-maintenance-mode"
    "unguessable-images"
    "rubsum-stuff-lists"
    "seo-file-renamer"
    "automatic-updates-enabled"
    "covid-coupons-fight-covid-19"
    "blocksolid-gateway"
    "rest-cache"
    "gf-move-fields"
    "bulk-products-selling"
    "lh-allow-shortcodes"
    "fria-single-value-chart"
    "convert-username-to-customer-code-for-woocommerce"
    "narnoo-shortcodes"
    "beachliga-iframe"
    "namaste-lms-bridge-for-gamipress"
    "wc-product-table-chart-column"
    "yeemail"
    "stachethemes-event-calendar-lite"
    "affiliates-manager-wp-express-checkout-integration"
    "woo-webdebit-payment-gateway"
    "simplify-menu-usage"
    "protocols-io-publications-widget"
    "website-reviewpilot-review-invite"
    "blog-pages-sitemap"
    "announcement-notice"
    "whatever-posts-widget"
    "entregar-shipping-method"
    "hidden-by-roles-the-admin-bar"
    "wp-latest-posts-widget"
    "sync-nginx-helper-cloudflare"
    "scheduled-posts-publisher"
    "wp-related-post-with-pagination"
    "mysql-process-list"
    "gateway-for-vantiv-on-wc"
    "local-number"
    "stapp-video"
    "danp-google-analytics-pageview-sync"
    "razorpay-payment-button-for-visual-composer"
    "cl-vg-wort"
    "ub-ultimate-post-list"
    "postcodex-lookup"
    "random-and-popular-post"
    "pigeon-affiliate-button"
    "the-wp-manager"
    "autolocation-checkout"
    "coinbarpay-payment-gateway"
    "manual-completions-tutorlms"
    "pic-tag"
    "blog-comment-form-jquery-validation"
    "mwb-cf7-integration-with-hubspot"
    "enrol-chat"
    "climbpress"
    "cross-platform-content-manager"
    "quickpay"
    "safety-passwords"
    "destiny-reviews"
    "sample-latest-post-widget"
    "login-registration-kit"
    "simple-guestbook"
    "database-anonymization"
    "arastoo-gmap-extended"
    "fidely-box-for-woocommerce"
    "vanilla-contact-form"
    "wp-easy-export-import"
    "give-coupon-to-friend"
    "ws-coupon-woocommerce"
    "phoca-restaurant-menu-block"
    "i-need-help"
    "wp-popular-posts-widget"
    "sardinia-poi"
    "donate-me"
    "random-dog"
    "deaddelete"
    "redirect-user-after-login-to-homepage"
    "vadim-evards-archive-org-post-saver"
    "nh-featured-posts"
    "pending-draft-alert"
    "immersive-designer"
    "delivery-date-time-picker-for-woocommerce"
    "photoprism"
    "easy-key-values"
    "keep-note"
    "content-tag-list"
    "terms-order"
    "hide-language-switcher"
    "blackswan-block-external-request"
    "pdf-embed-viewer"
    "wegner-tools"
    "2-klick-video-wpbakery"
    "selected-categories-post-ordering"
    "hosting-website-speed-check"
    "flush-transients"
    "et-coming-soon-page-maintenance-mode-under-construction-page"
    "track-unauthorized-access"
    "finest-quickview"
    "delivery-harmony"
    "woo-casinocoin-payments"
    "tel-publish"
    "periodic-nginx-cache-purger"
    "quick-create-pages"
    "telsender-events"
    "wc-postfinance-checkout-subscription"
    "property-permissions-for-realhomes"
    "walee-tracking"
    "w3scloud-contact-form-7-to-bigin"
    "arastoo-cpt"
    "folksy-product-listing"
    "slider-builder-elementor"
    "esami-di-laboratorio"
    "summarizes"
    "sepay-gateway"
    "ani-mate-animation-extension"
    "hide-shipping-rates-when-free-shipping-is-available"
    "smart-auto-featured-image"
    "bluebox-pricing-table-block"
    "auto-complete-all-orders"
    "dimoco-paysmart"
    "cb-countdown-timer-widget-for-elementor"
    "awesome-widgets"
    "multiple-email-recipient-woocommerce-orders"
    "rankcookie"
    "wolfoz-taxonomy-mbtree"
    "woo-cse-wallet-qr-gateway"
    "identic-canvas"
    "tippingboard"
    "flamix-bitrix24-and-elementor-forms-integration"
    "qform"
    "mamurjor-simple-contact-form"
    "dynamic-calculator"
    "what-the-cf7-which-contact-form-used-in-pagepost"
    "sharekar"
    "wp-notification-builder"
    "spawning-ai"
    "allow-webp-file-upload"
    "hivo-library"
    "creatrix-countdown"
    "pofw-option-css"
    "wpbr-payuni-payment"
    "utm-event-tracker-and-analytics"
    "xposure-listings"
    "ultimate-field-collections"
    "maakapay-checkout-for-woocommerce"
    "shipinsure-for-woocommerce"
    "wc-tracktum"
    "lorim-ipsm"
    "openasset"
    "mythic-cerberus"
    "map-field-for-contact-form-7"
    "grab-latest-track-from-soundcloud"
    "disable-fast-velocity-minify"
    "featured-image-add-in-admin-column"
    "fourbis-woocommerce-email-rapport"
    "reusable-blocks-list"
    "civic-geo"
    "tips-donations-woo"
    "wxy-tools-media-replace"
    "limited-editor"
    "neon-channel-product-customizer-free"
    "custom-login-customizer"
    "discount-regular-price-on-cart-checkout-page"
    "personalized-activity-for-buddypress-frfwa"
    "order-categories-for-woocommerce"
    "logintap-api"
    "tasti-rapidi"
    "flexbillet-events"
    "claspo"
    "redirect-links-randomizer"
    "mxchat-basic"
    "nvv-login-control"
    "e-payouts-for-woocommerce"
    "social-link-look"
    "wphobby-blocks"
    "paybats"
    "advanced-woo-ajax-search"
    "shipments-with-pulpo"
    "easy-progressbar"
    "corksy"
    "custom-review"
    "lekirpay-givewp"
    "post-classified-for-docs"
    "myasp-membership"
    "miyn-app"
    "fonk-slack-notifications"
    "link-to-button"
    "tickertape-oembed-provider"
    "window-blinds-solution"
    "denglu1"
    "encrypt-my-login-password"
    "wnokta-nginx-cache"
    "rz-extended-registration-form"
    "login-with-bondhumohal-network"
    "wp-post-reading-progress"
    "image-map-connect"
    "broadcast-companion-youtube"
    "disable-right-click-ninetyseven-infotech"
    "header-scroll-event-for-elementor"
    "webd-woo-event-bookings"
    "adflex-fulfillment"
    "angift"
    "mobilize-contact-form-7"
    "ng-secret-link"
    "remove-suggested-passwords"
    "post-status-indicator"
    "blacklisted-ip-adresses"
    "quick-quotes-wpshare247"
    "disableremove-login-hints"
    "revivify-social"
    "mazi-rest-apis"
    "gboost"
    "wp-post-type-widget"
    "basic-copyright"
    "add-manage-patterns-menu"
    "iaf-headertags"
    "checkoutchamp"
    "semor-analyzer"
    "gabriel-gateway-redirect-urls"
    "related-categories-post"
    "plugin-notification-bar"
    "sacredbits-remove-website-link-input-field-from-comment-form-of-post"
    "keensalon-companion"
    "my-schedule"
    "specialcart"
    "change-admin-logo"
    "apoyl-grabtoutiao"
    "awesome-team-widgets"
    "unotify"
    "product-configurations-table"
    "mandatly-cookie-compliance-and-consent-solution"
    "visitor-login-notice"
    "points-and-rewards-with-wc-blocks"
    "phantom-writer"
    "notify-engage"
    "unstitched-shortcode"
    "cinnox"
    "rebrand-bertha-ai"
    "segmetrics-membermouse"
    "quran-phrases-about-most-people-shortcodes"
    "iran-alves-upload-and-update-list-of-files"
    "contentlock"
    "smooth-scrolling-with-lenis"
    "telepost"
    "darkify"
    "astro-booking-engine"
    "yeshourun-digital-support"
    "tethered-uptime-monitoring"
    "page-scroll-progress"
    "opal-product-collection-woocommerce"
    "easy-social-links"
    "gabriel-auto-login"
    "easy-admin-page-master"
    "wp-currency-exchange-rate"
    "auto-social-media-screenshot-preview"
    "product-carousels-for-total"
    "cf7-mime-type-check"
    "lncj-variations-price"
    "external-notification"
    "smdp-fly-button"
    "biblescripturetagger"
    "contact-me-icon"
    "officeparty-connect"
    "debug-me"
    "mobi-builder"
    "karlog-it-save-for-later"
    "yatterukun"
    "crawler-hunter"
    "sensfrx-fraud-prevention-for-woocommerce"
    "restrict-date-for-wpforms"
    "infographicninja-wp"
    "eea-promotions-restrict-to-email"
    "chatpressai"
    "throwback-posts"
    "kinescope"
    "adilo-oembed-support"
    "catalogue-mode-simple"
    "user-role-adjustments"
    "simple-faq-to-the-website"
    "eyeone"
    "papernapfree-expert-reviews"
    "phoca-restaurant-menu-groups-and-items-block"
    "redirection-plus"
    "better-wp-admin-search"
    "dpsg-stammesauswahl-for-contact-form-7"
    "restrict-comments"
    "kein-web-fuer-nazis"
    "wp-simple-site-preloader"
    "institute-notice"
    "aquila-features"
    "custom-cart-page-notices-for-woocommerce"
    "sitemap-configurator"
    "fonts-arabic"
    "dcdn-engine"
    "product-sharing-buttons"
    "smartly"
    "genai-toolbox"
    "ai-content-copilot-auto-social-media-posting"
    "brevz-keep-your-users-in-touch-with-notifications-and-changelogs"
    "tryst"
    "calendar-widget-with-posts"
    "enable-customizer"
    "visualwp-cloudflare-turnstile"
    "contlo-for-woocommerce"
    "custom-customer-notes-for-woocommerce"
    "message-notification-for-contact-form-7"
    "open-in-social-debugger"
    "price-optimizer"
    "co2-footprint-widget"
    "resize-width"
    "media-manager-blocks"
    "pdf-rechnungsverwaltung"
    "quiz-by-categories"
    "posts-list-plus"
    "hostfully-booking"
    "navigation-dropdown-widget"
    "slug-translater"
    "ai-block"
    "creditop"
    "quizell"
    "gravity-notifications"
    "gpt-ai-content-creator-by-bestwebsoft"
    "heoheoheosziasztok"
    "socials-ag"
    "flair-chat"
    "woo-change-guest-owner-order"
    "wc-missing-stocks"
    "upsellwp-mini-cart"
    "menstrual-cycle-calculator"
    "jw-woo-order-prefix"
    "toolazy-custom-fields"
    "bixb-gateway"
    "mamurjor-employee-info"
    "alt-5-pay-checkout-for-woocommerce"
    "servientrega-mercancia-premier"
    "progressbar-with-scrolling"
    "ai-media-studio-by-paradiso"
    "f13-email"
    "uni-localize"
    "wc-slack"
    "wp-bing-background"
    "crypto-adaptive-payment"
    "rlm-elementor-widgets-pack"
    "wp3d-model-import-block"
    "nasswallet-payment-gateway-for-woocommerce"
    "ng-woo-moedelo-org-integration"
    "email-design-studio"
    "ls-wp-logger"
    "wp-affiliate-card"
    "mitt-pwa"
    "update-users-customers-using-csv"
    "cpay-crypto-payment-gateway"
    "hide-menu-items-by-role"
    "privado-gdpr-ccpa-cookie-consent"
    "ffsystems"
    "brandinizer"
    "free-ccpa-cookie"
    "really-simple-ga"
    "pay4fun-for-woocommerce"
    "trust-wp"
    "oddevan-deviantart-embed"
    "damaris"
    "gf-webhook-signature"
    "wp-carticon"
    "it-consulting-addons-wpbakery"
    "sft-product-recommendations-for-woocommerce"
    "accelerate-patterns"
    "monadic-addons-for-elementor"
    "kgr-elot-743"
    "coupons-by-country-for-woocommerce"
    "sunset-core"
    "get-in-touch-block"
    "fahipay-payment-gateway-for-wc"
    "wp-count"
    "web-service-all-in-one"
    "xoxzo-sms-voice-notification-for-woocommerce"
    "unik-post-layout"
    "image-meta-save"
    "mi-scroll-to-top"
    "telepress"
    "copyright-for-wp"
    "minimal-maintenance-mode"
    "easy-disable-right-click"
    "bmic-calculator"
    "only-admin-access"
    "beautify-code-blocks"
    "best-addons-for-elementor"
    "powerx-addons-for-elementor"
    "form-ga"
    "wp-frontend-publish-editor"
    "wolf-library-templates"
    "debug-switch"
    "footer-generator"
    "hatenablog-auto-migration"
    "pythia-for-woocommerce"
    "fr-map"
    "standout-fortnox-integration-for-woocommerce"
    "experto-custom-dashboard"
    "file-upload-for-woocommerce"
    "easy-feed-image"
    "powerwaf-cdn"
    "fizfy"
    "saturday-night"
    "rabbit-messenger-live-chat"
    "wooguten-block-editor-for-woocommerce"
    "pulsemotiv-integration"
    "ravioli-for-woocommerce"
    "automatic-translations-for-polylang"
    "dynamic-pin-it-button-on-image-hover"
    "elite-stay-helper"
    "zedna-auto-update"
    "viously"
    "rb-autologin"
    "activecalculator"
    "mailartery"
    "arabic-english-estimated-reading-time"
    "publish-and-add-new"
    "weitergeben-org"
    "visual-wp-anti-spam-and-fraud-prevention"
    "commented"
    "boingball-medaltv-shortcode"
    "reskillify-com"
    "shieldup"
    "cf7-visited-pages-url-tracking"
    "digital-samba-embedded-video-conferencing"
    "user-login-disable"
    "product-options-index-for-woocommerce"
    "menus-for-block-theme"
    "elementary-pos"
    "rate-limit-co"
    "bnm-blocks"
    "prepublish-checks-by-kgaurav"
    "one-click-logo"
    "magic-scroller"
    "local-pickup-for-woocommerce"
    "doleads-integrator"
    "pray-for-the-nations"
    "wp-google-search-profile"
    "bookacamp"
    "remove-unwanted-block-suggestions-of-block-directory-from-editor"
    "easy-gdpr-cookie-compliance"
    "catalog-for-logged-out-users"
    "auto-x-line"
    "messagespring"
    "foxmetrics"
    "gf-social-icons"
    "get-page-url"
    "psychological-first-aid-training-kit"
    "myschedulr"
    "wishlist-shibainuit"
    "hide-fields"
    "catalogue-custom-register-fields"
    "raagaadrm-integration-for-woocomerce"
    "opencritic-metadata-sync"
    "proxymis-shoutbox-com"
    "cf7-optimizer"
    "ultimate-custom-posts"
    "ai-product-tools"
    "eventful"
    "payflexi-checkout-for-woocommerce"
    "wp-plugin-management"
    "surveylock-me"
    "zhu-posts-icon-carousel"
    "ewoapps"
    "disclaimify"
    "user-register-date"
    "clean-menu"
    "local-business-details"
    "valhalla-cf"
    "fourbis-chart-navigator"
    "open-closed-woo-commerce-checkout-by-ritesh-ghimire"
    "rwit-phone-formatter"
    "fancy-login-form"
    "virtuaria-google-shopping"
    "task-randomizer"
    "salut-patrick"
    "clone-test-db"
    "juno-progress-bar-block"
    "default-email-and-sender-name-in-wp"
    "image-point-selector-field-for-advanced-custom-fields"
    "simple-meta-shortcode"
    "email-by-smtp"
    "tiny-default-thumbnail"
    "ask-expert"
    "fast-select-woo-attributes"
    "toolkits-addons"
    "user-identification"
    "vouch-release-on-delivery-for-woocommerce"
    "wc-forestcoin-payment-gateway"
    "thumbsupsurvey-wp-client"
    "ticketscandy-sell-tickets-online"
    "pdf-for-metform"
    "cff-area-and-perimeter-operations"
    "osom-for-youtube"
    "elform"
    "wp-minimal-typography"
    "admin-screenshots"
    "xml-e-katalog"
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


v0.1.7 / 2014-09-21 
==================

 * [workers] disable BoxWorker schedule
 * [webhook] finish orders hook and start question, items, payments hooks;
 * [spec] remove warning to defaults and require 'pry' in spec_helper.rb
 * [unicorn] fixed warning: File.exists? is a deprecated name, use File.exist? instead
 * [azk] add ngrok system;
 * relacionamento user com catalogo
 * geolocation
 * Merge branch 'develop' of bitbucket.org:aircrm/aircrm into develop
 * update attributes user
 * [envs] fixed `MERCADOLIBRE_APP_ID` and `MERCADOLIBRE_APP_SECRET`
 * Merge branch 'develop' of bitbucket.org:aircrm/aircrm into develop
 * catalogo
 * [core] fixed develop smtp settings;
 * [gems] fixed separate arguments to `Roo::Excel.new` is deprecated.
 * Revert "[azk] add alias to bundle exec"
 * add `azk` install and start in README
 * Merge branch 'develop' into walert/walert/develop
 * [walert] revert others walert changes
 * logos (reverted from commit 51f08b5f1fe5f0737147d7539cf82e9415a470b9)
 * Revert "logos"
 * [azk] add mercadolibre envs to azk domain
 * [user] invitations
 * logos
 * [mercadolibre/shipping] fixed #45 NoMethodError: undefined method '[]' for nil:NilClass;
 * [azk] add alias to bundle exec
 * [azk] add redis and mail systems;
 * [omniauth] fixed OpenSSL 1.0.1f with https://api.mercadolibre.com
 * [account] fixed TypeError (can't convert String into an exact number) in trial_period_end
 * [omniauth] fixed OpenSSL 1.0.1f with https://api.mercadolibre.com
 * fixed fury url
 * Merge branch 'develop' of bitbucket.org:thiagomartinho/aircrm into develop
 * [mercadolibre/shipping] fixed :receiver_address_s
 * [box] fixed #31 ArgumentError: 'shipping_not_verified' is not a valid shipping_status
 * [mercadolibre/shipping] manual shipping `:no_address` notify.
 * fix undefined RUBBER_ENV
 * [mercadolibre/shipping] paser box.shipping
 * trial message
 * [dashboard] disable sortable steps
 * [dashboard] reload button
 * [mercadolibre/box] fixed status not apply
 * update rollbar
 * [subscription] #42 ArgumentError: comparison of Time with nil failed
 * [dashboard] unsynced dashboard
 * support azk
 * azk
 * update gem omniauth-mercadolibre
 * update database poll size
 * dump README
 * fixed #31 ArgumentError: 'payment_in_process' is not a valid status
 * fixed _sidebar
 * fixed uninitialized constant Mercadolibre::ItemWorker
 * Merge branch 'develop' of bitbucket.org:thiagomartinho/aircrm into develop
 * rename project to walert
 * Mesclado thiagomartinho/aircrm em develop
 * [dashboard] fixed admin index
 * reset production config.active_suport.deprecation and change log_level
 * reset production config.active_suport.deprecation and change log_level
 * change default value to concurrency
 * undefined method 'user'
 * fixed skip_before_filter :account_trial?
 * [deploy] fixed unicorn restart
 * enable debug to active_support.deprecation
 * [subscription] fixed undefined method  for nil:NilClass
 * [core] fix database poll size
 * [account] trial message
 * [mercadolibre/item] show
 * [mercadolibre/items] fixed nil item.pictures
 * side_bar correcao
 * importação parte 1 refatoramento
 * importação parte 1
 * muda status em massa da question customer_blocket: true/false
 * [mercadolibre/item] edit view
 * [mercadolibre/item] get item description
 * [mercadolibre/items] index#refresh button
 * [fixed] no create trial_subscription because undefined variable trial_period_end;
 * update env.TRIAL_PERIOD to 14.days
 * block_customer_question parte 2
 * block_customer parte 1
 * question_destroy
 * feedback_page com item
 * feedback_page
 * feedback_index2
 * feedback_index
 * Merge branch 'develop' of bitbucket.org:thiagomartinho/aircrm into develop
 * port vagrant
 * [user] User.all#index.csv
 * [subscription] add column expires_in to subscription.
 * [mercadolibre-questions] link in sidebar
 * [mercadolibre-questions] fixed question status
 * [mercadolibre-questions] reverse remove link to question with param `:item_id`
 * Merge branch 'hotfix/fix-questions-link' into develop
 * [mercadolibre/questions] fixed question urls without standard
 * [omniauth-mercadolibre] update gem to fix redirect_uri no titleized.
 * [box] fixed box.status [payment_in_process, invalid] is not a valid status
 * [box] fixed box.status [payment_in_process, invalid] is not a valid status
 * [box] box.status :shipped incomplete
 * Merge branch 'hotfix/fix-order-status'
 * [box] fixed box.status [payment_in_process, invalid] is not a valid status
 * [box] fixed box.status [payment_in_process, invalid] is not a valid status
 * [box] box.status :shipped incomplete
 * refatoramento questions
 * Merge branch 'release/v0.1.5' into develop

v0.1.5 / 2014-08-28
==================

 * ad NOTE.md
 * [box] change status (more status)
 * disable mixpanel and kissmetrics in development
 * [box] change box.status of :confirmed to :paid;
 * add gem activerecord-session_store;
 * novas regras para edicao de feedback
 * Merge branch 'hotfix/fix-oauth-mercadolibre-redirect-uri' into develop
 * [jobs] fixed BoxWorker used token another dashboard
 * feedback2
 * feedback
 * Merge branch 'hotfix/fix-action_mailer-asset_host' into develop
 * [deploy] fixed unicorn no restart after deploy
 * Merge branch 'hotfix/fix-box_worker-error-403' into develop
 * Merge branch 'hotfix/fix-box-status' into develop
 * [box] #fixed BoxExtras.attributes is deprecated;
 * Merge branch 'hotfix/fix-shipping-status' into develop
 * Merge branch 'hotfix/fix-link-error-pages' into develop
 * Merge branch 'hotfix/fix-rescue-errors' into develop
 * Merge branch 'hotfix/fix-jquery-ui-update' into develop
 * Merge branch 'hotfix/fix-omniauth-mercadolibre2' into develop
 * Merge branch 'hotfix/fix-omniauth-mercadolibre' into develop
 * Merge branch 'release/v0.1.4' into develop

v0.1.4 / 2014-08-15
==================

 * welcome mailer
 * change ssh addres of ip to domain
 * [dashboard] status;
 * [dashboard][show] fix current_user.customers instead of current_account;
 * enable search only for dashboard#show; hidden notification/list;
 * error pages
 * Merge branch 'develop' of bitbucket.org:aircrm/aircrm into develop
 * feedback
 * fixed bundle install undefined method []
 * [Mercadolibre::Box] update api helpers;
 * [Meli] cache Meli::Base.user_id in callback load_provider;
 * [Box] remove columns `document_*`, `user_id` and `step_id`;
 * disable rollbar delayed reporting (using Sidekiq);
 * rspec and guard rspec; disable guard watch for rails, sidekiq, test;
 * change gem meli to private repository (gem fury)
 * status question
 * Merge branch 'develop' of bitbucket.org:aircrm/aircrm into develop
 * question_page final
 * disable link to Mercadolibre::Item
 * disable box#new
 * add .elasticbeanstalk to gitignore
 * post da resposta no Meli
 * fixed dashboard.preferences.no_address_mailer not boolean
 * disable LE (logentries) in deveopment environment
 * refatoração do question.rb
 * fixed Le.new in development
 * Merge branch 'hotfix/fix-mercadolibre-phone' into develop
 * changelog
 * install le (logentries);
 * update status na pergunta
 * Merge branch 'develop' of bitbucket.org:aircrm/aircrm into develop
 * salva perguntas do ML no banco e lista nas views

v0.1.3 / 2014-08-06
==================

 * install le (logentries);
 * fix flash_message in dashboards_controller
 * split BoxWorker Box.get! in :recent and :arquived
 * disable rollbar to development
 * install rollbar
 * Revert "add user infos to zopim if user logged"
 * disable all request local
 * add user infos to zopim if user logged
 * correcao bug criacao do trial
 * Merge commit '8cdbade8abad3ea56ba7b6e1a2e5a7c77692e039' into develop
 * Merge commit '9865f103d20e46a10fc47a9d52943d2d53d363f4' into develop
 * remove zopim from mercadolibre layout
 * remove #new and #create to plans
 * fixed I18n plan#index view
 * remove columns ml_* in boxes
 * add UX test tools: Inspectlet and CrazyEgg;
 * Event Tracker (with Mixpanel and Kissmetrics);
 * remove zopim from mercadolibre layout
 * remove #new and #create to plans
 * fixed I18n plan#index view
 * remove columns ml_* in boxes
 * add UX test tools: Inspectlet and CrazyEgg;
 * Event Tracker (with Mixpanel and Kissmetrics);
 * authenticate before subscription
 * remove zopim from mercadolibre layout
 * update terms, jobs and plans#index pages
 * remove #new and #create to plans
 * env paypal correcao
 * fixed I18n plan#index view
 * paypal env
 * remove columns ml_* in boxes
 * add UX test tools: Inspectlet and CrazyEgg;
 * Event Tracker (with Mixpanel and Kissmetrics);
 * termos de uso layout
 * termos de uso e jobs_page
 * task_plans
 * plans_page
 * correcao question_page
 * question_page
 * Merge branch 'develop' into perguntas-respostas-page
 * question_page
 * Merge branch 'develop' of bitbucket.org:aircrm/aircrm into develop
 * question_controller
 * Merge branch 'hotfix/fix-ability-provider' into develop
 * Merge branch 'hotfix/fix-capitalize-provider' into develop
 * Merge branch 'hotfix/sidekiq' into develop
 * Merge branch 'hotfix/sidekiq-config' into develop
 * Merge branch 'hotfix/box-ml-update' into develop
 * Merge branch 'hotfix/oauth-update-token' into develop
 * Merge branch 'hotfix/remove-flatui' into develop
 * Merge branch 'hotfix/dotenv' into develop
 * Merge branch 'release/v0.1.2' into develop

v0.1.2 / 2014-08-04
==================

 * fixed Box scope :total_price_por_day get all boxes.
 * update rubber
 * add shipping to BoxExtras
 * use dashboard.preferences.no_address_mailer to shipping.notify
 * fixed redis connection
 * guard
 * remove gem flatui3
 * annotate
 * DashboardPreferences
 * remove job to create default dashboard
 * enable all_requests_local in production to more complete log.
 * disable mongodb auth
 * remove `modal?` Helper
 * set_dashboard Helper
 * move providers/mercadolibre/items to mercadolibre/items;
 * [JS] change AIRCRM.providers_mercadolibre_categories to AIRCRM.mercadolibre_categories;
 * move providers/mercadolibre/items to mercadolibre/items;
 * list all dashboards to admin
 * Merge branch 'hotfix/error-pages' into develop
 * Merge branch 'hotfix/fix-security-box-index' into develop

v0.1.1 / 2014-07-31
==================

 * update mercadolibre/item edit
 * fixed disable incomplete home
 * user links;
 * remove old home
 * fixed sidebar and breadcrumbs.
 * fixed sort steps and boxes
 * Providers::ModelBase disable defaults methods
 * update:   Box;   Customer;   Step;   Mercadolibre::Shipping;
 * add Virtus to serialize HSTORE; add ZeroClipboard;
 * Meli.configure and Dashboard.credentials to Meli.
 * box is no longer dependent on the step
 * fixed simple_form horizontal wrapper
 * delegate :name and :model_name to class in Providers::ModelBase
 * enable hstore in postgresql:
 * fixed Mercadolibre::Items back link remote
 * part 2 question-page
 * rotas das perguntas e respostas
 * correcao do routes e payment notif controller
 * routes and payment notification controller
 * profile page
 * first part of question_page
 * fixed `payment_notifications_controller.rb:14: syntax error, unexpected ':', expecting => `;
 * start migration to meli gem instead of mercadolibre gem; add pry-rails to development;
 * move mercadolibre/categories to parent folder (removed providers/)
 * fixed Dashboard.create_default duplicated
 * Merge branch 'master' into develop
 * profile_page
 * delete pages
 * fixed gem mercadolibre use local path
 * fixed dashboard#show
 * make rake db:account_without_subscription, for accounts that do not have registration, it adds
 * .gitignore sublime-workspace
 * rake db:default_plans
 * checagem de subscription para usuarios antigos
 * Mercadolibre::Category
 * #partial_commit
 * ajustes layout
 * refatoramento subscription
 * payment module refactoring + email pagamento
 * paginas de erros
 * layout welcome_email + Job Welcome Email
 * Welcome Email
 * fixed GEM::Permission to pre provision vagrant
 * partial implementation of mercadolibre/item edit
 * model_base dinamic defaults methods.
 * change bootstrap gem. add helpers. add I18nHelper.
 * fixed mercadolibre expired_token?:  - update gem mercadolibre;
 * Providers::Mercadolibre::Item:  - add controllers: [ :show, :edit, :update, :destroy ]  - update views: [index, _item]
 * install mongoid-paranoia
 * style to table responsive
 * fixed update provider credentials after dashboard find
 * fix route get /logout
 * Providers::Mercadolibre::Item route and views
 * isole and update resources Provider::Mercadolibre::Item;
 * update gem mercadolibre:  - add to_hash to more models;  - update item attributes;  - add support params[:user_id] and cache get_my_user;  - bug fixed empty request to api;  - bug fixed array item_pictures to_hash;
 * bug fixed synced? check updated_at.nil?;
 * bug fixed update_token not call Dashboard.update_token;
 * Merge branch 'develop' of https://bitbucket.org/aircrm/aircrm into develop
 * view item
 * isolate provider model question
 * bug fixed: dashboard.provider not downcase;
 * login button and page
 * re-enable avatar name and avatar
 * fix sidebar link to dashboards
 * fix item_uploader
 * fix load pace-theme-flat-top.css; disable assets.debug;
 * bug foto
 * rack servindo a imagem
 * gridsf mongo parte 1 - salva foto no banco
 * fixbug step and box sortable; use nicescroll to custom scrollbar;
 * Merge branch 'develop' of bitbucket.org:aircrm/aircrm into develop
 * reset pace.js default configs;
 * add pace.js and dispatcher.js; fix dashboard#show sizes; fix glyphicons not loaded;
 * layout home and about
 * update admin theme
 * pages:  - about;  - services;  - features;  - contact;
 * fix home_old assets
 * new home template; remove flatui (reverted from commit 3476ab034c749c55868c5d3583c44a4baeedc0fe)
 * remove flatui
 * install theme
 * after login create_default in background. update User and Dashboard destroy. schedule box worker.
 * add helpers dispatcher_class and dispatcher_route
 * home
 * add git staging environment
 * view anuncios
 * keep assets provider folders
 * fix rubber staging not deploy
 * update README
 * fixbug box
 * remove beta message
 * fix Missing  for 'staging' environment (reverted from commit 83b157a265147a53ff241589ade9c19c1f95dd9a)
 * fix Missing  for 'staging' environment
 * shipping and notify
 * set haml with default template engine
 * fixbug Notify duplicate and change enum of type to param
 * fix load providers
 * fix worker unexpected end-of-inpu
 * when the dashboard is updated is now called the job `BoxWorker.get!(dashboard.id)`.
 * update Providers::Mercadolibre::Box. add Providers::Mercadolibre::Shipping.
 * add model notify
 * add mongoid-enum update mercadolibre gem (implemented reverse_merge to filters and helper to_hash)
 * add sidekiq web interface
 * refactored model/providers to simple implement new models
 * autoload provider after_find dashboard. fix update_token.
 * unicorn suport development mode disable rails autoload spring
 * Provider::ModelBase
 * box model
 * remove body > .navbar margim botton
 * vagrant: change redis chef repository
 * image log_aircrm_short
 * update html keywords
 * noticiation background
 * noticiation background
 * wercker write ssh private key
 * wecker change to deploy_via copy
 * wercker update deployes repositori
 * wercker disable bundle-package
 * wercker change ruby box to one with ruby 2.1.1
 * cap deploy rails console and bash interatively
 * update google account to staging
 * config wercker
 * env staging
 * rubber: update cloud_provider to roles [app, redis]
 * Merge branch 'develop'
 * sprim
 * Merge branch 'master' into develop
 * no_address_notification
 * enable autoreload after load dashboard
 * update instance
 * add newrelic to role app
 * fix update rails
 * fix unicorn not start
 * revert unicorn config
 * fixbug assets precompile
 * fixbug secret to production
 * google webmaster file
 * remove sass
 * fixbug assets precompile
 * update core source to rails 4.1
 * fixbug rubber redis crontab
 * if dashboard.provider? in Loaddashboard
 * add newrelic deployment event
 * fixbug in routes_helper, invalid status to render_error
 * remove /home/gmmaster to .env.production
 * update rubber sidekiq
 * redis
 * set rubber version to install in instances
 * fix rubber mongodb_port call var\nupdate rubber to v2.10.0
 * add assets_pipeline to deploy (precompile assets in production)
 * add redis to role background_worker (sidekiq)
 * update to rails 4.1.1 update assets and change style_sheet_engine to less update layouts, fonts and icons add favicon fix momment deprecated string constructor fix not render error pages
 * remove public/assets
 * #fix newrelic security vulnerability! update gem newrelic_rpm to 3.8
 * aws ENVs
 * merge feedback from thiago source
 * Merge branch 'develop' of bitbucket.org:aircrm/aircrm into develop
 * Merge branch 'release/v0.1.0' into develop
 * answer posting
 * meli item

v0.1.0 / 2014-06-15
==================

 * init changelog
 * Merge branch 'feature/rubber-aws' into develop
 * update instaces in production
 * fix nginx not load assets
 * fix nginx: [emerg] unexpected ;
 * update unicorn upstart script (reverted from commit 4b3ff6b11abcd6ae9d6342bd348b9565e0193354)
 * update unicorn upstart script
 * fix unicorn not start
 * load dotenv in Capfile
 * mongodb uri and port
 * enable auth mongodb
 * fix unicorn not load role
 * update unicorn config
 * remove passenger from vagrant provision
 * rubber remove and install unicorn
 * puma nginx
 * puma 502 and 503 pages
 * change vagrant memory size
 * before "rubber:config:configure", "rubber:config:chmod_plus_x" to after "deploy:finalize_update", "rubber:config:update_permission_scripts"
 * add rubber:config:chmod_plus_x to fix `script/rubber config` Permission denied
 * remove config/database.yml from .gitignore
 * remove full_host and fix nginx-tools
 * fix app_user and nginx-tools
 * assets very clean
 * clean assets
 * install jazz_hands
 * role redis
 * change rubber.app_user
 * change nginx log type
 * update rubber deploy configs
 * disable assets precompile in production
 * ssh psql
 * #fix rubber
 * assets precompile
 * rubber: add templates: mongodb, sidekiq, redis, newrelic
 * rubber update clean templates
 * fix rubber default configs
 * rubber remove: graphite, monit, collectd, web_tools, postgresql
 * Merge branch 'rubber' into feature/rubber-aws
 * user default_scope id
 * staging specific google analytics id
 * fix foreman
 * staging env
 * Merge branch 'feature/provider-to-nosql' into develop
 * mont parent project folder with path /www in vagrant VM
 * feedback in mongodb
 * questions in mongodb
 * disable form sign_up
 * update vagrant settins and install foreman
 * Vagrant in project
 * parse implement mongodb
 * question
 * #fixbug Feedback.get! nor working because not send order_id param
 * #fixbug undefined method `rating'
 * refatore
 * change callback for :set_currents in action controller
 * to address the thread variable leak issues in Puma/Thin webserver
 * sendgrid env vars
 * feedback module
 * Merge branch 'master' of https://bitbucket.org/aircrm/aircrm
 * load dashboard
 * question resources
 * feedbacks resources
 * Merge remote-tracking branch 'heroku/master'
 * correct home flash_message
 * assets precompile
 * #fixbug remove .erb file
 * orders without address listing
 * search
 * #fixbug step sport, nil user_id and account_id
 * assets precompile
 * Merge branch 'master' of bitbucket.org:aircrm/aircrm
 * auto refresh token
 * Q&A
 * Merge branch 'master' of https://bitbucket.org/aircrm/aircrm
 * layout home
 * layout home corrigido
 * set development trial period to 300 days
 * mercadolibre defaults_steps
 * #fixbug task app:users
 * #fixbug new user get boxes
 * #debug Box.get!
 * docs get_boxes in terminal
 * trial period message
 * #fixbug box.dahsboard_id invalid
 * update_token after user omniauth login
 * rename task app:users_with_boxes to app:users
 * #fixbug mercadolibre orders_update
 * #fixbug update_orders dashboard nil and step not relation with current_user
 * #fixbug mercadolibre shipping_address
 * #fixbug shipping nil
 * #fixbug shipping nil
 * fix analytics comment invalid
 * updata ZOPIM_KEY
 * fix image and security group
 * rubber passender_nginx_postgresql
 * rake app:users
 * update google analytics script
 * conditinal adds google analytics and zopim chat scripts
 * analytics and chat to layouts
 * google analytics demografic
 * google analytics avanced
 * google analytics
 * fix omniauth login
 * assets precompile
 * add link to name of the board in dashboards index
 * disable cancan restrictions
 * fix draggleb handle
 * new logo
 * fix current_user is invalid in current_account
 * assets precompile
 * nginx.conf
 * assets:clean keep
 * rename middlewares
 * home
 * Merge branch 'master' of bitbucket.org:aircrm/aircrm
 * Merge branch 'master' of bitbucket.org:aircrm/aircrm
 * home
 * assets precompile
 * fix compass-rails
 * rake assets:precompile
 * mercadolibre provider
 * provider mercadolibre
 * comments controllers
 * boxe favorite icon color #fix box.costumer_name
 * remove turbolinks
 * dashboard show
 * disable schedules in box form
 * comments resources
 * update resources: dashboards, steps and boxes
 * assets update
 * update form of dashboards and update boxes controllers
 * seeds
 * search to nav-bar
 * add user owner_of_account_id
 * create users to dashboards associations
 * jquery image lazy load
 * #fix helper down_mode not working
 * home my account link
 * + user account owner + fit application controller + translates +- navigation +- change dashboards route
 * remove normarlize user name; remove field subdomain of account; fix routes order;
 * updates migrations
 * add gem annotate
 * #fix #merge home
 * fix #merge migrations payment_notifications
 * Merge branch 'master' of bitbucket.org:aircrm/aircrm
 * merge others folders
 * update home
 * fix home javascripts
 * assets precompile
 * merge apps
 * merge repos: newaircrm -> aircrm
 * gitignore database.yml
 * gitignore database.yml
 * gitignore database.yml
 * gitignore database.yml
 * update README
 * rename sublime project file
 * ajuste
 * ajuste
 * calendar + ajuste icons form
 * layout home
 * ajuste plan index
 * ajuste plan index
 * ajuste plan index
 * img 3
 * cor rosa msg
 * ajustes home layout2
 * ajuste home layout
 * asset precompile
 * correcao barra lateral
 * teste paypal
 * teste paypal
 * teste paypal
 * teste paypal
 * teste paypal
 * teste paypal
 * teste paypal
 * teste
 * teste
 * config
 * teste
 * gabriel config
 * ajustes
 * ajustes
 * ajustes
 * ajustes
 * ajustes
 * ajustes
 * ajustes
 * ajustes
 * borda topo
 * borda topo
 * borda topo
 * borda topo
 * teste bordar topo
 * teste bordar topo
 * teste bordar topo
 * teste paypal
 * teste paypal
 * teste paypal
 * teste paypal
 * teste paypal
 * teste url aws s3
 * teste url aws s3
 * teste url aws s3
 * teste url aws s3
 * teste url aws s3
 * teste url aws s3
 * teste url aws s3
 * teste url aws s3
 * teste url aws s3
 * teste url aws s3
 * teste url aws s3
 * teste url aws s3
 * teste url aws s3
 * teste url aws s3
 * assets precompile
 * ajustes home
 * aws s3
 * teste removing S3 config
 * aws s3
 * home nova
 * ajuste
 * ajuste
 * font face sqmarket
 * migration dashboard_to_plans
 * assets precompile
 * exclusão de comentarios
 * teste paypal notificacao
 * teste paypal notificacao
 * word documento
 * teste
 * teste
 * teste
 * teste
 * teste
 * teste
 * teste
 * teste
 * teste
 * teste
 * teste
 * teste
 * teste
 * teste
 * teste
 * teste
 * precompile
 * pdf
 * correcao bug
 * correcao bug
 * asset precompile
 * teste
 * initial commit
 * undo
 * dashr inicial
 * assets precompile
 * fix plan_id to url
 * plans
 * planos
 * flash messa corrigido
 * bug correcao 2
 * bug correcao
 * ajustes para producao 3
 * ajustes para producao 2
 * ajustes para producao
 * ajustes
 * fonts and account
 * fix steps sort
 * assets precompile
 * edit steps sortable steps and boxes
 * add newrelic
 * disable facebook omniauth
 * box: hidde destroy button in new_record
 * remove flash message
 * ajuste layout
 * asset precompile
 * nova home
 * registration form and route
 * assets precompile
 * fix reports
 * ajuste titulo
 * asset precompile
 * relatorios
 * relatorios
 * assets precompile
 * login form
 * flash message
 * mailcatcher
 * fix mail support
 * login page
 * corrigindo de login para email na view session
 * assets precompile
 * JSs
 * steps and boxes form
 * home
 * plans form
 * box form
 * navigation links
 * login form
 * feature Negocio Perdido
 * asset precompile
 * Feature Negocio Fechado
 * ajustes layout 2
 * ajustes de layout
 * ajustes de layout
 * after_sign_in_path_for(resource)
 * after_sign_up_path_for
 * fix mongoid Mongoid::Errors::DocumentNotFound rescue
 * invalid byte sequence in US-ASCII
 * assets precompile
 * update compass-rails and remove assets
 * update rails to 4.0.3
 * bundle update
 * assets precopile
 * remove precompiled assets
 * steps style
 * home layout
 * gc-icons
 * routes and raise errors
 * detalhes da home
 *  home finished
 *  home finished
 * precompiled assets
 * fix form
 * locales
 * simple form
 * precompile assets
 * finish layout
 * finish layout
 * add precompiled assets
 * new_step_box_path(Step.first)
 * new_step_box_path(Step.first)
 * fix steps top position
 * precompile assets
 * Merge branch 'master' of bitbucket.org:thiagomartinho/air_crm_v3_thiago
 * auto width and height
 * layout v1
 * fix double create default steps
 * add precompiled assets
 * fix assets precompile
 * remove precompile assets
 * fix assets precompile
 * fix assets precompile
 * fix assets not-precompile
 * fix assets not-precompile
 * assets clean
 * assets clean
 * assets clean
 * remove omniauth-mercadolibre
 * fix drop box in canvas
 * box form
 * steps colors
 * default steps after create user
 * forms and resources
 * steps
 * gix ActiveRecord::ConnectionNotEstablished
 * puma config file
 * sprockets
 * sprockets
 * public assets
 * fix heroku assets
 * fix heroku assets
 * fix heroku assets
 * fix heroku assets
 * fix heroku assets
 * fix  dotenv in production
 * fix load dotenv in production
 * oauth-mercadolibre
 * fix ActiveModel::ForbiddenAttributesError
 * dotfiles
 * schema
 * application layout
 * box order
 * fix remove deals in step model
 * route root is steps#index
 * relationship between boxes and steps
 * merge deals in boxes
 * user and auth
 * flat-ui
 * root route
 * load jquery.ui.all
 * database schema
 * factory gir test
 * jquery ui
 * remove erbs files
 * erb to haml
 * app gems
 * config database
 * rename historical resources to box
 * create controller site
 * finish authentication
 * finish association
 * Finish First Part of Authentication

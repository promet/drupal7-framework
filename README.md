# Promet Drupal 7 Framework

This is an example of a starting point for developing the Promet Way.

You can most easily start your Drupal project with this baseline by using
[Composer](getcomposer.org):

```bash
composer create-project promet/drupal7-framework your_project_name
```

Running this command will download the latest release of this project to a new
directory called `your_project_name` and invoke `composer install` inside it,
which will trigger additional scripts to create a working Drupal root in the www
subdirectory from the packages downloaded with composer.

We reference a custom composer repository in composer.json
[here](composer.json#L5-8). This repository was created by
traversing the list of known projects on drupal.org using
`drupal/parse-composer`, and has the package metadata for all the valid packages
with a Drupal 7 release, including Drupal itself.

We use `drupal/tangler` to create the Drupal root by reacting to the `install`
and `update` events, and a custom installer provided by
`drupal/drupal-library-installer-plugin` to handle placing `ckeditor` in the
libraries directory of the resulting Drupal application. Also, we render
a settings.php file from `cnf/config.yml` using `winmillwill/settings_compile`,
which assures us that an operator without php familiarity but with knowledge of
the different tunables in settings.php will be able to update different
deployments of the application without needing to kludge anything.

As you add modules to your project, just update composer.json and run `composer
update`. You will also need to pin some versions down as you run across point
releases that break other functionality. If you are fastidious with this
practice, you will never accidentally install the wrong version of a module if
a point release should happen between your testing, and client sign off, and
actually deploying changes to production. If you are judicious with your
constraints, you will be able to update your contrib without trying to remember
known untenable versions and work arounds -- you will just run `composer update`
and be done.

This strategy may sound a lot like `drush make`, but it's actually what you
would get if you took the good ideas that lead to `drush make`, and then
discarded everything else about it, and then discarded those good ideas for
better ideas, and then added more good ideas.

See:

* [composer](getcomposer.org)
  * [composer install](https://getcomposer.org/doc/03-cli.md#install)
  * [composer update](https://getcomposer.org/doc/03-cli.md#update)
  * [composer create-project](https://getcomposer.org/doc/03-cli.md#create-project)
  * [composer scripts](https://getcomposer.org/doc/articles/scripts.md)
* [drupal/tangler](packagist.org/packages/drupal/tangler)
* [drupal/drupal-library-installer-plugin](packagist.org/packages/drupal/drupal-library-installer-plugin)
* [drupal/parse-composer](packagist.org/packages/drupal/parse-composer)
* [winmillwill/settings_compile](packagist.org/packages/winmillwill/settings_compile)

# Easy Development with Vagrant

We have a Vagrantfile that references a Debian 7 box with php 5.4 and apache2
and mysql. Once you have installed Vagrant, you can begin development like so:

```bash
vagrant up # turn on the box and provision it
vagrant ssh # log into the box like it's a server
cd /var/www/sites/<project-name> # go to the sync'ed folder on the box
alias drush="$PWD/vendor/bin/drush -r $PWD/www" # use drush from composer
drush <whatever> # do some stuff to your website
```

# The Build and Deployment Scripts

You may have noticed that provisioning the Vagrant box causes `build/install.sh`
to be invoked, and that this causes all of our modules to be enabled, giving us
a starting schema.

You should note that `build/install.sh` really just installs Drupal and then
passes off to `build/update.sh`, which is the reusable and non-destructive
script for applying updates in code to a Drupal site with existing content. This
is the tool you can use when testing to see if your changes have been persisted
in such a way that your collaborators can use them:

```bash
build/install.sh # get a baseline
alias drush="$PWD/vendor/bin/drush -r $PWD/www" # use drush from composer
drush sql-dump > base.sql                       # save your baseline
# ... do a whole bunch of Drupal hacking ...
drush sql-dump > tmp.sql                        # save your intended state
drush -y sql-drop && drush sqlc < base.sql      # restore baseline state
build/update.sh                                 # apply changes to the baseline
```

You should see a lot of errors if, for example, you failed to provide an update
hook for deleting a field whose fundamental config you are changing. Or, perhaps
you've done the right thing and clicked through the things that should be
working now and you see that it is not working as expected. This is a great time
to fix these issues, because you know what you meant to do and your
collaborators don't!

The actual application of updates, including managing the enabled modules,
firing their update hooks, disabling things that should not be enabled and
reverting features is handled by `drupal/drop_ship`, which uses (a fork of)
`kw_manifests` for providing an extensible set of deployment tasks that have
dependencies on one another.

Because manifests can't receive commandline arguments, we pass information to
them with Environment Variables and we provide an env.dist from which to create
a .env file that our scripts will then source. This allows an operator with
access to the target environment to update these tunables out of channel so that
you can deploy any arbitrary revision to any environment.

Particularly, the list of modules used to generate the dependency graph of all
the things we should enable resides in the `DROPSHIP_SEEDS` environment
variable. You may notice that it's a list of one and that it's a poorly named
do-nothing module with nothing besides dependencies. In real life, you would
name this module something relevant to your project and it would be responsible
for over-arching functionality or the application, like providing the minimal
set of modules to generate the dependencies of everything that must be enabled
for the application to work properly. You can think of this like an install
profile that doesn't suck, because it's not a singleton, so with care, you can
embed your whole project in another project that uses this workflow.

See:

* [drupal/drop_ship](github.com/promet/drop_ship)
* [drupal/kw_manifests](github.com/promet/kw_manifests)

# TODO

* Change `build/scripts/default_set_theme` to a manifest
* Make the README pithier, factor out discussions into an article or blog

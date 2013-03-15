#!/bin/sh

#
# Shell script based wordpress installer 
# Copyright 2012 Naden Badalgogtapeh http://www.naden.de
#
# Version history
# 0.1 03/11/2012 initial release
# 0.2 11/18/2012 added support for multiple themes and language pack 
#

#
# the root directory where wordpress should be installed to
#
WORDPRESS_ROOT_DIR=./

#
# just set the language, if it differs from english
#
WORDPRESS_LANGUAGE=de_DE

#
# the "lower case" names of the wordpress themes located at http://wordpress.org/extend/themes/...
# leave blank if you do not want to install any extra theme
#
WORDPRESS_THEMES="pachyderm babylog buttercream patchwork"

#
# the "lower case" name of the wordpress plugins located at http://wordpress.org/extend/plugins/...
# leave blank if you do not want to install any extra plugins
#
WORDPRESS_PLUGINS="yet-another-related-posts-plugin wordpress-seo robots-meta rss-footer antispam-bee wp-piwik w3-total-cache upprev"

#
# DO NOT EDIT BELOW THIS LINE
#

#
# make the root directory if it does not exists
#
if [ ! -d "${WORDPRESS_ROOT_DIR}" ]; then
	mkdir ${WORDPRESS_ROOT_DIR}
fi

#
# check out the latest wordpress
#
svn checkout http://core.svn.wordpress.org/trunk/ ${WORDPRESS_ROOT_DIR}

#
# get extra language file
#
if [ ! -z "${WORDPRESS_LANGUAGE}" ]; then
	mkdir ${WORDPRESS_ROOT_DIR}/wp-content/languages
	wget http://svn.automattic.com/wordpress-i18n/${WORDPRESS_LANGUAGE}/trunk/messages/${WORDPRESS_LANGUAGE}.mo -O ${WORDPRESS_ROOT_DIR}/wp-content/languages/${WORDPRESS_LANGUAGE}.mo
	wget http://svn.automattic.com/wordpress-i18n/${WORDPRESS_LANGUAGE}/trunk/messages/${WORDPRESS_LANGUAGE}.po -O ${WORDPRESS_ROOT_DIR}/wp-content/languages/${WORDPRESS_LANGUAGE}.po
	
	wget http://svn.automattic.com/wordpress-i18n/${WORDPRESS_LANGUAGE}/trunk/messages/admin-${WORDPRESS_LANGUAGE}.mo -O ${WORDPRESS_ROOT_DIR}/wp-content/languages/admin-${WORDPRESS_LANGUAGE}.mo
	wget http://svn.automattic.com/wordpress-i18n/${WORDPRESS_LANGUAGE}/trunk/messages/admin-${WORDPRESS_LANGUAGE}.po -O ${WORDPRESS_ROOT_DIR}/wp-content/languages/admin-${WORDPRESS_LANGUAGE}.po
	
	sed "s/WPLANG', /WPLANG', '${WORDPRESS_LANGUAGE}'/g" ${WORDPRESS_ROOT_DIR}/wp-config-sample.php > wp-config-sample.php.$$
	mv -f ${WORDPRESS_ROOT_DIR}/wp-content/languages/wp-config-sample.php.$$ ${WORDPRESS_ROOT_DIR}/wp-content/languages/wp-config-sample.php  
fi

#
# check out the latest plugins if any are listed above
#
if [ ! -z "${WORDPRESS_PLUGINS}" ]; then
	for WORDPRESS_PLUGIN in ${WORDPRESS_PLUGINS}; do 
  	svn checkout http://plugins.svn.wordpress.org/${WORDPRESS_PLUGIN}/trunk/ ${WORDPRESS_ROOT_DIR}/wp-content/plugins/${WORDPRESS_PLUGIN} 
	done
fi

#
# check out the latest theme if one is listed above
#
if [ ! -z "${WORDPRESS_THEMES}" ]; then
	for WORDPRESS_THEME in ${WORDPRESS_THEMES}; do
		WORDPRESS_THEME_VERSIONS=`svn list http://themes.svn.wordpress.org/${WORDPRESS_THEME}/`
		for WORDPRESS_THEME_VERSION in ${WORDPRESS_THEME_VERSIONS}; do
		 echo -n
		done
		svn checkout http://themes.svn.wordpress.org/${WORDPRESS_THEME}/${WORDPRESS_THEME_VERSION} ${WORDPRESS_ROOT_DIR}/wp-content/themes/${WORDPRESS_THEME}
	done
fi

# remove all .svn folders
find . -iname ".svn" | xargs rm -r $1

echo -n "All done, navigate your browser to your wordpress url for setup"

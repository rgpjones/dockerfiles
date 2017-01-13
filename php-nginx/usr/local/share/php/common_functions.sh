#!/bin/bash

do_build_permissions() {
  if [ "$IS_NFS" -ne 0 ]; then
    setfacl -R -m "d:u:$CODE_OWNER:rwX" -m "u:$CODE_OWNER:rwX" /app/
  else
    chown -R "$CODE_OWNER:$CODE_GROUP" /app/
  fi
}

run_composer() {
  if [ ! -d "/app/vendor" ] || [ ! -f "/app/vendor/autoload.php" ]; then
    mkdir -p /app/vendor
    if [ "$IS_NFS" -ne 0 ]; then
      chown "$CODE_OWNER":"$CODE_GROUP" /app/vendor
    fi

    if [ -n "$GITHUB_TOKEN" ]; then
      as_code_owner "composer global config github-oauth.github.com '$GITHUB_TOKEN'"
    fi

    as_code_owner "composer install --no-interaction --optimize-autoloader"
    rm -rf /home/build/.composer/cache/
    as_code_owner "composer clear-cache"

    if [ "$IS_NFS" -ne 0 ]; then
      chown -R "$CODE_OWNER:$APP_GROUP" /app/vendor
    fi

    chmod -R go-w /app/vendor
  fi
}

do_composer() {
  if [ -f "${WORK_DIRECTORY}/composer.json" ]; then
    run_composer
  fi
}

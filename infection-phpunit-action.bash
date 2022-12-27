#!/bin/bash
set -e
github_action_path=$(dirname "$0")
docker_tag=$(cat ./docker_tag)

echo "Docker tag: $docker_tag" >> output.log 2>&1

phpunit_phar_url="https://phar.phpunit.de/phpunit.phar"
infection_phar_url="https://github.com/infection/infection/releases/download/0.26.15/infection.phar"

echo "Using phar phpunit url $phpunit_phar_url" >> output.log 2>&1
echo "Using phar infection url $infection_phar_url" >> output.log 2>&1

phpunit_phar_path="${github_action_path}/phpunit.phar"
curl --silent -H "User-agent: cURL (https://github.com/php-actions)" -L "$phpunit_phar_url" > "$phar_phptunit_path"

infection_phar_path="${github_action_path}/infection.phar"
curl --silent -H "User-agent: cURL (https://github.com/php-actions)" -L "$infection_phar_url" > "$infection_phar_path"

echo "phpunit_phar_path=$phpunit_phar_path" >> output.log 2>&1
echo "infection_phar_path=$phpunit_phar_path" >> output.log 2>&1

chmod +x $phpunit_phar_path
chmod +x $infection_phar_path

command_string=("infection")

echo "Command: ${command_string[@]}" >> output.log 2>&1

docker run --rm \
	--volume "${infection_phar_path}":/usr/local/bin/infection \
	--volume "${GITHUB_WORKSPACE}":/app \
	--workdir /app \
	--network host \
	--env-file <( env| cut -f1 -d= ) \
	${docker_tag} "${command_string[@]}"

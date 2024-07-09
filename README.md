# Flinkbot
Create your own automated cryptocurrency trading bot with our robust cloud-based solution.

## A brief summary of how to get the bot working (some steps may be missing).

### 0. Installing PHP 8.2+ and the Trade Extension
```sh
sudo apt-get update
sudo apt install net-tools
sudo apt install lsb-release apt-transport-https ca-certificates software-properties-common -y
sudo apt install wget unzip
sudo wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg
sudo sh -c 'echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list'
sudo apt update

sudo apt install php8.2-{mysql,cli,common,imap,ldap,xml,fpm,curl,mbstring,zip,bcmath,pdo,pdo-mysql,mcrypt}
sudo apt-get install php-pear php8.2-dev php8.2-xml
sudo pecl install trader
sudo pear install trader

sudo apt install php8.2-json

sudo nano /etc/php/8.2/cli/php.ini

extension=trader
```

### 1. Run Composer Install
```sh
composer install
```

### 2. Rename `config.php.sample` to `config.php` and configure it with your data

### 3. Restore the Database
```sh
mysql -u yourusername -p yourpassword yourdatabase < dump-flinkbot-202407092003.sql
```

### 4. Create a Script to Execute the Following Code:
```php
<?php

declare(strict_types=1);

require __DIR__ . '/vendor/autoload.php';
require __DIR__ . '/config.php';

use FjrSoftware\Flinkbot\Bot\Model\Bots;
use FjrSoftware\Flinkbot\Bot\Security;

$apiKey = Security::encrypt('apiKey');
$apiSecret = Security::encrypt('apiSecret');

$bot = Bots::where([
    'id' => 4,
    'user_id' => 1,
])->update([
    'api_key' => $apiKey,
    'api_secret' => $apiSecret
]);
```
### 5. Update the Script with Your Binance API Key and Secret

### 6. Follow the Commands and Steps in `service/install.txt`

### 7. Starting the Bot
```sh
service flinkbot start
php service/client.php --type=begin_bot --bot=1 --customer=1
php service/client.php --type=run_bot --bot=1 --customer=1
```

### 8. Stopping the Bot
```sh
php service/client.php --type=stop_bot --bot=1 --customer=1 --symbol=ETHUSDT
php service/client.php --type=end_bot --bot=1 --customer=1
service flinkbot stop
```

### Note:
Input/output settings are defined in the `bots` table (a more detailed description will be provided soon).

## Project Status
The project is currently under development and may contain errors/bugs.

## Additional Information

- Currently, the bot is implemented only for the Binance exchange.
- It is limited to the futures market only.

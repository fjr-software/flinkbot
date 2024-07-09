<?php

declare(strict_types=1);

require __DIR__ . '/../vendor/autoload.php';

$connector = new React\Socket\Connector();
$loop = React\EventLoop\Loop::get();

$connector->connect('127.0.0.1:8055')->then(function (React\Socket\ConnectionInterface $connection) {
    $connection->on('data', function ($data) {
        echo $data.PHP_EOL;
    });
    $connection->on('close', function () {
        echo '=> Closed' . PHP_EOL;
    });

    $opts = getopt(
        'c::t::b::s::',
        ['customer::', 'type::', 'bot::', 'symbol::']
    );
    $type = (string) ($opts['type'] ?? '');
    $customerId = (int) ($opts['customer'] ?? 0);
    $botId = (int) ($opts['bot'] ?? 0);
    $symbol = (string) ($opts['symbol'] ?? '');

    # STEP 1.1
    if ($type === 'begin_bot') {
        $data = json_encode([
            'type' => 'begin_bot',
            'data' => [
                'customerId' => $customerId,
                'botId' => $botId,
            ],
        ]);
    }

    # STEP 2.1
    if ($type === 'run_bot') {
        $data = json_encode([
            'type' => 'run_bot',
            'data' => [
                'customerId' => $customerId,
                'botId' => $botId,
            ],
        ]);
    }

    # STEP 2.2
    if ($type === 'stop_bot') {
        $data = json_encode([
            'type' => 'stop_bot',
            'data' => [
                'customerId' => $customerId,
                'botId' => $botId,
                'symbol' => $symbol,
                'force' => false,
            ],
        ]);
    }

    # STEP 1.2
    if ($type === 'end_bot') {
        $data = json_encode([
            'type' => 'end_bot',
            'data' => [
                'customerId' => $customerId,
                'botId' => $botId,
            ],
        ]);
    }

    $connection->write($data);
}, function (Exception $e) {
    echo 'Error: ' . $e->getMessage() . PHP_EOL;
});

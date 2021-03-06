const Kafka = require("kafkajs").Kafka
const promClient = require("prom-client");
const { logger } = require("../logger/winston");
const adminWatchkafkaSummary = new promClient.Summary({
    name: 'admin_watch_kafka_call_summary',
    help: 'Summary of the duration of admin watch kafka call'
});
module.exports = async function (callback) {
    try {
        const kafka = new Kafka({
            "clientId": "myapp",
            "brokers": [`${process.env.BROKER1}`, `${process.env.BROKER2}`, `${process.env.BROKER3}`]
        })
        const end = adminWatchkafkaSummary.startTimer();
        const admin = kafka.admin();
        logger.info("poller Connecting admin.....")
        await admin.connect()
        logger.info("poller Admin Connected")

        await admin.disconnect();
        end();
        await callback(true)
    }
    catch (ex) {
        logger.error(`Something bad happened ${ex}`)
        callback(false)
    }


}
const moment = require('moment');
const { schema } = require('./knexfile');

/**
 * DIP Event Logging microservice
 */
class EventLogging {
  /**
  * Constructor
  * @param {Amqp} amqp
  * @param {Object} db
  * @param {Object} log
  * @param {Object} router
  * */
  constructor({
    amqp, db, log, router,
  }) {
    this._db = db;
    this._amqp = amqp;
    this._log = log;
  }

  /**
   * Log message
   * @param {{}} params
   * @param {{}} params.content
   * @param {{}} params.fields
   * @param {{}} params.properties
   * @param {Integer} params.id
   * @return {void}
   * */
  logMessage({
    content, fields, properties, id,
  }) {
    const contentToLog = content;
    Object.keys(contentToLog).forEach((key) => {
      if (typeof content[key] === 'string' && content[key].length > 160) {
        contentToLog[key] = '[Data omitted; Check DB to debug]';
      }
    });

    this._log.info(
      `<${moment().format('YYYY-MM-DD T HH:mm:ss')}> [MESSAGE #${id}] ${fields.routingKey}: ${JSON.stringify(contentToLog)}; correlationId: ${properties.correlationId}`,
    );
  }

  /**
   * Save message to DB
   * @param {{}} params
   * @param {{}} params.content
   * @param {{}} params.fields
   * @param {{}} params.properties
   * @return {Integer} id
   * */
  async saveMessage({ content, fields, properties }) {
    const idArray = await this._db(`${schema}.events`).insert({
      content: JSON.stringify(content),
      fields: JSON.stringify(fields),
      properties: JSON.stringify(properties),
    }).returning('id');
    return idArray[0];
  }

  /**
   * Bootstrap and listen
   * @return {Promise<void>}
   */
  async bootstrap() {
    this._amqp.consume({
      messageType: '*',
      messagetypeVersion: '#',
      handler: async ({ content, fields, properties }) => {
        const id = await this.saveMessage({ content, fields, properties });
        this.logMessage({
          content, fields, properties, id,
        });
      },
    });
  }
}

module.exports = EventLogging;
